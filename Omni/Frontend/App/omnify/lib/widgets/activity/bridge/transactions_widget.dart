// ignore_for_file: prefer_if_null_operators, use_key_in_widget_constructors

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/bridge_asset.dart';
import '../../../providers/activities/bridge_activity_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils.dart';
import '../../common/nestedScroller.dart';
import '../show_more.dart';

class BridgeTransactionsWidget extends StatefulWidget {
  final ScrollController controller;
  const BridgeTransactionsWidget(this.controller);

  @override
  State<BridgeTransactionsWidget> createState() =>
      _BridgeTransactionsWidgetState();
}

class _BridgeTransactionsWidgetState extends State<BridgeTransactionsWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<BridgeActivityProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    final list = provider.transactions;
    DataColumn2 buildColumn(String label) =>
        DataColumn2(label: Text(label), size: ColumnSize.S);
    DataCell buildCell(String content, bool showImage, bool isChain,
            [Color? color, Chain? c, String? logoUrl]) =>
        DataCell(Row(mainAxisSize: MainAxisSize.max, children: [
          if (showImage && isChain) Utils.buildNetworkLogo(false, c!, true),
          if (showImage && !isChain)
            Utils.buildAssetLogoFromUrl(false, logoUrl!, true),
          if (showImage) const SizedBox(width: 5),
          Expanded(
            child: Text(content,
                style: TextStyle(
                    color: color != null
                        ? color
                        : isDark
                            ? Colors.white60
                            : Colors.black)),
          ),
        ]));
    List<DataCell> getCells(BridgeTransaction t) {
      return [
        buildCell(t.id, false, false),
        buildCell(t.assetAddress, false, false),
        buildCell(
            Utils.removeTrailingZeros(
                t.assetAmount.toStringAsFixed(t.decimals)),
            true,
            false,
            t.isOutgoing ? Colors.red : Colors.green,
            Chain.Avalanche,
            t.assetImage),
        buildCell(t.sourceChain.name, true, true, null, t.sourceChain),
        buildCell(
            t.destinationChain.name, true, true, null, t.destinationChain),
        buildCell(
            Utils.timeStamp(t.date, theme.langCode, context), false, false),
        buildCell(t.sender, false, false),
        buildCell(t.recipient, false, false),
      ];
    }

    List<DataRow2> getRows() {
      return [
        ...list.map((e) => DataRow2(specificRowHeight: 70, cells: getCells(e)))
      ];
    }

    List<DataColumn2> getColumns() {
      return [
        buildColumn(lang.transferActivity12),
        buildColumn(lang.subtable7),
        buildColumn(lang.bridgeActivity9),
        buildColumn(lang.bridgeActivity8),
        buildColumn(lang.bridgeActivity10),
        buildColumn(lang.bridgeActivity11),
        buildColumn(lang.bridgeActivity12),
        buildColumn(lang.bridgeActivity13)
      ];
    }

    return Directionality(
        textDirection: dir,
        child: Container(
            padding: const EdgeInsets.all(8),
            height: widthQuery ? 450 : 550,
            decoration: BoxDecoration(
                border: border,
                borderRadius: BorderRadius.circular(5),
                color: isDark ? Colors.grey[800] : Colors.white),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(lang.bridgeActivity14,
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: widthQuery ? 18 : 16)),
              if (list.isEmpty) const Spacer(),
              if (list.isEmpty)
                Center(
                    child: Text(lang.bridgeActivity4,
                        style: TextStyle(
                            fontStyle: dir == TextDirection.ltr
                                ? FontStyle.italic
                                : FontStyle.normal,
                            fontSize: widthQuery ? 17 : 15,
                            color: isDark ? Colors.white60 : Colors.grey))),
              if (list.isEmpty) const Spacer(),
              if (list.isNotEmpty) const SizedBox(height: 10),
              if (list.isNotEmpty)
                Expanded(
                    child: NestedScroller(
                  controller: widget.controller,
                  child: DataTable2(
                    headingRowColor: WidgetStateColor.resolveWith(
                        (states) => Colors.grey[850]!),
                    headingTextStyle: const TextStyle(color: Colors.white),
                    headingCheckboxTheme: const CheckboxThemeData(
                        side: BorderSide(color: Colors.white, width: 2.0)),
                    isHorizontalScrollBarVisible: false,
                    isVerticalScrollBarVisible: false,
                    columnSpacing: 10,
                    showCheckboxColumn: false,
                    horizontalMargin: 10,
                    border: const TableBorder(
                        horizontalInside:
                            BorderSide(color: Colors.grey, width: .1)),
                    dividerThickness: 0,
                    bottomMargin: 10,
                    minWidth: 1400,
                    columns: getColumns(),
                    rows: getRows(),
                  ),
                )),
              if (list.isNotEmpty)
                const ShowMore(
                    isInTransfers: false,
                    isInPaymentReceipts: false,
                    isInPaymentWithdrawals: false,
                    isInBridgeTransactions: true)
            ])));
  }
}
