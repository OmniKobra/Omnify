import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/beneficiary.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/trusts_provider.dart';
import '../../utils.dart';
import 'trust_sheet.dart';

class TrustTable extends StatefulWidget {
  final bool isOwners;
  final List<Beneficiary> beneficiaries;
  final bool isModification;
  final int decimals;
  final void Function(Beneficiary)? removeBeneficiaryHandler;
  final void Function(Beneficiary, Beneficiary)? modifyBeneficiaryHandler;
  const TrustTable(
      {super.key,
      required this.isOwners,
      required this.beneficiaries,
      required this.removeBeneficiaryHandler,
      required this.isModification,
      required this.decimals,
      required this.modifyBeneficiaryHandler});

  @override
  State<TrustTable> createState() => _TrustTableState();
}

class _TrustTableState extends State<TrustTable> {
  DataColumn2 buildColumn(String label) =>
      DataColumn2(label: Text(label), size: ColumnSize.S);

  @override
  Widget build(BuildContext context) {
    final trust = Provider.of<TrustsProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final beneficiaries =
        widget.isModification ? widget.beneficiaries : trust.beneficiaries;
    final owners = trust.owners;
    final myAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(trust.currentChain);
    final lang = Utils.language(context);
    DataCell buildCell(String content) => DataCell(Text(content));
    DataCell buildActionCell(
            String content, Beneficiary? b, String? owner, String myAddress) =>
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.isOwners)
              IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    showModalBottomSheet(
                        context: context,
                        enableDrag: false,
                        useSafeArea: true,
                        constraints:
                            const BoxConstraints(maxHeight: double.infinity),
                        scrollControlDisabledMaxHeightRatio: 1,
                        backgroundColor:
                            isDark ? Colors.grey[800] : Colors.white,
                        builder: (_) {
                          return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: isDark
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade300),
                                  color:
                                      isDark ? Colors.grey[800] : Colors.white),
                              child: TrustSheet(
                                  isBeneficiary: true,
                                  isModification: widget.isModification,
                                  addBeneficiaryHandler: (_) {},
                                  isModifyBeneficiary: true,
                                  beneficiaryToModify: b,
                                  decimals: widget.decimals,
                                  modifyModificationBeneficiary:
                                      widget.isModification
                                          ? widget.modifyBeneficiaryHandler!
                                          : Provider.of<TrustsProvider>(context,
                                                  listen: false)
                                              .modifyBeneficiary));
                        });
                  },
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(Icons.edit_rounded,
                      color: isDark
                          ? Colors.white60
                          : Theme.of(context).colorScheme.secondary)),
            if (widget.isOwners && owner != myAddress || !widget.isOwners)
              IconButton(
                  onPressed: () {
                    if (widget.isOwners) {
                      Provider.of<TrustsProvider>(context, listen: false)
                          .removeOwner(owner!);
                    } else {
                      if (widget.isModification) {
                        widget.removeBeneficiaryHandler!(b!);
                      } else {
                        Provider.of<TrustsProvider>(context, listen: false)
                            .removeBeneficiary(b!);
                      }
                    }
                  },
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(Icons.remove_circle,
                      color: isDark ? Colors.white60 : Colors.red)),
            Expanded(child: Text(content)),
          ],
        ));
    List<DataCell> getCells(Beneficiary? b, String? owner) {
      if (widget.isOwners) {
        return [buildActionCell(owner!, null, owner, myAddress)];
      } else {
        return [
          buildActionCell(b!.address, b, null, myAddress),
          buildCell(b.isLimited
              ? Utils.removeTrailingZeros(
                  b.allowancePerDay.toStringAsFixed(widget.decimals))
              : lang.trust24),
        ];
      }
    }

    List<DataRow2> getRows() {
      if (widget.isOwners) {
        return [...owners.map((e) => DataRow2(cells: getCells(null, e)))];
      } else {
        return [
          ...beneficiaries.map((e) => DataRow2(cells: getCells(e, null)))
        ];
      }
    }

    List<DataColumn2> getColumns() {
      if (widget.isOwners) {
        return [buildColumn(lang.trust21)];
      } else {
        return [buildColumn(lang.trust21), buildColumn(lang.trust25)];
      }
    }

    return SizedBox(
      height: 250,
      width: double.infinity,
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
          columnSpacing: 10,
          showCheckboxColumn: false,
          horizontalMargin: 10,
          border: const TableBorder(
              horizontalInside: BorderSide(color: Colors.grey, width: .1)),
          dividerThickness: 0,
          bottomMargin: 10,
          minWidth: widget.isOwners ? 220 : 600,
          dataRowHeight: 100,
          columns: getColumns(),
          empty: Center(
              child: Container(
                  color: Colors.transparent,
                  child: widget.isOwners
                      ? Text(lang.trust17,
                          style: const TextStyle(fontStyle: FontStyle.italic))
                      : Text(lang.trust15,
                          style:
                              const TextStyle(fontStyle: FontStyle.italic)))),
          rows: getRows(),
        ),
      ),
    );
  }
}
