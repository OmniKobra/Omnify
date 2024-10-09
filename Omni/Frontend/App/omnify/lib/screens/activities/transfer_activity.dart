import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activities/transfer_activity_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../utils.dart';
import '../../widgets/common/refresh_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/activity/activity_appbar.dart';
import '../../widgets/activity/transfers/transfer_chart.dart';
import '../../widgets/activity/transfers/transfer_pie.dart';
import '../../widgets/activity/transfers/transfers_table.dart';
import '../../widgets/asset_picker.dart';
import '../../widgets/home/wallet_button.dart';
import '../../widgets/network_picker.dart';

class TransferActivity extends StatefulWidget {
  const TransferActivity({super.key});

  @override
  State<TransferActivity> createState() => _TransferActivityState();
}

class _TransferActivityState extends State<TransferActivity> {
  final controller = ScrollController();
  Widget buildStat(IconData icon, Color iconColor, String title, int value,
      bool isDark, bool widthQuery) {
    return Container(
        height: widthQuery ? 400 : null,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon,
                color: isDark ? Colors.white60 : iconColor,
                size: widthQuery ? 80 : 45),
            SizedBox(height: widthQuery ? 10 : 5),
            Center(
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: widthQuery ? 18 : 16)),
            ),
            const SizedBox(height: 2.5),
            Center(
                child: Text(value.toString(),
                    style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: widthQuery ? 17 : 14))),
          ],
        ));
  }

  Widget buildChartWidget(bool isDark, bool widthQuery, String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 400,
      decoration: BoxDecoration(
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5),
          color: isDark ? Colors.grey[800] : Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AssetPicker(
              isTransfers: false,
              currentAsset: null,
              changeCurrentAsset: (_) {},
              isTrust: false,
              isBridgeSource: false,
              isTransferActivity: true,
              isJustDisplaying: false),
          const Expanded(
              child: Row(children: [Expanded(child: TransferChart())]))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var activity =
        Provider.of<TransferActivityProvider>(context, listen: false);
    var c = activity.currentChain;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final address = wallet.getAddressString(c);
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    if (wallet.isWalletConnected) {
      activity.setFuture(c, address, false, client);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final client = theme.client;
    final activityProvider = Provider.of<TransferActivityProvider>(context);
    var c = activityProvider.currentChain;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final address = wallet.getAddressString(c);
    final fetchProfile = activityProvider.fetchTransferProfile;
    final sentNum = activityProvider.sentNum;
    final receivedNum = activityProvider.receivedNum;
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    return SelectionArea(
      child: Scaffold(
          body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                  child: Column(children: [
                ActivityAppBar(lang.transferActivity1),
                Expanded(
                    child: Directionality(
                        textDirection: dir,
                        child: FutureBuilder(
                            future: fetchProfile,
                            builder: (ctx, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return const MyLoading();
                              }
                              if (snap.hasError) {
                                return MyError(() {
                                  Provider.of<TransferActivityProvider>(context,
                                          listen: false)
                                      .setFuture(c, address, true, client);
                                });
                              }
                              return MyRefresh(
                                onRefresh: () async {
                                  Provider.of<TransferActivityProvider>(context,
                                          listen: false)
                                      .setFuture(c, address, true, client);
                                },
                                child: ListView(
                                  controller: controller,
                                  padding: const EdgeInsets.all(8.0),
                                  children: [
                                    Row(children: [
                                      Container(
                                          padding: widthQuery
                                              ? const EdgeInsets.all(8)
                                              : const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                          decoration: BoxDecoration(
                                              border: border,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: isDark
                                                  ? Colors.grey[800]
                                                  : Colors.white),
                                          child: const NetworkPicker(
                                              isExplorer: false,
                                              isTransfers: false,
                                              isPayments: false,
                                              isTrust: false,
                                              isBridgeSource: false,
                                              isBridgeTarget: false,
                                              isEscrow: false,
                                              isTransferActivity: true,
                                              isPaymentActivity: false,
                                              isTrustActivity: false,
                                              isBridgeActivity: false,
                                              isEscrowActivity: false,
                                              isTransactions: false,
                                              isDiscoverTransfers: false,
                                              isDiscoverPayments: false,
                                              isDiscoverTrust: false,
                                              isDiscoverBridges: false,
                                              isDiscoverEscrow: false)),
                                      const SizedBox(width: 5),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 8,
                                              right: 8,
                                              left: 8,
                                              bottom: 8),
                                          child: const WalletButton())
                                    ]),
                                    const SizedBox(height: 5),
                                    if (!widthQuery)
                                      Row(
                                        children: [
                                          Expanded(
                                              child: buildStat(
                                                  Icons.call_made,
                                                  Colors.red,
                                                  lang.transferActivity2,
                                                  sentNum,
                                                  isDark,
                                                  widthQuery)),
                                          const SizedBox(width: 5),
                                          Expanded(
                                              child: buildStat(
                                                  Icons.call_received,
                                                  Colors.green,
                                                  lang.transferActivity3,
                                                  receivedNum,
                                                  isDark,
                                                  widthQuery)),
                                        ],
                                      ),
                                    if (!widthQuery) const SizedBox(height: 5),
                                    if (!widthQuery)
                                      buildChartWidget(isDark, widthQuery,
                                          lang.transferActivity5),
                                    if (!widthQuery) const SizedBox(height: 5),
                                    if (!widthQuery) const TransferPieChart(),
                                    if (!widthQuery) const SizedBox(height: 5),
                                    if (!widthQuery) TransferTable(controller),
                                    if (widthQuery)
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 3,
                                              child: buildChartWidget(
                                                  isDark,
                                                  widthQuery,
                                                  "${lang.transferActivity4} $sentNum")),
                                          const SizedBox(width: 5),
                                          Expanded(
                                              flex: 1,
                                              child: buildStat(
                                                  Icons.call_made,
                                                  Colors.red,
                                                  lang.transferActivity2,
                                                  sentNum,
                                                  isDark,
                                                  widthQuery)),
                                          const SizedBox(width: 5),
                                          Expanded(
                                              flex: 1,
                                              child: buildStat(
                                                  Icons.call_received,
                                                  Colors.green,
                                                  lang.transferActivity3,
                                                  receivedNum,
                                                  isDark,
                                                  widthQuery)),
                                        ],
                                      ),
                                    if (widthQuery) const SizedBox(height: 5),
                                    if (widthQuery)
                                      Row(children: [
                                        Expanded(
                                            child: TransferTable(controller)),
                                        const SizedBox(width: 5),
                                        const TransferPieChart()
                                      ])
                                  ],
                                ),
                              );
                            })))
              ])))),
    );
  }
}
