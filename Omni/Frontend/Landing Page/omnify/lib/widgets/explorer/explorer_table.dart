// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/explorer_transfer.dart';
import '../../models/explorer_payment.dart';
import '../../models/explorer_trust.dart';
import '../../models/explorer_bridge.dart';
import '../../models/explorer_escrow.dart';
import '../../providers/explorer_provider.dart';
import '../../providers/theme_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../utils.dart';

class ExplorerTable extends StatefulWidget {
  final bool isTransfers;
  final bool isTrust;
  final bool isBridge;
  final bool isEscrow;
  const ExplorerTable(
      {required this.isTransfers,
      required this.isTrust,
      required this.isBridge,
      required this.isEscrow});

  @override
  State<ExplorerTable> createState() => _ExplorerTableState();
}

class _ExplorerTableState extends State<ExplorerTable> {
  DataColumn2 buildColumn(String label) =>
      DataColumn2(label: Text(label), size: ColumnSize.S);
  @override
  Widget build(BuildContext context) {
    final explorer = Provider.of<ExplorerProvider>(context);
    final widthQuery = Utils.widthQuery(context);
    final chain = explorer.currentChain;
    final theme = Provider.of<ThemeProvider>(context);
    final langCode = theme.langCode;
    final transfers = explorer.transferTable;
    final payments = explorer.paymentTable;
    final trust = explorer.trustTable;
    final bridge = explorer.bridgeTable;
    final escrows = explorer.escrowTable;
    final lang = Utils.language(context);
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
    List<DataCell> getCells(ExplorerTransfer? t, ExplorerPayment? p,
        ExplorerTrust? tr, ExplorerBridge? b, ExplorerEscrow? e) {
      if (widget.isTransfers) {
        return [
          buildCell(t!.sender, false, false, chain),
          buildCell(t.recipient, false, false, chain),
          buildCell(t.asset.address, false, false, chain),
          buildCell(t.amount.toString(), true, false, chain, t.asset.logoUrl),
          buildCell(stamp(t.date), false, false, chain),
          // buildCell(t.status, false, false, chain),
          buildCell(t.id, false, false, chain),
        ];
      } else if (widget.isTrust) {
        return [
          buildCell(tr!.depositor, false, false, chain),
          buildCell(tr.asset.address, false, false, chain),
          buildCell(tr.amount.toString(), true, false, chain, tr.asset.logoUrl),
          buildCell(stamp(tr.date), false, false, chain),
          // buildCell(tr.status, false, false, chain),
          buildCell(tr.id, false, false, chain),
        ];
      } else if (widget.isBridge) {
        return [
          buildCell(b!.id, false, false, chain),
          buildCell(b.asset.address, false, false, chain),
          buildCell(b.amount.toString(), false, false, chain, b.asset.logoUrl),
          buildCell(b.sourceChain.name, true, true, b.sourceChain),
          buildCell(b.sourceAddress, false, false, chain),
          buildCell(b.destinationChain.name, true, true, b.destinationChain),
          buildCell(b.destinationAddress, false, false, chain),
          buildCell(stamp(b.date), false, false, chain),
        ];
      } else if (widget.isEscrow) {
        return [
          buildCell(e!.id, false, false, chain),
          buildCell(e.owner, false, false, chain),
          buildCell(e.amount.toString(), true, false, chain, e.asset.logoUrl),
          buildCell(e.asset.address, false, false, chain),
          buildCell(
              e.isDeleted
                  ? lang.table36
                  : e.isCompleted
                      ? lang.table37
                      : lang.table38,
              false,
              false,
              chain),
          buildCell(stamp(e.date), false, false, chain),
        ];
      } else {
        return [
          buildCell(p!.payer, false, false, chain),
          buildCell(p.amount.toString(), true, false, chain),
          // buildCell(p.status, false, false, chain),
          buildCell(p.recipient, false, false, chain),
          buildCell(stamp(p.date), false, false, chain),
        ];
      }
    }

    List<DataRow2> getRows() {
      if (widget.isTransfers) {
        return [
          ...transfers
              .map((t) => DataRow2(cells: getCells(t, null, null, null, null)))
        ];
      } else if (widget.isTrust) {
        return [
          ...trust.map(
              (tr) => DataRow2(cells: getCells(null, null, tr, null, null)))
        ];
      } else if (widget.isBridge) {
        return [
          ...bridge
              .map((b) => DataRow2(cells: getCells(null, null, null, b, null)))
        ];
      } else if (widget.isEscrow) {
        return [
          ...escrows
              .map((e) => DataRow2(cells: getCells(null, null, null, null, e)))
        ];
      } else {
        return [
          ...payments
              .map((p) => DataRow2(cells: getCells(null, p, null, null, null)))
        ];
      }
    }

    List<DataColumn2> getColumns() {
      if (widget.isTransfers) {
        return [
          buildColumn(lang.table42),
          buildColumn(lang.table0),
          buildColumn(lang.table41),
          buildColumn(lang.table1),
          buildColumn(lang.table2),
          // buildColumn(lang.table4),
          buildColumn(lang.table6)
        ];
      } else if (widget.isTrust) {
        return [
          buildColumn(lang.table7),
          buildColumn(lang.table41),
          buildColumn(lang.table8),
          buildColumn(lang.table9),
          // buildColumn(lang.table12),
          buildColumn(lang.table13)
        ];
      } else if (widget.isBridge) {
        return [
          buildColumn(lang.table13),
          buildColumn(lang.table41),
          buildColumn(lang.table31),
          buildColumn(lang.table32),
          buildColumn(lang.table33),
          buildColumn(lang.table34),
          buildColumn(lang.table35),
          buildColumn(lang.table16),
        ];
      } else if (widget.isEscrow) {
        return [
          buildColumn(lang.explorerHint3),
          buildColumn(lang.table39),
          buildColumn(lang.table40),
          buildColumn(lang.table41),
          buildColumn(lang.table22),
          buildColumn(lang.table16),
        ];
      } else {
        return [
          buildColumn(lang.table25),
          buildColumn(lang.table26),
          // buildColumn(lang.table27),
          buildColumn(lang.table28),
          buildColumn(lang.table29),
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
          minWidth: widget.isBridge ? 1200 : 1100,
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

// 202409172228446092970x06c90b3d5d75372a2b99f2acdcbebc728bb03e9f - usdc transfer
// 202409172223484832210x06c90b3d5d75372a2b99f2acdcbebc728bb03e9f - avax transfer
// 202409301146102860x45ddd25f6b07bd4fb32ee81f614d8b3a3166c977 - fuji payment
// 202409271211488320x06c90b3d5d75372a2b99f2acdcbebc728bb03e9f - avax trust
// 202409262159541330x06c90b3d5d75372a2b99f2acdcbebc728bb03e9f - usdc trust
// 22 - bridge usdc
// 202409292023356840x06c90b3d5d75372a2b99f2acdcbebc728bb03e9f - usdc escrow / avax bid
// 202409300042141829200x06c90b3d5d75372a2b99f2acdcbebc728bb03e9f - avax escrow / usdc bid
