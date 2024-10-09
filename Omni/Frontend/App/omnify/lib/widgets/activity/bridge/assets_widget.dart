// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/bridge_asset.dart';
import '../../../providers/activities/bridge_activity_provider.dart';
import '../../../providers/activities/trust_activity_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils.dart';
import '../../common/nestedScroller.dart';

class BridgeAssetsWidget extends StatefulWidget {
  final ScrollController controller;
  final bool isMigrated;
  final bool isWithdrawn;
  final bool isAvailable;
  const BridgeAssetsWidget(
      {required this.isMigrated,
      required this.isWithdrawn,
      required this.isAvailable,
      required this.controller});

  @override
  State<BridgeAssetsWidget> createState() => _BridgeAssetsWidgetState();
}

class _BridgeAssetsWidgetState extends State<BridgeAssetsWidget> {
  Widget buildAssetTile(BridgeAsset asset, bool widthQuery) => ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: Utils.buildAssetLogoFromUrl(false, asset.imageUrl, true),
      horizontalTitleGap: 10,
      title: Text(
        Utils.removeTrailingZeros(asset.amount.toStringAsFixed(asset.decimals)),
        style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: widthQuery ? 16 : 14),
      ),
      trailing: Text(asset.symbol));

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<BridgeActivityProvider>(context);
    final trustActivityProvider = Provider.of<TrustActivityProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final migratedAssets = provider.migratedAssets;
    final receivedAssets = provider.receivedAssets;
    final withdrawnAssets = trustActivityProvider.withdrawnAssets;
    final availableAssets = trustActivityProvider.availableAssets;
    final list = widget.isWithdrawn
        ? withdrawnAssets
        : widget.isAvailable
            ? availableAssets
            : widget.isMigrated
                ? migratedAssets
                : receivedAssets;
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    return Directionality(
      textDirection: dir,
      child: Container(
          padding: const EdgeInsets.all(8),
          height: widthQuery ? 400 : 350,
          decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(5),
              color: isDark ? Colors.grey[800] : Colors.white),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                widget.isWithdrawn
                    ? lang.trustActivity2
                    : widget.isAvailable
                        ? lang.trustActivity3
                        : widget.isMigrated
                            ? lang.bridgeActivity2
                            : lang.bridgeActivity3,
                style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: widthQuery ? 18 : 16)),
            if (list.isEmpty) const Spacer(),
            if (list.isEmpty)
              Center(
                  child: Text(lang.bridgeActivity4,
                      style: TextStyle(
                          fontStyle: dir == TextDirection.ltr
                              ? FontStyle.italic
                              : FontStyle.normal,
                          fontSize: widthQuery ? 17 : 15,
                          color: isDark ? Colors.white60 : Colors.grey))),
            if (list.isEmpty) const Spacer(),
            if (list.isNotEmpty) const SizedBox(height: 5),
            if (list.isNotEmpty)
              Expanded(
                  child: NestedScroller(
                      controller: widget.controller,
                      child: ListView(children: [
                        ...list.map((e) => buildAssetTile(e, widthQuery))
                      ])))
          ])),
    );
  }
}
