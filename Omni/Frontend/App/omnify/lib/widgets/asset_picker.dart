// ignore_for_file: use_key_in_widget_constructors, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/asset.dart';
import '../providers/activities/transfer_activity_provider.dart';
import '../providers/bridges_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/trusts_provider.dart';
import '../providers/wallet_provider.dart';
import '../utils.dart';

class AssetPicker extends StatefulWidget {
  final bool isTransfers;
  final CryptoAsset? currentAsset;
  final void Function(CryptoAsset) changeCurrentAsset;
  final bool isTrust;
  final bool isBridgeSource;
  final bool isTransferActivity;
  final bool isJustDisplaying;
  const AssetPicker(
      {required this.isTransfers,
      required this.currentAsset,
      required this.changeCurrentAsset,
      required this.isTrust,
      required this.isBridgeSource,
      required this.isTransferActivity,
      required this.isJustDisplaying});

  @override
  State<AssetPicker> createState() => _AssetPickerState();
}

class _AssetPickerState extends State<AssetPicker> {
  DropdownMenuItem<String> buildLangButtonItem(
          CryptoAsset value,
          dynamic setAsset,
          bool widthQuery,
          bool isDark,
          CryptoAsset current) =>
      DropdownMenuItem<String>(
        value: value.address,
        onTap: () {
          if (value.address != current.address) {
            if (widget.isBridgeSource) {
              var theme = Provider.of<ThemeProvider>(context, listen: false);
              setAsset(value, theme.client, theme.walletClient);
            } else {
              setAsset(value);
            }
          }
        },
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Utils.buildAssetLogo(widthQuery, value, true),
              const SizedBox(width: 7.5),
              Text("\$${value.symbol}",
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black,
                      fontSize: widthQuery ? 17 : 15))
            ]),
      );
  Widget buildAssetPicker(CryptoAsset current, bool isDark, bool widthQuery,
          dynamic setAsset, List<CryptoAsset> assets) =>
      DropdownButton(
          dropdownColor: isDark ? Colors.black : Colors.white,
          elevation: 8,
          menuMaxHeight: widthQuery ? 500 : 450,
          onChanged: widget.isJustDisplaying ? null : (_) => setState(() {}),
          underline: Container(color: Colors.transparent),
          icon: Icon(Icons.arrow_drop_down,
              color: widget.isJustDisplaying
                  ? Colors.transparent
                  : isDark
                      ? Colors.white70
                      : Colors.black),
          value: current.address,
          items: [
            ...assets
                .map((a) => buildLangButtonItem(
                    a, setAsset, widthQuery, isDark, current))
                .toList()
          ]);
  dynamic getHandler() {
    if (widget.isTransfers) {
      return widget.changeCurrentAsset;
    }
    if (widget.isTrust) {
      return Provider.of<TrustsProvider>(context, listen: false)
          .setCurrentAsset;
    }
    if (widget.isBridgeSource) {
      return Provider.of<BridgesProvider>(context, listen: false)
          .setSourceAsset;
    }
    if (widget.isTransferActivity) {
      return Provider.of<TransferActivityProvider>(context, listen: false)
          .setCurrentAsset;
    }
    return widget.changeCurrentAsset;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final widthQuery = Utils.widthQuery(context);

    List<CryptoAsset> assets = [
      ...Provider.of<WalletProvider>(context).myAssets
    ];
    if (!widget.isTransfers &&
        !widget.isTrust &&
        !widget.isBridgeSource &&
        !widget.isTransferActivity &&
        !widget.isJustDisplaying) {
      final index =
          assets.indexWhere((a) => a.address == widget.currentAsset!.address);

      assets[index] = widget.currentAsset!;
    }
    if (widget.isBridgeSource) {
      assets.removeWhere((a) => a.address == Utils.zeroAddress);
      if (!assets.any((a) =>
          a.address ==
          Provider.of<BridgesProvider>(context, listen: false)
              .currentSourceAsset
              .address)) {
        assets.add(Provider.of<BridgesProvider>(context, listen: false)
            .currentSourceAsset);
      }
    }
    if (widget.isJustDisplaying) {
      assets = [widget.currentAsset!];
    }
    if (widget.isTransferActivity) {
      assets = Provider.of<TransferActivityProvider>(context, listen: false)
          .getTransactionAssets();
    }

    CryptoAsset getCurrentAsset() {
      if (widget.isTransfers) {
        return widget.currentAsset!;
      }
      if (widget.isTrust) {
        return Provider.of<TrustsProvider>(context).currentAsset;
      }
      if (widget.isBridgeSource) {
        return Provider.of<BridgesProvider>(context).currentSourceAsset;
      }
      if (widget.isTransferActivity) {
        return Provider.of<TransferActivityProvider>(context).currentAsset;
      }
      return widget.currentAsset!;
    }

    return buildAssetPicker(
        getCurrentAsset(), isDark, widthQuery, getHandler(), assets);
  }
}
