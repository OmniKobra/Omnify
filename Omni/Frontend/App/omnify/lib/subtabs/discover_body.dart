import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

import '../crypto/features/discover_utils.dart';
import '../languages/app_language.dart';
import '../models/discover_events.dart';
import '../providers/discover_provider.dart';
import '../providers/fees_provider.dart';
import '../providers/theme_provider.dart';
import '../utils.dart';

import '../widgets/my_image.dart';
import '../widgets/network_picker.dart';

class DiscoverBody extends StatefulWidget {
  final bool isTransfers;
  final bool isPayments;
  final bool isTrust;
  final bool isBridges;
  final bool isEscrow;
  const DiscoverBody(
      {super.key,
      required this.isTransfers,
      required this.isPayments,
      required this.isTrust,
      required this.isBridges,
      required this.isEscrow});

  @override
  State<DiscoverBody> createState() => _DiscoverBodyState();
}

class _DiscoverBodyState extends State<DiscoverBody> {
  String title(AppLanguage lang) {
    if (widget.isTransfers) {
      return lang.discover1;
    }
    if (widget.isPayments) {
      return lang.discover2;
    }
    if (widget.isTrust) {
      return lang.discover3;
    }
    if (widget.isBridges) {
      return lang.discover4;
    }
    if (widget.isEscrow) {
      return lang.discover5;
    }
    return '';
  }

  String imageUrl() {
    if (widget.isTransfers) {
      return Utils.transferUrl;
    }
    if (widget.isPayments) {
      return Utils.payUrl;
    }
    if (widget.isTrust) {
      return Utils.trustUrl;
    }
    if (widget.isBridges) {
      return Utils.bridgeUrl;
    }
    if (widget.isEscrow) {
      return Utils.escrowUrl;
    }
    return '';
  }

