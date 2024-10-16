import 'package:flutter/material.dart';
import 'package:omnify/providers/governance_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../providers/home_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/wallet_provider.dart';
import '../routes.dart';
import '../utils.dart';

class MyFab extends StatefulWidget {
  const MyFab({super.key});

  @override
  State<MyFab> createState() => _MyFabState();
}

class _MyFabState extends State<MyFab> {
  Widget buildButton(IconData icon, String label, Color primaryColor,
          bool widthQuery, bool isDark, bool walletConnected) =>
      Container(
          margin: const EdgeInsets.only(left: 5, right: 0, top: 5, bottom: 5),
          child: TextButton(
              onPressed: () {
                if (icon == Icons.wallet) {
                  if (walletConnected) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .disconnectWallet(
                            context,
                            false,
                            Provider.of<WalletProvider>(context, listen: false)
                                .disconnectWallet);
                  } else {
                    Provider.of<WalletProvider>(context, listen: false)
                        .connectWallet(context);
                  }
                }
                if (icon == Icons.add_box_rounded) {
                  Navigator.pushNamed(context, Routes.proposal);
                }
                if (icon == Icons.launch) {
                  launchUrlString("https://app.omnify.finance");
                }
              },
              style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                  elevation: WidgetStatePropertyAll(10),
                  overlayColor: WidgetStatePropertyAll(Colors.transparent)),
              child: Container(
                  height: widthQuery ? 45 : 30,
                  width: widthQuery ? 150 : 120,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.rectangle,
                      borderRadius:
                          BorderRadius.circular(widthQuery ? 15 : 10)),
                  child: Center(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(icon, size: widthQuery ? 22 : 18, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(label,
                        style: TextStyle(
                            fontSize: widthQuery ? 15 : 13,
                            color: Colors.white))
                  ])))));

  @override
  Widget build(BuildContext context) {
    final shares = Provider.of<GovernanceProvider>(context).yourShares;
    final tabView = Provider.of<HomeProvider>(context).currentView;
    final c = Provider.of<ThemeProvider>(context).startingChain;
    final widthQuery = Utils.widthQuery(context);
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lang = Utils.language(context);
    final wallet = Provider.of<WalletProvider>(context);
    // final firstPart = wallet.walletAddress.substring(0, 4);
    // final secondPart = wallet.walletAddress.substring(
    //     wallet.walletAddress.length - 4, wallet.walletAddress.length);
    // final walletAddress = " $firstPart...$secondPart  ";
    final bool walletConnected = wallet.isWalletConnected;
    final walletSubstring =
        Provider.of<WalletProvider>(context, listen: false).addressSubstring;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: wallet.walletSheetOpen
          ? []
          : [
              if (tabView == TabView.governance &&
                  walletConnected &&
                  shares > 0)
                buildButton(Icons.add_box_rounded, lang.home7, primaryColor,
                    widthQuery, isDark, walletConnected),
              if (tabView == TabView.governance || tabView == TabView.coins)
                buildButton(
                    Icons.wallet,
                    walletConnected ? walletSubstring(c) : lang.home6,
                    primaryColor,
                    widthQuery,
                    isDark,
                    walletConnected),
              buildButton(Icons.launch, lang.home5, primaryColor, widthQuery,
                  isDark, walletConnected),
            ],
    );
  }
}
