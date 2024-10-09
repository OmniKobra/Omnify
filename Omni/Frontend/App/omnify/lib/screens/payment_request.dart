// ignore_for_file: deprecated_member_use

import 'package:decimal/decimal.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils.dart';
import '../widgets/payments/Bill/payment_form.dart';
import '../widgets/payments/Request/payment_widget.dart';

enum ViewMode { request, payment }

class PaymentRequestScreen extends StatefulWidget {
  const PaymentRequestScreen({super.key});

  @override
  State<PaymentRequestScreen> createState() => _PaymentRequestScreenState();
}

class _PaymentRequestScreenState extends State<PaymentRequestScreen> {
  ViewMode view = ViewMode.request;
  Decimal amount = Decimal.parse("0.0");
  Decimal fullAmount = Decimal.parse("0.0");
  Decimal amountperMonth = Decimal.parse("0.0");
  Decimal finalMonthAmount = Decimal.parse("0.0");
  Decimal installmentFee = Decimal.parse("0.0");
  Decimal networkFee = Decimal.parse("0.0");
  Decimal omnifyFee = Decimal.parse("0.0");
  int installmentPeriod = 0;
  String paymentID = '';
  Chain c = Chain.Avalanche;
  bool isInstallments = false;
  Widget buildLogo(
          bool isDark, bool widthQuery, TextDirection dir, String label) =>
      Directionality(
        textDirection: dir,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  if (view == ViewMode.request) {
                    Navigator.pop(context);
                  } else {
                    view = ViewMode.request;
                    setState(() {});
                  }
                },
                child: Icon(Icons.arrow_back_ios,
                    color: isDark ? Colors.white70 : Colors.black)),
            SizedBox(
                height: 60,
                width: 60,
                child: ExtendedImage.network(Utils.payUrl,
                    cache: true, enableLoadState: false)),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widthQuery ? 20 : 17)),
          ],
        ),
      );
  void changeViewmode(
      Decimal amountParam,
      Decimal perMonthParam,
      Decimal installmentFeeParam,
      Decimal networkFeeParam,
      Decimal omnifyFeeParam,
      int periodParam,
      Chain chainParam,
      bool isInstallmentsParam,
      String payID,
      Decimal fullAmountParam,
      Decimal finalMonthAmountParam) {
    amount = amountParam;
    amountperMonth = perMonthParam;
    installmentFee = installmentFeeParam;
    networkFee = networkFeeParam;
    omnifyFee = omnifyFeeParam;
    installmentPeriod = periodParam;
    c = chainParam;
    isInstallments = isInstallmentsParam;
    paymentID = payID;
    fullAmount = fullAmountParam;
    finalMonthAmount = finalMonthAmountParam;
    view = ViewMode.payment;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final widthQuery = Utils.widthQuery(context);
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final lang = Utils.language(context);
    return WillPopScope(
        onWillPop: () async {
          if (view == ViewMode.request) {
            return true;
          } else {
            view = ViewMode.request;
            setState(() {});
            return false;
          }
        },
        child: SelectionArea(
          child: Scaffold(
            appBar: null,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          buildLogo(isDark, widthQuery, dir, lang.pay18),
                          if (view == ViewMode.payment)
                            PaymentRequestWidget(
                              amount: amount,
                              amountperMonth: amountperMonth,
                              c: c,
                              installmentFee: installmentFee,
                              installmentPeriod: installmentPeriod,
                              isInstallments: isInstallments,
                              networkFee: networkFee,
                              omnifyFee: omnifyFee,
                              paymentID: paymentID,
                              fullAmount: fullAmount,
                              finalMonthAmount: finalMonthAmount,
                            ),
                          if (view == ViewMode.request)
                            PaymentForm(
                                isRequest: true, changeViewMode: changeViewmode)
                        ],
                      ))),
            ),
          ),
        ));
  }
}
