import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/fees_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/fees/fee_table.dart';
import '../widgets/network_picker.dart';

class FeesTab extends StatefulWidget {
  const FeesTab({super.key});

  @override
  State<FeesTab> createState() => _FeesTabState();
}

class _FeesTabState extends State<FeesTab> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    Provider.of<FeesProvider>(context, listen: false).setFuture(false, client);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final fees = Provider.of<FeesProvider>(context).getAndSetFeesFuture;
    final client = Provider.of<ThemeProvider>(context).client;
    super.build(context);
    return FutureBuilder(
        future: fees,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const MyLoading();
          }

          if (snap.hasError) {
            return MyError(() {
              setState(() {
                Provider.of<FeesProvider>(context, listen: false)
                    .setFuture(true, client);
              });
            });
          }

          return Container(
              color: isDark ? Colors.black : Colors.grey[50],
              child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    Row(children: [
                      Theme(
                          data: ThemeData(hoverColor: Colors.transparent),
                          child: const NetworkPicker(
                              isExplorer: false,
                              isGovernance: false,
                              isIco: false))
                    ]),
                    const SizedBox(height: 10),
                    const FeeTable(
                        isTransfers: true,
                        isPayments: false,
                        isTrust: false,
                        isBridge: false,
                        isEscrow: false),
                    const FeeTable(
                        isTransfers: false,
                        isPayments: true,
                        isTrust: false,
                        isBridge: false,
                        isEscrow: false),
                    const FeeTable(
                        isTransfers: false,
                        isPayments: false,
                        isTrust: true,
                        isBridge: false,
                        isEscrow: false),
                    const FeeTable(
                        isTransfers: false,
                        isPayments: false,
                        isTrust: false,
                        isBridge: true,
                        isEscrow: false),
                    const FeeTable(
                        isTransfers: false,
                        isPayments: false,
                        isTrust: false,
                        isBridge: false,
                        isEscrow: true),
                    // const FeeTable(
                    //     isTransfers: false,
                    //     isPayments: false,
                    //     isTrust: false,
                    //     isBridge: false,
                    //     isEscrow: false)
                  ]));
        });
  }

  @override
  bool get wantKeepAlive => true;
}
