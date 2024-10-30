// ignore_for_file: prefer_conditional_assignment

import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import 'dart:async';
import '../../common/refresh_indicator.dart';
import '../../../crypto/features/payment_utils.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../toasts.dart';
import '../../../utils.dart';

enum PaymentStatus { pending, successful }

class PaymentRequestWidget extends StatefulWidget {
  final Chain c;
  final Decimal amount;
  final Decimal fullAmount;
  final bool isInstallments;
  final int installmentPeriod;
  final Decimal amountperMonth;
  final Decimal networkFee;
  final Decimal omnifyFee;
  final Decimal installmentFee;
  final Decimal finalMonthAmount;
  final String paymentID;
  const PaymentRequestWidget(
      {super.key,
      required this.c,
      required this.amount,
      required this.fullAmount,
      required this.isInstallments,
      required this.installmentPeriod,
      required this.amountperMonth,
      required this.networkFee,
      required this.omnifyFee,
      required this.paymentID,
      required this.finalMonthAmount,
      required this.installmentFee});

  @override
  State<PaymentRequestWidget> createState() => _PaymentRequestWidgetState();
}

class _PaymentRequestWidgetState extends State<PaymentRequestWidget>
    with SingleTickerProviderStateMixin {
  Timer? timer;
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();
  Decimal networkFee = Decimal.parse("0.0");
  Decimal omnifyFee = Decimal.parse("0.0");
  Decimal installmentFee = Decimal.parse("0.0");
  PaymentStatus paymentStatus = PaymentStatus.pending;
  String paymentLink = '';
  bool isReusable = false;
  @protected
  late QrImage qrImage;
  Widget buildNetwork(bool widthQuery, bool isDark) {
    final container = Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5),
          color: isDark ? Colors.grey[800] : Colors.white,
        ),
        child: Container(
            margin: const EdgeInsets.all(8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Utils.buildNetworkLogo(widthQuery, widget.c, true),
              const SizedBox(width: 7.5),
              Text(widget.c.name,
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: widthQuery ? 19 : 17))
            ])));
    return container;
  }

  Widget buildVendor(bool widthQuery, bool isDark, String vendor) {
    final lang = Utils.language(context);
    final container = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Text(
          "${lang.pay17}  $vendor",
          softWrap: true,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white60 : Colors.black,
              fontSize: widthQuery ? 18 : 16),
        ));
    return container;
  }

  Widget buildFee(String label, Decimal amount, bool widthQuery, bool isDark,
      bool isPeriod, int period) {
    return Container(
      margin: EdgeInsets.only(top: widthQuery ? 4 : 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13.25,
                  color: isDark ? Colors.white60 : Colors.grey)),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isPeriod)
                  SizedBox(
                      child: Utils.buildNetworkLogo(
                          widthQuery, Utils.feeLogo(widget.c), true, true)),
                if (!isPeriod) const SizedBox(width: 5),
                Text(
                    isPeriod
                        ? period.toString()
                        : Utils.removeTrailingZeros(amount.toStringAsFixed(
                            Utils.nativeTokenDecimals(widget.c))),
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14))
              ])
        ],
      ),
    );
  }

  Widget buildPaymentStatus(bool isDark, bool widthQuery) {
    final lang = Utils.language(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(widthQuery ? 15 : 10)),
                child: Center(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (paymentStatus == PaymentStatus.pending)
                    AnimatedBuilder(
                        animation: _controller,
                        builder: (_, child) {
                          return Transform.rotate(
                            angle: _controller.value * 2 * math.pi,
                            child: child,
                          );
                        },
                        child: const Icon(Icons.hourglass_full,
                            size: 27, color: Colors.amber)),
                  if (paymentStatus == PaymentStatus.successful)
                    const Icon(Icons.check_circle,
                        size: 27, color: Colors.green),
                  const SizedBox(width: 7.5),
                  Text(
                      paymentStatus == PaymentStatus.pending
                          ? lang.transactions3
                          : lang.paymentActivity13,
                      style: TextStyle(
                          fontSize: 17,
                          color: paymentStatus == PaymentStatus.pending
                              ? Colors.amber
                              : Colors.green))
                ])))
          ]),
    );
  }

  Widget buildReusableButton(bool isDark, bool widthQuery, Color primaryColor) {
    final lang = Utils.language(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(widthQuery ? 15 : 10)),
                child: Center(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Switch(
                    activeTrackColor: primaryColor,
                    inactiveTrackColor: Colors.grey.shade300,
                    hoverColor: Colors.transparent,
                    splashRadius: 0.0,
                    focusColor: Colors.transparent,
                    trackOutlineColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    onChanged: (newVal) {
                      final vendor =
                          Provider.of<WalletProvider>(context, listen: false)
                              .getAddressString(widget.c);
                      isReusable = newVal;
                      if (isReusable) {
                        String emptyId = '';
                        paymentLink =
                            'https://app.omnify.finance/pay/chain=${widget.c.name}?vendor=$vendor?id=$emptyId?amount=${widget.amount}?gas=${widget.networkFee}?omnify=${widget.omnifyFee}?installmentFee=${widget.installmentFee}?isInstallments=${widget.isInstallments}?period=${widget.installmentPeriod}?amountpermonth=${widget.amountperMonth}?fullAmount=${widget.fullAmount}?finalMonthAmount=${widget.finalMonthAmount}';
                        final qrCode = QrCode(18, QrErrorCorrectLevel.M)
                          ..addData(paymentLink);
                        qrImage = QrImage(qrCode);
                      } else {
                        paymentLink =
                            'https://app.omnify.finance/pay/chain=${widget.c.name}?vendor=$vendor?id=${widget.paymentID}?amount=${widget.amount}?gas=${widget.networkFee}?omnify=${widget.omnifyFee}?installmentFee=${widget.installmentFee}?isInstallments=${widget.isInstallments}?period=${widget.installmentPeriod}?amountpermonth=${widget.amountperMonth}?fullAmount=${widget.fullAmount}?finalMonthAmount=${widget.finalMonthAmount}';
                        final qrCode = QrCode(18, QrErrorCorrectLevel.M)
                          ..addData(paymentLink);
                        qrImage = QrImage(qrCode);
                      }
                      setState(() {});
                    },
                    value: isReusable,
                  ),
                  const SizedBox(width: 7.5),
                  Text(lang.reusable,
                      style: TextStyle(
                          fontSize: 17,
                          color: primaryColor,
                          fontWeight: FontWeight.w500))
                ])))
          ]),
    );
  }

  Widget buildShareButton(bool isDark, bool widthQuery, Color primaryColor) {
    final lang = Utils.language(context);
    return TextButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: paymentLink));
          Toasts.showInfoToast(lang.toast5, lang.toast6, isDark,
              Provider.of<ThemeProvider>(context, listen: false).textDirection);
        },
        style: const ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
            elevation: WidgetStatePropertyAll(5),
            overlayColor: WidgetStatePropertyAll(Colors.transparent)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.rectangle,
                        borderRadius:
                            BorderRadius.circular(widthQuery ? 15 : 10)),
                    child: Center(
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.share, size: 27, color: primaryColor),
                      const SizedBox(width: 7.5),
                      Text(lang.pay33,
                          style: TextStyle(fontSize: 17, color: primaryColor))
                    ])))
              ]),
        ));
  }

  @override
  void initState() {
    super.initState();
    final vendor = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(widget.c);
    paymentLink =
        'https://app.omnify.finance/pay/chain=${widget.c.name}?vendor=$vendor?id=${widget.paymentID}?amount=${widget.amount}?gas=${widget.networkFee}?omnify=${widget.omnifyFee}?installmentFee=${widget.installmentFee}?isInstallments=${widget.isInstallments}?period=${widget.installmentPeriod}?amountpermonth=${widget.amountperMonth}?fullAmount=${widget.fullAmount}?finalMonthAmount=${widget.finalMonthAmount}';
    final qrCode = QrCode(18, QrErrorCorrectLevel.M)..addData(paymentLink);
    qrImage = QrImage(qrCode);
    networkFee = widget.networkFee;
    omnifyFee = widget.omnifyFee;
    installmentFee = widget.installmentFee;
  }

  Future<void> checkHasBeenPaid(Web3Client client) async {
    if (paymentStatus != PaymentStatus.successful) {
      if (!isReusable) {
        var isPaid =
            await PaymentUtils.checkPaid(widget.c, widget.paymentID, client);
        if (isPaid) {
          paymentStatus = PaymentStatus.successful;
          if (mounted) setState(() {});
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final heightBox = SizedBox(height: widthQuery ? 10 : 5);
    final lang = Utils.language(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final vendor = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(widget.c);
    Decimal total = widget.amount +
        widget.networkFee +
        widget.omnifyFee +
        widget.installmentFee;
    if (paymentStatus != PaymentStatus.successful) {
      if (timer == null) {
        timer = Timer.periodic(Utils.queryFeesDuration, (t) {
          checkHasBeenPaid(theme.client);
        });
      }
    } else {
      if (timer != null) {
        timer!.cancel();
        timer = null;
      }
    }
    final dialog = Directionality(
      textDirection: dir,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                )),
            Expanded(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PrettyQrView(
                  qrImage: qrImage,
                  decoration: PrettyQrDecoration(
                    background: Colors.white,
                    image: PrettyQrDecorationImage(
                        image: ExtendedNetworkImageProvider(Utils.logo,
                            cache: true)),
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
    return Directionality(
        textDirection: dir,
        child: widthQuery
            ? Expanded(
                child: MyRefresh(
                  onRefresh: () async {
                    checkHasBeenPaid(theme.client);
                  },
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          const Spacer(flex: 5),
                          buildNetwork(widthQuery, isDark),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 15,
                            child: buildVendor(widthQuery, isDark, vendor),
                          ),
                          const Spacer(flex: 5),
                        ],
                      ),
                      heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 1),
                          Expanded(
                            flex: 5,
                            child: SizedBox(
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => showDialog(
                                      context: context,
                                      barrierColor: Colors.white,
                                      builder: (_) => dialog),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1.5,
                                            color: paymentStatus ==
                                                    PaymentStatus.pending
                                                ? Colors.amber
                                                : Colors.green),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: PrettyQrView(
                                      qrImage: qrImage,
                                      decoration: PrettyQrDecoration(
                                        background: Colors.white,
                                        image: PrettyQrDecorationImage(
                                            image: ExtendedNetworkImageProvider(
                                                Utils.logo,
                                                cache: true)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                              flex: 5,
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: isDark
                                              ? Colors.grey.shade700
                                              : Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(5),
                                      color: isDark
                                          ? Colors.grey[800]
                                          : Colors.white),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildFee(lang.pay8, widget.amount,
                                            widthQuery, isDark, false, 0),
                                        if (widget.isInstallments)
                                          buildFee(
                                              lang.pay12,
                                              widget.amountperMonth,
                                              widthQuery,
                                              isDark,
                                              false,
                                              0),
                                        if (widget.isInstallments)
                                          buildFee(
                                              lang.pay53,
                                              widget.finalMonthAmount,
                                              widthQuery,
                                              isDark,
                                              false,
                                              0),
                                        if (widget.isInstallments)
                                          buildFee(
                                              lang.pay54,
                                              widget.fullAmount,
                                              widthQuery,
                                              isDark,
                                              false,
                                              0),
                                        if (widget.isInstallments)
                                          buildFee(
                                              lang.pay13,
                                              Decimal.parse("3"),
                                              widthQuery,
                                              isDark,
                                              true,
                                              widget.installmentPeriod),
                                        buildFee(lang.pay9, widget.networkFee,
                                            widthQuery, isDark, false, 0),
                                        buildFee(lang.pay10, widget.omnifyFee,
                                            widthQuery, isDark, false, 0),
                                        if (widget.isInstallments)
                                          Divider(
                                              color: isDark
                                                  ? Colors.grey.shade600
                                                  : Colors.grey.shade300),
                                        buildFee(lang.pay14, total, widthQuery,
                                            isDark, false, 0),
                                      ]))),
                          const Spacer(flex: 1),
                        ],
                      ),
                      heightBox,
                      Row(children: [
                        const Spacer(flex: 5),
                        Expanded(
                            flex: 10,
                            child: buildReusableButton(
                                isDark, widthQuery, primaryColor)),
                        const Spacer(flex: 5)
                      ]),
                      if (!isReusable) heightBox,
                      if (!isReusable)
                        Row(children: [
                          const Spacer(flex: 5),
                          Expanded(
                              flex: 10,
                              child: buildPaymentStatus(isDark, widthQuery)),
                          const Spacer(flex: 5)
                        ]),
                      heightBox,
                      Row(children: [
                        const Spacer(flex: 5),
                        Expanded(
                            flex: 10,
                            child: buildShareButton(
                                isDark, widthQuery, primaryColor)),
                        const Spacer(flex: 5)
                      ]),
                    ],
                  ),
                ),
              )
            : Expanded(
                child: MyRefresh(
                  onRefresh: () async {
                    checkHasBeenPaid(theme.client);
                  },
                  child: ListView(
                    children: [
                      buildNetwork(widthQuery, isDark),
                      heightBox,
                      buildVendor(widthQuery, isDark, vendor),
                      heightBox,
                      SizedBox(
                        child: Center(
                          child: GestureDetector(
                            onTap: () => showDialog(
                                context: context,
                                barrierColor: Colors.white,
                                builder: (_) => dialog),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1.5,
                                      color:
                                          paymentStatus == PaymentStatus.pending
                                              ? Colors.amber
                                              : Colors.green),
                                  borderRadius: BorderRadius.circular(5)),
                              child: PrettyQrView(
                                qrImage: qrImage,
                                decoration: PrettyQrDecoration(
                                  background: Colors.white,
                                  image: PrettyQrDecorationImage(
                                      image: ExtendedNetworkImageProvider(
                                          Utils.logo,
                                          cache: true)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      heightBox,
                      Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: isDark
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(5),
                              color: isDark ? Colors.grey[800] : Colors.white),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildFee(lang.pay8, widget.amount, widthQuery,
                                    isDark, false, 0),
                                if (widget.isInstallments)
                                  buildFee(lang.pay12, widget.amountperMonth,
                                      widthQuery, isDark, false, 0),
                                if (widget.isInstallments)
                                  buildFee(lang.pay53, widget.finalMonthAmount,
                                      widthQuery, isDark, false, 0),
                                if (widget.isInstallments)
                                  buildFee(lang.pay54, widget.fullAmount,
                                      widthQuery, isDark, false, 0),
                                if (widget.isInstallments)
                                  buildFee(
                                      lang.pay13,
                                      Decimal.parse("3"),
                                      widthQuery,
                                      isDark,
                                      true,
                                      widget.installmentPeriod),
                                buildFee(lang.pay9, widget.networkFee,
                                    widthQuery, isDark, false, 0),
                                buildFee(lang.pay10, widget.omnifyFee,
                                    widthQuery, isDark, false, 0),
                                Divider(
                                    color: isDark
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade300),
                                buildFee(lang.pay14, total, widthQuery, isDark,
                                    false, 0),
                              ])),
                      heightBox,
                      buildReusableButton(isDark, widthQuery, primaryColor),
                      if (!isReusable) heightBox,
                      if (!isReusable) buildPaymentStatus(isDark, widthQuery),
                      heightBox,
                      buildShareButton(isDark, widthQuery, primaryColor)
                    ],
                  ),
                ),
              ));
  }
}
