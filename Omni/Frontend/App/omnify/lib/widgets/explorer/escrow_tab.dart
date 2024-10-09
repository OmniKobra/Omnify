import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/escrow_contract.dart';
import '../../providers/explorer_provider.dart';
import '../../utils.dart';
import 'explorer_table.dart';
import 'search_bar.dart';
import 'sub_table.dart';

class EscrowTab extends StatefulWidget {
  const EscrowTab({super.key});

  @override
  State<EscrowTab> createState() => _EscrowTabState();
}

class _EscrowTabState extends State<EscrowTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    final bids = Provider.of<ExplorerProvider>(context).escrowTable.isNotEmpty
        ? Provider.of<ExplorerProvider>(context).escrowTable.first.bids
        : <EscrowBid>[];
    super.build(context);
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MySearchBar(
                isTransfers: false,
                isTrust: false,
                isPayment: false,
                isBridge: false,
                isEscrow: true),
            const ExplorerTable(
                isTransfers: false,
                isTrust: false,
                isBridge: false,
                isEscrow: true),
            const SizedBox(height: 5),
            Text(lang.explorer16,
                style: TextStyle(
                    fontSize: widthQuery ? 21 : 17,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ExplorerSubTable(
              isBids: true,
              isOwners: false,
              owners: const [],
              beneficiaries: const [],
              bids: bids,
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
