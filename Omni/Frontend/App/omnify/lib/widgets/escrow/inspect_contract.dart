import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/escrow_contract.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';

class InspectContract extends StatefulWidget {
  final EscrowContract contract;
  const InspectContract({super.key, required this.contract});

  @override
  State<InspectContract> createState() => _InspectContractState();
}

class _InspectContractState extends State<InspectContract> {
  Widget buildPropertyLabel(
          String label, Color primaryColor, bool isDark, bool widthQuery) =>
      Row(
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
    final locale = theme.langCode;
    final primaryColor =
        isDark ? Colors.white60 : Theme.of(context).colorScheme.primary;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    const heightBox2 = SizedBox(height: 15);
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Directionality(
            textDirection: direction,
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
                          Text(lang.escrow28,
                              style: TextStyle(
                                  color: isDark ? Colors.white60 : Colors.black,
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
                    Divider(color: isDark ? Colors.white60 : Colors.grey[300]),
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
                                    enableLoadState: false)),
                          ),
                          heightBox2,
                          Center(
                              child: Text(widget.contract.coinName,
                                  style: TextStyle(color: primaryColor))),
                          heightBox2,
                          buildPropertyLabel(
                              lang.escrow20, primaryColor, isDark, widthQuery),
                          Text(Utils.removeTrailingZeros(widget.contract.amount
                              .toStringAsFixed(widget.contract.decimals))),
                          heightBox2,
                          buildPropertyLabel(
                              lang.escrow21, primaryColor, isDark, widthQuery),
                          Text(widget.contract.ownerAddress),
                          heightBox2,
                          buildPropertyLabel(
                              lang.escrow22, primaryColor, isDark, widthQuery),
                          Text(widget.contract.assetAddress),
                          heightBox2,
                          buildPropertyLabel(
                              lang.escrow23, primaryColor, isDark, widthQuery),
                          Text(Utils.timeStamp(
                              widget.contract.dateCreated, locale, context)),
                          if (widget.contract.isDeleted) heightBox2,
                          if (widget.contract.isDeleted)
                            buildPropertyLabel(lang.escrow35, primaryColor,
                                isDark, widthQuery),
                          if (widget.contract.isDeleted)
                            Text(Utils.timeStamp(
                                widget.contract.dateDeleted, locale, context)),
                          const SizedBox(height: 8),
                          SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom)
                        ]))
                  ]),
            )));
  }
}
