// ignore_for_file: deprecated_member_use

import 'package:decimal/decimal.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/installment_plan.dart';
import '../providers/theme_provider.dart';
import '../providers/wallet_provider.dart';
import '../utils.dart';
import '../widgets/home/wallet_button.dart';
import '../widgets/payments/Bill/payment_details.dart';
import '../widgets/payments/installments/installment_payments.dart';
import '../widgets/payments/installments/plans.dart';

enum ViewMode { plans, payments, paying }

class InstallmentScreen extends StatefulWidget {
  const InstallmentScreen({super.key});

  @override
  State<InstallmentScreen> createState() => _InstallmentScreenState();
}

class _InstallmentScreenState extends State<InstallmentScreen> {
  ViewMode view = ViewMode.plans;
  Chain c = Chain.Avalanche;
  Decimal amount = Decimal.parse("0.0");
  String vendorAddress = '';
  int installmentPeriod = 0;
  Decimal amountPerMonth = Decimal.parse("0.0");
  void Function() installmentHandler = () {};
  void Function() planSetState = () {};
  void switchToPayment(Decimal a, String vendor, int period, Decimal perMonth,
      void Function() handler) {
    view = ViewMode.paying;
    amount = a;
    vendorAddress = vendor;
    installmentPeriod = period;
    amountPerMonth = perMonth;
    installmentHandler = handler;
    setState(() {});
  }

  List<InstallmentPlan> plans = [];
  void setPlans(List<InstallmentPlan> ps) {
    plans = ps;
    if (mounted) setState(() {});
  }

  InstallmentPlan? currentPlan;
  void setCurrentPlan(
      InstallmentPlan i, Chain pc, void Function() _planSetState) {
    currentPlan = i;
    c = pc;
    view = ViewMode.payments;
    planSetState = _planSetState;
    setState(() {});
  }

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
                  if (view == ViewMode.plans) {
                    Navigator.pop(context);
                  } else if (view == ViewMode.payments) {
                    view = ViewMode.plans;
                    setState(() {});
                  } else {
                    view = ViewMode.payments;
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
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final wallet = Provider.of<WalletProvider>(context);
    final walletConnected = wallet.isWalletConnected;
    return WillPopScope(
        onWillPop: () async {
          if (view == ViewMode.plans) {
            return true;
          } else if (view == ViewMode.payments) {
            view = ViewMode.plans;
            setState(() {});
            return false;
          } else {
            view = ViewMode.payments;
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
                          padding:
                              const EdgeInsets.only(top: 8, left: 8, right: 8),
                          child: Column(children: [
                            buildLogo(
                                isDark,
                                widthQuery,
                                dir,
                                view == ViewMode.plans
                                    ? lang.pay3
                                    : lang.pay25),
                            Expanded(
                                child: walletConnected
                                    ? view == ViewMode.plans
                                        ? InstallmentPlans(
                                            plans, setCurrentPlan, setPlans)
                                        : view == ViewMode.payments
                                            ? InstallmentPayments(
                                                currentPlan!,
                                                c,
                                                switchToPayment,
                                                planSetState,
                                              )
                                            : PaymentDetails(
                                                buildLogo: null,
                                                chain: c,
                                                amount: amount,
                                                isInstallments: true,
                                                paymentID:
                                                    currentPlan!.paymentID,
                                                amountperMonth: amountPerMonth,
                                                finalInstallment: currentPlan!
                                                    .calculateFinalInstallment(),
                                                installmentPeriod:
                                                    installmentPeriod,
                                                vendorAddress: vendorAddress,
                                                hasInstallments: false,
                                                fullAmount:
                                                    currentPlan!.amountTotal,
                                                installmentHandler:
                                                    installmentHandler,
                                              )
                                    : Column(
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
                                              child: Text(lang.pay34,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: widthQuery
                                                          ? 19
                                                          : 16)),
                                            )),
                                            const SizedBox(height: 15),
                                            const WalletButton(),
                                          ]))
                          ]))))),
        ));
  }
}
