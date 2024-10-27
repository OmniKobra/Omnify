import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:provider/provider.dart';

import '../../crypto/features/escrow_utils.dart';
import '../../languages/app_language.dart';
import '../../models/escrow_contract.dart';
import '../../my_flutter_app_icons.dart';
import '../../providers/activities/escrow_activity_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../utils.dart';
import '../../widgets/activity/activity_appbar.dart';
import '../../widgets/common/refresh_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/field_suffix.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/escrow/escrow_widget.dart';
import '../../widgets/home/wallet_button.dart';
import '../../widgets/network_picker.dart';

class EscrowActivity extends StatefulWidget {
  const EscrowActivity({super.key});

  @override
  State<EscrowActivity> createState() => _EscrowActivityState();
}

class _EscrowActivityState extends State<EscrowActivity> {
  final TextEditingController searchController = TextEditingController();
  bool isOngoing = true;
  bool isComplete = true;
  bool isDeleted = true;
  bool bids = true;
  Widget buildField(String hintText, bool widthQuery, bool isDark) => Flexible(
      flex: widthQuery ? 2 : 5,
      child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
            suffixIcon: AddressFieldSuffix(
                showScanButton: false,
                copyHandler: () async {
                  final data = await Clipboard.getData(Clipboard.kTextPlain);
                  if (data != null && data.text != null) {
                    searchController.text = data.text!;
                  }
                },
                scannerHandler: (_) {}),
            hoverColor: Colors.transparent,
            prefixIcon: Icon(Icons.search,
                size: 18, color: isDark ? Colors.white70 : Colors.grey),
            hintText: hintText,
            hintStyle: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey,
                fontSize: widthQuery ? 13 : 12),
            filled: true,
            fillColor: isDark ? Colors.grey.shade700 : Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide.none)),
      ));
  Widget buildSearchButton(
          String label,
          String clearLabel,
          bool hasSearched,
          void Function(bool) setSearched,
          void Function(EscrowContract?) setSearchedContract) =>
      TextButton(
          onPressed: () {
            if (hasSearched) {
              setSearched(false);
              setSearchedContract(null);
              searchController.clear();
            } else {
              if (searchController.value.text.isNotEmpty) {
                FocusScope.of(context).unfocus();
                setSearched(true);
                var profileContracts =
                    Provider.of<EscrowActivityProvider>(context, listen: false)
                        .escrowContracts;
                setSearchedContract(EscrowUtils.searchProfileContract(
                    profileContracts, searchController.value.text));
              }
              setState(() {});
            }
          },
          child: Text(hasSearched ? clearLabel : label,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)));
  Widget buildStat(IconData icon, Color iconColor, String title, int value,
      bool isDark, bool widthQuery) {
    final dir = Provider.of<ThemeProvider>(context).textDirection;
    return Container(
        height: widthQuery ? 225 : 170,
        width: widthQuery ? 175 : 150,
        margin: EdgeInsets.only(
            right: dir == TextDirection.ltr ? 8 : 0,
            left: dir == TextDirection.ltr ? 0 : 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon,
                color: isDark ? Colors.white60 : iconColor,
                size: widthQuery ? 80 : 45),
            SizedBox(height: widthQuery ? 10 : 5),
            Center(
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: widthQuery ? 18 : 16)),
            ),
            const SizedBox(height: 2.5),
            Center(
                child: Text(value.toString(),
                    style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: widthQuery ? 17 : 14))),
          ],
        ));
  }

  Widget buildCheckBox(bool value, String label, bool isDark, bool widthQuery,
          bool paramIsDeleted, bool paramIsOngoing, bool paramIsBids) =>
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
                        if (paramIsDeleted) {
                          isDeleted = true;
                        } else if (paramIsOngoing) {
                          isOngoing = true;
                        } else if (paramIsBids) {
                          bids = true;
                        } else {
                          isComplete = true;
                        }
                      } else {
                        if (paramIsDeleted) {
                          isDeleted = false;
                        } else if (paramIsOngoing) {
                          isOngoing = false;
                        } else if (paramIsBids) {
                          bids = false;
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
                      Text(lang.escrowActivity11,
                          style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black,
                              fontSize: widthQuery ? 17 : 14,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(children: [
                    Expanded(
                        flex: 2,
                        child: buildCheckBox(isOngoing, lang.escrowActivity2,
                            isDark, widthQuery, false, true, false)),
                    if (widthQuery)
                      Expanded(
                          flex: 2,
                          child: buildCheckBox(isComplete, lang.escrowActivity3,
                              isDark, widthQuery, false, false, false)),
                    if (widthQuery) const Spacer(flex: 3),
                  ]),
                  if (!widthQuery)
                    buildCheckBox(isComplete, lang.escrowActivity3, isDark,
                        widthQuery, false, false, false),
                  Row(children: [
                    Expanded(
                        flex: 2,
                        child: buildCheckBox(isDeleted, lang.escrowActivity4,
                            isDark, widthQuery, true, false, false)),
                    if (widthQuery)
                      Expanded(
                          flex: 2,
                          child: buildCheckBox(bids, lang.escrowActivity5,
                              isDark, widthQuery, false, false, true)),
                    if (widthQuery) const Spacer(flex: 3)
                  ]),
                  if (!widthQuery)
                    buildCheckBox(bids, lang.escrowActivity5, isDark,
                        widthQuery, false, false, true)
                ],
              )));

  @override
  void initState() {
    super.initState();
    var activity = Provider.of<EscrowActivityProvider>(context, listen: false);
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
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dir = theme.textDirection;
    final isDark = theme.isDark;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    final primary = Theme.of(context).colorScheme.primary;
    var c = Provider.of<EscrowActivityProvider>(context, listen: false)
        .currentChain;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final address = wallet.getAddressString(c);
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    return SelectionArea(
      child: Scaffold(
          body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: PieCanvas(
                  onMenuToggle: (_) => FocusScope.of(context).unfocus(),
                  child: SafeArea(
                      child: Column(children: [
                    ActivityAppBar(lang.escrowActivity1),
                    Expanded(
                        child: Directionality(
                            textDirection: dir,
                            child: FutureBuilder(
                                future:
                                    Provider.of<EscrowActivityProvider>(context)
                                        .fetchEscrowProfile,
                                builder: (context, snap) {
                                  if (snap.connectionState ==
                                      ConnectionState.waiting) {
                                    return const MyLoading();
                                  }
                                  if (snap.hasError) {
                                    return MyError(() {
                                      Provider.of<EscrowActivityProvider>(
                                              context,
                                              listen: false)
                                          .setFuture(c, address, true, client);
                                      searchController.clear();
                                    });
                                  }
                                  return Builder(builder: (ctx) {
                                    final provider =
                                        Provider.of<EscrowActivityProvider>(
                                            ctx);
                                    final contractsNumber = provider.contracts;
                                    final completedContracts =
                                        provider.completedContracts;
                                    final deletedContracts =
                                        provider.deletedContracts;
                                    final bidsMade = provider.bidsMade;
                                    final bidsReceived = provider.bidsReceived;
                                    final contracts = provider.escrowContracts;
                                    final hasSearched = provider.hasSearched;
                                    final searchedContract =
                                        provider.searchedContract;
                                    final setHasSearched =
                                        Provider.of<EscrowActivityProvider>(ctx,
                                                listen: false)
                                            .setHasSearched;
                                    final setSearchedContract =
                                        Provider.of<EscrowActivityProvider>(ctx,
                                                listen: false)
                                            .setSearchedContract;
                                    return MyRefresh(
                                      onRefresh: () async {
                                        Provider.of<EscrowActivityProvider>(
                                                context,
                                                listen: false)
                                            .setFuture(
                                                c, address, true, client);
                                        searchController.clear();
                                      },
                                      child: ListView(
                                          padding: const EdgeInsets.all(8.0),
                                          children: [
                                            Row(children: [
                                              Container(
                                                  padding: widthQuery
                                                      ? const EdgeInsets.all(8)
                                                      : const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                  decoration: BoxDecoration(
                                                      border: border,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
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
                                                      isTrustActivity: false,
                                                      isBridgeActivity: false,
                                                      isEscrowActivity: true,
                                                      isTransactions: false,
                                                      isDiscoverTransfers:
                                                          false,
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
                                            SizedBox(
                                              height: widthQuery ? 225 : 170,
                                              child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [
                                                    buildStat(
                                                        MyFlutterApp.hand,
                                                        primary,
                                                        lang.escrowActivity6,
                                                        contractsNumber,
                                                        isDark,
                                                        widthQuery),
                                                    buildStat(
                                                        Icons.check_circle,
                                                        Colors.green,
                                                        lang.escrowActivity7,
                                                        completedContracts,
                                                        isDark,
                                                        widthQuery),
                                                    buildStat(
                                                        Icons.delete,
                                                        Colors.red,
                                                        lang.escrowActivity8,
                                                        deletedContracts,
                                                        isDark,
                                                        widthQuery),
                                                    buildStat(
                                                        Icons.money,
                                                        primary,
                                                        lang.escrowActivity9,
                                                        bidsMade,
                                                        isDark,
                                                        widthQuery),
                                                    buildStat(
                                                        Icons.call_received,
                                                        primary,
                                                        lang.escrowActivity10,
                                                        bidsReceived,
                                                        isDark,
                                                        widthQuery)
                                                  ]),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  buildField(
                                                      lang.escrow1,
                                                      Utils.widthQuery(context),
                                                      isDark),
                                                  const SizedBox(width: 5),
                                                  buildSearchButton(
                                                      lang.trust37,
                                                      lang.escrow2,
                                                      hasSearched,
                                                      setHasSearched,
                                                      setSearchedContract),
                                                  if (widthQuery)
                                                    const Spacer(flex: 1)
                                                ]),
                                            const SizedBox(height: 5),
                                            buildDetails(
                                                isDark, dir, widthQuery, lang),
                                            const SizedBox(height: 5),
                                            if (contracts.isNotEmpty &&
                                                !hasSearched)
                                              Wrap(children: [
                                                ...contracts.map((e) {
                                                  if (e.isDeleted &&
                                                      !isDeleted) {
                                                    return const SizedBox();
                                                  }
                                                  if (e.bids.any((element) =>
                                                          element
                                                              .bidAccepted) &&
                                                      !isComplete) {
                                                    return const SizedBox();
                                                  }
                                                  if (!e.bids.any((element) =>
                                                          element
                                                              .bidAccepted) &&
                                                      !e.isDeleted &&
                                                      !isOngoing) {
                                                    return const SizedBox();
                                                  }
                                                  if (e.bids.isNotEmpty &&
                                                      !bids) {
                                                    return const SizedBox();
                                                  }
                                                  return EscrowWidget(
                                                      contract: e,
                                                      setStater: () {
                                                        setState(() {});
                                                      },
                                                      currentChain: provider
                                                          .currentChain);
                                                })
                                              ]),
                                            if (contracts.isEmpty &&
                                                    searchedContract == null ||
                                                hasSearched &&
                                                    searchedContract == null)
                                              const SizedBox(height: 25),
                                            if (contracts.isEmpty &&
                                                    searchedContract == null ||
                                                hasSearched &&
                                                    searchedContract == null)
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                        child: Icon(
                                                            MyFlutterApp.hand,
                                                            color: Colors
                                                                .grey.shade500,
                                                            size: 80)),
                                                    const SizedBox(height: 5),
                                                    Center(
                                                        child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        widthQuery
                                                                            ? 8
                                                                            : 24.0),
                                                            child: Text(
                                                                lang.escrow4,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500,
                                                                    fontSize:
                                                                        widthQuery
                                                                            ? 19
                                                                            : 16))))
                                                  ]),
                                            if (hasSearched &&
                                                searchedContract != null)
                                              Wrap(children: [
                                                EscrowWidget(
                                                    contract: searchedContract,
                                                    setStater: () {
                                                      setState(() {});
                                                    },
                                                    currentChain:
                                                        provider.currentChain)
                                              ])
                                          ]),
                                    );
                                  });
                                })))
                  ]))))),
    );
  }
}
