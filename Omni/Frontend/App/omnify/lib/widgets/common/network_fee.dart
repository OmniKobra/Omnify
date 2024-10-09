// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously
import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:omnify/providers/bridges_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../crypto/features/bridge_utils.dart';
import '../../crypto/features/escrow_utils.dart';
import '../../crypto/features/payment_utils.dart';
import '../../crypto/features/transfer_utils.dart';
import '../../crypto/features/trust_utils.dart';
import '../../models/asset.dart';
import '../../models/transfer.dart';
import '../../providers/theme_provider.dart';
import '../../providers/trusts_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../utils.dart';
import '../../validators.dart';

class NetworkFee extends StatefulWidget {
  //TODO ADD NEW FEATURE NETWORK FEES HERE
  final bool isInTransfers;
  final bool isSpecialCase;
  final TransferFormModel? currentTransfer;
  final CryptoAsset? bridgeDestinationAsset;
  final bool isPaymentFee;
  final bool isInInstallmentFee;
  final bool isPaymentWithdrawals;
  final bool isTrust;
  final bool isTrustCreation;
  final bool isTrustModification;
  final bool isBridge;
  final bool isEscrow;
  final bool isRefuel;
  final int ownerLength;
  final int benefLength;
  final void Function() setState;
  final void Function(Decimal) setFee;
  final void Function(Decimal) setBridgeNativeGas;
  final CryptoAsset? asset;
  final Decimal? omnifyFee;
  final Decimal? amount;
  final String? recipient;
  final bool? isEscrowCreation;
  final bool? isEscrowDeletion;
  const NetworkFee({
    required this.isInTransfers,
    required this.currentTransfer,
    required this.isSpecialCase,
    required this.isPaymentFee,
    required this.isInInstallmentFee,
    required this.isPaymentWithdrawals,
    required this.setFee,
    required this.isTrust,
    required this.isTrustCreation,
    required this.isTrustModification,
    required this.isBridge,
    required this.isEscrow,
    required this.isRefuel,
    required this.ownerLength,
    required this.benefLength,
    required this.setState,
    required this.setBridgeNativeGas,
    required this.bridgeDestinationAsset,
    this.asset,
    this.omnifyFee,
    this.amount,
    this.recipient,
    this.isEscrowCreation,
    this.isEscrowDeletion,
  });

  @override
  State<NetworkFee> createState() => _NetworkFeeState();
}

class _NetworkFeeState extends State<NetworkFee> {
  late Future<void> _getAndSetFee;
  bool timerSet = false;
  Decimal stateGasFee = Decimal.parse("0.0");
  Decimal stateBridgeAmount = Decimal.parse("0.0");
  late CryptoAsset? stateBridgeAsset;
  String stateBridgeAddress = "";
  Timer? timer;
  int newBenfs = 0;
  Future<void> getAndSetFee(
      dynamic addressValidator, dynamic amountValidator) async {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final c = theme.startingChain;
    final client = theme.client;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final walletAddress = wallet.getAddressString(c);
    // if (mounted) {
    if (widget.isInTransfers) {
      if (addressValidator == null) {
        Decimal _gasFee = await TransferUtils.quoteTransferFee(
            c, widget.currentTransfer!, walletAddress, client);
        stateGasFee = _gasFee;
        widget.currentTransfer!.setGasFee(_gasFee, () {
          setState(() {});
          widget.setState();
        });
      } else {
        final addressValid =
            addressValidator!(widget.currentTransfer!.recipient.text) == null;
        final amountValid =
            amountValidator!(widget.currentTransfer!.amount.text) == null;
        if (amountValid && addressValid) {
          Decimal _gasFee = await TransferUtils.quoteTransferFee(
              c, widget.currentTransfer!, walletAddress, client);
          stateGasFee = _gasFee;
          widget.currentTransfer!.setGasFee(_gasFee, () {
            setState(() {});
            widget.setState();
          });
        }
      }
    }
    if (widget.isPaymentWithdrawals ||
        widget.isInInstallmentFee ||
        widget.isPaymentFee) {
      Decimal _gasFee = await PaymentUtils.quotePaymentFee(
          c: c,
          isFullPayment: widget.isPaymentFee,
          isAnInstallment: widget.isInInstallmentFee,
          client: client);
      stateGasFee = _gasFee;
      setState(() {});
      widget.setFee(stateGasFee);
    }
    if (widget.isTrust) {
      final trust = Provider.of<TrustsProvider>(context, listen: false);
      final trustBenefLength = trust.beneficiaries.length;
      final trustOwnerLength = trust.owners.length;
      Decimal _gasFee = await TrustUtils.quoteGas(
          c: c,
          client: client,
          isCreation: widget.isTrust,
          benefLength: widget.isTrustModification
              ? widget.benefLength
              : trustBenefLength,
          ownerLength: widget.isTrustModification ? 0 : trustOwnerLength,
          isModification: widget.isTrustModification);
      stateGasFee = _gasFee;
      setState(() {});
      widget.setFee(stateGasFee);
    }
    if (widget.isBridge) {
      var bridges = Provider.of<BridgesProvider>(context, listen: false);
      Decimal _gasFee = await BridgeUtils.quoteGasFee(
          c: c,
          client: client,
          isFirstBridging: widget.bridgeDestinationAsset == null);
      Decimal _nativeGas = await BridgeUtils.quoteNativeGas(
          c: c,
          targetChain: bridges.currentTargetChain,
          client: client,
          wcClient: theme.walletClient,
          sessionTopic: theme.stateSessionTopic,
          omnifyFee: widget.omnifyFee!,
          amount: widget.amount!,
          asset: widget.asset!,
          recipient: widget.recipient!,
          walletAddress: walletAddress);
      widget.setBridgeNativeGas(_nativeGas);
      widget.setFee(_gasFee);
      stateGasFee = _nativeGas + _gasFee;
      setState(() {});
    }
    if (widget.isEscrow) {
      Decimal _gasFee = await EscrowUtils.quoteGasFee(
          c: c,
          client: client,
          isCreation: widget.isEscrowCreation!,
          isDelete: widget.isEscrowDeletion!);
      stateGasFee = _gasFee;
      setState(() {});
      widget.setFee(stateGasFee);
    }
    widget.setState();
    // }
  }

