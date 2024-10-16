import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../languages/app_language.dart';
import '../../models/deposit.dart';
import '../../providers/activities/trust_activity_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../subtabs/manage_tab.dart';
import '../../utils.dart';
import '../../widgets/common/refresh_indicator.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/activity/activity_appbar.dart';
import '../../widgets/activity/bridge/assets_widget.dart';
import '../../widgets/home/wallet_button.dart';
import '../../widgets/network_picker.dart';

class TrustActivity extends StatefulWidget {
  const TrustActivity({super.key});

  @override
  State<TrustActivity> createState() => _TrustActivityState();
}

class _TrustActivityState extends State<TrustActivity> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final controller = ScrollController();
  bool isOwner = true;
  bool isBeneficiary = true;

  Widget buildDepositTile(
      bool isDark, bool widthQuery, TextDirection dir, Deposit d) {
    const transparent = WidgetStatePropertyAll(Colors.transparent);
    final decoration = BoxDecoration(
        border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        color: isDark ? Colors.grey[800] : Colors.white);
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
          leading: Utils.buildAssetLogoFromUrl(true, d.asset.logoUrl, true),
          title: Text(Utils.removeTrailingZeros(
              d.amountRemaining.toStringAsFixed(d.asset.decimals))),
          subtitle: Text(Utils.timeStamp(
              d.dateCreated,
              Provider.of<ThemeProvider>(context, listen: false).langCode,
              context)),
          trailing: TextButton(
              onPressed: () {
                scaffoldState.currentState?.showBottomSheet(
                  (context) {
                    return Container(
                        decoration: decoration,
                        child: SelectionArea(
                            child: ManageTab(isSheet: true, deposit: d)));
                  },
                  enableDrag: false,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                );
              },
              style: ButtonStyle(
                  alignment: dir == TextDirection.rtl
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
                  overlayColor: transparent,
                  shadowColor: transparent,
                  backgroundColor: transparent),
              child: Text(Utils.language(context).escrow5)),
        ));
  }

  Widget buildCheckBox(bool value, String label, bool isDark, bool widthQuery,
          bool paramIsOwner) =>
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
                        if (paramIsOwner) {
                          isOwner = true;
                        } else {
                          isBeneficiary = true;
                        }
                      } else {
                        if (paramIsOwner) {
                          isOwner = false;
                        } else {
                          isBeneficiary = false;
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
              child: Column(children: [
                Row(
                  children: [
                    Icon(Icons.filter_alt,
                        color: isDark ? Colors.white60 : Colors.black),
                    const SizedBox(width: 5),
                    Text(lang.trustActivity4,
                        style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black,
                            fontSize: widthQuery ? 17 : 14,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                Row(children: [
                  Expanded(
                      flex: 2,
                      child: buildCheckBox(isOwner, lang.trustActivity5, isDark,
                          widthQuery, true)),
                  if (widthQuery)
                    Expanded(
                        flex: 2,
                        child: buildCheckBox(isBeneficiary, lang.trustActivity6,
                            isDark, widthQuery, false)),
                  if (widthQuery) const Spacer(flex: 3),
                ]),
                if (!widthQuery)
                  buildCheckBox(isBeneficiary, lang.trustActivity6, isDark,
                      widthQuery, false)
              ])));

  @override
  void initState() {
    super.initState();
    var activity = Provider.of<TrustActivityProvider>(context, listen: false);
    var c = activity.currentChain;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final address = wallet.getAddressString(c);
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    if (wallet.isWalletConnected) {
      activity.setFuture(c, address, false, client);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dir = theme.textDirection;
    final client = theme.client;
    final isDark = theme.isDark;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    var trustActivity = Provider.of<TrustActivityProvider>(context);
    final list = trustActivity.deposits;
    final fetchProfile = trustActivity.fetchTrustProfile;
    final myAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(theme.startingChain);
    final c = trustActivity.currentChain;
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    return SelectionArea(
      child: Scaffold(
          key: scaffoldState,
          body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                  child: Column(children: [
                ActivityAppBar(lang.trustActivity1),
                Expanded(
                    child: Directionality(
                  textDirection: dir,
                  child: FutureBuilder(
                      future: fetchProfile,
                      builder: (ctx, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const MyLoading();
                        }
                        if (snap.hasError) {
                          return MyError(() {
                            Provider.of<TrustActivityProvider>(context,
                                    listen: false)
                                .setFuture(c, myAddress, true, client);
                          });
                        }
                        return MyRefresh(
                          onRefresh: () async {
                            Provider.of<TrustActivityProvider>(context,
                                    listen: false)
                                .setFuture(c, myAddress, true, client);
                          },
                          child: ListView(
                            controller: controller,
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
                                        borderRadius: BorderRadius.circular(5),
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
                                        isPaymentActivity: false,
                                        isTrustActivity: true,
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
                                        top: 8, right: 8, left: 8, bottom: 8),
                                    child: const WalletButton())
                              ]),
                              const SizedBox(height: 5),
                              if (widthQuery)
                                Row(children: [
                                  Expanded(
                                      child: BridgeAssetsWidget(
                                          isWithdrawn: true,
                                          isAvailable: false,
                                          isMigrated: false,
                                          controller: controller)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: BridgeAssetsWidget(
                                          isWithdrawn: false,
                                          isAvailable: true,
                                          isMigrated: false,
                                          controller: controller))
                                ]),
                              if (!widthQuery)
                                BridgeAssetsWidget(
                                    isWithdrawn: true,
                                    isAvailable: false,
                                    isMigrated: false,
                                    controller: controller),
                              const SizedBox(height: 5),
                              if (!widthQuery)
                                BridgeAssetsWidget(
                                    isWithdrawn: false,
                                    isAvailable: true,
                                    isMigrated: false,
                                    controller: controller),
                              const SizedBox(height: 5),
                              buildDetails(isDark, dir, widthQuery, lang),
                              const SizedBox(height: 5),
                              Wrap(
                                children: [
                                  ...list.map((e) {
                                    if (!isOwner &&
                                        e.owners.any((element) =>
                                            element == myAddress)) {
                                      return Container();
                                    }
                                    if (!isBeneficiary &&
                                        e.beneficiaries.any((element) =>
                                            element.address == myAddress)) {
                                      return Container();
                                    }
                                    return e.beneficiaries.any((element) =>
                                                element.address == myAddress) ||
                                            e.owners.any((element) =>
                                                element == myAddress)
                                        ? buildDepositTile(
                                            isDark, widthQuery, dir, e)
                                        : Container();
                                  })
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                ))
              ])))),
    );
  }
}
