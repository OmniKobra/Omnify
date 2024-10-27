import 'package:flutter/material.dart';

import '../../utils.dart';
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
    final widthQuery = Utils.widthQuery(context);
    super.build(context);
    return Padding(
        padding: EdgeInsets.only(
            top: 10, left: 12, right: 12, bottom: widthQuery ? 8 : 70),
        child: const Column(
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
