import 'package:flutter/material.dart';

import '../../utils.dart';
import 'search_bar.dart';
import 'explorer_table.dart';

class BridgeTab extends StatefulWidget {
  const BridgeTab({super.key});

  @override
  State<BridgeTab> createState() => _BridgeTabState();
}

class _BridgeTabState extends State<BridgeTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final widthQuery = Utils.widthQuery(context);
    super.build(context);
    return Padding(
        padding: EdgeInsets.only(
            top: 10, left: 12, right: 12, bottom: widthQuery ? 8 : 70),
        child: const Column(children: [
          MySearchBar(
              isTransfers: false,
              isPayment: false,
              isTrust: false,
              isBridge: true,
              isEscrow: false),
          ExplorerTable(
              isTransfers: false,
              isTrust: false,
              isBridge: true,
              isEscrow: false)
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}
