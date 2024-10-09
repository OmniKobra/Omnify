// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:omnify/providers/trusts_provider.dart';
import 'package:omnify/validators.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../models/transfer.dart';
import '../../providers/fees_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../utils.dart';

class OmnifyFee extends StatefulWidget {
  //TODO ADD NEW FEATURE FEES HERE
  final String label;
  final bool isSpecialCase;
  final bool isInTransfers;
  final bool isPaymentFee;
  final bool isInInstallmentFee;
  final bool isTrust;
  final bool isTrustModifying;
  final bool isTrustCreating;
  final bool isBridge;
  final bool isEscrow;
  final bool isRefuel;
  final TransferFormModel? currentTransfer;
  final int newBeneficiaries;
  final void Function() setState;
  final void Function(Decimal) setFee;

  const OmnifyFee({
    required this.label,
    required this.isSpecialCase,
    required this.isInTransfers,
    required this.isPaymentFee,
    required this.isInInstallmentFee,
    required this.isTrust,
    required this.isTrustModifying,
    required this.isTrustCreating,
    required this.isBridge,
    required this.isEscrow,
    required this.isRefuel,
    required this.currentTransfer,
    required this.newBeneficiaries,
    required this.setState,
    required this.setFee,
  });

  @override
  State<OmnifyFee> createState() => _OmnifyFeeState();
}

class _OmnifyFeeState extends State<OmnifyFee> {
  late Future<void> _getAndSetFee;
  bool timerSet = false;
  List<FeeTier> _stateTiers = [];
  Decimal _stateAltcoinFee = Decimal.parse("0.0");
  Decimal _stateAmount = Decimal.parse("0.0");
  Timer? timer;
  int newBenfs = 0;

  Future<void> getAndSetFee(
      dynamic addressValidator, dynamic amountValidator) async {
    if (mounted) {
      final theme = Provider.of<ThemeProvider>(context, listen: false);
      final c = theme.startingChain;
      final client = theme.client;
      var feeMethods = Provider.of<FeesProvider>(context, listen: false);
      if (widget.isInTransfers) {
        final addressValid =
            addressValidator!(widget.currentTransfer!.recipient.text) == null;
        final amountValid =
            amountValidator!(widget.currentTransfer!.amount.text) == null;
        if (amountValid && addressValid) {
          List<dynamic> _tiers =
              await feeMethods.getAndSetTransferFees(c, client);
          final amount = widget.currentTransfer!.amount.text;
          final List<FeeTier> tiers = [
            _tiers[0],
            _tiers[1],
            _tiers[2],
            _tiers[3]
          ];
          _stateTiers = tiers;
          final altcoinFee = _tiers[4];
          _stateAltcoinFee = altcoinFee;
          widget.currentTransfer!.checkTierMatch(amount, tiers, altcoinFee, () {
            setState(() {
              _stateAmount = widget.currentTransfer!.omnifyFee;
            });
            widget.setState();
          });
        }
      }
      if (widget.isPaymentFee || widget.isInInstallmentFee) {
        List<Decimal> _fees = await feeMethods.getAndSetPaymentFees(c, client);
        late Decimal _fee;
        if (widget.isPaymentFee) {
          _fee = _fees[0];
        } else {
          _fee = _fees[1];
        }
        _stateAmount = _fee;
        setState(() {});
        widget.setFee(_stateAmount);
      }
      if (widget.isTrust) {
        final trust = Provider.of<TrustsProvider>(context, listen: false);
        final trustBenefLength = trust.beneficiaries.length;
        late Decimal totalFees;
        List<Decimal> _fees = await feeMethods.getAndSetTrustFees(c, client);
        final perDeposit = _fees[0];
        final perBenef = _fees[1];
        final benefFees = widget.isTrustModifying
            ? perBenef * Decimal.parse(widget.newBeneficiaries.toString())
            : perBenef * Decimal.parse(trustBenefLength.toString());
        if (widget.isTrustModifying) {
          totalFees = benefFees;
        } else if (widget.isTrustCreating) {
          totalFees = perDeposit + benefFees;
        } else {
          totalFees = perDeposit;
        }
        _stateAmount = totalFees;
        setState(() {});
        widget.setFee(_stateAmount);
      }
      if (widget.isBridge) {
        Decimal fee = await feeMethods.getAndSetBridgeFees(c, client);
        _stateAmount = fee;
        setState(() {});
        widget.setFee(_stateAmount);
      }
      if (widget.isEscrow) {
        Decimal fee = await feeMethods.getAndSetEscrowFees(c, client);
        _stateAmount = fee;
        setState(() {});
        widget.setFee(_stateAmount);
      }
      widget.setState();
    }
  }

