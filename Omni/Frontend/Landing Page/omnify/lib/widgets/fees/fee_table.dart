// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/fees_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';
import '../my_image.dart';
import 'fee_data_table.dart';

class FeeTable extends StatefulWidget {
  final bool isTransfers;
  final bool isPayments;
  final bool isTrust;
  final bool isBridge;
  final bool isEscrow;
  const FeeTable(
      {required this.isTransfers,
      required this.isPayments,
      required this.isTrust,
      required this.isBridge,
      required this.isEscrow});

  @override
  State<FeeTable> createState() => _FeeTableState();
}

class _FeeTableState extends State<FeeTable> {
  bool isExpanded = false;
  String getUrl() {
    if (widget.isTransfers) {
      return Utils.transferUrl;
    } else if (widget.isPayments) {
      return Utils.payUrl;
    } else if (widget.isTrust) {
      return Utils.trustUrl;
    } else if (widget.isBridge) {
      return Utils.bridgeUrl;
    } else if (widget.isEscrow) {
      return Utils.escrowUrl;
    } else {
      return Utils.refuelUrl;
    }
  }

  String getTitle() {
    final lang = Utils.language(context);
    if (widget.isTransfers) {
      return lang.fees1;
    } else if (widget.isPayments) {
      return lang.fees2;
    } else if (widget.isTrust) {
      return lang.fees3;
    } else if (widget.isBridge) {
      return lang.fees4;
    } else if (widget.isEscrow) {
      return lang.fees5;
    } else {
      return lang.fees36;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Utils.language(context);
    final bool isDark = Provider.of<ThemeProvider>(context).isDark;
    final dir = Provider.of<ThemeProvider>(context).textDirection;
    final fees = Provider.of<FeesProvider>(context);
    final altCoinTransferFee = fees.altcoinTransferFee;
    final paymentFees = fees.paymentfees;
    final trustFees = fees.trustFees;
    final bridgeFees = fees.bridgeFees;
    final escrowFees = fees.escrowFees;
    final widthQuery = Utils.widthQuery(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Card(
        shadowColor: Colors.grey[850],
        child: AnimatedContainer(
          padding: const EdgeInsets.all(8),
          height: isExpanded
              ? widget.isTransfers
                  ? 390
                  : 160
              : 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isDark ? Colors.transparent : Colors.white),
          duration: kThemeAnimationDuration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: widthQuery ? 44 : 35,
                    width: widthQuery ? 44 : 35,
                    margin: EdgeInsets.only(
                        right: dir == TextDirection.rtl ? 0 : 7,
                        left: dir == TextDirection.rtl ? 7 : 0),
                    child: MyImage(url: getUrl(), fit: null),
                  ),
                  Text(
                    getTitle(),
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: widthQuery ? 18 : 16),
                  ),
                  IconButton(
                      onPressed: () => setState(() => isExpanded = !isExpanded),
                      icon: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: isDark ? Colors.white70 : Colors.black))
                ],
              ),
              if (isExpanded && widget.isTransfers ||
                  (isExpanded &&
                      !widget.isTransfers &&
                      !widget.isBridge &&
                      !widget.isEscrow &&
                      !widget.isPayments &&
                      !widget.isTrust))
                FeeDataTable(
                    isTransfers: widget.isTransfers,
                    isPayments: widget.isPayments,
                    isTrust: widget.isTrust,
                    isBridge: widget.isBridge,
                    isEscrow: widget.isEscrow),
              if (isExpanded && widget.isTransfers)
                ListTile(
                  leading: Text(
                    lang.fees29,
                    style: const TextStyle(fontSize: 16),
                  ),
                  title: Row(children: [
                    Utils.buildNetworkLogo(
                        true, Utils.feeLogo(fees.currentChain), true, true),
                    const SizedBox(width: 5),
                    Text(altCoinTransferFee.toString())
                  ]),
                ),
              if (isExpanded && widget.isPayments)
                Column(
                  children: [
                    ListTile(
                      leading: Utils.buildNetworkLogo(
                          true, Utils.feeLogo(fees.currentChain), true, true),
                      title: Text(
                          "${paymentFees.amountPerPayment.toString()} ${lang.fees30}"),
                    ),
                    ListTile(
                      leading: Utils.buildNetworkLogo(
                          true, Utils.feeLogo(fees.currentChain), true, true),
                      title: Text(
                          "${paymentFees.amountPerInstallment.toString()} ${lang.fees31}"),
                    ),
                  ],
                ),
              if (isExpanded && widget.isTrust)
                Column(
                  children: [
                    ListTile(
                      leading: Utils.buildNetworkLogo(
                          true, Utils.feeLogo(fees.currentChain), true, true),
                      title: Text(
                          "${trustFees.amountPerDeposit.toString()} ${lang.fees32}"),
                    ),
                    ListTile(
                      leading: Utils.buildNetworkLogo(
                          true, Utils.feeLogo(fees.currentChain), true, true),
                      title: Text(
                          "${trustFees.amountPerBeneficiary.toString()} ${lang.fees33}"),
                    ),
                  ],
                ),
              if (isExpanded && widget.isBridge)
                Column(
                  children: [
                    ListTile(
                      leading: Utils.buildNetworkLogo(
                          true, Utils.feeLogo(fees.currentChain), true, true),
                      title: Text(
                          "${bridgeFees.feePerTransaction.toString()} ${lang.fees34}"),
                    ),
                  ],
                ),
              if (isExpanded && widget.isEscrow)
                Column(
                  children: [
                    ListTile(
                      leading: Utils.buildNetworkLogo(
                          true, Utils.feeLogo(fees.currentChain), true, true),
                      title: Text(
                          "${escrowFees.feePerContract.toString()} ${lang.fees35}"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
