import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/explorer_escrow.dart';
import '../../models/explorer_trust.dart';
import '../../providers/explorer_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';

class ExplorerSubTable extends StatefulWidget {
  final bool isBids;
  final bool isOwners;
  final List<String> owners;
  final List<Beneficiary> beneficiaries;
  final List<EscrowBid> bids;
  const ExplorerSubTable(
      {super.key,
      required this.isBids,
      required this.isOwners,
      required this.owners,
      required this.beneficiaries,
      required this.bids});

  @override
  State<ExplorerSubTable> createState() => _ExplorerSubTableState();
}

class _ExplorerSubTableState extends State<ExplorerSubTable> {
  DataColumn2 buildColumn(String label) =>
      DataColumn2(label: Text(label), size: ColumnSize.S);
  @override
  Widget build(BuildContext context) {
    final explorer = Provider.of<ExplorerProvider>(context);
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final chain = explorer.currentChain;
    final theme = Provider.of<ThemeProvider>(context);
    final langCode = theme.langCode;
    String stamp(DateTime t) => Utils.timeStamp(t, langCode, context);
    DataCell buildCell(String content, bool showLogo, bool isChain, Chain c,
            [String? logoUrl]) =>
        DataCell(Row(
          children: [
            if (showLogo && logoUrl == null)
              Utils.buildNetworkLogo(
                  widthQuery, isChain ? c : Utils.feeLogo(c), true, true),
            if (showLogo && logoUrl != null)
              Utils.buildAssetLogoFromUrl(widthQuery, logoUrl, true, true),
            if (showLogo) const SizedBox(width: 5),
            Expanded(child: Text(content)),
          ],
        ));
    List<DataCell> getCells(String? owner, Beneficiary? b, EscrowBid? bi) {
      if (widget.isOwners) {
        return [buildCell(owner!, false, false, chain)];
      } else if (widget.isBids) {
        return [
          buildCell(bi!.bidderAddress, false, false, chain),
          buildCell(bi.amount.toString(), true, false, chain, bi.imageUrl),
          buildCell(bi.assetAddress, false, false, chain),
          buildCell(
              bi.bidAccepted
                  ? lang.subtable1
                  : bi.bidCancelled
                      ? lang.subtable12
                      : lang.subtable2,
              false,
              false,
              chain),
          buildCell(stamp(bi.dateBid), false, false, chain),
        ];
      } else {
        return [
          buildCell(b!.address, false, false, chain),
          buildCell(b.isLimited ? b.allowancePerDay.toString() : lang.subtable3,
              b.isLimited, false, chain),
          buildCell(stamp(b.dateLastWithdrawal), false, false, chain)
        ];
      }
    }

    List<DataRow2> getRows() {
      if (widget.isOwners) {
        return [
          ...widget.owners.map((o) => DataRow2(cells: getCells(o, null, null)))
        ];
      } else if (widget.isBids) {
        return [
          ...widget.bids.map((bi) => DataRow2(cells: getCells(null, null, bi)))
        ];
      } else {
        return [
          ...widget.beneficiaries
              .map((b) => DataRow2(cells: getCells(null, b, null)))
        ];
      }
    }

    List<DataColumn2> getColumns() {
      if (widget.isOwners) {
        return [buildColumn(lang.subtable4)];
      } else if (widget.isBids) {
        return [
          buildColumn(lang.subtable5),
          buildColumn(lang.subtable6),
          buildColumn(lang.subtable7),
          buildColumn(lang.subtable8),
          buildColumn(lang.subtable9)
        ];
      } else {
        return [
          buildColumn(lang.subtable10),
          buildColumn(lang.subtable11),
          buildColumn(lang.subtable13)
        ];
      }
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: DataTable2(
          dataRowHeight: 100,
          headingRowColor:
              WidgetStateColor.resolveWith((states) => Colors.grey[850]!),
          headingTextStyle: const TextStyle(color: Colors.white),
          headingCheckboxTheme: const CheckboxThemeData(
              side: BorderSide(color: Colors.white, width: 2.0)),
          isHorizontalScrollBarVisible: true,
          isVerticalScrollBarVisible: true,
          columnSpacing: 12,
          showCheckboxColumn: false,
          horizontalMargin: 12,
          border: const TableBorder(
              horizontalInside: BorderSide(color: Colors.grey, width: .1)),
          dividerThickness: 0,
          bottomMargin: 10,
          minWidth: 900,
          columns: getColumns(),
          empty: Center(
              child: Container(
                  color: Colors.transparent, child: Text(lang.table30))),
          rows: getRows(),
        ),
      ),
    );
  }
}
