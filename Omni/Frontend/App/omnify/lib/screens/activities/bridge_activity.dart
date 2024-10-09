import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activities/bridge_activity_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../utils.dart';
import '../../widgets/activity/activity_appbar.dart';
import '../../widgets/activity/bridge/assets_widget.dart';
import '../../widgets/activity/bridge/transactions_widget.dart';
import '../../widgets/common/refresh_indicator.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/home/wallet_button.dart';
import '../../widgets/network_picker.dart';

class BridgeActivity extends StatefulWidget {
  const BridgeActivity({super.key});

  @override
  State<BridgeActivity> createState() => _BridgeActivityState();
}

class _BridgeActivityState extends State<BridgeActivity> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    var activity = Provider.of<BridgeActivityProvider>(context, listen: false);
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
    final dir = theme.textDirection;
    final isDark = theme.isDark;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    var activity = Provider.of<BridgeActivityProvider>(context, listen: false);
    var c = activity.currentChain;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final address = wallet.getAddressString(c);
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    return SelectionArea(
      child: Scaffold(
          body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                  child: Column(children: [
                ActivityAppBar(lang.bridgeActivity1),
                Expanded(
                    child: FutureBuilder(
                        future: Provider.of<BridgeActivityProvider>(context)
                            .fetchBridgeProfile,
                        builder: (ctx, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const MyLoading();
                          }
                          if (snap.hasError) {
                            return MyError(() {
                              Provider.of<BridgeActivityProvider>(context,
                                      listen: false)
                                  .setFuture(c, address, true, client);
                            });
                          }
                          return MyRefresh(
                            onRefresh: () async {
                              Provider.of<BridgeActivityProvider>(context,
                                      listen: false)
                                  .setFuture(c, address, true, client);
                            },
                            child: ListView(
                                controller: controller,
                                padding: const EdgeInsets.all(8.0),
                                children: [
                                  Directionality(
                                      textDirection: dir,
                                      child: Row(children: [
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
                                                isTransferActivity: false,
                                                isPaymentActivity: false,
                                                isTrustActivity: false,
                                                isBridgeActivity: true,
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
                                      ])),
                                  const SizedBox(height: 5),
                                  if (widthQuery)
                                    Row(children: [
                                      Expanded(
                                          child: BridgeAssetsWidget(
                                              isWithdrawn: false,
                                              isAvailable: false,
                                              isMigrated: true,
                                              controller: controller)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: BridgeAssetsWidget(
                                              isWithdrawn: false,
                                              isAvailable: false,
                                              isMigrated: false,
                                              controller: controller))
                                    ]),
                                  if (!widthQuery)
                                    BridgeAssetsWidget(
                                        isWithdrawn: false,
                                        isAvailable: false,
                                        isMigrated: true,
                                        controller: controller),
                                  const SizedBox(height: 5),
                                  if (!widthQuery)
                                    BridgeAssetsWidget(
                                        isWithdrawn: false,
                                        isAvailable: false,
                                        isMigrated: false,
                                        controller: controller),
                                  const SizedBox(height: 5),
                                  if (widthQuery)
                                    Row(children: [
                                      Expanded(
                                          child: BridgeTransactionsWidget(
                                              controller))
                                    ]),
                                  if (!widthQuery)
                                    BridgeTransactionsWidget(controller)
                                ]),
                          );
                        }))
              ])))),
    );
  }
}
