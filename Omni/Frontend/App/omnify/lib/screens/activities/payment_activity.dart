import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';
import '../../routes.dart';
import '../../providers/activities/payment_activity_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/refresh_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/activity/activity_appbar.dart';
import '../../widgets/activity/payment/payments_graph.dart';
import '../../widgets/network_picker.dart';
import '../../widgets/home/wallet_button.dart';

class PaymentActivity extends StatefulWidget {
  const PaymentActivity({super.key});

  @override
  State<PaymentActivity> createState() => _PaymentActivityState();
}

class _PaymentActivityState extends State<PaymentActivity> {
  bool showPaymentsMade = true;
  bool showPaymentsReceived = true;
  bool showRefunds = false;
  bool showWithdrawals = false;
  Widget buildStatTile(bool widthQuery, bool isDark, TextDirection dir,
      String title, Decimal value, Chain c) {
    return Container(
      width: widthQuery ? 220 : null,
      height: 100,
      margin: widthQuery
          ? EdgeInsets.only(
              bottom: 4,
              right: dir == TextDirection.ltr ? 4 : 0,
              left: dir == TextDirection.ltr ? 0 : 4)
          : const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5),
          color: isDark ? Colors.grey[800] : Colors.white),
      child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Container(
            margin: EdgeInsets.only(bottom: widthQuery ? 4 : 8),
            child: Text(title,
                style: TextStyle(
                    fontSize: widthQuery ? 13 : 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white60 : Colors.black)),
          ),
          subtitle: Row(
            children: [
              Utils.buildNetworkLogo(widthQuery, Utils.feeLogo(c), true),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                    Utils.removeTrailingZeros(
                        value.toStringAsFixed(Utils.nativeTokenDecimals(c))),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black,
                        fontWeight: FontWeight.w400)),
              ),
            ],
          ),
          isThreeLine: true),
    );
  }

  Widget buildMoreButton(IconData icon, String label, String routeName,
      Color primaryColor, TextDirection dir) {
    return Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: primaryColor),
        height: 100,
        // width: 88,
        child: InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => Navigator.pushNamed(context, routeName),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 80, child: Icon(icon, size: 40, color: Colors.white)),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ));
  }

  Widget buildChip(String label, bool widthQuery, Color primaryColor,
      Color secondary, bool value, void Function() handler, Color labelColor) {
    bool isDark = Provider.of<ThemeProvider>(context).isDark;
    return Container(
      margin: widthQuery
          ? const EdgeInsets.only(bottom: 4)
          : const EdgeInsets.only(right: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              handler();
              setState(() {});
            },
            child: Chip(
                labelPadding: const EdgeInsets.all(0),
                color: WidgetStatePropertyAll(
                    isDark ? Colors.transparent : Colors.white),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                        width: value ? 1 : 0,
                        color: value ? primaryColor : Colors.transparent)),
                label: Text(
                  label,
                  style: TextStyle(
                      fontSize: widthQuery ? 13.5 : 13, color: labelColor),
                )),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var activity = Provider.of<PaymentActivityProvider>(context, listen: false);
    var c = activity.currentChain;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final address = wallet.getAddressString(c);
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    if (wallet.isWalletConnected) {
      activity.setFuture(c, address, false, client);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final client = theme.client;
    final paymentsProvider = Provider.of<PaymentActivityProvider>(context);
    final future = paymentsProvider.fetchPaymentProfile;
    final balance = paymentsProvider.balance;
    final revenue = paymentsProvider.revenue;
    final spending = paymentsProvider.spending;
    final refunds = paymentsProvider.refunds;
    final withdrawals = paymentsProvider.withdrawals;
    final paymentsMade = paymentsProvider.paymentsMade;
    final paymentsReceived = paymentsProvider.paymentsReceived;
    final refundsNum = paymentsProvider.refundsNum;
    final withdrawalsNum = paymentsProvider.withdrawalsNum;
    final c = paymentsProvider.currentChain;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final address = wallet.getAddressString(c);
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final decoration = BoxDecoration(
        border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(5),
        color: isDark ? Colors.grey[800] : Colors.white);
    List<Widget> chips = [
      buildChip(
          "${lang.paymentActivity2} $paymentsMade",
          widthQuery,
          primaryColor,
          secondaryColor,
          showPaymentsMade,
          () => showPaymentsMade = !showPaymentsMade,
          Colors.red),
      buildChip(
          "${lang.paymentActivity3} $paymentsReceived",
          widthQuery,
          primaryColor,
          secondaryColor,
          showPaymentsReceived,
          () => showPaymentsReceived = !showPaymentsReceived,
          const Color(0xFF3BFF49)),
      buildChip(
          "${lang.paymentActivity4} $refundsNum",
          widthQuery,
          primaryColor,
          secondaryColor,
          showRefunds,
          () => showRefunds = !showRefunds,
          Colors.yellow.shade700),
      buildChip(
          "${lang.paymentActivity5} $withdrawalsNum",
          widthQuery,
          primaryColor,
          secondaryColor,
          showWithdrawals,
          () => showWithdrawals = !showWithdrawals,
          const Color(0xFFFF3AF2)),
    ];
    final moreButtons = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: widthQuery ? null : const EdgeInsets.all(8),
            decoration: decoration,
            width: widthQuery ? 194 : double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(children: [
                    buildMoreButton(Icons.receipt, lang.paymentActivity6,
                        Routes.paymentReceipts, primaryColor, dir),
                    buildMoreButton(Icons.exit_to_app, lang.paymentActivity5,
                        Routes.paymentWithdrawals, primaryColor, dir),
                  ])
                ])),
        if (widthQuery) const SizedBox(height: 5),
        if (widthQuery)
          Container(
              decoration: decoration,
              height: 277,
              width: widthQuery ? 194 : null,
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: chips,
              ))
      ],
    );
    return SelectionArea(
      child: Scaffold(
          body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                  child: Column(children: [
                ActivityAppBar(lang.paymentActivity1),
                Expanded(
                    child: Directionality(
                        textDirection: dir,
                        child: FutureBuilder(
                            future: future,
                            builder: (ctx, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return const MyLoading();
                              }
                              if (snap.hasError) {
                                return MyError(() {
                                  Provider.of<PaymentActivityProvider>(context,
                                          listen: false)
                                      .setFuture(c, address, true, client);
                                });
                              }
                              return MyRefresh(
                                onRefresh: () async {
                                  Provider.of<PaymentActivityProvider>(context,
                                          listen: false)
                                      .setFuture(c, address, true, client);
                                },
                                child: ListView(
                                    padding: const EdgeInsets.all(8.0),
                                    children: [
                                      Row(children: [
                                        Container(
                                            padding: widthQuery
                                                ? const EdgeInsets.all(8)
                                                : const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            decoration: BoxDecoration(
                                                border: border,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: isDark
                                                    ? Colors.grey[800]
                                                    : Colors.white),
                                            child: const NetworkPicker(
                                                isExplorer: false,
                                                isTransfers: false,
                                                isPayments: false,
                                                isTrust: false,
                                                isBridgeSource: false,
                                                isBridgeTarget: false,
                                                isEscrow: false,
                                                isTransferActivity: false,
                                                isPaymentActivity: true,
                                                isTrustActivity: false,
                                                isBridgeActivity: false,
                                                isEscrowActivity: false,
                                                isTransactions: false,
                                                isDiscoverTransfers: false,
                                                isDiscoverPayments: false,
                                                isDiscoverTrust: false,
                                                isDiscoverBridges: false,
                                                isDiscoverEscrow: false)),
                                        const SizedBox(width: 5),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                top: 8,
                                                right: 8,
                                                left: 8,
                                                bottom: 8),
                                            child: const WalletButton())
                                      ]),
                                      const SizedBox(height: 5),
                                      Wrap(children: [
                                        buildStatTile(widthQuery, isDark, dir,
                                            lang.paymentActivity7, balance, c),
                                        buildStatTile(widthQuery, isDark, dir,
                                            lang.paymentActivity8, revenue, c),
                                        buildStatTile(widthQuery, isDark, dir,
                                            lang.paymentActivity9, spending, c),
                                        buildStatTile(widthQuery, isDark, dir,
                                            lang.paymentActivity4, refunds, c),
                                        buildStatTile(
                                            widthQuery,
                                            isDark,
                                            dir,
                                            lang.paymentActivity5,
                                            withdrawals,
                                            c),
                                      ]),
                                      const SizedBox(height: 1),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Container(
                                                    height:
                                                        widthQuery ? 500 : 400,
                                                    padding: const EdgeInsets.all(
                                                        16),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: isDark
                                                                ? Colors.grey
                                                                    .shade700
                                                                : Colors.grey
                                                                    .shade200),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        color: isDark
                                                            ? Colors.grey[800]
                                                            : Colors.white),
                                                    child: PaymentsChart(
                                                        showPaymentsMade:
                                                            showPaymentsMade,
                                                        showPaymentsReceived:
                                                            showPaymentsReceived,
                                                        showWithdrawals:
                                                            showWithdrawals,
                                                        showRefunds: showRefunds))),
                                            if (widthQuery)
                                              const SizedBox(width: 5),
                                            if (widthQuery) moreButtons,
                                          ]),
                                      if (!widthQuery)
                                        const SizedBox(height: 5),
                                      if (!widthQuery)
                                        Container(
                                            padding: const EdgeInsets.all(8),
                                            height: 55,
                                            decoration: decoration,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: chips,
                                            )),
                                      if (!widthQuery)
                                        const SizedBox(height: 5),
                                      if (!widthQuery) moreButtons,
                                    ]),
                              );
                            })))
              ])))),
    );
  }
}