  @override
  void initState() {
    super.initState();
    final c = Provider.of<ThemeProvider>(context, listen: false).startingChain;
    _getAndSetFee = getAndSetFee(null, null);
    if (widget.isInTransfers) {
      stateGasFee = widget.currentTransfer!.gasFee;
    }
    if (widget.isBridge) {
      stateBridgeAsset = Utils.generateNativeUSDT(c);
    }
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.isInTransfers) {
      _getAndSetFee = getAndSetFee(null, null);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }

  Widget buildWidget(
      bool isInLoading, bool widthQuery, bool isDark, Chain c, String label) {
    final hyphen = Text("≈ ",
        style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black,
            // fontWeight: FontWeight.bold,
            fontSize: 16));
    return Skeletonizer(
        enabled: isInLoading,
        ignoreContainers: true,
        child: widget.isSpecialCase
            ? widthQuery
                ? Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 25),
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
                            hyphen,
                            SizedBox(
                                child: Utils.buildNetworkLogo(
                                    widthQuery, Utils.feeLogo(c), true, true)),
                            const SizedBox(width: 10),
                            Text(
                                Utils.removeTrailingZeros(
                                    stateGasFee.toStringAsFixed(
                                        Utils.nativeTokenDecimals(c))),
                                style: TextStyle(
                                    color:
                                        isDark ? Colors.white70 : Colors.black,
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
                            hyphen,
                            SizedBox(
                                child: Utils.buildNetworkLogo(
                                    widthQuery, Utils.feeLogo(c), true, true)),
                            const SizedBox(width: 5),
                            Text(
                                Utils.removeTrailingZeros(
                                    stateGasFee.toStringAsFixed(
                                        Utils.nativeTokenDecimals(c))),
                                style: TextStyle(
                                    color:
                                        isDark ? Colors.white70 : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))
                          ])
                    ],
                  )
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
                        hyphen,
                        SizedBox(
                            child: Utils.buildNetworkLogo(
                                widthQuery, Utils.feeLogo(c), true, true)),
                        const SizedBox(width: 5),
                        Text(
                            Utils.removeTrailingZeros(stateGasFee
                                .toStringAsFixed(Utils.nativeTokenDecimals(c))),
                            style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14))
                      ])
                ],
              ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final c = theme.startingChain;
    final wallet = Provider.of<WalletProvider>(context);
    final lang = Utils.language(context);
    final walletConnected = wallet.isWalletConnected;
    final widthQuery = Utils.widthQuery(context);
    final trust = Provider.of<TrustsProvider>(context);
    final trustBenefLength = trust.beneficiaries.length;
    final addressValidator = widget.isInTransfers
        ? Validators.giveAddressValidator(context, c)
        : null;
    final amountValidator = widget.isInTransfers
        ? Validators.giveAmountValidator(context, Utils.nativeTokenDecimals(c))
        : null;
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    if (widget.isTrust) {
      if (widget.isTrustModification) {
        if (newBenfs != widget.benefLength) {
          newBenfs = widget.benefLength;
          _getAndSetFee = getAndSetFee(null, null);
        }
      }
      if (widget.isTrustCreation) {
        if (newBenfs != trustBenefLength) {
          newBenfs = trustBenefLength;
          _getAndSetFee = getAndSetFee(null, null);
        }
      }
    }
    if (widget.isBridge) {
      if (widget.amount! != stateBridgeAmount ||
          widget.recipient! != stateBridgeAddress ||
          widget.asset!.address != stateBridgeAsset!.address) {
        if (widget.recipient! != stateBridgeAddress) {
          stateBridgeAddress = widget.recipient!;
          _getAndSetFee = getAndSetFee(null, null);
        }
        if (widget.amount! != stateBridgeAmount) {
          stateBridgeAmount = widget.amount!;
          _getAndSetFee = getAndSetFee(null, null);
        }
        if (widget.asset!.address != stateBridgeAsset!.address) {
          stateBridgeAsset = widget.asset;
          Future.delayed(const Duration(milliseconds: 1510), () {
            _getAndSetFee = getAndSetFee(null, null);
          });
        }
      }
    }
    if (walletConnected) {
      if (!timerSet) {
        timer = Timer.periodic(Utils.queryFeesDuration, (t) {
          if (mounted) {
            setState(() {
              _getAndSetFee = getAndSetFee(addressValidator, amountValidator);
            });
          }
        });
        timerSet = true;
      }
    } else {
      if (timer != null) {
        timer!.cancel();
        timer = null;
        timerSet = false;
      }
    }
    return FutureBuilder(
        future: _getAndSetFee,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return buildWidget(true, widthQuery, isDark, c, lang.transfer2);
          }
          return buildWidget(false, widthQuery, isDark, c, lang.transfer2);
        });
  }
}
