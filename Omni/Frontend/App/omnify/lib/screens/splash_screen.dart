// ignore_for_file: use_build_context_synchronously

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:omnify/theme_preference.dart';
import 'package:omnify/widgets/common/error_widget.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../crypto/utils/aliases.dart';
import '../providers/fees_provider.dart';
import '../providers/theme_provider.dart';
import '../routes.dart';
import '../utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<void> getAndSetFees;
  bool isShown = false;
  Future<void> _getAndSetFees(
      String description,
      void Function(Web3App) setWalletClient,
      void Function(String, String, [bool?]) setClient) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Chain c = ThemePreferences.stringToChain(
        sharedPreferences.getString(ThemePreferences.homeChain) ?? "Avalanche");
    var alias = Aliases.getAlias(c);
    setClient(alias.rpcUrl, alias.wss, false);
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    var wcClient = Web3App(
      core: Core(
          logLevel: LogLevel.nothing,
          projectId: Utils.wcProjectId,
          relayUrl:
              'wss://relay.walletconnect.com' // The relay websocket URL, leave blank to use the default
          ),
      metadata: PairingMetadata(
        name: 'Omnify',
        description: description,
        url: 'https://app.omnify.finance',
        icons: [Utils.logo],
        redirect: const Redirect(
          native: 'omnify://',
          universal: 'https://app.omnify.finance',
        ),
      ),
    );
    await wcClient.init();
    setWalletClient(wcClient);
    await Provider.of<FeesProvider>(context, listen: false)
        .getAndSetFees(c, client);
    Navigator.pushReplacementNamed(context, Routes.homeScreen);
  }

  @override
  void initState() {
    super.initState();
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final lang = theme.appLanguage;
    final setClient = theme.setClient;
    getAndSetFees =
        _getAndSetFees(lang.wcDescription, theme.setWalletClient, setClient);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 650), () {
      if (mounted) {
        setState(() {
          isShown = !isShown;
        });
      }
    });
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final setClient = theme.setClient;
    final isDark = theme.isDark;
    final lang = Provider.of<ThemeProvider>(context).appLanguage;
    const version = "V1.2.2";
    return SelectionArea(
      child: Scaffold(
          appBar: null,
          body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FutureBuilder(
                      future: getAndSetFees,
                      builder: (ctx, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Expanded(
                                    child: Center(
                                        child: AnimatedOpacity(
                                            duration: const Duration(
                                                milliseconds: 450),
                                            opacity: isShown ? 1.0 : 0.25,
                                            child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: ExtendedImage.network(
                                                    Utils.logo,
                                                    cache: true,
                                                    enableLoadState: false))))),
                                const Spacer(),
                                Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      version,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.grey.shade300),
                                    ))
                              ]);
                        }
                        if (snap.hasError) {
                          return MyError(() {
                            setState(() {
                              getAndSetFees = _getAndSetFees(lang.wcDescription,
                                  theme.setWalletClient, setClient);
                            });
                          });
                        }
                        return Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Expanded(
                                  child: Center(
                                      child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: ExtendedImage.network(
                                              Utils.logo,
                                              cache: true,
                                              enableLoadState: false)))),
                              const Spacer(),
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    version,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.grey.shade300),
                                  ))
                            ]);
                      })))),
    );
  }
}
