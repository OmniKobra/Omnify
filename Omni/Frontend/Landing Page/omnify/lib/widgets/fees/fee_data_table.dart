// ignore_for_file: use_key_in_widget_constructors, prefer_interpolation_to_compose_strings

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/fees_provider.dart';
import '../../utils.dart';

class FeeDataTable extends StatefulWidget {
  final bool isTransfers;
  final bool isPayments;
  final bool isTrust;
  final bool isBridge;
  final bool isEscrow;
  const FeeDataTable(
      {required this.isTransfers,
      required this.isPayments,
      required this.isTrust,
      required this.isBridge,
      required this.isEscrow});

  @override
  State<FeeDataTable> createState() => _FeeDataTableState();
}

class _FeeDataTableState extends State<FeeDataTable> {
  DataColumn2 buildColumn(String label) =>
      DataColumn2(label: Text(label), size: ColumnSize.S);

  @override
  Widget build(BuildContext context) {
    final fees = Provider.of<FeesProvider>(context);
    final chain = fees.currentChain;
    final transferFees = [
      fees.transferFeeTier1,
      fees.transferFeeTier2,
      fees.transferFeeTier3,
      fees.transferFeeTier4
    ];
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    String buildRange(FeeTier tier) => tier.highThreshold != null
        ? "${tier.lowThreshold} - ${tier.highThreshold}"
        : "${tier.lowThreshold}+";
    DataCell buildCell(String content, bool showImage, Chain c) => DataCell(Row(
          children: [
            if (showImage)
              Utils.buildNetworkLogo(widthQuery, Utils.feeLogo(c), true, true),
            if (showImage) const SizedBox(width: 5),
            Expanded(child: Text(content)),
          ],
        ));
    List<DataCell> getCells(FeeTier feeRow) {
      if (widget.isTransfers || widget.isTrust) {
        return [
          buildCell(buildRange(feeRow), true, chain),
          buildCell(feeRow.fee.toString(), true, chain),
          // buildCell(feeRow.scheduleFee.toString()),
          // buildCell(feeRow.networkFee.toString()),
        ];
      } else {
        return [];
      }
    }

    List<DataRow2> getRows() {
      if (widget.isTransfers) {
        return [...transferFees.map((e) => DataRow2(cells: getCells(e)))];
      } else {
        return [];
      }
    }

    List<DataColumn2> getColumns() {
      if (widget.isTransfers) {
        return [
          buildColumn(lang.fees8),
          buildColumn(lang.fees9),
          // buildColumn(lang.fees10),
          // buildColumn(lang.fees11)
        ];
      } else {
        return [];
      }
    }

    return Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DataTable2(
              headingRowColor:
                  WidgetStateColor.resolveWith((states) => Colors.grey[850]!),
              headingTextStyle: const TextStyle(color: Colors.white),
              headingCheckboxTheme: const CheckboxThemeData(
                  side: BorderSide(color: Colors.white, width: 2.0)),
              isHorizontalScrollBarVisible: false,
              isVerticalScrollBarVisible: false,
              columnSpacing: 12,
              showCheckboxColumn: false,
              horizontalMargin: 12,
              border: const TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey, width: .1)),
              dividerThickness: 0,
              bottomMargin: 10,
              minWidth: 520,
              columns: getColumns(),
              empty: const Center(child: SizedBox(child: Text(''))),
              rows: getRows(),
            )));
  }
}
