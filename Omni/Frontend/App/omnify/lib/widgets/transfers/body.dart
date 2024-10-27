// ignore_for_file: use_build_context_synchronously

import 'package:card_swiper/card_swiper.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../languages/app_language.dart';
import '../../models/transfer.dart';
import '../../providers/fees_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/transfers_provider.dart';
import '../../toasts.dart';
import '../../utils.dart';
import '../../validators.dart';
import '../asset_picker.dart';
import '../common/asset_fee.dart';
import '../common/field_suffix.dart';
import '../common/network_fee.dart';
import '../common/omnify_fee.dart';
import 'schedule_form.dart';

class TransfersBody extends StatefulWidget {
  const TransfersBody({super.key});

  @override
  State<TransfersBody> createState() => _TransfersBodyState();
}

class _TransfersBodyState extends State<TransfersBody> {
  late void Function() disposer;

  @override
  void initState() {
    super.initState();
    disposer = Provider.of<TransfersProvider>(context, listen: false).disposer;
  }

  @override
  void dispose() {
    super.dispose();
    disposer();
  }

  @override
  Widget build(BuildContext context) {
    final transferProvider = Provider.of<TransfersProvider>(context);
    final transfers = transferProvider.transfers;
    final swiperController = transferProvider.swiperController;
    return Swiper(
        loop: false,
        itemCount: transfers.length,
        controller: swiperController,
        onIndexChanged: (i) {
          Provider.of<TransfersProvider>(context, listen: false).setIndex(i);
          FocusScope.of(context).unfocus();
        },
        itemBuilder: (context, index) {
          final currentTransfer = transfers[index];
          return SingleTransfer(currentTransfer: currentTransfer);
        });
  }
}

class SingleTransfer extends StatefulWidget {
  final TransferFormModel currentTransfer;
  const SingleTransfer({super.key, required this.currentTransfer});

  @override
  State<SingleTransfer> createState() => _SingleTransferState();
}

