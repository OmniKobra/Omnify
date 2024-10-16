// ignore_for_file: prefer_final_fields

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:omnify/toasts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../languages/app_language.dart';
import '../models/transaction.dart';
import '../my_flutter_app_icons.dart';
import '../providers/theme_provider.dart';
import '../providers/transactions_provider.dart';
import '../providers/wallet_provider.dart';
import '../utils.dart';
import '../widgets/home/wallet_button.dart';
import '../widgets/network_picker.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool isCategoryCollapsed = true;
  bool isStatusCollapsed = true;
  List<TransactionType> _allowedTransactions = [
    TransactionType.transfer,
    TransactionType.payment,
    TransactionType.trust,
    TransactionType.bridge,
    TransactionType.escrow
  ];
  List<Status> _allowedStatus = [
    Status.pending,
    Status.omnifyReceived,
    Status.omnifySent,
    Status.complete,
    Status.failed
  ];
  void allowTransaction(TransactionType t) {
    if (!_allowedTransactions.contains(t)) {
      _allowedTransactions.add(t);
      setState(() {});
    }
  }

  void removeTransaction(TransactionType t) {
    if (_allowedTransactions.contains(t)) {
      _allowedTransactions.remove(t);
      setState(() {});
    }
  }

  void allowStatus(Status s) {
    if (!_allowedStatus.contains(s)) {
      _allowedStatus.add(s);
      setState(() {});
    }
  }

  void removeStatus(Status s) {
    if (_allowedStatus.contains(s)) {
      _allowedStatus.remove(s);
      setState(() {});
    }
  }

  Widget buildTransactionCheckBox(
          TransactionType t, String label, bool isDark, bool widthQuery) =>
      Row(
        children: [
          Expanded(
            child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                visualDensity: VisualDensity.comfortable,
                hoverColor: Colors.transparent,
                leading: Checkbox(
                    value: _allowedTransactions.contains(t),
                    onChanged: (_) {
                      if (_ == true) {
                        allowTransaction(t);
                      } else {
                        removeTransaction(t);
                      }
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
  Widget buildStatusCheckBox(
          Status s, String label, bool isDark, bool widthQuery) =>
      Row(
        children: [
          Expanded(
            child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                visualDensity: VisualDensity.comfortable,
                hoverColor: Colors.transparent,
                leading: Checkbox(
                    value: _allowedStatus.contains(s),
                    onChanged: (_) {
                      if (_ == true) {
                        allowStatus(s);
                      } else {
                        removeStatus(s);
                      }
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
  Widget buildTransactionDetails(
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
                      Icon(Icons.language,
                          color: isDark ? Colors.white60 : Colors.black),
                      const SizedBox(width: 5),
                      Text(lang.transactions13,
                          style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black,
                              fontSize: widthQuery ? 17 : 14,
                              fontWeight: FontWeight.bold)),
                      if (!widthQuery) const Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isCategoryCollapsed = !isCategoryCollapsed;
                          });
                        },
                        icon: Icon(
                            isCategoryCollapsed
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: isDark ? Colors.white60 : Colors.black),
                      )
                    ],
                  ),
                  if (!isCategoryCollapsed)
                    Column(children: [
                      if (widthQuery)
                        Row(children: [
                          Expanded(
                              flex: 2,
                              child: buildTransactionCheckBox(
                                  TransactionType.transfer,
                                  lang.transactions14,
                                  isDark,
                                  widthQuery)),
                          Expanded(
                              flex: 2,
                              child: buildTransactionCheckBox(
                                  TransactionType.payment,
                                  lang.transactions15,
                                  isDark,
                                  widthQuery)),
                          const Spacer(flex: 3)
                        ]),
                      if (widthQuery)
                        Row(children: [
                          Expanded(
                              flex: 2,
                              child: buildTransactionCheckBox(
                                  TransactionType.trust,
                                  lang.transactions16,
                                  isDark,
                                  widthQuery)),
                          Expanded(
                              flex: 2,
                              child: buildTransactionCheckBox(
                                  TransactionType.bridge,
                                  lang.transactions17,
                                  isDark,
                                  widthQuery)),
                          const Spacer(flex: 3)
                        ]),
                      if (!widthQuery)
                        buildTransactionCheckBox(TransactionType.transfer,
                            lang.transactions14, isDark, widthQuery),
                      if (!widthQuery)
                        buildTransactionCheckBox(TransactionType.payment,
                            lang.transactions15, isDark, widthQuery),
                      if (!widthQuery)
                        buildTransactionCheckBox(TransactionType.trust,
                            lang.transactions16, isDark, widthQuery),
                      if (!widthQuery)
                        buildTransactionCheckBox(TransactionType.bridge,
                            lang.transactions17, isDark, widthQuery),
                      buildTransactionCheckBox(TransactionType.escrow,
                          lang.transactions18, isDark, widthQuery),
                    ])
                ],
              )));
  Widget buildStatusDetails(
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
                      Icon(Icons.satellite_alt_outlined,
                          color: isDark ? Colors.white60 : Colors.black),
                      const SizedBox(width: 5),
                      Text(lang.transactions19,
                          style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black,
                              fontSize: widthQuery ? 17 : 14,
                              fontWeight: FontWeight.bold)),
                      if (!widthQuery) const Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isStatusCollapsed = !isStatusCollapsed;
                          });
                        },
                        icon: Icon(
                            isStatusCollapsed
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: isDark ? Colors.white60 : Colors.black),
                      )
                    ],
                  ),
                  if (!isStatusCollapsed)
                    Column(children: [
                      if (widthQuery)
                        Row(children: [
                          Expanded(
                              flex: 2,
                              child: buildStatusCheckBox(Status.pending,
                                  lang.transactions3, isDark, widthQuery)),
                          Expanded(
                              flex: 2,
                              child: buildStatusCheckBox(Status.complete,
                                  lang.transactions6, isDark, widthQuery)),
                          const Spacer(flex: 3)
                        ]),
                      if (widthQuery)
                        Row(children: [
                          Expanded(
                              flex: 2,
                              child: buildStatusCheckBox(Status.omnifyReceived,
                                  lang.transactions4, isDark, widthQuery)),
                          Expanded(
                              flex: 2,
                              child: buildStatusCheckBox(Status.omnifySent,
                                  lang.transactions5, isDark, widthQuery)),
                          const Spacer(flex: 3)
                        ]),
                      if (!widthQuery)
                        buildStatusCheckBox(Status.pending, lang.transactions3,
                            isDark, widthQuery),
                      if (!widthQuery)
                        buildStatusCheckBox(Status.complete, lang.transactions6,
                            isDark, widthQuery),
                      if (!widthQuery)
                        buildStatusCheckBox(Status.omnifyReceived,
                            lang.transactions4, isDark, widthQuery),
                      if (!widthQuery)
                        buildStatusCheckBox(Status.omnifySent,
                            lang.transactions5, isDark, widthQuery),
                      buildStatusCheckBox(Status.failed, lang.transactions7,
                          isDark, widthQuery),
                    ])
                ],
              )));
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final direction = themeProvider.textDirection;
    final isDark = themeProvider.isDark;
    final widthQuery = Utils.widthQuery(context);
    final _allTransactions =
        Provider.of<TransactionsProvider>(context).transactions;
    final currentChain =
        Provider.of<TransactionsProvider>(context).currentChain;
    final transactions =
        _allTransactions.where((t) => t.c == currentChain).toList();
    final wallet = Provider.of<WalletProvider>(context);
    final walletConnected = wallet.isWalletConnected;
    final lang = Utils.language(context);
    final heightBox = SizedBox(height: widthQuery ? 10 : 5);
    return Directionality(
        textDirection: direction,
        child: SelectionArea(
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  surfaceTintColor: Colors.transparent,
                  automaticallyImplyLeading: true,
                  leading: IconButton(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios,
                          color: isDark ? Colors.white70 : Colors.black)),
                ),
                body: SafeArea(
                    child: Column(children: [
                  Expanded(
                      child:
                          ListView(padding: const EdgeInsets.all(8), children: [
                    if (widthQuery) const SizedBox(height: 5),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                  isEscrowActivity: false,
                                  isTransactions: true,
                                  isDiscoverTransfers: false,
                                  isDiscoverPayments: false,
                                  isDiscoverTrust: false,
                                  isDiscoverBridges: false,
                                  isDiscoverEscrow: false)),
                          const SizedBox(width: 5),
                          Container(
                              margin: EdgeInsets.only(
                                  top: 8, right: 8, left: widthQuery ? 8 : 0),
                              child: const WalletButton())
                        ]),
                    heightBox,
                    if (walletConnected && transactions.isNotEmpty)
                      buildTransactionDetails(
                          isDark, direction, widthQuery, lang),
                    if (walletConnected && transactions.isNotEmpty) heightBox,
                    if (walletConnected && transactions.isNotEmpty)
                      buildStatusDetails(isDark, direction, widthQuery, lang),
                    if (walletConnected && transactions.isNotEmpty) heightBox,
                    if (walletConnected && transactions.isNotEmpty)
                      Wrap(children: [
                        ...transactions.map((t) => TransactionWidget(
                            transaction: t,
                            allowedStatus: _allowedStatus,
                            allowedTransactions: _allowedTransactions))
                      ]),
                    if (walletConnected && transactions.isEmpty)
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: Icon(Icons.hourglass_full,
                                    color: Colors.grey.shade500, size: 80)),
                            const SizedBox(height: 5),
                            Center(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthQuery ? 8 : 24.0),
                                    child: Text(lang.transactions2,
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: widthQuery ? 19 : 16))))
                          ]),
                    if (!walletConnected)
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: Icon(Icons.wallet,
                                    color: Colors.grey.shade500, size: 80)),
                            Center(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthQuery ? 8 : 24.0),
                                    child: Text(lang.transactions1,
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: widthQuery ? 19 : 16)))),
                          ])
                  ]))
                ])))));
  }
}