  @override
  void initState() {
    super.initState();
    final feesProvider = Provider.of<FeesProvider>(context, listen: false);
    final _initTiers = [
      feesProvider.transferFeeTier1,
      feesProvider.transferFeeTier2,
      feesProvider.transferFeeTier3,
      feesProvider.transferFeeTier4
    ];
    _stateTiers = _initTiers;
    _stateAltcoinFee = feesProvider.altcoinTransferFee;
    if (widget.isInTransfers) {
      widget.currentTransfer!.amount.addListener(() {
        if (mounted) {
          widget.currentTransfer!.checkTierMatch(
              widget.currentTransfer!.amount.text,
              _stateTiers,
              _stateAltcoinFee, () {
            setState(() {
              _stateAmount = widget.currentTransfer!.omnifyFee;
            });
            widget.setState();
          });
        }
      });
    }
    _getAndSetFee = getAndSetFee(null, null);
    if (widget.isInTransfers) {
      _stateAmount = widget.currentTransfer!.omnifyFee;
    }
  }

  @override
  void didUpdateWidget(covariant OmnifyFee oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isInTransfers) {
      _stateAmount = widget.currentTransfer!.omnifyFee;
      widget.currentTransfer!.amount.addListener(() {
        if (mounted) {
          widget.currentTransfer!.checkTierMatch(
              widget.currentTransfer!.amount.text,
              _stateTiers,
              _stateAltcoinFee, () {
            setState(() {
              _stateAmount = widget.currentTransfer!.omnifyFee;
            });
            widget.setState();
          });
        }
      });
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
    if (widget.isInTransfers) {
      widget.currentTransfer!.amount.removeListener(() {});
    }
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }

  Widget buildWidget(bool isInLoading, bool widthQuery, bool isDark, Chain c) {
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
                        Text(widget.label,
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
                                Utils.removeTrailingZeros(
                                    _stateAmount.toStringAsFixed(
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
                      Text(widget.label,
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
                                Utils.removeTrailingZeros(
                                    _stateAmount.toStringAsFixed(
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
                  Text(widget.label,
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
                            Utils.removeTrailingZeros(_stateAmount
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
    final widthQuery = Utils.widthQuery(context);
    final trust = Provider.of<TrustsProvider>(context);
    final trustBenefLength = trust.beneficiaries.length;
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final c = theme.startingChain;
    final wallet = Provider.of<WalletProvider>(context);
    final walletConnected = wallet.isWalletConnected;
    final addressValidator = widget.isInTransfers
        ? Validators.giveAddressValidator(context, c)
        : null;
    final amountValidator = widget.isInTransfers
        ? Validators.giveAmountValidator(context, Utils.nativeTokenDecimals(c))
        : null;
    if (widget.isTrust) {
      if (widget.isTrustModifying) {
        if (newBenfs != widget.newBeneficiaries) {
          newBenfs = widget.newBeneficiaries;
          _getAndSetFee = getAndSetFee(null, null);
        }
      } else {
        if (newBenfs != trustBenefLength) {
          newBenfs = trustBenefLength;
          _getAndSetFee = getAndSetFee(null, null);
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
            return buildWidget(true, widthQuery, isDark, c);
          }
          return buildWidget(false, widthQuery, isDark, c);
        });
  }
}
