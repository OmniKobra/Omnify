import 'package:flutter/material.dart';

import 'search_bar.dart';
import 'explorer_table.dart';

class TransfersTab extends StatefulWidget {
  const TransfersTab({super.key});

  @override
  State<TransfersTab> createState() => _TransfersTabState();
}

class _TransfersTabState extends State<TransfersTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Padding(
        padding: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 8),
        child: Column(
          children: [
            MySearchBar(
                isTransfers: true,
                isTrust: false,
                isPayment: false,
                isBridge: false,
                isEscrow: false),
            ExplorerTable(
                isTransfers: true,
                isTrust: false,
                isBridge: false,
                isEscrow: false),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