class TransactionWidget extends StatefulWidget {
  final List<TransactionType> allowedTransactions;
  final List<Status> allowedStatus;
  final Transaction transaction;
  const TransactionWidget(
      {super.key,
      required this.transaction,
      required this.allowedStatus,
      required this.allowedTransactions});

  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  //TODO ADD NEW FEATURES HERE
  bool isExpanded = false;

  String getExplorerUrl(String hash) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (widget.transaction.c) {
      case Chain.Avalanche:
        return "https://snowtrace.io/tx/$hash?chainid=43114";
      case Chain.Optimism:
        return "https://optimistic.etherscan.io/tx/$hash";
      case Chain.BSC:
        return "https://bscscan.com/tx/$hash";
      case Chain.Arbitrum:
        return "https://arbiscan.io/tx/$hash";
      case Chain.Polygon:
        return "https://polygonscan.com/tx/$hash";
      case Chain.Fantom:
        return "https://ftmscan.com/tx/$hash";
      case Chain.Base:
        return "https://basescan.org/tx/$hash";
      case Chain.Linea:
        return "https://lineascan.build/tx/$hash";
      case Chain.Mantle:
        return "https://mantlescan.xyz/tx/$hash";
      case Chain.Gnosis:
        return "https://gnosisscan.io/tx/$hash";
      case Chain.Celo:
        return "https://celoscan.io/tx/$hash";
      case Chain.Scroll:
        return "https://scrollscan.com/tx/$hash";
      case Chain.Blast:
        return "https://blastscan.io/tx/$hash";
      case Chain.Zksync:
        return "https://era.zksync.network/tx/$hash";

      default:
        return "";
    }
  }

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
          bool isStatus, Status? status,
          [bool? underline]) =>
      ListTile(
          minLeadingWidth: 0,
          horizontalTitleGap: 8,
          contentPadding: const EdgeInsets.all(0),
          minVerticalPadding: 0,
          dense: !widthQuery,
          leading: isStatus
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: TransactionUtils.giveStatusColor(
                              status!, isDark)),
                      color: TransactionUtils.giveStatusColor(status, isDark)
                          .withOpacity(.25)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TransactionUtils.giveStatusIcon(status, isDark),
                      const SizedBox(width: 5),
                      Text(statusToString(status))
                    ],
                  ),
                )
              : null,
          title: isStatus
              ? null
              : underline == null
                  ? Text(title)
                  : InkWell(
                      onTap: () {
                        if (widget.transaction.type == TransactionType.bridge) {
                          launchUrlString(
                              "https://layerzeroscan.com/tx/$title");
                        } else {
                          launchUrlString(getExplorerUrl(title));
                        }
                      },
                      child: Text(title,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Theme.of(context).colorScheme.primary)),
                    ));
  String statusToString(Status s) {
    final lang = Utils.language(context);
    switch (s) {
      case Status.pending:
        return lang.transactions3;
      case Status.omnifyReceived:
        return lang.transactions4;
      case Status.omnifySent:
        return lang.transactions5;
      case Status.complete:
        return lang.transactions6;
      case Status.failed:
        return lang.transactions7;
      default:
        return lang.transactions3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dir = theme.textDirection;
    final isDark = theme.isDark;
    final langCode = theme.langCode;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final primary = Theme.of(context).colorScheme.primary;
    final currentStatus = widget.transaction.status;
    final currentCategory = widget.transaction.type;

    return Directionality(
        textDirection: dir,
        key: ValueKey<String>(widget.transaction.id),
        child: widget.allowedStatus.contains(currentStatus) &&
                widget.allowedTransactions.contains(currentCategory)
            ? Container(
                margin: EdgeInsets.only(
                    right: widthQuery ? 8 : 0, bottom: widthQuery ? 8 : 5),
                height: isExpanded
                    ? null
                    : widthQuery
                        ? 220
                        : 205,
                width: widthQuery ? 450 : double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: TransactionUtils.giveColor(
                        isDark, widget.transaction.type)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(8),
                          margin: widthQuery
                              ? const EdgeInsets.symmetric(horizontal: 8)
                              : null,
                          child: Center(
                              child: TransactionUtils.giveIcon(isDark,
                                  widthQuery, widget.transaction.type))),
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: isDark
                                          ? Colors.grey.shade700
                                          : TransactionUtils.giveColor(
                                              isDark, widget.transaction.type)),
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      isDark ? Colors.grey[800] : Colors.white),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildPropertyLabel(lang.transactions8,
                                        primary, isDark, widthQuery),
                                    buildContentTile(widget.transaction.id,
                                        widthQuery, isDark, false, null),
                                    buildPropertyLabel(lang.transactions9,
                                        primary, isDark, widthQuery),
                                    buildContentTile("", widthQuery, isDark,
                                        true, widget.transaction.status),
                                    if (isExpanded)
                                      buildPropertyLabel(
                                          "(1) " + lang.transactions10,
                                          primary,
                                          isDark,
                                          widthQuery),
                                    if (isExpanded)
                                      buildContentTile(
                                          widget.transaction.transactionHash,
                                          widthQuery,
                                          isDark,
                                          false,
                                          null,
                                          true),
                                    if (isExpanded)
                                      buildPropertyLabel(
                                          "(1) " + lang.transactions11,
                                          primary,
                                          isDark,
                                          widthQuery),
                                    if (isExpanded)
                                      buildContentTile(
                                          widget.transaction.blockNumber
                                              .toString(),
                                          widthQuery,
                                          isDark,
                                          false,
                                          null),
                                    if (isExpanded &&
                                        widget.transaction.secondTransactionHash
                                            .isNotEmpty)
                                      buildPropertyLabel(
                                          "(2) " + lang.transactions10,
                                          primary,
                                          isDark,
                                          widthQuery),
                                    if (isExpanded &&
                                        widget.transaction.secondTransactionHash
                                            .isNotEmpty)
                                      buildContentTile(
                                          widget.transaction
                                              .secondTransactionHash,
                                          widthQuery,
                                          isDark,
                                          false,
                                          null,
                                          true),
                                    if (isExpanded &&
                                        widget.transaction.secondBlockNumber >
                                            0)
                                      buildPropertyLabel(
                                          "(2) " + lang.transactions11,
                                          primary,
                                          isDark,
                                          widthQuery),
                                    if (isExpanded &&
                                        widget.transaction.secondBlockNumber >
                                            0)
                                      buildContentTile(
                                          widget.transaction.secondBlockNumber
                                              .toString(),
                                          widthQuery,
                                          isDark,
                                          false,
                                          null),
                                    if (isExpanded &&
                                        widget.transaction.thirdTransactionHash
                                            .isNotEmpty)
                                      buildPropertyLabel(
                                          "(3) " + lang.transactions10,
                                          primary,
                                          isDark,
                                          widthQuery),
                                    if (isExpanded &&
                                        widget.transaction.thirdTransactionHash
                                            .isNotEmpty)
                                      buildContentTile(
                                          widget
                                              .transaction.thirdTransactionHash,
                                          widthQuery,
                                          isDark,
                                          false,
                                          null),
                                    if (isExpanded &&
                                        widget.transaction.thirdBlockNumber > 0)
                                      buildPropertyLabel(
                                          "(3) " + lang.transactions11,
                                          primary,
                                          isDark,
                                          widthQuery),
                                    if (isExpanded &&
                                        widget.transaction.thirdBlockNumber > 0)
                                      buildContentTile(
                                          widget.transaction.thirdBlockNumber
                                              .toString(),
                                          widthQuery,
                                          isDark,
                                          false,
                                          null),
                                    if (isExpanded)
                                      buildPropertyLabel(lang.transactions12,
                                          primary, isDark, widthQuery),
                                    if (isExpanded)
                                      buildContentTile(
                                          Utils.timeStamp(
                                              widget.transaction.date,
                                              langCode,
                                              context),
                                          widthQuery,
                                          isDark,
                                          false,
                                          null),
                                  ]))),
                      IconButton(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        icon: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: isDark ? Colors.white60 : Colors.white),
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                      )
                    ]),
              )
            : const SizedBox(height: 0, width: 0));
  }
}

