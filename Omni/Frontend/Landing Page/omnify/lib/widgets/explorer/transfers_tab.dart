import 'package:flutter/material.dart';

import '../../utils.dart';
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
    final widthQuery = Utils.widthQuery(context);
    super.build(context);
    return Padding(
        padding: EdgeInsets.only(
            top: 10, left: 12, right: 12, bottom: widthQuery ? 8 : 70),
        child: const Column(
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
