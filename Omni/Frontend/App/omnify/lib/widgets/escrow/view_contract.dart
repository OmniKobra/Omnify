import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:provider/provider.dart';

import '../../models/escrow_contract.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';
import 'bidder_widget.dart';

class ContractViewer extends StatefulWidget {
  final EscrowContract contract;
  final void Function() setStater;
  const ContractViewer(
      {super.key, required this.contract, required this.setStater});

  @override
  State<ContractViewer> createState() => _ContractViewerState();
}

class _ContractViewerState extends State<ContractViewer> {
  Widget buildPropertyLabel(String label, Color primaryColor, bool isDark,
          bool widthQuery, bool isBids) =>
      Row(
        mainAxisAlignment:
            isBids ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Chip(
              // visualDensity: VisualDensity.compact,
              elevation: 0,
              padding: const EdgeInsets.all(0),
              labelPadding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 0,
                      color:
                          isDark ? Colors.grey.shade800 : Colors.transparent)),
              color: WidgetStatePropertyAll(
                  isDark ? Colors.grey[800] : Colors.white),
              label: Text(label,
                  style: TextStyle(
                      color: primaryColor, fontSize: widthQuery ? null : 13))),
        ],
      );
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final direction = theme.textDirection;
    final primaryColor =
        isDark ? Colors.white60 : Theme.of(context).colorScheme.primary;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    const heightBox2 = SizedBox(height: 15);
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Directionality(
            textDirection: direction,
            child: PieCanvas(
              child: SelectionArea(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 8.0, right: 8, top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lang.escrow29,
                                style: TextStyle(
                                    color:
                                        isDark ? Colors.white60 : Colors.black,
                                    fontWeight: FontWeight.bold)),
                            IconButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close,
                                    color:
                                        isDark ? Colors.white60 : Colors.black))
                          ],
                        ),
                      ),
                      Divider(
                          color: isDark ? Colors.white60 : Colors.grey[300]),
                      Expanded(
                          child: ListView(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, bottom: 8),
                              children: [
                            const SizedBox(height: 5),
                            Text(widget.contract.escrowID,
                                style: TextStyle(color: primaryColor)),
                            const SizedBox(height: 5),
                            Center(
                                child: SizedBox(
                                    height: 120,
                                    width: double.infinity,
                                    child: ExtendedImage.network(
                                        widget.contract.imageUrl,
                                        cache: true,
                                        enableLoadState: false))),
                            heightBox2,
                            Center(
                                child: Text(widget.contract.coinName,
                                    style: TextStyle(color: primaryColor))),
                            heightBox2,
                            buildPropertyLabel(lang.escrow33, primaryColor,
                                isDark, widthQuery, false),
                            Center(
                                child: Text(Utils.removeTrailingZeros(
                                    widget.contract.amount.toStringAsFixed(
                                        widget.contract.decimals)))),
                            heightBox2,
                            buildPropertyLabel(lang.escrow34, primaryColor,
                                isDark, widthQuery, false),
                            Center(child: Text(widget.contract.ownerAddress)),
                            heightBox2,
                            buildPropertyLabel(lang.escrow22, primaryColor,
                                isDark, widthQuery, false),
                            Center(child: Text(widget.contract.assetAddress)),
                            Divider(
                                color: isDark
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade300),
                            buildPropertyLabel(
                                "${lang.escrow30} ${widget.contract.bids.length}",
                                primaryColor,
                                isDark,
                                widthQuery,
                                true),
                            Wrap(children: [
                              ...widget.contract.bids.map((e) => BidderWidget(
                                  bid: e,
                                  contract: widget.contract,
                                  setStateHandle: () {
                                    widget.setStater();
                                    setState(() {});
                                  }))
                            ])
                          ]))
                    ]),
              ),
            )));
  }
}