class TransactionUtils {
  //TODO ADD NEW FEATURES HERE
  static Color giveColor(bool isDark, TransactionType type) {
    if (isDark) {
      return Colors.grey.shade600;
    } else {
      switch (type) {
        case TransactionType.transfer:
          return Colors.red;
        case TransactionType.payment:
          return Colors.purple;
        case TransactionType.trust:
          return Colors.orange;
        case TransactionType.bridge:
          return Colors.yellowAccent.shade700;
        case TransactionType.escrow:
          return Colors.pink;
        default:
          return Colors.red;
      }
    }
  }

  static Icon giveIcon(bool isDark, bool widthQuery, TransactionType type,
      [double? optionalSize, Color? c]) {
    var color = isDark ? Colors.white60 : c ?? Colors.white;
    double size = optionalSize ?? (widthQuery ? 50 : 30);
    switch (type) {
      case TransactionType.transfer:
        return Icon(MyFlutterApp.transfer, size: size, color: color);
      case TransactionType.payment:
        return Icon(MyFlutterApp.infinity, size: size, color: color);
      case TransactionType.trust:
        return Icon(MyFlutterApp.safe, size: size, color: color);
      case TransactionType.bridge:
        return Icon(MyFlutterApp.jigsaw, size: size, color: color);
      case TransactionType.escrow:
        return Icon(MyFlutterApp.hand, size: size, color: color);
      default:
        return Icon(MyFlutterApp.transfer, size: size, color: color);
    }
  }

