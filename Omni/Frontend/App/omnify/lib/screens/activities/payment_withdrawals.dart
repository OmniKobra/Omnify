import 'package:flutter/material.dart';
import 'package:omnify/models/withdrawal.dart';
import 'package:provider/provider.dart';

import '../../crypto/features/payment_utils.dart';
import '../../providers/activities/payment_activity_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../utils.dart';
import '../../widgets/activity/activity_appbar.dart';
import '../../widgets/activity/show_more.dart';
import '../../widgets/common/refresh_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/home/wallet_button.dart';

class PaymentWithdrawalsScreen extends StatefulWidget {
  const PaymentWithdrawalsScreen({super.key});

  @override
  State<PaymentWithdrawalsScreen> createState() => _PaymentReceiptScreenState();
}

class _PaymentReceiptScreenState extends State<PaymentWithdrawalsScreen> {
  Future<List<Withdrawal>>? getWithdrawals;
  Widget buildWithdrawalTile(bool isDark, bool widthQuery, TextDirection dir,
      Withdrawal w, Chain currentChain) {
    return Container(
        width: widthQuery ? 250 : null,
        padding: const EdgeInsets.all(8),
        margin: widthQuery
            ? EdgeInsets.only(
                bottom: 8,
                right: dir == TextDirection.ltr ? 8 : 0,
                left: dir == TextDirection.ltr ? 0 : 8)
            : const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading:
              Utils.buildNetworkLogo(true, Utils.feeLogo(currentChain), true),
          title: Text(Utils.removeTrailingZeros(w.amount
              .toStringAsFixed(Utils.nativeTokenDecimals(currentChain)))),
          subtitle: Text(Utils.timeStamp(
              w.date,
              Provider.of<ThemeProvider>(context, listen: false).langCode,
              context)),
        ));
  }

  @override
  void initState() {
    super.initState();
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final paymentActivityProvider =
        Provider.of<PaymentActivityProvider>(context, listen: false);
    final c = paymentActivityProvider.currentChain;
    final setWithdrawals = paymentActivityProvider.setWithdrawalsList;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final withdrawalsList = paymentActivityProvider.allWithdrawalsList;
    if (wallet.isWalletConnected) {
      if (withdrawalsList.isEmpty) {
        getWithdrawals = PaymentUtils.fetchProfileWithdrawals(
            c: c,
            client: theme.client,
            walletAddress: wallet.getAddressString(c),
            setWithdrawals: setWithdrawals,
            useSetter: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dir = Provider.of<ThemeProvider>(context).textDirection;
    final lang = Utils.language(context);
    final theme = Provider.of<ThemeProvider>(context);
    final wallet = Provider.of<WalletProvider>(context);
    final walletMethods = Provider.of<WalletProvider>(context, listen: false);
    final paymentActivity = Provider.of<PaymentActivityProvider>(context);
    final walletConnected = wallet.isWalletConnected;
    final widthQuery = Utils.widthQuery(context);
    final chain = paymentActivity.currentChain;
    final isDark = theme.isDark;
    return SelectionArea(
        child: Scaffold(
            body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                    child: Column(children: [
                  ActivityAppBar(lang.paymentActivity5),
                  Expanded(
                    child: FutureBuilder(
                        future: getWithdrawals,
                        builder: (ctx, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const MyLoading();
                          }
                          if (snap.hasError) {
                            return MyError(() {
                              setState(() {
                                getWithdrawals =
                                    PaymentUtils.fetchProfileWithdrawals(
                                        c: chain,
                                        client: theme.client,
                                        walletAddress: walletMethods
                                            .getAddressString(chain),
                                        setWithdrawals: Provider.of<
                                                    PaymentActivityProvider>(
                                                context,
                                                listen: false)
                                            .setWithdrawalsList,
                                        useSetter: true);
                              });
                            });
                          }
                          return Builder(builder: (ctx) {
                            final _paymentActivity =
                                Provider.of<PaymentActivityProvider>(ctx);
                            final withdrawals = _paymentActivity.withdrawalList;
                            return Expanded(
                              child: Column(children: [
                                if (!walletConnected)
                                  Expanded(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                              child: Icon(Icons.wallet,
                                                  color: Colors.grey.shade500,
                                                  size: 80)),
                                          const SizedBox(height: 5),
                                          Center(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    widthQuery ? 8 : 24.0),
                                            child: Text(lang.paymentActivity12,
                                                style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize:
                                                        widthQuery ? 19 : 16)),
                                          )),
                                          const SizedBox(height: 15),
                                          const WalletButton(),
                                        ]),
                                  ),
                                if (walletConnected && withdrawals.isNotEmpty)
                                  Expanded(
                                      child: Directionality(
                                          textDirection: dir,
                                          child: MyRefresh(
                                            onRefresh: () async {
                                              setState(() {
                                                getWithdrawals = PaymentUtils
                                                    .fetchProfileWithdrawals(
                                                        c: chain,
                                                        client: theme.client,
                                                        walletAddress: walletMethods
                                                            .getAddressString(
                                                                chain),
                                                        setWithdrawals: Provider
                                                                .of<PaymentActivityProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                            .setWithdrawalsList,
                                                        useSetter: true);
                                              });
                                            },
                                            child: ListView(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                children: [
                                                  Wrap(
                                                    children: [
                                                      ...withdrawals.map((w) =>
                                                          buildWithdrawalTile(
                                                              isDark,
                                                              widthQuery,
                                                              dir,
                                                              w,
                                                              chain))
                                                    ],
                                                  )
                                                ]),
                                          ))),
                                if (walletConnected && withdrawals.isNotEmpty)
                                  const ShowMore(
                                      isInTransfers: false,
                                      isInPaymentReceipts: false,
                                      isInPaymentWithdrawals: true,
                                      isInBridgeTransactions: false),
                                if (walletConnected && withdrawals.isEmpty)
                                  Column(
                                    children: [
                                      Center(
                                          child: Icon(Icons.exit_to_app,
                                              color: Colors.grey.shade500,
                                              size: 80)),
                                      const SizedBox(height: 5),
                                      Center(
                                          child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: widthQuery ? 8 : 24.0),
                                        child: Text(lang.paymentActivity22,
                                            style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize:
                                                    widthQuery ? 19 : 16)),
                                      ))
                                    ],
                                  )
                              ]),
                            );
                          });
                        }),
                  )
                ])))));
  }
}