  Widget buildTransferFee(bool widthQuery, bool isDark, Chain c, FeeTier? tier,
          bool isAltCoin, Decimal altcoinFee, AppLanguage lang) =>
      SizedBox(
          width: widthQuery ? 325 : null,
          child: isAltCoin
              ? ListTile(
                  leading: Text(lang.discover6,
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black,
                          fontSize: 16)),
                  title: Row(children: [
                    Utils.buildNetworkLogo(true, Utils.feeLogo(c), true, true),
                    const SizedBox(width: 5),
                    Text(altcoinFee.toString(),
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black,
                        ))
                  ]))
              : ListTile(
                  leading: Utils.buildNetworkLogo(
                      true, Utils.feeLogo(c), true, true),
                  title: Text(
                      "${tier!.lowThreshold.toString()}${tier.highThreshold != null ? " - ${tier.highThreshold.toString()}" : "+"}  {${tier.fee.toString()}}",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black,
                      ))));

  Widget buildFee(bool widthQuery, bool isDark, Chain c, Decimal feeAmount,
          String perLabel) =>
      SizedBox(
          width: widthQuery ? 275 : null,
          child: ListTile(
              leading:
                  Utils.buildNetworkLogo(true, Utils.feeLogo(c), true, true),
              title: Text(
                  "${Utils.removeTrailingZeros(feeAmount.toStringAsFixed(Utils.nativeTokenDecimals(c)))} $perLabel",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black,
                  ))));

  Widget buildFees(bool widthQuery, bool isDark, Chain c, AppLanguage lang) {
    final fees = Provider.of<FeesProvider>(context);
    List<Widget> children = [];
    if (widget.isTransfers) {
      final transferFees1 = fees.transferFeeTier1;
      final transferFees2 = fees.transferFeeTier2;
      final transferFees3 = fees.transferFeeTier3;
      final transferFees4 = fees.transferFeeTier4;
      children = [
        buildTransferFee(widthQuery, isDark, c, transferFees1, false,
            Decimal.parse("0.0"), lang),
        buildTransferFee(widthQuery, isDark, c, transferFees2, false,
            Decimal.parse("0.0"), lang),
        buildTransferFee(widthQuery, isDark, c, transferFees3, false,
            Decimal.parse("0.0"), lang),
        buildTransferFee(widthQuery, isDark, c, transferFees4, false,
            Decimal.parse("0.0"), lang),
        buildTransferFee(
            widthQuery, isDark, c, null, true, fees.altcoinTransferFee, lang),
      ];
    }
    if (widget.isPayments) {
      final paymentFees = fees.paymentfees;
      children = [
        buildFee(widthQuery, isDark, c, paymentFees.amountPerPayment,
            lang.discover7),
        buildFee(widthQuery, isDark, c, paymentFees.amountPerInstallment,
            lang.discover8),
      ];
    }
    if (widget.isTrust) {
      final trustFees = fees.trustFees;
      children = [
        buildFee(
            widthQuery, isDark, c, trustFees.amountPerDeposit, lang.discover9),
        buildFee(widthQuery, isDark, c, trustFees.amountPerBeneficiary,
            lang.discover10),
      ];
    }
    if (widget.isBridges) {
      final bridgeFees = fees.bridgeFees;
      children = [
        buildFee(widthQuery, isDark, c, bridgeFees.feePerTransaction,
            lang.discover11)
      ];
    }
    if (widget.isEscrow) {
      final escrowFees = fees.escrowFees;
      children = [
        buildFee(
            widthQuery, isDark, c, escrowFees.feePerContract, lang.discover12)
      ];
    }
    return widthQuery ? Wrap(children: children) : Column(children: children);
  }

  Widget buildStat(bool widthQuery, bool isDark, String description,
          dynamic val, bool isValue) =>
      Container(
        margin: EdgeInsets.only(
            top: widthQuery ? 16 : 8,
            bottom: widthQuery ? 16 : 8,
            right: widthQuery ? 26 : 18),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: 50,
              maxWidth: 200,
              minHeight: widthQuery ? 60 : 50.0,
              maxHeight: widthQuery ? 60 : 55.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(description,
                    style: TextStyle(
                        color: Colors.grey, fontSize: widthQuery ? 17 : 15)),
                const SizedBox(height: 5.0),
                Text(Utils.optimisedNumbers(val, isValue),
                    style: TextStyle(
                        fontSize: widthQuery ? 19 : 17,
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold))
              ]),
        ),
      );

  Widget buildLooper(
      bool widthQuery, bool isDark, AppLanguage lang, TextDirection direction) {
    List<Widget> children = [];
    final discoverProvider = Provider.of<DiscoverProvider>(context);
    if (widget.isTransfers) {
      final transferStats = discoverProvider.transferStats;
      children = [
        buildStat(widthQuery, isDark, lang.discover14,
            transferStats['transfers']!, false),
        buildStat(widthQuery, isDark, lang.discover15,
            transferStats['assets transferred']!, true),
        buildStat(widthQuery, isDark, lang.discover16,
            transferStats['senders']!, false),
        buildStat(widthQuery, isDark, lang.discover17,
            transferStats['recipients']!, false),
      ];
    }
    if (widget.isPayments) {
      final paymentStats = discoverProvider.paymentStats;
      children = [
        buildStat(widthQuery, isDark, lang.discover18,
            paymentStats['payments']!, false),
        buildStat(widthQuery, isDark, lang.discover19,
            paymentStats['amount paid']!, true),
        buildStat(widthQuery, isDark, lang.discover20,
            paymentStats['installments']!, false),
        buildStat(widthQuery, isDark, lang.discover21,
            paymentStats['installments paid']!, false),
        buildStat(widthQuery, isDark, lang.discover22,
            paymentStats['paid in installments']!, true),
        buildStat(widthQuery, isDark, lang.discover23,
            paymentStats['withdrawals']!, false),
        buildStat(widthQuery, isDark, lang.discover24,
            paymentStats['amount withdrawn']!, true),
        buildStat(widthQuery, isDark, lang.discover25,
            paymentStats['customers']!, false),
        buildStat(widthQuery, isDark, lang.discover26, paymentStats['vendors']!,
            false),
        buildStat(widthQuery, isDark, lang.discover79, paymentStats['refunds']!,
            false),
        buildStat(widthQuery, isDark, lang.discover80,
            paymentStats['amount refunded']!, true),
      ];
    }
    if (widget.isTrust) {
      final trustStats = discoverProvider.trustStats;
      children = [
        buildStat(widthQuery, isDark, lang.discover27, trustStats['deposits']!,
            false),
        buildStat(widthQuery, isDark, lang.discover28,
            trustStats['amount deposited']!, true),
        buildStat(widthQuery, isDark, lang.discover29,
            trustStats['withdrawals']!, false),
        buildStat(widthQuery, isDark, lang.discover30,
            trustStats['assets withdrawn']!, true),
        buildStat(
            widthQuery, isDark, lang.discover31, trustStats['owners']!, false),
        buildStat(widthQuery, isDark, lang.discover32,
            trustStats['beneficiaries']!, false),
      ];
    }
    if (widget.isBridges) {
      final bridgeStats = discoverProvider.bridgeStats;
      children = [
        buildStat(widthQuery, isDark, lang.discover33,
            bridgeStats['received transactions']!, false),
        buildStat(widthQuery, isDark, lang.discover34,
            bridgeStats['assets received']!, true),
        buildStat(widthQuery, isDark, lang.discover35,
            bridgeStats['migration transactions']!, false),
        buildStat(widthQuery, isDark, lang.discover36,
            bridgeStats['assets migrated']!, true),
      ];
    }
    if (widget.isEscrow) {
      final escrowStats = discoverProvider.escrowStats;
      children = [
        buildStat(widthQuery, isDark, lang.discover37,
            escrowStats['contracts']!, false),
        buildStat(widthQuery, isDark, lang.discover38,
            escrowStats['contract assets']!, true),
        buildStat(widthQuery, isDark, lang.discover39,
            escrowStats['bids made']!, false),
        buildStat(widthQuery, isDark, lang.discover40,
            escrowStats['bid assets']!, true),
        buildStat(widthQuery, isDark, lang.discover41,
            escrowStats['complete contracts']!, false),
      ];
    }
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ScrollLoopAutoScroll(
          gap: 100,
          duplicateChild: 100,
          duration: const Duration(seconds: 960),
          reverseScroll: direction == TextDirection.rtl,
          scrollDirection: Axis.horizontal,
          child: Row(
              children: direction == TextDirection.rtl
                  ? children.reversed.toList()
                  : children)),
    );
  }

  Widget buildTextTitle(bool widthQuery, bool isDark, AppLanguage lang) => Text(
        title(lang),
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: widthQuery ? 20 : 17,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : Colors.black),
      );
  Widget buildHeader(bool isDark, bool widthQuery, Chain c, AppLanguage lang,
          TextDirection dir) =>
      Container(
        padding: const EdgeInsets.all(8),
        // height: widthQuery ? 350 : 500,
        width: double.infinity,
        decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            border: Border(
                bottom: BorderSide(
                    color:
                        isDark ? Colors.grey.shade700 : Colors.grey.shade200))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: widthQuery ? 125 : 75,
                      width: widthQuery ? 125 : 75,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.transparent),
                      child: Center(
                          child:
                              MyImage(url: imageUrl(), fit: BoxFit.scaleDown))),
                  const SizedBox(width: 15),
                  buildTextTitle(widthQuery, isDark, lang)
                ]),
            const SizedBox(height: 10),
            Text(lang.discover13,
                style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: widthQuery ? 18 : 16)),
            const SizedBox(height: 5),
            buildFees(widthQuery, isDark, c, lang),
            const SizedBox(height: 10),
            buildLooper(widthQuery, isDark, lang, dir),
            const SizedBox(height: 10),
            NetworkPicker(
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
                isTransactions: false,
                isDiscoverTransfers: widget.isTransfers,
                isDiscoverPayments: widget.isPayments,
                isDiscoverTrust: widget.isTrust,
                isDiscoverBridges: widget.isBridges,
                isDiscoverEscrow: widget.isEscrow),
          ],
        ),
      );

  Widget buildBodyItem(
          DiscoverTransferEvent? transferEvent,
          DiscoverPaymentEvent? paymentEvent,
          DiscoverTrustEvent? trustEvent,
          DiscoverBridgeEvent? bridgeEvent,
          DiscoverEscrowEvent? escrowEvent) =>
      EventWidget(
          isTransfers: widget.isTransfers,
          isPayments: widget.isPayments,
          isTrust: widget.isTrust,
          isBridges: widget.isBridges,
          isEscrow: widget.isEscrow,
          transferEvent: transferEvent,
          paymentEvent: paymentEvent,
          trustEvent: trustEvent,
          bridgeEvent: bridgeEvent,
          escrowEvent: escrowEvent);

  Widget buildBodyList() {
    final discover = Provider.of<DiscoverProvider>(context);
    List<Widget> children = [];
    if (widget.isTransfers) {
      final List<DiscoverTransferEvent> events = discover.transferEvents;
      children = [
        ...events.map((e) => buildBodyItem(e, null, null, null, null))
      ];
    }
    if (widget.isPayments) {
      final List<DiscoverPaymentEvent> events = discover.paymentEvents;
      children = [
        ...events.map((e) => buildBodyItem(null, e, null, null, null))
      ];
    }
    if (widget.isTrust) {
      final List<DiscoverTrustEvent> events = discover.trustEvents;
      children = [
        ...events.map((e) => buildBodyItem(null, null, e, null, null))
      ];
    }
    if (widget.isBridges) {
      final List<DiscoverBridgeEvent> events = discover.bridgeEvents;
      children = [
        ...events.map((e) => buildBodyItem(null, null, null, e, null))
      ];
    }
    if (widget.isEscrow) {
      final List<DiscoverEscrowEvent> events = discover.escrowEvents;
      children = [
        ...events.map((e) => buildBodyItem(null, null, null, null, e))
      ];
    }
    return Wrap(children: children);
  }

  @override
  void initState() {
    super.initState();
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final c = theme.startingChain;
    final client = theme.client;
    final discoverMethods =
        Provider.of<DiscoverProvider>(context, listen: false);
    final addTransferEvent = discoverMethods.insertTransferEvent;
    final addPaymentEvent = discoverMethods.insertPaymentEvent;
    final addTrustEvent = discoverMethods.insertTrustEvent;
    final addBridgeEvent = discoverMethods.insertBridgeEvent;
    final addEscrowEvent = discoverMethods.insertEscrowEvent;
    if (widget.isTransfers) {
      DiscoverUtils.initTransferEventListeners(
          c: c, addEvent: addTransferEvent, client: client);
    }
    if (widget.isPayments) {
      DiscoverUtils.initPaymentEventListeners(
          c: c, addEvent: addPaymentEvent, client: client);
    }
    if (widget.isTrust) {
      DiscoverUtils.initTrustEventListeners(
          c: c, addEvent: addTrustEvent, client: client);
    }
    if (widget.isBridges) {
      DiscoverUtils.initBridgesEventListeners(
          c: c, addEvent: addBridgeEvent, client: client);
    }
    if (widget.isEscrow) {
      DiscoverUtils.initEscrowEventListeners(
          c: c, addEvent: addEscrowEvent, client: client);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.isTransfers) {
      DiscoverUtils.disposeTransferEventListeners();
    }
    if (widget.isPayments) {
      DiscoverUtils.disposePaymentEventListeners();
    }
    if (widget.isTrust) {
      DiscoverUtils.disposeTrustListeners();
    }
    if (widget.isBridges) {
      DiscoverUtils.disposeBridgeListeners();
    }
    if (widget.isEscrow) {
      DiscoverUtils.disposeEscrowEventListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final discover = Provider.of<DiscoverProvider>(context);
    final widthQuery = Utils.widthQuery(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final lang = Utils.language(context);
    const int limit = 30;
    if (widget.isTransfers) {
      final events = discover.transferEvents;
      if (events.length >= limit) {
        DiscoverUtils.disposeTransferEventListeners();
      }
    }
    if (widget.isPayments) {
      final events = discover.paymentEvents;
      if (events.length > limit) {
        DiscoverUtils.disposePaymentEventListeners();
      }
    }
    if (widget.isTrust) {
      final events = discover.trustEvents;
      if (events.length > limit) {
        DiscoverUtils.disposeTrustListeners();
      }
    }
    if (widget.isBridges) {
      final events = discover.bridgeEvents;
      if (events.length > limit) {
        DiscoverUtils.disposeBridgeListeners();
      }
    }
    if (widget.isEscrow) {
      final events = discover.escrowEvents;
      if (events.length > limit) {
        DiscoverUtils.disposeEscrowEventListeners();
      }
    }

    Chain currentChain() {
      if (widget.isTransfers) {
        return discover.transferChain;
      }
      if (widget.isPayments) {
        return discover.paymentChain;
      }
      if (widget.isTrust) {
        return discover.trustChain;
      }
      if (widget.isBridges) {
        return discover.bridgeChain;
      }
      if (widget.isEscrow) {
        return discover.escrowChain;
      }
      return discover.transferChain;
    }

    return ListView(
      children: [
        buildHeader(isDark, widthQuery, currentChain(), lang, dir),
        const SizedBox(height: 4),
        buildBodyList()
      ],
    );
  }
}

class EventWidget extends StatefulWidget {
  final bool isTransfers;
  final bool isPayments;
  final bool isTrust;
  final bool isBridges;
  final bool isEscrow;
  final DiscoverTransferEvent? transferEvent;
  final DiscoverPaymentEvent? paymentEvent;
  final DiscoverTrustEvent? trustEvent;
  final DiscoverBridgeEvent? bridgeEvent;
  final DiscoverEscrowEvent? escrowEvent;
  const EventWidget(
      {super.key,
      required this.isTransfers,
      required this.isPayments,
      required this.isTrust,
      required this.isBridges,
      required this.isEscrow,
      required this.transferEvent,
      required this.paymentEvent,
      required this.trustEvent,
      required this.bridgeEvent,
      required this.escrowEvent});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  bool isExpanded = false;
  List<dynamic> transferTypeToString(TransferEventType t, AppLanguage lang) {
    switch (t) {
      case TransferEventType.sent:
        return [lang.discover42, Icons.call_made, Colors.red];
      case TransferEventType.received:
        return [lang.discover43, Icons.call_received, Colors.green];
      case TransferEventType.completed:
        return [lang.discover44, Icons.check_circle, Colors.green];
      default:
        return ["", Icons.abc];
    }
  }

  List<dynamic> paymentTypeToString(PaymentEventType t, AppLanguage lang) {
    switch (t) {
      case PaymentEventType.payment:
        return [lang.discover45, Icons.mobile_friendly_rounded, Colors.blue];
      case PaymentEventType.refund:
        return [lang.discover46, Icons.refresh, Colors.yellow];
      case PaymentEventType.installlmentPayment:
        return [lang.discover47, Icons.calendar_month_rounded, Colors.amber];
      case PaymentEventType.withdrawal:
        return [lang.discover48, Icons.exit_to_app_rounded, Colors.red];
      default:
        return ["", Icons.abc];
    }
  }

  List<dynamic> trustTypeToString(TrustEventType t, AppLanguage lang) {
    switch (t) {
      case TrustEventType.deposit:
        return [lang.discover49, Icons.add_circle, Colors.green];
      case TrustEventType.withdrawal:
        return [lang.discover50, Icons.remove_circle, Colors.red];
      case TrustEventType.modification:
        return [lang.discover51, Icons.edit, Colors.yellow];
      case TrustEventType.retraction:
        return [lang.discover52, Icons.close_fullscreen, Colors.red];
      default:
        return ["", Icons.abc];
    }
  }

  List<dynamic> bridgeTypeToString(BridgeEventType t, AppLanguage lang) {
    switch (t) {
      case BridgeEventType.migrate:
        return [lang.discover53, Icons.arrow_circle_up, Colors.red];
      case BridgeEventType.receive:
        return [
          lang.discover54,
          Icons.arrow_circle_down_outlined,
          Colors.green
        ];
      default:
        return ["", Icons.abc];
    }
  }

  List<dynamic> escrowTypeToString(EscrowEventType t, AppLanguage lang) {
    switch (t) {
      case EscrowEventType.newContract:
        return [lang.discover55, Icons.article, Colors.blue];
      case EscrowEventType.newBid:
        return [lang.discover56, Icons.money, Colors.green];
      case EscrowEventType.bidAccepted:
        return [lang.discover57, Icons.check, Colors.green];
      case EscrowEventType.deleteContract:
        return [lang.discover58, Icons.delete, Colors.red];
      default:
        return ["", Icons.abc];
    }
  }

  Widget buildTopRow(bool widthQuery, bool isDark, AppLanguage lang) {
    Widget icon = const Icon(Icons.abc);
    Widget text = const Text('');
    if (widget.isTransfers) {
      final stuff = transferTypeToString(widget.transferEvent!.type, lang);
      icon = Icon(stuff[1],
          color: isDark ? Colors.white70 : stuff[2],
          size: widthQuery ? 25 : 20);
      text = Text(stuff[0],
          style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black,
              fontWeight: FontWeight.bold));
    }
    if (widget.isPayments) {
      final stuff = paymentTypeToString(widget.paymentEvent!.type, lang);
      icon = Icon(stuff[1],
          color: isDark ? Colors.white70 : stuff[2],
          size: widthQuery ? 25 : 20);
      text = Text(stuff[0],
          style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black,
              fontWeight: FontWeight.bold));
    }
    if (widget.isTrust) {
      final stuff = trustTypeToString(widget.trustEvent!.type, lang);
      icon = Icon(stuff[1],
          color: isDark ? Colors.white70 : stuff[2],
          size: widthQuery ? 25 : 20);
      text = Text(stuff[0],
          style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black,
              fontWeight: FontWeight.bold));
    }
    if (widget.isBridges) {
      final stuff = bridgeTypeToString(widget.bridgeEvent!.type, lang);
      icon = Icon(stuff[1],
          color: isDark ? Colors.white70 : stuff[2],
          size: widthQuery ? 25 : 20);
      text = Text(stuff[0],
          style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black,
              fontWeight: FontWeight.bold));
    }
    if (widget.isEscrow) {
      final stuff = escrowTypeToString(widget.escrowEvent!.type, lang);
      icon = Icon(stuff[1],
          color: isDark ? Colors.white70 : stuff[2],
          size: widthQuery ? 25 : 20);
      text = Text(stuff[0],
          style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black,
              fontWeight: FontWeight.bold));
    }
    return Row(children: [
      icon,
      const SizedBox(width: 5),
      Expanded(child: text),
      IconButton(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more,
              color: isDark ? Colors.white60 : Colors.grey))
    ]);
  }

  Widget buildTitle(String label, bool widthQuery, bool isDark) => Text(label,
      style: TextStyle(
          fontSize: widthQuery ? 16 : 14,
          color: isDark ? Colors.white70 : Colors.black,
          fontWeight: FontWeight.bold));
  Widget buildSubtitle(String value, bool widthQuery, bool isDark,
          [bool? isChain, Chain? c, bool? isPayment, Chain? paymentC]) =>
      Row(
        children: [
          if (isChain != null || isPayment != null)
            Utils.buildNetworkLogo(
                widthQuery,
                isChain != null && isChain ? c! : Utils.feeLogo(paymentC!),
                true,
                true),
          if (isChain != null || isPayment != null) const SizedBox(width: 5),
          Expanded(
            child: Text(value,
                style: TextStyle(
                  fontSize: widthQuery ? 15 : 14,
                  color: isDark ? Colors.white60 : Colors.grey,
                )),
          ),
        ],
      );
  Widget buildProperty(bool isDark, bool widthQuery, String label, String value,
          [bool? isChain, Chain? c, bool? isPayment, Chain? paymentC]) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 10),
        buildTitle(label, widthQuery, isDark),
        const SizedBox(height: 5),
        buildSubtitle(
            value, widthQuery, isDark, isChain, c, isPayment, paymentC)
      ]);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final langCode = theme.langCode;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final discover = Provider.of<DiscoverProvider>(context);
    String formatDate(DateTime d) => Utils.timeStamp(d, langCode, context);
    List<Widget> children = [];
    if (widget.isTransfers) {
      final event = widget.transferEvent!;
      children = [
        buildTopRow(widthQuery, isDark, lang),
        buildProperty(isDark, widthQuery, lang.discover59, event.id),
        if (isExpanded)
          buildProperty(
              isDark, widthQuery, lang.discover60, event.senderAddress),
        if (isExpanded)
          buildProperty(
              isDark, widthQuery, lang.discover61, event.recipientAddress),
        if (isExpanded)
          buildProperty(isDark, widthQuery, lang.discover62, event.asset),
        if (isExpanded)
          buildProperty(
              isDark, widthQuery, lang.discover63, event.amount.toString()),
        // if (isExpanded)
        // buildProperty(
        // isDark, widthQuery, lang.discover64, event.transactionHash),
        if (isExpanded)
          buildProperty(isDark, widthQuery, lang.discover65,
              event.blockNumber.toString()),
        if (isExpanded)
          buildProperty(
              isDark, widthQuery, lang.discover66, formatDate(event.date))
      ];
    }
    if (widget.isPayments) {
      final event = widget.paymentEvent!;
      children = [
        buildTopRow(widthQuery, isDark, lang),
        if (event.type != PaymentEventType.withdrawal)
          buildProperty(isDark, widthQuery, lang.discover67, event.id),
        if (isExpanded && event.type != PaymentEventType.withdrawal)
          buildProperty(
              isDark, widthQuery, lang.discover68, event.payerAddress),
        if (isExpanded || event.type == PaymentEventType.withdrawal)
          buildProperty(
              isDark, widthQuery, lang.discover69, event.vendorAddress),
        if (isExpanded)
          buildProperty(
              isDark,
              widthQuery,
              lang.discover63,
              event.amount.toString(),
              false,
              null,
              true,
              discover.paymentChain),
        // if (isExpanded)
        // buildProperty(
        // isDark, widthQuery, lang.discover64, event.transactionHash),
        if (isExpanded)
          buildProperty(isDark, widthQuery, lang.discover65,
              event.blockNumber.toString()),
        if (isExpanded)
          buildProperty(
              isDark, widthQuery, lang.discover66, formatDate(event.date)),
      ];
    }
    if (widget.isTrust) {
      final event = widget.trustEvent!;
      children = [
        buildTopRow(widthQuery, isDark, lang),
        buildProperty(isDark, widthQuery, lang.discover70, event.id),
        if (isExpanded)
          buildProperty(
              isDark, widthQuery, lang.discover71, event.initiatorAddress),
        if (isExpanded && event.type != TrustEventType.modification)
          buildProperty(isDark, widthQuery, lang.discover62, event.asset),
        if (isExpanded && event.type != TrustEventType.modification)
          buildProperty(
              isDark, widthQuery, lang.discover63, event.amount.toString()),
        // if (isExpanded)
        // buildProperty(
        // isDark, widthQuery, lang.discover64, event.transactionHash),
        if (isExpanded)
          buildProperty(isDark, widthQuery, lang.discover65,
              event.blockNumber.toString()),
        if (isExpanded)
          buildProperty(
              isDark, widthQuery, lang.discover66, formatDate(event.date)),
      ];
    }
    if (widget.isBridges) {
      final event = widget.bridgeEvent!;
      children = [
        buildTopRow(widthQuery, isDark, lang),
        buildProperty(isDark, widthQuery, lang.discover72, event.id),
        if (isExpanded)
          buildProperty(isDark, widthQuery, lang.discover62, event.asset),
        if (isExpanded)
          buildProperty(
              isDark, widthQuery, lang.discover63, event.amount.toString()),
        if (isExpanded)
          buildProperty(isDark, widthQuery, lang.discover73,
              event.sourceChain.name, true, event.sourceChain, false, null),
        if (isExpanded)
          buildProperty(
              isDark, widthQuery, lang.discover74, event.sourceAddress),
        if (isExpanded)
          buildProperty(
              isDark,
              widthQuery,
              lang.discover76,
              event.destinationChain.name,
              true,
              event.destinationChain,
              false,
              null),
        if (isExpanded)
          buildProperty(
              isDark, widthQuery, lang.discover75, event.destinationAddress),
        // if (isExpanded)
        //   buildProperty(
        // isDark, widthQuery, lang.discover64, event.transactionHash),
        if (isExpanded)
          buildProperty(isDark, widthQuery, lang.discover65,
              event.blockNumber.toString()),
        if (isExpanded)
          buildProperty(
              isDark, widthQuery, lang.discover66, formatDate(event.date)),
      ];
    }
    if (widget.isEscrow) {
      children = [
        buildTopRow(widthQuery, isDark, lang),
        buildProperty(isDark, widthQuery, lang.discover77,
            widget.escrowEvent!.contractID),
        if (isExpanded)
          buildProperty(isDark, widthQuery, lang.discover78,
              widget.escrowEvent!.ownerAddress),
        // if (isExpanded)
        // buildProperty(isDark, widthQuery, lang.discover64,
        //       widget.escrowEvent!.transactionHash),
        if (isExpanded)
          buildProperty(isDark, widthQuery, lang.discover65,
              widget.escrowEvent!.blockNumber.toString()),
        if (isExpanded)
          buildProperty(isDark, widthQuery, lang.discover66,
              formatDate(widget.escrowEvent!.date)),
      ];
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: widthQuery ? 4 : 8, vertical: 4),
      padding: const EdgeInsets.all(8),
      height: isExpanded ? null : null,
      width: widthQuery ? 470 : double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isDark ? Colors.grey[800] : Colors.white,
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}
