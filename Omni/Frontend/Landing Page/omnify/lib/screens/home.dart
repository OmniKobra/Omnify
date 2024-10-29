// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:omnify/main.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../crypto/utils/chain_data.dart';
import '../crypto/utils/eip155.dart';
import '../languages/app_language.dart';
import '../providers/home_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/wallet_provider.dart';
import '../tabs/coin_seller.dart';
import '../tabs/explorer_tab.dart';
import '../tabs/fees_tab.dart';
import '../tabs/governance_tab.dart';
import '../tabs/home_tab.dart';
import '../toasts.dart';
import '../utils.dart';
import '../widgets/fab.dart';
// import '../widgets/my_image.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool sessionSet = false;
  late Web3App _stateWcClient;
  Map<String, RequiredNamespace> optionalNamespaces = {};
  late void Function() disposeClient;

  Widget buildCurrentTab(TabView vie) {
    switch (vie) {
      case TabView.home:
        return const HomeTab();
      case TabView.explorer:
        return const ExplorerTab();
      case TabView.governance:
        return const GovernanceTab();
      case TabView.fees:
        return const FeesTab();
      case TabView.coins:
        return const CoinSeller();
      default:
        return const HomeTab();
    }
  }

  Widget buildButton(String title, TabView v,
      void Function(TabView, [bool?]) changeTab, TabView current, bool isDark) {
    return TextButton(
        style: ButtonStyle(
            elevation: WidgetStateProperty.all<double?>(0),
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all<Color?>(Colors.transparent)),
        onPressed: () {
          FocusScope.of(context).unfocus();
          changeTab(v);
        },
        child: Text(title,
            style: TextStyle(
                color: v == current
                    ? Theme.of(context).colorScheme.primary
                    : isDark
                        ? Colors.white70
                        : Colors.grey,
                fontWeight: v == current ? FontWeight.bold : FontWeight.normal,
                fontSize: Utils.widthQuery(context) ? 19 : 14)));
  }

  void updateNamespaces() {
    optionalNamespaces = {};
    final evmChains = ChainData.eip155Chains;
    optionalNamespaces['eip155'] = RequiredNamespace(
        chains: evmChains.map((c) => c.chainId).toList(),
        methods: EIP155.methods.values.toList(),
        events: ['chainChanged', 'accountsChanged']);
    //TODO ADD TRON SUPPORT HERE

    // optionalNamespaces['tron'] = const RequiredNamespace(chains: [
    //   'tron:0x2b6653dc'
    // ], methods: [
    //   'tron_signTransaction',
    //   'tron_signMessage',
    //   'tron_sign',
    //   'tron_sendTransaction',
    //   'personal_sign',
    //   'tron_signTypedData'
    // ], events: [
    //   'chainChanged',
    //   'accountsChanged'
    // ]);
  }

  Future<void> setSession(
      SessionData session,
      List<Chain> currentSupportedChains,
      Future<void> Function(Chain) getAndSetAssets,
      void Function(String, bool) setWalletConnected,
      void Function(String, bool) setTronWalletConnected,
      void Function(List<Chain>) setSupportedChains,
      void Function(Chain, BuildContext, [void Function()?]) setStartingChain,
      void Function(String) setSessionTopic,
      void Function(String) setTopic,
      void Function(Chain, String) setChainAddress,
      void Function(BuildContext, [Chain?]) initializer,
      AppLanguage lang) async {
    if (!sessionSet) {
      sessionSet = true;
      String address = '';
      String tronAddress = '';
      var starter =
          Provider.of<ThemeProvider>(context, listen: false).startingChain;
      Chain thisChain = starter;
      final pairingTopic = session.pairingTopic;
      Map<Chain, String> _nestedAddresses = {};
      List<Chain> _supported = [];
      if (session.namespaces['eip155'] != null) {
        var evmAccounts = session.namespaces['eip155']!.accounts;
        if (evmAccounts.isNotEmpty) {
          Map<int, String> addresses = {};
          List<int> chainIds = [];
          address = evmAccounts.first.split(":").last.split(":").last;
          setWalletConnected(address, false);
          for (var account in evmAccounts) {
            var split1 = account.split("eip155:").last;
            var split2 = split1.split(":").first;
            var thisChainsAddress = split1.split(":").last;
            var number = int.parse(split2.split(":").last);
            chainIds.add(number);
            addresses[number] = thisChainsAddress;
          }
          for (var chain in currentSupportedChains) {
            final itsId = Utils.chainToId(chain);
            bool contains = chainIds.contains(itsId);
            if (contains) {
              _supported.add(chain);
              _nestedAddresses[chain] = addresses[itsId]!;
              setChainAddress(chain, addresses[itsId]!);
            }
          }
        }
      }
      if (session.namespaces['tron'] != null) {
        var tronAccounts = session.namespaces['tron']!.accounts;
        if (tronAccounts.isNotEmpty) {
          tronAddress = tronAccounts.first.split(":").last.split(":").last;
          _supported.add(Chain.Tron);
          _nestedAddresses[Chain.Tron] = tronAddress;
          setChainAddress(Chain.Tron, tronAddress);
          setTronWalletConnected(tronAddress, false);
        }
      }
      if (_supported.isNotEmpty) {
        if (!_supported.contains(thisChain)) {
          thisChain = _supported.first;
          setStartingChain(thisChain, context, () {
            setSupportedChains(_supported);
            getAndSetAssets(thisChain);
            setTopic(pairingTopic);
            setSessionTopic(session.topic);
          });
        } else {
          setStartingChain(thisChain, context, () {
            setSupportedChains(_supported);
            getAndSetAssets(thisChain);
            setTopic(pairingTopic);
            setSessionTopic(session.topic);
          });
        }
      } else {
        _stateWcClient
            .disconnectSession(
                topic: session.topic,
                reason: const WalletConnectError(code: 1, message: "message"))
            .then((_) {
          sessionSet = false;
          Toasts.showErrorToast(
              lang.toast15,
              lang.toasts16,
              Provider.of<ThemeProvider>(context, listen: false).isDark,
              Provider.of<ThemeProvider>(context, listen: false).textDirection);
        });
      }
      bool walletSheetOpen =
          Provider.of<WalletProvider>(context, listen: false).walletSheetOpen;
      if (walletSheetOpen) Navigator.pop(context);
    }
  }

  Future<void> prepareForConnection() async {
    var keys = _stateWcClient.getActiveSessions().keys.toList();
    for (var key in keys) {
      await _stateWcClient.disconnectSession(
          topic: key,
          reason: const WalletConnectError(code: 1, message: "message"));
      await _stateWcClient.sessions.delete(key);
    }
  }

  Future<void> connectHandler(
      String pairingTopic,
      void Function(String) topicHandler,
      bool isDark,
      TextDirection textDirection,
      AppLanguage lang) async {
    return prepareForConnection().then((_) {
      _stateWcClient
          .connect(
              optionalNamespaces: optionalNamespaces,
              pairingTopic: pairingTopic)
          .then((r) {})
          .catchError((e) {
        topicHandler("");
        Toasts.showErrorToast(
            lang.toasts28, lang.toasts29, isDark, textDirection);
      });
    });
  }

  void handleDeeplink(void Function(TabView, [bool?]) setView) {
    if (MyApp.cameFromLink) {
      final url = MyApp.fullUrl;
      if (url.endsWith("/home")) {
        setView(TabView.home, true);
      }
      if (url.endsWith("/explorer")) {
        setView(TabView.explorer, true);
      }
      if (url.endsWith("/governance")) {
        setView(TabView.governance, true);
      }
      if (url.endsWith("/fees")) {
        setView(TabView.fees, true);
      }
      if (url.endsWith("/coins")) {
        setView(TabView.coins, true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final setView =
        Provider.of<HomeProvider>(context, listen: false).setCurrentView;
    handleDeeplink(setView);
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    disposeClient = theme.disposeClient;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final lang = theme.appLanguage;
    final pairingTopic = theme.walletTopic;
    updateNamespaces();
    _stateWcClient = theme.walletClient;
    final currentSupportedChains = wallet.supportedChains;
    final void Function(String, bool) setWalletConnected =
        wallet.setWalletConnected;
    final void Function(String, bool) setTronWalletConnected =
        wallet.setTronWalletConnected;
    final setStartingChain = theme.setStartingChain;
    final setTopic = theme.setTopic;
    final setSessionTopic = theme.setSessionTopic;
    final initializer = theme.initializer;
    if (pairingTopic.isNotEmpty) {
      connectHandler(pairingTopic, theme.setTopic, theme.isDark,
          theme.textDirection, theme.appLanguage);
      Future.delayed(
          const Duration(milliseconds: 100),
          () => Toasts.showInfoToast(lang.wcRequest1, lang.wcRequest2,
              theme.isDark, theme.textDirection));
    }

    // _stateWcClient.core.relayClient.onRelayClientDisconnect.subscribe((args) {
    //   if (args != null) {
    //     _stateWcClient.core.relayClient.connect();
    //     print("connecting relay");
    //   }
    // });
    _stateWcClient.onSessionConnect.subscribe((connect) {
      if (connect != null) {
        // if (connect.session.acknowledged) {
        setSession(
            connect.session,
            currentSupportedChains,
            wallet.getAndSetAssets,
            setWalletConnected,
            setTronWalletConnected,
            wallet.setSupportedChains,
            setStartingChain,
            setSessionTopic,
            setTopic,
            wallet.setChainAddress,
            initializer,
            lang);
        // }
      }
    });

    _stateWcClient.onProposalExpire.subscribe((proposalExpire) {
      if (proposalExpire != null) {}
    });

    _stateWcClient.onSessionDelete.subscribe((delete) {
      if (delete != null) {
        if (delete.topic ==
            Provider.of<ThemeProvider>(context, listen: false)
                .stateSessionTopic) {
          sessionSet = false;
          theme.disconnectWallet(context, false, wallet.disconnectWallet);
        }
      }
    });
    _stateWcClient.onSessionExpire.subscribe((expire) {
      if (expire != null) {
        if (expire.topic ==
            Provider.of<ThemeProvider>(context, listen: false)
                .stateSessionTopic) {
          sessionSet = false;
          Toasts.showErrorToast(
              lang.toasts17, lang.toasts18, theme.isDark, theme.textDirection);
          theme.disconnectWallet(context, false, wallet.disconnectWallet);
        }
      }
    });
    _stateWcClient.onSessionUpdate.subscribe((update) {
      //TODO HANDLE NETWORK CHANGE FROM WALLET
      if (update != null) {}
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stateWcClient.onSessionConnect.unsubscribe((_) {});
    _stateWcClient.onProposalExpire.unsubscribe((_) {});
    _stateWcClient.onSessionDelete.unsubscribe((_) {});
    _stateWcClient.onSessionExpire.unsubscribe((_) {});
    _stateWcClient.onSessionUpdate.unsubscribe((_) {});
    // _stateWcClient.core.relayClient.onRelayClientDisconnect
    //     .unsubscribe((args) {});
    disposeClient();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final lang = Utils.language(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dir = themeProvider.textDirection;
    final isDark = themeProvider.isDark;
    final handler =
        Provider.of<HomeProvider>(context, listen: false).setCurrentView;
    final currentView = homeProvider.currentView;
    // const image = Padding(
    //     padding: EdgeInsets.symmetric(vertical: 2.0),
    //     child: MyImage(url: Utils.logo, fit: BoxFit.contain));
    return SelectionArea(
      child: Scaffold(
          appBar: AppBar(
              shape: Border(
                  bottom: BorderSide(
                      color:
                          isDark ? Colors.transparent : Colors.grey.shade200)),
              scrolledUnderElevation: 0.0,
              automaticallyImplyLeading: false,
              backgroundColor: isDark ? Colors.black : Colors.white,
              leadingWidth: dir == TextDirection.ltr
                  ? MediaQuery.of(context).size.width
                  : 0,
              actions: dir == TextDirection.ltr
                  ? []
                  : [
                      buildButton(lang.home9, TabView.coins, handler,
                          currentView, isDark),
                      buildButton(lang.home4, TabView.fees, handler,
                          currentView, isDark),
                      buildButton(lang.home3, TabView.governance, handler,
                          currentView, isDark),
                      buildButton(lang.home2, TabView.explorer, handler,
                          currentView, isDark),
                      buildButton(lang.home1, TabView.home, handler,
                          currentView, isDark),
                      // image,
                    ],
              leading: dir == TextDirection.ltr
                  ? ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // image,
                              buildButton(lang.home1, TabView.home, handler,
                                  currentView, isDark),
                              buildButton(lang.home2, TabView.explorer, handler,
                                  currentView, isDark),
                              buildButton(lang.home3, TabView.governance,
                                  handler, currentView, isDark),
                              buildButton(lang.home4, TabView.fees, handler,
                                  currentView, isDark),
                              buildButton(lang.home9, TabView.coins, handler,
                                  currentView, isDark),
                              // const Spacer()
                            ]),
                      ],
                    )
                  : null),
          floatingActionButton: const MyFab(),
          floatingActionButtonLocation: dir == TextDirection.ltr
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.startFloat,
          body: Directionality(
            textDirection: dir,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: buildCurrentTab(currentView))
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
