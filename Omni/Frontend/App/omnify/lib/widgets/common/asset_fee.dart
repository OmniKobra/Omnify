import 'package:decimal/decimal.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../providers/theme_provider.dart';
import '../../models/asset.dart';
import '../../utils.dart';

class AssetFee extends StatefulWidget {
  final Chain currentChain;
  final bool isSpecialCase;
  final CryptoAsset asset;
  final Decimal amount;
  final bool? isBridgeTarget;
  const AssetFee(
      {super.key,
      required this.currentChain,
      required this.asset,
      required this.amount,
      required this.isSpecialCase,
      this.isBridgeTarget});

  @override
  State<AssetFee> createState() => _AssetFeeState();
}

class _AssetFeeState extends State<AssetFee> {
  Widget buildSpecialFee(String label, bool widthQuery, bool isDark) {
    return widthQuery
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
            height: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white60 : Colors.grey)),
                const SizedBox(height: 7),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Utils.buildAssetLogo(
                            widthQuery, widget.asset, true, true)),
                    const SizedBox(width: 10),
                    Text(
                        widget.asset.decimals == 0
                            ? widget.amount.toStringAsFixed(0)
                            : Utils.removeTrailingZeros(widget.amount
                                .toStringAsFixed(widget.asset.decimals)),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))
                  ],
                ),
              ],
            ))
        : Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 13.25,
                      color: isDark ? Colors.white60 : Colors.grey)),
              Expanded(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          child: Utils.buildAssetLogo(
                              widthQuery, widget.asset, true, true)),
                      const SizedBox(width: 5),
                      Text(
                          widget.asset.decimals == 0
                              ? widget.amount.toStringAsFixed(0)
                              : Utils.removeTrailingZeros(widget.amount
                                  .toStringAsFixed(widget.asset.decimals)),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14))
                    ]),
              )
            ],
          );
  }

  Widget buildFee(String label, bool widthQuery, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13.25, color: isDark ? Colors.white60 : Colors.grey)),
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  child: Utils.buildAssetLogo(
                      widthQuery, widget.asset, true, true)),
              const SizedBox(width: 5),
              Text(
                  widget.asset.decimals == 0
                      ? widget.amount.toStringAsFixed(0)
                      : Utils.removeTrailingZeros(
                          widget.amount.toStringAsFixed(widget.asset.decimals)),
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14))
            ])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final widthQuery = Utils.widthQuery(context);
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final lang = Utils.language(context);
    return widget.isSpecialCase
        ? buildSpecialFee(
            widget.isBridgeTarget != null
                ? lang.bridge6
                : lang.transferActivity9,
            widthQuery,
            isDark)
        : buildFee(
            widget.isBridgeTarget != null
                ? lang.bridge6
                : lang.transferActivity9,
            widthQuery,
            isDark);
  }
}
