import 'package:flutter/material.dart';

import 'search_bar.dart';
import 'explorer_table.dart';

class PaymentsTab extends StatefulWidget {
  const PaymentsTab({super.key});

  @override
  State<PaymentsTab> createState() => _PaymentsTabState();
}

class _PaymentsTabState extends State<PaymentsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Padding(
        padding: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 8),
        child: Column(
          children: [
            MySearchBar(
                isTransfers: false,
                isTrust: false,
                isPayment: true,
                isBridge: false,
                isEscrow: false),
            ExplorerTable(
                isTransfers: false,
                isTrust: false,
                isBridge: false,
                isEscrow: false)
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
