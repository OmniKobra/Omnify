import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:provider/provider.dart';

import '../crypto/features/escrow_utils.dart';
import '../my_flutter_app_icons.dart';
import '../providers/escrows_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/wallet_provider.dart';
import '../utils.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/field_suffix.dart';
import '../widgets/common/refresh_indicator.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/escrow/escrow_widget.dart';
import '../widgets/escrow/new_contract.dart';
import '../widgets/home/wallet_button.dart';
import '../widgets/network_picker.dart';

class Escrow extends StatefulWidget {
  const Escrow({super.key});

  @override
  State<Escrow> createState() => _EscrowState();
}

class _EscrowState extends State<Escrow> {
  final TextEditingController searchController = TextEditingController();
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
  Widget buildSearchButton(String label, String clearLabel) {
    var provider = Provider.of<EscrowsProvider>(context, listen: false);
    var hasSearched = provider.hasSearched;
    var isSearching = provider.isSearching;
    return TextButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (hasSearched) {
            provider.setHasSearched(false);
            provider.setSearchedContract(null);
            searchController.clear();
          } else {
            if (searchController.text.isNotEmpty) {
              if (!isSearching) {
                final theme =
                    Provider.of<ThemeProvider>(context, listen: false);
                final client = theme.client;
                final c = theme.startingChain;
                setState(() {
                  provider.setIsSearching(true);
                });
                provider.setSearchedContract(await EscrowUtils.fetchContract(
                    c: c, client: client, id: searchController.text));
                if (provider.searchedContract == null ||
                    provider.searchedContract != null) {
                  provider.setHasSearched(true);
                  provider.setIsSearching(false);
                }
              }
            }
            setState(() {});
          }
        },
        child: isSearching
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(strokeWidth: 1))
            : Text(hasSearched ? clearLabel : label,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.primary)));
  }

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<EscrowsProvider>(context, listen: false);
    var c = provider.currentChain;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final address = wallet.getAddressString(c);
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    if (wallet.isWalletConnected) {
      provider.setFuture(c, address, false, client);
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
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    const heightBox = SizedBox(height: 5);
    final wallet = Provider.of<WalletProvider>(context);
    final walletConnected = wallet.isWalletConnected;
    final walletMethods = Provider.of<WalletProvider>(context, listen: false);
    final address = walletMethods.getAddressString(theme.startingChain);
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    final c = Provider.of<EscrowsProvider>(context, listen: false).currentChain;
    return PieCanvas(
        onMenuToggle: (_) => FocusScope.of(context).unfocus(),
        child: Stack(children: [
          Column(children: [
            Expanded(
                child: Directionality(
                    textDirection: dir,
                    child: FutureBuilder(
                        future:
                            Provider.of<EscrowsProvider>(context).getContracts,
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const MyLoading();
                          }
                          if (snap.hasError) {
                            return MyError(() {
                              Provider.of<EscrowsProvider>(context,
                                      listen: false)
                                  .setFuture(c, address, true, client);
                              searchController.clear();
                            });
                          }
                          Provider.of<EscrowsProvider>(context, listen: false)
                              .setEscrowContracts(snap.data ?? [], false);
                          return Builder(builder: (ctx) {
                            final provider = Provider.of<EscrowsProvider>(ctx);
                            final contracts = provider.escrowContracts;
                            return MyRefresh(
                              onRefresh: () async {
                                Provider.of<EscrowsProvider>(context,
                                        listen: false)
                                    .setFuture(c, address, true, client);
                                searchController.clear();
                              },
                              child: ListView(
                                  padding: EdgeInsets.only(
                                      top: 8,
                                      left: 8,
                                      right: 8,
                                      bottom: widthQuery
                                          ? MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              78
                                          : MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              140),
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
                                              isEscrow: true,
                                              isTransferActivity: false,
                                              isPaymentActivity: false,
                                              isTrustActivity: false,
                                              isBridgeActivity: false,
                                              isEscrowActivity: false,
                                              isTransactions: false,
                                              isDiscoverTransfers: false,
                                              isDiscoverPayments: false,
                                              isDiscoverTrust: false,
                                              isDiscoverBridges: false,
                                              isDiscoverEscrow: false)),
                                      if (widthQuery) const SizedBox(width: 5),
                                      if (widthQuery)
                                        Container(
                                            margin: EdgeInsets.only(
                                                top: 8,
                                                right: 8,
                                                left: widthQuery ? 8 : 0),
                                            child: const WalletButton())
                                    ]),
                                    heightBox,
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
                                              lang.trust37, lang.escrow2),
                                          if (widthQuery) const Spacer(flex: 1),
                                        ]),
                                    heightBox,
                                    if (walletConnected &&
                                        contracts.isNotEmpty &&
                                        !provider.hasSearched)
                                      Wrap(children: [
                                        ...contracts.map((e) => EscrowWidget(
                                            contract: e,
                                            setStater: () {
                                              setState(() {});
                                            },
                                            currentChain:
                                                Provider.of<EscrowsProvider>(
                                                        context)
                                                    .currentChain))
                                      ]),
                                    if (!walletConnected &&
                                        !provider.hasSearched)
                                      const SizedBox(height: 20),
                                    if (!walletConnected &&
                                        !provider.hasSearched)
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                                child: Icon(Icons.wallet,
                                                    color: Colors.grey.shade500,
                                                    size: 80)),
                                            Center(
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widthQuery
                                                                    ? 8
                                                                    : 24.0),
                                                    child: Text(lang.escrow3,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade500,
                                                            fontSize: widthQuery
                                                                ? 19
                                                                : 16)))),
                                            const SizedBox(height: 10),
                                            const WalletButton()
                                          ]),
                                    if (walletConnected && contracts.isEmpty ||
                                        provider.hasSearched &&
                                            provider.searchedContract == null)
                                      const SizedBox(height: 25),
                                    if (walletConnected && contracts.isEmpty ||
                                        provider.hasSearched &&
                                            provider.searchedContract == null)
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                                child: Icon(MyFlutterApp.hand,
                                                    color: Colors.grey.shade500,
                                                    size: 80)),
                                            const SizedBox(height: 5),
                                            Center(
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                widthQuery
                                                                    ? 8
                                                                    : 24.0),
                                                    child: Text(lang.escrow4,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade500,
                                                            fontSize: widthQuery
                                                                ? 19
                                                                : 16))))
                                          ]),
                                    if (provider.hasSearched &&
                                        provider.searchedContract != null)
                                      Wrap(children: [
                                        EscrowWidget(
                                            contract:
                                                provider.searchedContract!,
                                            setStater: () {
                                              setState(() {});
                                            },
                                            currentChain:
                                                Provider.of<EscrowsProvider>(
                                                        context)
                                                    .currentChain)
                                      ])
                                  ]),
                            );
                          });
                        })))
          ]),
          if (walletConnected)
            Align(
                alignment: dir == TextDirection.rtl
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                child: Container(
                    margin: EdgeInsets.only(
                        bottom: widthQuery ? 8 : 70,
                        right: 8,
                        left: dir == TextDirection.rtl ? 8 : 0),
                    child: FloatingActionButton(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          showBottomSheet(
                              context: context,
                              enableDrag: false,
                              backgroundColor:
                                  isDark ? Colors.grey[800] : Colors.white,
                              builder: (_) {
                                return Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: isDark
                                                ? Colors.grey.shade700
                                                : Colors.grey.shade300),
                                        color: isDark
                                            ? Colors.grey[800]
                                            : Colors.white),
                                    child: const NewContractSheet(
                                        isBid: false,
                                        contract: null,
                                        contractChain: Chain.Avalanche));
                              });
                        },
                        child: const Icon(Icons.add_box, color: Colors.white))))
        ]));
  }
}
