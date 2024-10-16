// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../languages/app_language.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../utils.dart';
import '../../toasts.dart';

class WalletButton extends StatefulWidget {
  const WalletButton({super.key});

  @override
  State<WalletButton> createState() => _WalletButtonState();
}

class _WalletButtonState extends State<WalletButton> {
  late Web3App wcClient;
  Widget buildAddressTile(
    Chain c,
    bool isEvm,
    String address,
    bool widthQuery,
    bool isDark,
    AppLanguage lang,
    String Function(Chain) giveWalletAddress,
  ) {
    return ListTile(
        horizontalTitleGap: 5,
        leading: Utils.buildNetworkLogo(widthQuery, c, true),
        title: Text(c.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black)),
        subtitle: Text(giveWalletAddress(c),
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.white70 : Colors.black)),
        trailing: IconButton(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: address));
              Toasts.showInfoToast(
                  lang.addressCopied,
                  "",
                  isDark,
                  Provider.of<ThemeProvider>(context, listen: false)
                      .textDirection);
            },
            icon: Icon(Icons.copy,
                color: Theme.of(context).colorScheme.primary)));
  }

  void disconnectHandler(
      String topic,
      bool widthQuery,
      bool isDark,
      String walletAddress,
      void Function(Chain) disconnectWallet,
      String Function(Chain) giveWalletAddress,
      AppLanguage lang,
      TextDirection dir,
      Map<Chain, String> myaddresses,
      Chain currentChain) async {
    Widget buildTile(Chain c) => myaddresses[c]! != ''
        ? buildAddressTile(c, c != Chain.Tron, myaddresses[c]!, widthQuery,
            isDark, lang, giveWalletAddress)
        : const SizedBox.shrink();
    await showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        useSafeArea: true,
        builder: (ctx) {
          return Material(
            color: Colors.transparent,
            child: Directionality(
              textDirection: dir,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                          margin: const EdgeInsets.all(8),
                          width: widthQuery ? 400 : double.infinity,
                          height: MediaQuery.of(context).size.height - 16,
                          decoration: BoxDecoration(
                              color: isDark ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: isDark
                                      ? Colors.grey.shade700
                                      : Colors.transparent)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(9),
                                        topRight: Radius.circular(9)),
                                    color: isDark
                                        ? Colors.grey.shade700
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      lang.addresses,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        icon: const Icon(Icons.close,
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                  child: ListView(children: [
                                ...Utils.ourChains.map((c) => buildTile(c))
                              ])),
                              Center(
                                child: TextButton(
                                  onPressed: () async {
                                    Utils.showLoadingDialog(
                                        context,
                                        lang,
                                        Utils.widthQuery(context),
                                        false,
                                        lang.toasts19);
                                    Provider.of<ThemeProvider>(context,
                                            listen: false)
                                        .disconnectWallet(
                                            context, true, disconnectWallet);
                                  },
                                  style: const ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                      overlayColor: WidgetStatePropertyAll(
                                          Colors.transparent)),
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Center(
                                        child: Text(lang.disconnectWallet,
                                            style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.red)),
                                      )),
                                ),
                              )
                            ],
                          )),
                    )
                  ]),
            ),
          );
        });
  }

  Future<void> initWc() async {
    wcClient = await Web3App.createInstance(
      projectId: Utils.wcProjectId,
      relayUrl:
          'wss://relay.walletconnect.com', // The relay websocket URL, leave blank to use the default
      metadata: const PairingMetadata(
        name: 'Omnify',
        description: "",
        url: 'https://app.omnify.finance',
        icons: [Utils.logo],
        redirect: Redirect(
          native: 'omnify://',
          universal: 'https://app.omnify.finance',
        ),
      ),
    );
  }

  Widget buildButton(
          String topic,
          String label,
          Color primaryColor,
          String walletAddress,
          bool widthQuery,
          bool isDark,
          bool walletConnected,
          void Function(Chain) disconnectWallet,
          String Function(Chain) giveWalletAddress,
          AppLanguage lang,
          TextDirection dir,
          Map<Chain, String> myAddresses,
          Chain currentChain) =>
      Container(
          margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
          child: TextButton(
              onPressed: () {
                if (walletConnected) {
                  disconnectHandler(
                      topic,
                      widthQuery,
                      isDark,
                      walletAddress,
                      disconnectWallet,
                      giveWalletAddress,
                      lang,
                      dir,
                      myAddresses,
                      currentChain);
                } else {
                  FocusScope.of(context).unfocus();
                  Provider.of<WalletProvider>(context, listen: false)
                      .connectWallet(context);
                }
              },
              style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                  elevation: WidgetStatePropertyAll(5),
                  overlayColor: WidgetStatePropertyAll(Colors.transparent)),
              child: Container(
                  height: widthQuery ? 45 : 40,
                  width: widthQuery ? 150 : 115,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(widthQuery ? 10 : 7)),
                  child: Center(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: widthQuery ? 15 : 13,
                            color: Colors.white))
                  ])))));

  @override
  void initState() {
    super.initState();
    initWc();
  }

  @override
  Widget build(BuildContext context) {
    final widthQuery = Utils.widthQuery(context);
    final wallet = Provider.of<WalletProvider>(context);
    final currentChain = Provider.of<ThemeProvider>(context).startingChain;
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final topic = Provider.of<ThemeProvider>(context).walletTopic;
    final dir = Provider.of<ThemeProvider>(context).textDirection;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lang = Utils.language(context);
    final walletAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(currentChain);
    final disconnectWallet =
        Provider.of<WalletProvider>(context, listen: false).disconnectWallet;
    final giveWalletAddress =
        Provider.of<WalletProvider>(context, listen: false).addressSubstring;
    final bool walletConnected = wallet.isWalletConnected;
    return buildButton(
        topic,
        walletConnected ? giveWalletAddress(currentChain) : lang.home8,
        primaryColor,
        walletAddress,
        widthQuery,
        isDark,
        walletConnected,
        disconnectWallet,
        giveWalletAddress,
        lang,
        dir,
        wallet.myAddresses,
        currentChain);
  }
}