  static String statusToTitle(Status s, AppLanguage lang) {
    switch (s) {
      case Status.pending:
        return lang.transactions20;
      case Status.omnifyReceived:
        return lang.transactions21;
      case Status.omnifySent:
        return lang.transactions22;
      case Status.complete:
        return lang.transactions23;
      case Status.failed:
        return lang.transactions24;
      default:
        return "default";
    }
  }

  static Icon giveStatusIcon(Status s, bool isDark, [double? optionalSize]) {
    switch (s) {
      case Status.pending:
        return Icon(Icons.pending,
            color: giveStatusColor(s, isDark), size: optionalSize ?? 20);
      case Status.omnifyReceived:
        return Icon(Icons.call_received,
            color: giveStatusColor(s, isDark), size: optionalSize ?? 20);
      case Status.omnifySent:
        return Icon(Icons.call_made,
            color: giveStatusColor(s, isDark), size: optionalSize ?? 20);
      case Status.complete:
        return Icon(Icons.check_circle,
            color: giveStatusColor(s, isDark), size: optionalSize ?? 20);
      case Status.failed:
        return Icon(Icons.cancel,
            color: giveStatusColor(s, isDark), size: optionalSize ?? 20);
      default:
        return Icon(Icons.pending,
            color: giveStatusColor(s, isDark), size: optionalSize ?? 20);
    }
  }

