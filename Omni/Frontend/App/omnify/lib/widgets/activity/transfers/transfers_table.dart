// ignore_for_file: prefer_if_null_operators, use_key_in_widget_constructors

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/transfer_transaction.dart';
import '../../../providers/activities/transfer_activity_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils.dart';
import '../../common/nestedScroller.dart';
import '../show_more.dart';

class TransferTable extends StatefulWidget {
  final ScrollController controller;
  const TransferTable(this.controller);

  @override
  State<TransferTable> createState() => _TransferTableState();
}

class _TransferTableState extends State<TransferTable> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<TransferActivityProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    final list = provider.transactions;
    final allList = provider.allTransactions;
    DataColumn2 buildColumn(String label) =>
        DataColumn2(label: Text(label), size: ColumnSize.S);
    DataCell buildCell(String content, bool showImage,
            [Color? color, Chain? c]) =>
        DataCell(Row(mainAxisSize: MainAxisSize.max, children: [
          if (showImage) Utils.buildNetworkLogo(false, c!, true),
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
    List<DataCell> getCells(TransferActivityTransaction t) {
      return [
        buildCell(t.asset.address, false, null, null),
        buildCell(
            t.asset.symbol +
                " " +
                Utils.removeTrailingZeros(
                    t.amount.toStringAsFixed(t.asset.decimals)),
            false,
            t.isOutgoing ? Colors.red : Colors.green,
            Chain.Avalanche),
        buildCell(t.address, false, null, null),
        buildCell(Utils.timeStamp(t.date, theme.langCode, context), false),
        buildCell(t.id, false),
      ];
    }

    List<DataRow2> getRows() {
      return [
        ...list.map((e) => DataRow2(specificRowHeight: 70, cells: getCells(e)))
      ];
    }

    List<DataColumn2> getColumns() {
      return [
        buildColumn(lang.table41),
        buildColumn(lang.transferActivity9),
        buildColumn(lang.transferActivity10),
        buildColumn(lang.transferActivity11),
        buildColumn(lang.transferActivity12),
      ];
    }

    return Directionality(
        textDirection: dir,
        child: Container(
            padding: const EdgeInsets.all(8),
            height: widthQuery ? 650 : 550,
            decoration: BoxDecoration(
                border: border,
                borderRadius: BorderRadius.circular(5),
                color: isDark ? Colors.grey[800] : Colors.white),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(lang.transferActivity13 + "  " + allList.length.toString(),
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
                    minWidth: 1100,
                    columns: getColumns(),
                    rows: getRows(),
                  ),
                )),
              if (list.isNotEmpty)
                const ShowMore(
                    isInTransfers: true,
                    isInPaymentReceipts: false,
                    isInPaymentWithdrawals: false,
                    isInBridgeTransactions: false)
            ])));
  }
}
