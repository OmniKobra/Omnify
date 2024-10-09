// ignore_for_file: use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../crypto/features/payment_utils.dart';
import '../../../languages/app_language.dart';
import '../../../models/installment_plan.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../utils.dart';
import '../../common/refresh_indicator.dart';
import '../../common/loading_widget.dart';
import '../../common/error_widget.dart';
import '../../home/wallet_button.dart';

class InstallmentPlans extends StatefulWidget {
  final List<InstallmentPlan> plans;
  final void Function(InstallmentPlan, Chain, void Function()) setPlan;
  final void Function(List<InstallmentPlan>) setAllPlans;
  const InstallmentPlans(this.plans, this.setPlan, this.setAllPlans);

  @override
  State<InstallmentPlans> createState() => _InstallmentPlansState();
}

class _InstallmentPlansState extends State<InstallmentPlans> {
  bool isDue = true;
  bool isComplete = true;
  bool isOngoing = true;
  Chain c = Chain.Avalanche;
  Future<List<InstallmentPlan>>? _getAndSetPlans;
  DropdownMenuItem<Chain> buildLangButtonItem(
      Chain value, AppLanguage lang, bool widthQuery, bool isDark) {
    return DropdownMenuItem<Chain>(
      value: value,
      onTap: () async {
        final wallet = Provider.of<WalletProvider>(context, listen: false);
        final walletAddress = wallet.getAddressString(value);
        if (c != value) {
          final val = await Provider.of<ThemeProvider>(context, listen: false)
              .setStartingChain(value, context, walletAddress);
          if (val) {
            final _wallet = Provider.of<WalletProvider>(context, listen: false);
            if (_wallet.isWalletConnected) {
              setState(() {
                _getAndSetPlans =
                    getAndSetPlans(_wallet.getAddressString(value));
              });
            }
            setState(() {
              c = value;
            });
          }
        }
      },
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Utils.buildNetworkLogo(widthQuery, value, true),
            const SizedBox(width: 7.5),
            Text(value.name,
                style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black,
                    fontSize: widthQuery ? 17 : 15))
          ]),
    );
  }

  Widget buildNetworkPicker(Chain current, bool isDark, bool widthQuery,
          AppLanguage lang, List<Chain> supportedChains) =>
      DropdownButton(
          dropdownColor: isDark ? Colors.grey[800] : Colors.white,
          // key: UniqueKey(),
          elevation: 8,
          onChanged: supportedChains.isEmpty ? null : (_) => setState(() {}),
          menuMaxHeight: widthQuery ? 500 : 450,
          underline: Container(color: Colors.transparent),
          icon: Icon(Icons.arrow_drop_down,
              color: isDark ? Colors.white70 : Colors.black),
          value: current,
          items: supportedChains
              .map((c) => buildLangButtonItem(c, lang, widthQuery, isDark))
              .toList());

  Widget buildCheckBox(bool value, String label, bool isDark, bool widthQuery,
          bool paramIsDue, bool paramIsOngoing) =>
      Row(
        children: [
          Expanded(
            child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                visualDensity: VisualDensity.comfortable,
                hoverColor: Colors.transparent,
                leading: Checkbox(
                    value: value,
                    onChanged: (_) {
                      if (_ == true) {
                        if (paramIsDue) {
                          isDue = true;
                        } else if (paramIsOngoing) {
                          isOngoing = true;
                        } else {
                          isComplete = true;
                        }
                      } else {
                        if (paramIsDue) {
                          isDue = false;
                        } else if (paramIsOngoing) {
                          isOngoing = false;
                        } else {
                          isComplete = false;
                        }
                      }
                      setState(() {});
                    },
                    hoverColor: Colors.transparent,
                    splashRadius: 0),
                horizontalTitleGap: 5,
                title: Text(label,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black,
                      fontSize: widthQuery ? 16 : 14,
                    ))),
          ),
        ],
      );
  Widget buildDetails(
          bool isDark, TextDirection dir, bool widthQuery, AppLanguage lang) =>
      Directionality(
          textDirection: dir,
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                    color:
                        isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(5),
                color: isDark ? Colors.grey[800] : Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.filter_alt,
                          color: isDark ? Colors.white60 : Colors.black),
                      const SizedBox(width: 5),
                      Text(lang.pay35,
                          style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black,
                              fontSize: widthQuery ? 17 : 14,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  if (widthQuery)
                    Row(children: [
                      Expanded(
                          flex: 2,
                          child: buildCheckBox(isDue, lang.pay36, isDark,
                              widthQuery, true, false)),
                      Expanded(
                          flex: 2,
                          child: buildCheckBox(isOngoing, lang.pay37, isDark,
                              widthQuery, false, true)),
                      const Spacer(flex: 3)
                    ]),
                  if (!widthQuery)
                    buildCheckBox(
                        isDue, lang.pay36, isDark, widthQuery, true, false),
                  if (!widthQuery)
                    buildCheckBox(
                        isOngoing, lang.pay37, isDark, widthQuery, false, true),
                  buildCheckBox(
                      isComplete, lang.pay38, isDark, widthQuery, false, false),
                ],
              )));

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

  Widget buildContentTile(IconData icon, String title, bool widthQuery,
          bool isDark, bool isCurrency) =>
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

  Widget buildPlanTile(bool isDark, TextDirection dir, bool widthQuery,
      InstallmentPlan plan, Color primaryColor, AppLanguage lang) {
    const empty = SizedBox(height: 0, width: 0);
    return Directionality(
      textDirection: dir,
      child: plan.isComplete && !isComplete
          ? empty
          : plan.isDue && !isDue
              ? empty
              : !plan.isComplete && !plan.isDue && !isOngoing
                  ? empty
                  : Container(
                      margin: EdgeInsets.only(
                          right: widthQuery ? 8 : 0,
                          bottom: widthQuery ? 8 : 5),
                      height: null,
                      width: widthQuery ? 450 : double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: isDark
                              ? Colors.grey.shade700
                              : plan.isComplete
                                  ? Colors.lightGreenAccent
                                  : plan.isDue
                                      ? Colors.red
                                      : plan.isOngoing && !plan.isDue
                                          ? Colors.amber
                                          : Colors.red),
                      child: InkWell(
                        onTap: () {
                          widget.setPlan(plan, c, () {
                            setState(() {});
                          });
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: widthQuery
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 8)
                                      : null,
                                  child: Center(
                                      child: Icon(
                                          plan.isComplete
                                              ? Icons.check
                                              : plan.isDue
                                                  ? Icons.warning_amber
                                                  : plan.isOngoing &&
                                                          !plan.isDue
                                                      ? Icons.hourglass_full
                                                      : Icons.warning_amber,
                                          color: isDark
                                              ? Colors.white60
                                              : Colors.white,
                                          size: widthQuery ? 50 : 30))),
                              Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.5,
                                              color: isDark
                                                  ? Colors.grey.shade700
                                                  : plan.isComplete
                                                      ? Colors.lightGreenAccent
                                                      : plan.isDue
                                                          ? Colors.red
                                                          : plan.isOngoing &&
                                                                  !plan.isDue
                                                              ? Colors.amber
                                                              : Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: isDark
                                              ? Colors.grey[800]
                                              : Colors.white),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildPropertyLabel(
                                                lang.pay39,
                                                primaryColor,
                                                isDark,
                                                widthQuery),
                                            buildContentTile(
                                                Icons.person,
                                                "${plan.vendorAddress} / ${plan.payerAddress}",
                                                widthQuery,
                                                isDark,
                                                false),
                                            buildPropertyLabel(
                                                lang.pay40,
                                                primaryColor,
                                                isDark,
                                                widthQuery),
                                            buildContentTile(
                                                Icons.receipt,
                                                "${Utils.removeTrailingZeros(plan.amountPaid.toStringAsFixed(Utils.nativeTokenDecimals(c)))}/${Utils.removeTrailingZeros(plan.amountTotal.toStringAsFixed(Utils.nativeTokenDecimals(c)))}",
                                                widthQuery,
                                                isDark,
                                                true),
                                            buildPropertyLabel(
                                                lang.pay41,
                                                primaryColor,
                                                isDark,
                                                widthQuery),
                                            buildContentTile(
                                                Icons.calculate,
                                                "${Utils.removeTrailingZeros(plan.plan.toStringAsFixed(Utils.nativeTokenDecimals(c)))}/${lang.pay43}",
                                                widthQuery,
                                                isDark,
                                                true),
                                            buildPropertyLabel(
                                                lang.pay42,
                                                primaryColor,
                                                isDark,
                                                widthQuery),
                                            buildContentTile(
                                                Icons.date_range,
                                                Utils.timeStamp(
                                                    plan.upcomingPaymentDate,
                                                    Provider.of<ThemeProvider>(
                                                            context,
                                                            listen: false)
                                                        .langCode,
                                                    context),
                                                widthQuery,
                                                isDark,
                                                false)
                                          ])))
                            ]),
                      )),
    );
  }

  Future<List<InstallmentPlan>> getAndSetPlans(String walletAddress) async {
    return Future<List<InstallmentPlan>>.delayed(
        const Duration(milliseconds: 500), () {
      final client = Provider.of<ThemeProvider>(context, listen: false).client;
      return PaymentUtils.fetchInstallmentPlans(
              c: c, walletAddress: walletAddress, client: client)
          .then((pls) {
        widget.setAllPlans(pls);
        if (mounted) setState(() {});
        return pls;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    c = Provider.of<ThemeProvider>(context, listen: false).startingChain;
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final walletConnected = walletProvider.isWalletConnected;
    final walletAddress = walletProvider.getAddressString(c);
    if (walletConnected && _getAndSetPlans == null) {
      _getAndSetPlans = getAndSetPlans(walletAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final heightBox = SizedBox(height: widthQuery ? 10 : 5);
    final lang = Utils.language(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final supportedChains = walletProvider.supportedChains;
    final walletMethods = Provider.of<WalletProvider>(context, listen: false);
    final walletConnected = walletProvider.isWalletConnected;
    final walletAddress = walletMethods.getAddressString(c);
    if (walletConnected && _getAndSetPlans == null) {
      _getAndSetPlans = getAndSetPlans(walletAddress);
    }
    if (!walletConnected && _getAndSetPlans != null) {
      widget.setAllPlans([]);
      _getAndSetPlans = null;
    }
    return FutureBuilder(
        future: _getAndSetPlans,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const MyLoading();
          }
          if (snap.hasError) {
            return MyError(() {
              setState(() {
                _getAndSetPlans = getAndSetPlans(walletAddress);
              });
            });
          }
          return Directionality(
            textDirection: dir,
            child: MyRefresh(
              onRefresh: () async {
                setState(() {
                  _getAndSetPlans = getAndSetPlans(walletAddress);
                });
              },
              child: ListView(
                children: [
                  Directionality(
                    textDirection: dir,
                    child: Row(
                      children: [
                        Container(
                            padding: widthQuery
                                ? const EdgeInsets.all(8)
                                : const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isDark
                                        ? Colors.grey.shade700
                                        : Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(5),
                                color:
                                    isDark ? Colors.grey[800] : Colors.white),
                            child: buildNetworkPicker(
                                c, isDark, widthQuery, lang, supportedChains)),
                        const SizedBox(width: 5),
                        const WalletButton()
                      ],
                    ),
                  ),
                  heightBox,
                  buildDetails(isDark, dir, widthQuery, lang),
                  heightBox,
                  if (!widthQuery)
                    ...widget.plans.map((e) => buildPlanTile(
                        isDark, dir, widthQuery, e, primaryColor, lang)),
                  if (widthQuery)
                    Wrap(children: [
                      ...widget.plans.map((e) => buildPlanTile(
                          isDark, dir, widthQuery, e, primaryColor, lang))
                    ]),
                  const SizedBox(height: 8)
                ],
              ),
            ),
          );
        });
  }
}