  static String statusToDescription(Status s, AppLanguage lang) {
    switch (s) {
      case Status.pending:
        return lang.transactions25;
      case Status.omnifyReceived:
        return lang.transactions26;
      case Status.omnifySent:
        return lang.transactions27;
      case Status.complete:
        return lang.transactions28;
      case Status.failed:
        return lang.transactions29;
      default:
        return "default";
    }
  }

  static Widget buildToastIcon(Status s, TransactionType t, bool isDark,
      bool widthQuery, TransactionType type) {
    return Stack(
      children: [
        if (s == Status.complete || s == Status.failed || s == Status.pending)
          giveIcon(isDark, widthQuery, type, 50, giveColor(false, type)),
        if (s == Status.omnifyReceived || s == Status.omnifySent)
          SizedBox(
              height: 60,
              width: 60,
              child: ExtendedImage.network(Utils.logo,
                  cache: true, enableLoadState: false)),
        if (s == Status.omnifyReceived || s == Status.omnifySent)
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade200)),
                  child: giveStatusIcon(s, isDark, 15))),
        if (s == Status.omnifyReceived || s == Status.omnifySent)
          Positioned(
              bottom: 0.1,
              right: 0.1,
              child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade200)),
                  child: giveIcon(
                      isDark, widthQuery, type, 15, giveColor(false, type)))),
        if (s == Status.complete || s == Status.failed || s == Status.pending)
          Positioned(top: 0.1, right: 0.1, child: giveStatusIcon(s, isDark)),
      ],
    );
  }

  static Color giveStatusColor(Status s, bool isDark) {
    switch (s) {
      case Status.pending:
        return Colors.yellow;
      case Status.omnifyReceived:
        return Colors.orange;
      case Status.omnifySent:
        return Colors.amber;
      case Status.complete:
        return Colors.green;
      case Status.failed:
        return Colors.red;
      default:
        return Colors.yellow;
    }
  }

  static handleTransactionToast(Transaction t, bool isDark, TextDirection dir,
      bool widthQuery, AppLanguage lang) {
    Future.delayed(const Duration(seconds: 1), () {
      Toasts.showCustomToast(
          buildToastIcon(t.status, t.type, isDark, widthQuery, t.type),
          statusToTitle(t.status, lang),
          statusToDescription(t.status, lang),
          isDark,
          dir);
    });
  }
}