class _SingleTransferState extends State<SingleTransfer>
    with AutomaticKeepAliveClientMixin {
  Widget buildAssetPicker(bool widthQuery, bool isDark) {
    final feesProvider = Provider.of<FeesProvider>(context);
    final tier1 = feesProvider.transferFeeTier1;
    final tier2 = feesProvider.transferFeeTier2;
    final tier3 = feesProvider.transferFeeTier3;
    final tier4 = feesProvider.transferFeeTier4;
    final tiers = [tier1, tier2, tier3, tier4];
    final altcoinFee = feesProvider.altcoinTransferFee;
    return Container(
        padding: widthQuery
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            border: widthQuery
                ? null
                : Border.all(
                    color:
                        isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: AssetPicker(
            isTransfers: true,
            currentAsset: widget.currentTransfer.asset,
            changeCurrentAsset: (a) {
              widget.currentTransfer.changeAsset(
                  a,
                  widget.currentTransfer.amount.text,
                  tiers,
                  altcoinFee,
                  () => setState(() {}));
              setState(() {});
            },
            isTrust: false,
            isBridgeSource: false,
            isTransferActivity: false,
            isJustDisplaying: false));
  }

  buildAssetBox(String label, bool widthQuery, bool isDark) => SizedBox(
        height: 75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(label, isDark, widthQuery),
            SizedBox(width: 150, child: buildAssetPicker(widthQuery, isDark))
          ],
        ),
      );

  Widget buildField(AppLanguage lang, Chain c, bool isDark,
      TextEditingController controller, String? Function(String?)? validator,
      [TextInputType? keyboardType]) {
    final int decimals = widget.currentTransfer.asset.decimals;
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: TextFormField(
          validator: validator,
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: [
            if (keyboardType == null)
              LengthLimitingTextInputFormatter(
                  Validators.giveChainMaxLength(c, controller.text)),
            if (keyboardType == null)
              TextInputFormatter.withFunction(
                (TextEditingValue oldValue, TextEditingValue newValue) {
                  return Validators.giveChainAddressRegexp(c, newValue.text)
                          .hasMatch(newValue.text)
                      ? newValue
                      : newValue.text == ''
                          ? const TextEditingValue(text: '')
                          : oldValue;
                },
              ),
            if (keyboardType != null && decimals > 0)
              DecimalTextInputFormatter(decimalRange: decimals),
            if (keyboardType != null && decimals > 0)
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
            if (keyboardType != null && decimals < 1)
              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
          ],
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: keyboardType == null
                  ? AddressFieldSuffix(
                      showScanButton: true,
                      copyHandler: () async {
                        final data =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (data != null && data.text != null) {
                          var validationResult = validator!(data.text);
                          if (validationResult == null) {
                            controller.text = data.text!;
                          } else {
                            Toasts.showErrorToast(
                                lang.addressValidator,
                                lang.toast10,
                                isDark,
                                Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .textDirection);
                          }
                        }
                      },
                      scannerHandler: (_) {
                        var validationResult = validator!(_);
                        if (validationResult == null) {
                          controller.text = _;
                          Navigator.pop(context);
                        } else {
                          Toasts.showErrorToast(
                              lang.addressValidator,
                              lang.toast9,
                              isDark,
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .textDirection);
                        }
                      })
                  : null,
              filled: true,
              fillColor: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
              floatingLabelBehavior: FloatingLabelBehavior.never),
        ));
  }

  Widget buildFieldBox(
      AppLanguage lang,
      Chain c,
      String label,
      bool isDark,
      bool widthQuery,
      TextEditingController controller,
      String? Function(String?)? validator,
      [TextInputType? keyboardType]) {
    return SizedBox(
        height: 75,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(label, isDark, widthQuery),
              SizedBox(
                  child: buildField(
                      lang, c, isDark, controller, validator, keyboardType))
            ]));
  }

  Widget buildCheckBox(bool value, String label, bool isDark, bool widthQuery,
          bool isSchedule, TransferFormModel t) =>
      ListTile(
          visualDensity: VisualDensity.comfortable,
          hoverColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          leading: Checkbox(
              value: value,
              onChanged: (_) {
                if (_ == true) {
                  if (isSchedule) {
                    t.isInstant = false;
                    t.vision = Vision.date;
                    t.isScheduled = _!;
                  } else {
                    t.isScheduled = false;
                    t.isInstant = _!;
                  }
                } else {
                  if (isSchedule) {
                    t.isInstant = true;
                    t.isScheduled = _!;
                  } else {
                    t.isScheduled = true;
                    t.isInstant = _!;
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
              )));

  Widget buildTitle(String label, bool isDark, bool widthQuery) => Text(label,
      style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black,
          fontSize: widthQuery ? 17 : 14,
          fontWeight: FontWeight.bold));

  Widget buildFee(
      String label, Decimal amount, bool widthQuery, Chain c, bool isDark) {
    return widthQuery
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
            height: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white60 : Colors.grey)),
                const SizedBox(height: 7),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Utils.buildNetworkLogo(
                            widthQuery, Utils.feeLogo(c), true, true)),
                    const SizedBox(width: 10),
                    Text(
                        Utils.removeTrailingZeros(amount
                            .toStringAsFixed(Utils.nativeTokenDecimals(c))),
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17))
                  ],
                ),
              ],
            ))
        : Row(
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
                    SizedBox(
                        child: Utils.buildNetworkLogo(
                            widthQuery, Utils.feeLogo(c), true, true)),
                    const SizedBox(width: 5),
                    Text(
                        Utils.removeTrailingZeros(amount
                            .toStringAsFixed(Utils.nativeTokenDecimals(c))),
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14))
                  ])
            ],
          );
  }

  void checkTierMatch(String val, FeeTier tier, TransferFormModel transfer) {
    final amount = val.isEmpty ? Decimal.parse("0") : Decimal.parse(val);
    if (amount == Decimal.parse("0")) {
      transfer.omnifyFee = Decimal.parse("0");
      setState(() {});
    }
    if (tier.highThreshold != null) {
      if (amount >= tier.lowThreshold && amount <= tier.highThreshold!) {
        transfer.omnifyFee = tier.fee;
        setState(() {});
      }
    } else {
      if (amount >= tier.lowThreshold) {
        transfer.omnifyFee = tier.fee;
        setState(() {});
      }
    }
    transfer.totalFee = transfer.gasFee + transfer.omnifyFee;
    if (transfer.asset.address == Utils.zeroAddress) {
      transfer.totalFee += amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transferProvider = Provider.of<TransfersProvider>(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final direction = Provider.of<ThemeProvider>(context).textDirection;
    final chain = transferProvider.currentChain;
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    final lang = Utils.language(context);
    const heightBox = SizedBox(height: 15);
    const heightBox2 = SizedBox(height: 5);
    final widthQuery = Utils.widthQuery(context);
    Decimal totalFees = widget.currentTransfer.totalFee;
    Widget topBar(TransferFormModel currentTransfer) => Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      currentTransfer.vision = Vision.transfer;
                    });
                  },
                  icon: Icon(Icons.receipt_long_rounded,
                      size: widthQuery ? 33 : 26,
                      color: currentTransfer.vision == Vision.transfer
                          ? primaryColor
                          : isDark
                              ? Colors.grey.shade600
                              : Colors.grey)),
              if (currentTransfer.isScheduled)
                IconButton(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        currentTransfer.vision = Vision.date;
                      });
                    },
                    icon: Icon(Icons.timer_outlined,
                        size: widthQuery ? 33 : 26,
                        color: currentTransfer.vision == Vision.date
                            ? primaryColor
                            : isDark
                                ? Colors.grey.shade600
                                : Colors.grey)),
            ]);
    final int decimals = widget.currentTransfer.asset.decimals;
    super.build(context);
    return Form(
        key: widget.currentTransfer.formkey,
        child: Directionality(
          textDirection: direction,
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: border,
                  borderRadius: BorderRadius.circular(5),
                  color: isDark ? Colors.grey[800] : Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.currentTransfer.vision == Vision.transfer)
                    Expanded(
                        child: SingleChildScrollView(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widthQuery
                                    ? [
                                        topBar(widget.currentTransfer),
                                        // heightBox,
                                        Wrap(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                buildAssetBox(lang.transfer6,
                                                    widthQuery, isDark),
                                                const Spacer(flex: 2),
                                                Expanded(
                                                  flex: 6,
                                                  child: buildFieldBox(
                                                      lang,
                                                      chain,
                                                      lang.transfer7,
                                                      isDark,
                                                      widthQuery,
                                                      widget.currentTransfer
                                                          .recipient,
                                                      Validators
                                                          .giveAddressValidator(
                                                              context, chain)),
                                                ),
                                                const Spacer(flex: 2),
                                                Expanded(
                                                  flex: 6,
                                                  child: buildFieldBox(
                                                      lang,
                                                      chain,
                                                      lang.transfer8,
                                                      isDark,
                                                      widthQuery,
                                                      widget.currentTransfer
                                                          .amount,
                                                      Validators
                                                          .giveAmountValidator(
                                                              context,
                                                              decimals),
                                                      TextInputType.number),
                                                ),
                                              ],
                                            ),
                                            // const SizedBox(
                                            //     height: 40, width: double.infinity),
                                            // Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.start,
                                            //     mainAxisSize: MainAxisSize.max,
                                            //     children: [
                                            //       buildTitle(lang.transfer9, isDark,
                                            //           widthQuery),
                                            //       const SizedBox(width: 30),
                                            //       Expanded(
                                            //           child: buildCheckBox(
                                            //               widget.currentTransfer
                                            //                   .isInstant,
                                            //               lang.transfer10,
                                            //               isDark,
                                            //               widthQuery,
                                            //               false,
                                            //               widget.currentTransfer)),
                                            //       Expanded(
                                            //           child: buildCheckBox(
                                            //               widget.currentTransfer
                                            //                   .isScheduled,
                                            //               lang.transfer11,
                                            //               isDark,
                                            //               widthQuery,
                                            //               true,
                                            //               widget.currentTransfer)),
                                            //       const Spacer(),
                                            //     ]),
                                            Divider(
                                                color: isDark
                                                    ? Colors.grey.shade600
                                                    : Colors.grey.shade300),
                                            AssetFee(
                                                currentChain: chain,
                                                asset: widget
                                                    .currentTransfer.asset,
                                                amount: Decimal.tryParse(widget
                                                        .currentTransfer
                                                        .amount
                                                        .text) ??
                                                    Decimal.parse("0"),
                                                isSpecialCase: true),
                                            NetworkFee(
                                                isInTransfers: true,
                                                currentTransfer:
                                                    widget.currentTransfer,
                                                isSpecialCase: true,
                                                isPaymentFee: false,
                                                isInInstallmentFee: false,
                                                isPaymentWithdrawals: false,
                                                isTrust: false,
                                                isBridge: false,
                                                isEscrow: false,
                                                isRefuel: false,
                                                isTrustCreation: false,
                                                isTrustModification: false,
                                                benefLength: 0,
                                                ownerLength: 0,
                                                setBridgeNativeGas: (_) {},
                                                bridgeDestinationAsset: null,
                                                setState: () => setState(() {}),
                                                setFee: (_) {}),
                                            OmnifyFee(
                                              label: lang.transfer3,
                                              isSpecialCase: true,
                                              isInTransfers: true,
                                              isPaymentFee: false,
                                              isInInstallmentFee: false,
                                              isTrust: false,
                                              isTrustModifying: false,
                                              isTrustCreating: false,
                                              isBridge: false,
                                              newBeneficiaries: 0,
                                              isEscrow: false,
                                              isRefuel: false,
                                              currentTransfer:
                                                  widget.currentTransfer,
                                              setState: () => setState(() {}),
                                              setFee: (_) {},
                                            ),
                                            // buildFee(lang.transfer4, 0.000001,
                                            //     widthQuery, chain, isDark),
                                            buildFee(lang.transfer5, totalFees,
                                                widthQuery, chain, isDark),
                                          ],
                                        ),
                                      ]
                                    : [
                                        topBar(widget.currentTransfer),
                                        buildTitle(
                                            lang.transfer6, isDark, widthQuery),
                                        heightBox2,
                                        buildAssetPicker(widthQuery, isDark),
                                        heightBox,
                                        buildTitle(
                                            lang.transfer7, isDark, widthQuery),
                                        heightBox2,
                                        buildField(
                                            lang,
                                            chain,
                                            isDark,
                                            widget.currentTransfer.recipient,
                                            Validators.giveAddressValidator(
                                                context, chain)),
                                        heightBox,
                                        buildTitle(
                                            lang.transfer8, isDark, widthQuery),
                                        heightBox2,
                                        buildField(
                                            lang,
                                            chain,
                                            isDark,
                                            widget.currentTransfer.amount,
                                            Validators.giveAmountValidator(
                                                context, decimals),
                                            TextInputType.number),
                                        // heightBox,
                                        // buildTitle(
                                        //     lang.transfer9, isDark, widthQuery),
                                        // heightBox2,
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.center,
                                        //   children: [
                                        //     Expanded(
                                        //         child: buildCheckBox(
                                        //             widget
                                        //                 .currentTransfer.isInstant,
                                        //             lang.transfer10,
                                        //             isDark,
                                        //             widthQuery,
                                        //             false,
                                        //             widget.currentTransfer)),
                                        //     Expanded(
                                        //         child: buildCheckBox(
                                        //             widget.currentTransfer
                                        //                 .isScheduled,
                                        //             lang.transfer11,
                                        //             isDark,
                                        //             widthQuery,
                                        //             true,
                                        //             widget.currentTransfer)),
                                        //   ],
                                        // ),
                                        Divider(
                                            color: isDark
                                                ? Colors.grey.shade600
                                                : Colors.grey.shade300),
                                        AssetFee(
                                            currentChain: chain,
                                            asset: widget.currentTransfer.asset,
                                            amount: Decimal.tryParse(widget
                                                    .currentTransfer
                                                    .amount
                                                    .text) ??
                                                Decimal.parse("0"),
                                            isSpecialCase: true),
                                        NetworkFee(
                                          isInTransfers: true,
                                          currentTransfer:
                                              widget.currentTransfer,
                                          isSpecialCase: true,
                                          isPaymentFee: false,
                                          isInInstallmentFee: false,
                                          isPaymentWithdrawals: false,
                                          isTrust: false,
                                          isBridge: false,
                                          isEscrow: false,
                                          isRefuel: false,
                                          isTrustCreation: false,
                                          isTrustModification: false,
                                          benefLength: 0,
                                          ownerLength: 0,
                                          setBridgeNativeGas: (_) {},
                                          bridgeDestinationAsset: null,
                                          setState: () => setState(() {}),
                                          setFee: (_) {},
                                        ),
                                        OmnifyFee(
                                          label: lang.transfer3,
                                          isSpecialCase: true,
                                          isInTransfers: true,
                                          isPaymentFee: false,
                                          isInInstallmentFee: false,
                                          isTrust: false,
                                          isTrustModifying: false,
                                          isTrustCreating: false,
                                          isBridge: false,
                                          isEscrow: false,
                                          newBeneficiaries: 0,
                                          isRefuel: false,
                                          currentTransfer:
                                              widget.currentTransfer,
                                          setState: () => setState(() {}),
                                          setFee: (_) {},
                                        ),
                                        // buildFee(lang.transfer4, 0.000000001,
                                        //     widthQuery, chain, isDark),
                                        buildFee(lang.transfer5, totalFees,
                                            widthQuery, chain, isDark),
                                      ]))),
                  if (widget.currentTransfer.vision == Vision.date)
                    ScheduleForm(topBar: topBar(widget.currentTransfer)),
                ],
              )),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
