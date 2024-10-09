// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../../models/transaction.dart';
import '../../../providers/transactions_provider.dart';
import '../../../languages/app_language.dart';
import '../../../models/receipt.dart';
import '../../../providers/activities/payment_activity_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../crypto/features/payment_utils.dart';
import '../../../utils.dart';
import '../../../toasts.dart';

class PaymentReceipt extends StatefulWidget {
  final Receipt receipt;
  const PaymentReceipt({super.key, required this.receipt});

  @override
  State<PaymentReceipt> createState() => _PaymentReceiptState();
}

class _PaymentReceiptState extends State<PaymentReceipt> {
  bool isExpanded = false;
  Widget buildPropertyLabel(
          String label, Color primaryColor, bool isDark, bool widthQuery) =>
      Chip(
          visualDensity: VisualDensity.compact,
          elevation: 0,
          padding: const EdgeInsets.all(0),
          labelPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.transparent)),
          color:
              WidgetStatePropertyAll(isDark ? Colors.grey[800] : Colors.white),
          label: Text(label,
              style: TextStyle(
                  color: primaryColor, fontSize: widthQuery ? null : 13)));
  Widget buildContentTile(String title, bool widthQuery, bool isDark,
          bool isCurrency, Chain c) =>
      ListTile(
          minLeadingWidth: 0,
          horizontalTitleGap: 8,
          contentPadding: const EdgeInsets.all(0),
          minVerticalPadding: 0,
          dense: !widthQuery,
          leading: isCurrency
              ? Utils.buildNetworkLogo(widthQuery, Utils.feeLogo(c), true, true)
              : null,
          title: Text(title));
  Widget buildRefundButton(
      Chain c,
      bool widthQuery,
      Color primaryColor,
      AppLanguage lang,
      bool isDark,
      String walletAddress,
      TextDirection direction,
      void Function(Transaction) addTransaction,
      void Function(Decimal) issueProviderRefund,
      Decimal amount) {
    return TextButton(
        onPressed: widget.receipt.isRefunded
            ? () {}
            : () {
                QuickAlert.show(
                  context: context,
                  title: lang.paymentActivity17,
                  text: "",
                  showCancelBtn: true,
                  type: QuickAlertType.error,
                  headerBackgroundColor: Colors.red,
                  backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
                  titleColor: isDark ? Colors.white60 : Colors.black,
                  textColor: isDark ? Colors.white60 : Colors.black,
                  confirmBtnText: lang.manage4,
                  confirmBtnColor: Colors.red,
                  cancelBtnText: lang.manage5,
                  onConfirmBtnTap: () async {
                    Future.delayed(const Duration(milliseconds: 300), () async {
                      final theme =
                          Provider.of<ThemeProvider>(context, listen: false);
                      final client = theme.client;
                      final wcClient = theme.walletClient;
                      final sessionTopic = theme.stateSessionTopic;
                      final now = DateTime.now();
                      Utils.showLoadingDialog(context, lang, widthQuery);
                      final txHash = await PaymentUtils.issueRefund(
                          c: c,
                          id: widget.receipt.id,
                          client: client,
                          walletAddress: walletAddress,
                          wcClient: wcClient,
                          sessionTopic: sessionTopic,
                          isDark: isDark,
                          dir: direction,
                          lang: lang);
                      if (txHash != null) {
                        addTransaction(Transaction(
                            c: c,
                            type: TransactionType.payment,
                            id: widget.receipt.id,
                            date: now,
                            status: Status.omnifySent,
                            transactionHash: txHash,
                            blockNumber: 0,
                            secondTransactionHash: "",
                            secondBlockNumber: 0,
                            thirdTransactionHash: "",
                            thirdBlockNumber: 0));
                        widget.receipt.refundPayment();
                        setState(() {});
                        Future.delayed(const Duration(seconds: 1), () {
                          Toasts.showSuccessToast(lang.transactionSent,
                              lang.transactionSent2, isDark, direction);
                          issueProviderRefund(amount);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      } else {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Toasts.showErrorToast(
                            lang.toast13, lang.toasts30, isDark, direction);
                      }
                    });
                  },
                );
              },
        style: const ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
            elevation: WidgetStatePropertyAll(5),
            overlayColor: WidgetStatePropertyAll(Colors.transparent)),
        child: Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: widget.receipt.isRefunded
                    ? Border.all(color: Colors.red)
                    : null,
                color: widget.receipt.isRefunded
                    ? Colors.transparent
                    : primaryColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(widthQuery ? 15 : 10)),
            child: Center(
                child: Text(
                    widget.receipt.isRefunded
                        ? lang.paymentActivty18
                        : lang.paymentActivity19,
                    style: TextStyle(
                        fontSize: 18,
                        color: widget.receipt.isRefunded
                            ? Colors.red
                            : Colors.white)))));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final direction = theme.textDirection;
    final langCode = theme.langCode;
    final widthQuery = Utils.widthQuery(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final c = Provider.of<PaymentActivityProvider>(context).currentChain;
    final balance = Provider.of<PaymentActivityProvider>(context).balance;
    final paymentActivityMethods =
        Provider.of<PaymentActivityProvider>(context, listen: false);
    final myAddress =
        Provider.of<WalletProvider>(context, listen: false).getAddressString(c);
    final payer = widget.receipt.payer;
    final vendor = widget.receipt.vendor;
    final lang = Utils.language(context);
    final addTransaction =
        Provider.of<TransactionsProvider>(context, listen: false)
            .addTransaction;
    return Directionality(
      textDirection: direction,
      child: Container(
          height: isExpanded
              ? null
              : widthQuery
                  ? 240
                  : 225,
          width: widthQuery ? 400 : double.infinity,
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.only(
              bottom: 8,
              right: widthQuery && direction == TextDirection.ltr ? 8 : 0,
              left: widthQuery && direction == TextDirection.rtl ? 8 : 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPropertyLabel(
                  payer == myAddress ? lang.paymentActivity20 : lang.table25,
                  primaryColor,
                  isDark,
                  widthQuery),
              buildContentTile(
                  payer == myAddress
                      ? widget.receipt.vendor
                      : widget.receipt.payer,
                  widthQuery,
                  isDark,
                  false,
                  c),
              buildPropertyLabel(lang.table1, primaryColor, isDark, widthQuery),
              buildContentTile(
                  widget.receipt.isRefunded
                      ? "-${Utils.removeTrailingZeros(widget.receipt.amount.toStringAsFixed(Utils.nativeTokenDecimals(c)))}"
                      : Utils.removeTrailingZeros(widget.receipt.amount
                          .toStringAsFixed(Utils.nativeTokenDecimals(c))),
                  widthQuery,
                  isDark,
                  true,
                  c),
              if (isExpanded) ...[
                buildPropertyLabel(
                    lang.explorerHint4, primaryColor, isDark, widthQuery),
                buildContentTile(
                    widget.receipt.id, widthQuery, isDark, false, c),
                buildPropertyLabel(
                    payer == myAddress
                        ? lang.paymentActivity15
                        : lang.paymentActivity16,
                    primaryColor,
                    isDark,
                    widthQuery),
                buildContentTile(
                    Utils.timeStamp(widget.receipt.date, langCode, context),
                    widthQuery,
                    isDark,
                    false,
                    c),
                // buildPropertyLabel(
                //     lang.transactions10, primaryColor, isDark, widthQuery),
                // buildContentTile(widget.receipt.transactionHash, widthQuery,
                //     isDark, false, c),
                // buildPropertyLabel(
                //     lang.transactions11, primaryColor, isDark, widthQuery),
                // buildContentTile(widget.receipt.blockNumber.toString(),
                //     widthQuery, isDark, false, c),
                if ((widget.receipt.isRefunded && vendor == myAddress) ||
                    (!widget.receipt.isRefunded &&
                        vendor == myAddress &&
                        balance >= widget.receipt.amount) ||
                    (payer == myAddress && widget.receipt.isRefunded))
                  buildRefundButton(
                      c,
                      widthQuery,
                      primaryColor,
                      lang,
                      isDark,
                      myAddress,
                      direction,
                      addTransaction,
                      paymentActivityMethods.issueRefund,
                      widget.receipt.amount)
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    icon: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: isDark ? Colors.white60 : Colors.black),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  )
                ],
              )
            ],
          )),
    );
  }
}
