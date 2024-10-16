import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../languages/app_language.dart';
import '../../providers/payments_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../utils.dart';

class PaymentsHeader extends StatefulWidget {
  const PaymentsHeader({super.key});

  @override
  State<PaymentsHeader> createState() => _PaymentsHeaderState();
}

class _PaymentsHeaderState extends State<PaymentsHeader> {
  Widget buildStat(String label, bool isDark, bool widthQuery, Chain c,
      Decimal amount, int number, bool isNumber) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: widthQuery ? 15 : 13.25,
                    color: isDark ? Colors.white60 : Colors.grey)),
            const SizedBox(height: 7),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isNumber)
                  SizedBox(
                      child: Utils.buildNetworkLogo(
                          widthQuery, Utils.feeLogo(c), true, true)),
                if (!isNumber) const SizedBox(width: 10),
                Text(isNumber ? number.toString() : amount.toStringAsFixed(18),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widthQuery ? 17 : 14))
              ],
            ),
          ],
        ));
  }

  Widget buildWithdrawButton(
      bool widthQuery,
      AppLanguage lang,
      bool walletConnected,
      void Function(BuildContext) connectWallet,
      Color primaryColor) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextButton(
              onPressed: walletConnected
                  ? () {
                      FocusScope.of(context).unfocus();
                    }
                  : () => connectWallet(context),
              style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                  elevation: WidgetStatePropertyAll(5),
                  overlayColor: WidgetStatePropertyAll(Colors.transparent)),
              child: Container(
                  height: 50,
                  width: widthQuery ? 400 : double.infinity,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.rectangle,
                      borderRadius:
                          BorderRadius.circular(widthQuery ? 15 : 10)),
                  child: Center(
                      child: walletConnected
                          ? const Text("Withdraw balance",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white))
                          : Row(mainAxisSize: MainAxisSize.min, children: [
                              const Icon(Icons.wallet,
                                  size: 27, color: Colors.white),
                              const SizedBox(width: 5),
                              Text(lang.home8,
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.white))
                            ])))),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final payments = Provider.of<PaymentsProvider>(context);
    final widthQuery = Utils.widthQuery(context);
    final balance = payments.balance;
    final balanceWithdrawn = payments.balanceWithdrawn;
    final totalRevenue = payments.totalRevenue;
    final totalSpent = payments.totalSpent;
    final amountRefunded = payments.amountRefunded;
    final paymentsMade = payments.paymentsMade;
    final paymentsReceived = payments.paymentsReceived;
    final refunds = payments.refunds;
    final c = payments.currentChain;
    final lang = Utils.language(context);
    final wallet = Provider.of<WalletProvider>(context);
    final walletConnected = wallet.isWalletConnected;
    final connectWallet =
        Provider.of<WalletProvider>(context, listen: false).connectWallet;
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      // height: widthQuery ? 400 : 700,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200)),
      child: widthQuery
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    children: [
                      buildStat("Payments Received", isDark, widthQuery, c,
                          Decimal.parse("0"), paymentsReceived, true),
                      buildStat("Revenue", isDark, widthQuery, c, totalRevenue,
                          0, false),
                      buildStat("Payments Made", isDark, widthQuery, c,
                          Decimal.parse("0"), paymentsMade, true),
                      buildStat("Total Spent", isDark, widthQuery, c,
                          totalSpent, 0, false),
                      buildStat("Refunds Issued", isDark, widthQuery, c,
                          Decimal.parse("0"), refunds, true),
                      buildStat("Refunds", isDark, widthQuery, c,
                          amountRefunded, 0, false),
                      buildStat(
                          "Balance", isDark, widthQuery, c, balance, 0, false),
                      buildStat("Balance Withdrawn", isDark, widthQuery, c,
                          balanceWithdrawn, 0, false),
                      buildWithdrawButton(widthQuery, lang, walletConnected,
                          connectWallet, primaryColor)
                    ],
                  ),
                ),
                // const SizedBox.expand(),
                // const Spacer()
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  children: [
                    buildStat("Payments Received", isDark, widthQuery, c,
                        Decimal.parse("0"), paymentsReceived, true),
                    buildStat("Revenue", isDark, widthQuery, c, totalRevenue, 0,
                        false),
                    buildStat("Payments Made", isDark, widthQuery, c,
                        Decimal.parse("0"), paymentsMade, true),
                    buildStat("Total Spent", isDark, widthQuery, c, totalSpent,
                        0, false),
                    buildStat("Refunds Issued", isDark, widthQuery, c,
                        Decimal.parse("0"), refunds, true),
                    buildStat("Refunds", isDark, widthQuery, c, amountRefunded,
                        0, false),
                    buildStat(
                        "Balance", isDark, widthQuery, c, balance, 0, false),
                    buildStat("Balance Withdrawn", isDark, widthQuery, c,
                        balanceWithdrawn, 0, false),
                    buildWithdrawButton(widthQuery, lang, walletConnected,
                        connectWallet, primaryColor)
                  ],
                ),
                // const SizedBox.expand(),
                // const Spacer()
              ],
            ),
    );
  }
}
