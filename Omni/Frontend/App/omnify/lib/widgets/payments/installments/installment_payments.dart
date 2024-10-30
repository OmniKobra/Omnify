// ignore_for_file: use_key_in_widget_constructors

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languages/app_language.dart';
import '../../../models/installment_payments.dart';
import '../../../models/installment_plan.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../utils.dart';

class InstallmentPayments extends StatefulWidget {
  final InstallmentPlan plan;
  final void Function() setPlanState;
  final void Function(Decimal, String, int, Decimal, void Function())
      switchToPayment;
  final Chain c;
  const InstallmentPayments(
      this.plan, this.c, this.switchToPayment, this.setPlanState);

  @override
  State<InstallmentPayments> createState() => _InstallmentPaymentsState();
}

class _InstallmentPaymentsState extends State<InstallmentPayments> {
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
  Widget buildContentTile(String label, String title, bool widthQuery,
      bool isDark, bool isCurrency) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final tile = ListTile(
        minLeadingWidth: 0,
        horizontalTitleGap: 8,
        contentPadding: const EdgeInsets.all(0),
        minVerticalPadding: 0,
        dense: !widthQuery,
        leading: isCurrency
            ? Utils.buildNetworkLogo(
                widthQuery, Utils.feeLogo(widget.c), true, true)
            : null,
        title: Text(title));
    return Container(
      width: widthQuery ? 200 : null,
      margin: widthQuery ? const EdgeInsets.all(8) : null,
      child: widthQuery
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              buildPropertyLabel(label, primaryColor, isDark, widthQuery),
              tile
            ])
          : tile,
    );
  }

  Widget buildHeader(bool isDark, TextDirection dir, bool widthQuery,
      Color primaryColor, AppLanguage lang) {
    final installmentsPaid =
        widget.plan.plan * Decimal.parse("${widget.plan.installmentsComplete}");
    final totalPaid = installmentsPaid + widget.plan.downpayment;
    final remainingAmount =
        widget.plan.installmentsComplete == widget.plan.installmentsQuantity
            ? Decimal.parse("0.0")
            : widget.plan.amountTotal - totalPaid;
    final children = [
      if (!widthQuery)
        buildPropertyLabel(lang.pay39, primaryColor, isDark, widthQuery),
      buildContentTile(
          lang.pay39,
          "${widget.plan.vendorAddress} / ${widget.plan.payerAddress}",
          widthQuery,
          isDark,
          false),
      if (!widthQuery)
        buildPropertyLabel(lang.pay44, primaryColor, isDark, widthQuery),
      buildContentTile(
          lang.pay44,
          Utils.removeTrailingZeros(widget.plan.amountTotal
              .toStringAsFixed(Utils.nativeTokenDecimals(widget.c))),
          widthQuery,
          isDark,
          true),
      if (!widthQuery)
        buildPropertyLabel(lang.pay45, primaryColor, isDark, widthQuery),
      buildContentTile(lang.pay45, widget.plan.installmentsQuantity.toString(),
          widthQuery, isDark, false),
      if (!widthQuery)
        buildPropertyLabel(lang.pay46, primaryColor, isDark, widthQuery),
      buildContentTile(
          lang.pay46,
          "${Utils.removeTrailingZeros(widget.plan.plan.toStringAsFixed(Utils.nativeTokenDecimals(widget.c)))}/${lang.pay43}",
          widthQuery,
          isDark,
          true),
      if (!widthQuery)
        buildPropertyLabel(lang.pay53, primaryColor, isDark, widthQuery),
      buildContentTile(
          lang.pay53,
          Utils.removeTrailingZeros(widget.plan
              .calculateFinalInstallment()
              .toStringAsFixed(Utils.nativeTokenDecimals(widget.c))),
          widthQuery,
          isDark,
          true),
      if (!widthQuery)
        buildPropertyLabel(lang.pay47, primaryColor, isDark, widthQuery),
      buildContentTile(
          lang.pay47,
          Utils.removeTrailingZeros(widget.plan.amountPaid
              .toStringAsFixed(Utils.nativeTokenDecimals(widget.c))),
          widthQuery,
          isDark,
          true),
      if (!widthQuery)
        buildPropertyLabel(lang.pay48, primaryColor, isDark, widthQuery),
      buildContentTile(
          lang.pay48,
          "${widget.plan.installmentsQuantity - widget.plan.installmentsComplete}",
          widthQuery,
          isDark,
          false),
      if (!widthQuery)
        buildPropertyLabel(lang.pay49, primaryColor, isDark, widthQuery),
      buildContentTile(
          lang.pay49,
          Utils.removeTrailingZeros(remainingAmount
              .toStringAsFixed(Utils.nativeTokenDecimals(widget.c))),
          widthQuery,
          isDark,
          true),
      if (!widthQuery)
        buildPropertyLabel(lang.pay50, primaryColor, isDark, widthQuery),
      buildContentTile(
          lang.pay50,
          Utils.timeStamp(
              widget.plan.startingDate,
              Provider.of<ThemeProvider>(context, listen: false).langCode,
              context),
          widthQuery,
          isDark,
          false),
    ];
    return Directionality(
        textDirection: dir,
        child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(
                    color:
                        isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(5),
                color: isDark ? Colors.grey[800] : Colors.white),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widthQuery ? [Wrap(children: children)] : children)));
  }

  Widget buildPaymentTile(bool isDark, bool widthQuery, InstallmentPayment p,
      int index, TextDirection dir, AppLanguage lang, String myAddress) {
    const transparent = WidgetStatePropertyAll(Colors.transparent);
    var isFinalPayment = widget.plan.installments.indexOf(p) ==
        widget.plan.installments.length - 1;
    var finalInstallment = widget.plan.calculateFinalInstallment();
    var remainingInstallments =
        widget.plan.installmentsQuantity - widget.plan.installmentsComplete;
    return Directionality(
      textDirection: dir,
      child: Container(
          padding: const EdgeInsets.all(8),
          margin: widthQuery
              ? const EdgeInsets.all(8)
              : const EdgeInsets.only(bottom: 5),
          width: widthQuery ? 450 : double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(5),
              color: isDark ? Colors.grey[800] : Colors.white),
          child: ListTile(
              minLeadingWidth: 0,
              horizontalTitleGap: 15,
              contentPadding: const EdgeInsets.all(0),
              minVerticalPadding: 0,
              // dense: !widthQuery,
              leading: Column(
                children: [
                  const Spacer(),
                  Icon(
                      p.isPaid
                          ? Icons.check_circle
                          : Icons.pending_actions_outlined,
                      color: isDark
                          ? Colors.white60
                          : p.isPaid
                              ? Colors.lightGreenAccent
                              : Colors.amber),
                ],
              ),
              isThreeLine: true,
              title: Row(
                children: [
                  Utils.buildNetworkLogo(
                      widthQuery, Utils.feeLogo(widget.c), true, true),
                  const SizedBox(width: 8),
                  Text(Utils.removeTrailingZeros(isFinalPayment
                      ? finalInstallment
                          .toStringAsFixed(Utils.nativeTokenDecimals(widget.c))
                      : p.amount.toStringAsFixed(
                          Utils.nativeTokenDecimals(widget.c))))
                ],
              ),
              subtitle: Text(
                  "${lang.pay51} ${Utils.timeStamp(p.dateDue, Provider.of<ThemeProvider>(context, listen: false).langCode, context)}\n${lang.pay52} ${p.isPaid ? Utils.timeStamp(p.dateSettled, Provider.of<ThemeProvider>(context, listen: false).langCode, context) : '-/-'}"),
              trailing: widget.plan.payerAddress == myAddress
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${index + 1}/${widget.plan.installments.length}"),
                        const Spacer(),
                        if ((!p.isPaid && !isFinalPayment) ||
                            (isFinalPayment &&
                                remainingInstallments == 1 &&
                                widget.plan.plan != finalInstallment &&
                                !p.isPaid) ||
                            (isFinalPayment &&
                                widget.plan.plan == finalInstallment &&
                                !p.isPaid))
                          TextButton(
                              onPressed: () {
                                widget.switchToPayment(
                                    isFinalPayment
                                        ? finalInstallment
                                        : p.amount,
                                    widget.plan.vendorAddress,
                                    widget.plan.installmentsQuantity,
                                    widget.plan.plan, () {
                                  p.payIt();
                                  widget.plan.payInstallment();
                                  widget.setPlanState();
                                  setState(() {});
                                });
                              },
                              style: ButtonStyle(
                                  alignment: dir == TextDirection.rtl
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  padding: const WidgetStatePropertyAll(
                                      EdgeInsets.all(0)),
                                  overlayColor: transparent,
                                  shadowColor: transparent,
                                  backgroundColor: transparent),
                              child: Text(lang.pay16))
                      ],
                    )
                  : null)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final widthQuery = Utils.widthQuery(context);
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final heightBox = SizedBox(height: widthQuery ? 10 : 5);
    final myAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(theme.startingChain);
    final lang = Utils.language(context);
    return Directionality(
      textDirection: dir,
      child: ListView(
        children: [
          buildHeader(isDark, dir, widthQuery, primaryColor, lang),
          heightBox,
          if (!widthQuery)
            ...widget.plan.installments.map((e) => buildPaymentTile(
                isDark,
                widthQuery,
                e,
                widget.plan.installments.indexOf(e),
                dir,
                lang,
                myAddress)),
          if (widthQuery)
            Wrap(
              children: [
                ...widget.plan.installments.map((e) => buildPaymentTile(
                    isDark,
                    widthQuery,
                    e,
                    widget.plan.installments.indexOf(e),
                    dir,
                    lang,
                    myAddress))
              ],
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
