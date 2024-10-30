// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:omnify/providers/fees_provider.dart';
import 'package:omnify/providers/governance_provider.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../../utils.dart';
import '../languages/app_language.dart';
import '../providers/wallet_provider.dart';
import '../providers/explorer_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/ico_provider.dart';

class NetworkPicker extends StatefulWidget {
  final bool isExplorer;
  final bool isGovernance;
  final bool isIco;
  const NetworkPicker(
      {required this.isExplorer,
      required this.isGovernance,
      required this.isIco});

  @override
  State<NetworkPicker> createState() => _NetworkPickerState();
}

class _NetworkPickerState extends State<NetworkPicker> {
  DropdownMenuItem<Chain> buildLangButtonItem(
          Chain value,
          void Function(Chain, AppLanguage, Web3Client) setNetwork,
          AppLanguage lang,
          bool widthQuery,
          bool isDark) =>
      DropdownMenuItem<Chain>(
        value: value,
        onTap: () {
          Provider.of<ThemeProvider>(context, listen: false)
              .setStartingChain(value, context);
          if (widget.isGovernance || widget.isIco) {
            final theme = Provider.of<ThemeProvider>(context, listen: false);
            final client = theme.client;
            final wallet = Provider.of<WalletProvider>(context, listen: false);
            final walletAddress = wallet.getAddressString(value);
            if (widget.isIco) {
              Provider.of<IcoProvider>(context, listen: false)
                  .setChain(value, lang, client, walletAddress, true);
            }
            if (wallet.isWalletConnected) {
              if (widget.isGovernance) {
                Provider.of<GovernanceProvider>(context, listen: false)
                    .setChain(value, lang, client, walletAddress, true);
              }
            }
          }
        },
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Utils.buildNetworkLogo(widthQuery, value, true),
              const SizedBox(width: 7.5),
              Text(value.name,
                  style: TextStyle(
                      color: widget.isExplorer
                          ? Colors.white70
                          : isDark
                              ? Colors.white70
                              : Colors.black,
                      fontSize: widthQuery ? 17 : 15))
            ]),
      );

  Widget buildNetworkPicker(
      Chain current,
      bool isDark,
      bool widthQuery,
      void Function(Chain, AppLanguage, Web3Client) setNetwork,
      AppLanguage lang,
      List<Chain> supportedChains) {
    return DropdownButton(
        dropdownColor: widget.isExplorer
            ? Colors.black
            : isDark
                ? Colors.black
                : Colors.white,
        // key: UniqueKey(),
        elevation: 8,
        menuMaxHeight: widthQuery ? 400 : 300,
        onChanged: supportedChains.isEmpty ? null : (_) => setState(() {}),
        underline: Container(color: Colors.transparent),
        icon: Icon(Icons.arrow_drop_down,
            color: widget.isExplorer
                ? Colors.white70
                : isDark
                    ? Colors.white70
                    : Colors.black),
        value: current,
        items: supportedChains
            .map((c) =>
                buildLangButtonItem(c, setNetwork, lang, widthQuery, isDark))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final explorerChain = Provider.of<ExplorerProvider>(context).currentChain;
    final feesChain = Provider.of<FeesProvider>(context).currentChain;
    final icoChain = Provider.of<IcoProvider>(context).currentChain;
    final governanceChain =
        Provider.of<GovernanceProvider>(context).currentChain;
    final explorerHandler =
        Provider.of<ExplorerProvider>(context, listen: false).setCurrentChain;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final feesHandler =
        Provider.of<FeesProvider>(context, listen: false).setChain;
    final supportedChains =
        Provider.of<WalletProvider>(context).supportedChains;

    Chain getChain() {
      if (widget.isExplorer) {
        return explorerChain;
      }
      if (widget.isGovernance) {
        return governanceChain;
      }
      if (widget.isIco) {
        return icoChain;
      }
      return feesChain;
    }

    void Function(Chain, AppLanguage, Web3Client) getHandler() {
      if (widget.isExplorer) {
        return explorerHandler;
      }
      if (widget.isGovernance) {
        return Provider.of<GovernanceProvider>(context, listen: false).setChain;
      }
      if (widget.isIco) {
        return Provider.of<IcoProvider>(context, listen: false).setChain;
      }

      return feesHandler;
    }

    return buildNetworkPicker(
        getChain(), isDark, widthQuery, getHandler(), lang, supportedChains);
  }
}
