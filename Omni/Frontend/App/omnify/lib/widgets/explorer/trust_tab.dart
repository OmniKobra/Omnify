import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/explorer_trust.dart';
import '../../providers/explorer_provider.dart';
import '../../utils.dart';
import 'explorer_table.dart';
import 'search_bar.dart';
import 'sub_table.dart';

class TrustTab extends StatefulWidget {
  const TrustTab({super.key});

  @override
  State<TrustTab> createState() => _TrustTabState();
}

class _TrustTabState extends State<TrustTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    final trustTable = Provider.of<ExplorerProvider>(context).trustTable;
    final beneficiaries = trustTable.isNotEmpty
        ? trustTable.first.beneficiaries.isNotEmpty
            ? trustTable.first.beneficiaries
            : <Beneficiary>[]
        : <Beneficiary>[];
    final owners = trustTable.isNotEmpty
        ? trustTable.first.owners.isNotEmpty
            ? trustTable.first.owners
            : <String>[]
        : <String>[];
    super.build(context);
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MySearchBar(
                isTransfers: false,
                isPayment: false,
                isTrust: true,
                isBridge: false,
                isEscrow: false),
            const ExplorerTable(
                isTransfers: false,
                isTrust: true,
                isBridge: false,
                isEscrow: false),
            const SizedBox(height: 5),
            Text(lang.explorer18,
                style: TextStyle(
                    fontSize: widthQuery ? 21 : 17,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ExplorerSubTable(
              isBids: false,
              isOwners: false,
              owners: const [],
              beneficiaries: beneficiaries,
              bids: const [],
            ),
            const SizedBox(height: 5),
            Text(lang.explorer17,
                style: TextStyle(
                    fontSize: widthQuery ? 21 : 17,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ExplorerSubTable(
              isBids: false,
              isOwners: true,
              owners: owners,
              beneficiaries: const [],
              bids: const [],
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
