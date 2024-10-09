import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../../crypto/features/payment_utils.dart';
import '../../languages/app_language.dart';
import '../../models/receipt.dart';
import '../../providers/activities/payment_activity_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../utils.dart';
import '../../widgets/activity/activity_appbar.dart';
import '../../widgets/activity/payment/payments_receipt_widget.dart';
import '../../widgets/activity/show_more.dart';
import '../../widgets/common/refresh_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/field_suffix.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/home/wallet_button.dart';

class PaymentReceiptScreen extends StatefulWidget {
  const PaymentReceiptScreen({super.key});

  @override
  State<PaymentReceiptScreen> createState() => _PaymentReceiptScreenState();
}

class _PaymentReceiptScreenState extends State<PaymentReceiptScreen> {
  final TextEditingController searchController = TextEditingController();
  Future<List<Receipt>>? getReceipts;
  bool hasSearched = false;
  bool isPaid = true;
  bool isReceived = true;
  bool isRefunds = true;
  bool isSearching = false;
  List<Receipt> searchedReceipts = [];
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
          Chain c, Web3Client client, String label, String clearLabel) =>
      TextButton(
          onPressed: () async {
            if (!isSearching) {
              FocusScope.of(context).unfocus();
              if (hasSearched) {
                hasSearched = false;
                searchedReceipts = [];
                searchController.clear();
                setState(() {});
              } else {
                setState(() {
                  isSearching = true;
                });
                if (searchController.text.isNotEmpty) {
                  hasSearched = true;
                  final Receipt? r = await PaymentUtils.fetchReceipt(
                      c: c, id: searchController.text, client: client);
                  searchedReceipts = r != null ? [r] : [];
                }
                setState(() {
                  isSearching = false;
                });
              }
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
  Widget buildCheckBox(bool value, String label, bool isDark, bool widthQuery,
          bool paramIsPaid, bool paramIsRefunds) =>
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
                        if (paramIsPaid) {
                          isPaid = true;
                        } else if (paramIsRefunds) {
                          isRefunds = true;
                        } else {
                          isReceived = true;
                        }
                      } else {
                        if (paramIsPaid) {
                          isPaid = false;
                        } else if (paramIsRefunds) {
                          isRefunds = false;
                        } else {
                          isReceived = false;
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
                      Text(lang.bridgeActivity7,
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
                          child: buildCheckBox(isPaid, lang.paymentActivity13,
                              isDark, widthQuery, true, false)),
                      Expanded(
                          flex: 2,
                          child: buildCheckBox(
                              isReceived,
                              lang.paymentActivity14,
                              isDark,
                              widthQuery,
                              false,
                              false)),
                      const Spacer(flex: 3)
                    ]),
                  if (!widthQuery)
                    buildCheckBox(isPaid, lang.paymentActivity13, isDark,
                        widthQuery, true, false),
                  if (!widthQuery)
                    buildCheckBox(isReceived, lang.paymentActivity14, isDark,
                        widthQuery, false, false),
                  buildCheckBox(isRefunds, lang.paymentActivity4, isDark,
                      widthQuery, false, true),
                ],
              )));

  @override
  void initState() {
    super.initState();
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final paymentActivityProvider =
        Provider.of<PaymentActivityProvider>(context, listen: false);
    final c = paymentActivityProvider.currentChain;
    final setReceipts = paymentActivityProvider.setReceipts;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final client = theme.client;
    final receiptList = paymentActivityProvider.allReceipts;
    if (wallet.isWalletConnected) {
      if (receiptList.isEmpty) {
        getReceipts = PaymentUtils.fetchProfileReceipts(
            c: c,
            client: client,
            walletAddress: wallet.getAddressString(c),
            setReceipts: setReceipts,
            useSetter: true);
      }
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
    final lang = Utils.language(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final walletMethods = Provider.of<WalletProvider>(context, listen: false);
    final myAddress = walletMethods.getAddressString(theme.startingChain);
    final walletConnected = walletProvider.isWalletConnected;
    final widthQuery = Utils.widthQuery(context);
    final paymentActivity = Provider.of<PaymentActivityProvider>(context);
    final chain = paymentActivity.currentChain;
    return SelectionArea(
        child: Scaffold(
            body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                    child: Column(children: [
                  ActivityAppBar(lang.paymentActivity6),
                  if (!walletConnected)
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Icon(Icons.wallet,
                                    color: Colors.grey.shade500, size: 80)),
                            const SizedBox(height: 5),
                            Center(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widthQuery ? 8 : 24.0),
                              child: Text(lang.paymentActivity10,
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: widthQuery ? 19 : 16)),
                            )),
                            const SizedBox(height: 15),
                            const WalletButton(),
                          ]),
                    ),
                  Expanded(
                      child: FutureBuilder(
                          future: getReceipts,
                          builder: (ctx, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return const MyLoading();
                            }
                            if (snap.hasError) {
                              return MyError(() {
                                setState(() {
                                  getReceipts =
                                      PaymentUtils.fetchProfileReceipts(
                                          c: chain,
                                          client: theme.client,
                                          walletAddress: myAddress,
                                          setReceipts: Provider.of<
                                                      PaymentActivityProvider>(
                                                  context,
                                                  listen: false)
                                              .setReceipts,
                                          useSetter: true);
                                  hasSearched = false;
                                  isSearching = false;
                                  searchedReceipts = [];
                                  searchController.clear();
                                });
                              });
                            }
                            return Builder(builder: (ctx) {
                              final _paymentActivity =
                                  Provider.of<PaymentActivityProvider>(ctx);
                              final receipts = _paymentActivity.receipts;
                              return Expanded(
                                  child: Column(children: [
                                if (walletConnected)
                                  Expanded(
                                      child: Directionality(
                                          textDirection: dir,
                                          child: MyRefresh(
                                            onRefresh: () async {
                                              setState(() {
                                                getReceipts = PaymentUtils
                                                    .fetchProfileReceipts(
                                                        c: chain,
                                                        client: theme.client,
                                                        walletAddress:
                                                            myAddress,
                                                        setReceipts: Provider
                                                                .of<PaymentActivityProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                            .setReceipts,
                                                        useSetter: true);
                                                hasSearched = false;
                                                isSearching = false;
                                                searchedReceipts = [];
                                                searchController.clear();
                                              });
                                            },
                                            child: ListView(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                children: [
                                                  Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        buildField(
                                                            lang.explorerHint4,
                                                            Utils.widthQuery(
                                                                context),
                                                            isDark),
                                                        const SizedBox(
                                                            width: 5),
                                                        buildSearchButton(
                                                            chain,
                                                            theme.client,
                                                            lang.trust37,
                                                            lang.escrow2),
                                                        if (widthQuery)
                                                          const Spacer(flex: 1)
                                                      ]),
                                                  const SizedBox(height: 5),
                                                  buildDetails(isDark, dir,
                                                      widthQuery, lang),
                                                  const SizedBox(height: 5),
                                                  if (!hasSearched &&
                                                      receipts.isNotEmpty &&
                                                      !widthQuery)
                                                    ...receipts.map((r) => ((!isRefunds &&
                                                                r.isRefunded) ||
                                                            (!isReceived &&
                                                                r.payer !=
                                                                    myAddress) ||
                                                            (!isPaid &&
                                                                r.payer ==
                                                                    myAddress))
                                                        ? Container()
                                                        : PaymentReceipt(
                                                            receipt: r)),
                                                  if (!hasSearched &&
                                                      receipts.isNotEmpty &&
                                                      widthQuery)
                                                    Wrap(children: [
                                                      ...receipts.map((r) => ((!isRefunds &&
                                                                  r
                                                                      .isRefunded) ||
                                                              (!isReceived &&
                                                                  r.payer !=
                                                                      myAddress) ||
                                                              (!isPaid &&
                                                                  r.payer ==
                                                                      myAddress))
                                                          ? Container()
                                                          : PaymentReceipt(
                                                              receipt: r))
                                                    ]),
                                                  if (hasSearched &&
                                                          searchedReceipts
                                                              .isEmpty ||
                                                      receipts.isEmpty) ...[
                                                    Center(
                                                        child: Icon(
                                                            Icons.receipt,
                                                            color: Colors
                                                                .grey.shade500,
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
                                                      child: Text(
                                                          lang
                                                              .paymentActivity21,
                                                          style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade500,
                                                              fontSize:
                                                                  widthQuery
                                                                      ? 19
                                                                      : 16)),
                                                    ))
                                                  ],
                                                  if (hasSearched &&
                                                      searchedReceipts
                                                          .isNotEmpty)
                                                    Wrap(children: [
                                                      ...searchedReceipts.map(
                                                          (r) => ((!isRefunds &&
                                                                      r
                                                                          .isRefunded) ||
                                                                  (!isReceived &&
                                                                      r.payer !=
                                                                          myAddress) ||
                                                                  (!isPaid &&
                                                                      r.payer ==
                                                                          myAddress))
                                                              ? Container()
                                                              : PaymentReceipt(
                                                                  receipt: r))
                                                    ])
                                                ]),
                                          ))),
                                if (!hasSearched && receipts.isNotEmpty)
                                  const ShowMore(
                                      isInTransfers: false,
                                      isInPaymentReceipts: true,
                                      isInPaymentWithdrawals: false,
                                      isInBridgeTransactions: false)
                              ]));
                            });
                          }))
                ])))));
  }
}
