// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../crypto/features/bridge_utils.dart';
import '../crypto/utils/aliases.dart';
import '../crypto/utils/chain_data.dart';
import '../crypto/utils/chain_utils.dart';
import '../crypto/utils/eip155.dart';
import '../languages/app_language.dart';
import '../main.dart';
import '../models/transaction.dart' as otx;
import '../providers/theme_provider.dart';
import '../providers/transactions_provider.dart';
import '../providers/trusts_provider.dart';
import '../providers/wallet_provider.dart';
import '../routes.dart';
import '../screens/transactions_screen.dart';
import '../tabs/bridges.dart';
import '../tabs/escrow.dart';
import '../tabs/payments.dart';
// import '../tabs/refuel.dart';
import '../tabs/transfers.dart';
import '../tabs/trust.dart';
import '../toasts.dart';
import '../utils.dart';
import '../widgets/home/navbar.dart';
import '../widgets/home/sidebar.dart';
import '../widgets/home/toolbar.dart';
import '../widgets/home/wallet_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool sessionSet = false;
  // bool hasReconnectedRelay = false;
  late Web3App _stateWcClient;
  Map<String, RequiredNamespace> optionalNamespaces = {};
  late StreamSubscription<List<otx.Transaction>> transactionListener;
  late void Function() disposeClient;
  final Key _key = GlobalKey();
  final PageController pageController = PageController();
  void pageHandler(int index) {
    FocusScope.of(context).unfocus();
    _currentIndex = index;
    pageController.jumpToPage(index);
  }

  Widget buildBody(bool widthQuery, bool isDark) {
    final dir = Provider.of<ThemeProvider>(context).textDirection;
    return Expanded(
        child: SelectionArea(
            child: Stack(children: [
      Padding(
        padding: EdgeInsets.only(top: widthQuery ? 0 : 70.0),
        child: PageView(
            key: _key,
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              Transfers(),
              Payments(),
              Trust(),
              Bridges(),
              Escrow(),
              // Refuel()
            ]),
      ),
      if (!widthQuery)
        Align(
            alignment: Alignment.bottomCenter,
            child:
                Navbar(indexHandler: pageHandler, currentIndex: _currentIndex)),
      if (!widthQuery)
        Align(
            alignment: Alignment.topCenter,
            child: Directionality(
                textDirection: dir,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: dir == TextDirection.rtl ? 0 : 8,
                              right: dir == TextDirection.rtl ? 8 : 0),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.white,
                              border: Border.all(
                                  color: isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          height: 60,
                          width: 60,
                          child: ExtendedImage.network(Utils.logo,
                              cache: true, enableLoadState: false)),
                      Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: const WalletButton()),
                      const MyToolbar()
                    ])))
    ])));
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
      void Function(Chain, BuildContext, String,
              [void Function()?, void Function()?])
          setStartingChain,
      void Function(String) setSessionTopic,
      void Function(String) setTopic,
      void Function(Chain, String) setChainAddress,
      void Function(BuildContext, String, [Chain?]) initializer,
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
          setStartingChain(thisChain, context, _nestedAddresses[thisChain]!,
              () {
            setSupportedChains(_supported);
            getAndSetAssets(thisChain);
            setTopic(pairingTopic);
            setSessionTopic(session.topic);
          }, () {
            _stateWcClient
                .disconnectSession(
                    topic: session.topic,
                    reason:
                        const WalletConnectError(code: 1, message: "message"))
                .then((_) {
              sessionSet = false;
              Toasts.showErrorToast(
                  lang.error1,
                  "",
                  Provider.of<ThemeProvider>(context, listen: false).isDark,
                  Provider.of<ThemeProvider>(context, listen: false)
                      .textDirection);
            });
          });
        } else {
          setStartingChain(thisChain, context, _nestedAddresses[thisChain]!,
              () {
            setSupportedChains(_supported);
            getAndSetAssets(thisChain);
            setTopic(pairingTopic);
            setSessionTopic(session.topic);
          }, () {
            _stateWcClient
                .disconnectSession(
                    topic: session.topic,
                    reason:
                        const WalletConnectError(code: 1, message: "message"))
                .then((_) {
              sessionSet = false;
              Toasts.showErrorToast(
                  lang.error1,
                  "",
                  Provider.of<ThemeProvider>(context, listen: false).isDark,
                  Provider.of<ThemeProvider>(context, listen: false)
                      .textDirection);
            });
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
      // await _stateWcClient.disconnectSession(
      //     topic: key,
      //     reason: const WalletConnectError(code: 1, message: "message"));
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

  void handleDeepLink() {
    if (MyApp.cameFromPaymentLink) {
      Future.delayed(const Duration(milliseconds: 250), () {
        Navigator.pushNamed(context, Routes.paymentGateway);
      });
    }
    if (MyApp.cameFromOtherLink) {
      Future.delayed(const Duration(milliseconds: 250), () {
        final url = MyApp.fullUrl;
        if (url.endsWith("/transfers")) {
          //default
        }
        if (url.endsWith("/payments")) {
          pageHandler(1);
        }
        if (url.endsWith("/trust")) {
          pageHandler(2);
        }
        if (url.endsWith("/bridges") || url.endsWith("/bridge")) {
          pageHandler(3);
        }
        if (url.endsWith("/escrow")) {
          pageHandler(4);
        }
        if (url.endsWith("/refuel")) {
          //TODO ADD NEW FEATURE HERE
        }
        if (url.endsWith("/explorer")) {
          Navigator.pushNamed(context, Routes.explorer);
        }
        if (url.endsWith("/discover")) {
          Navigator.pushNamed(context, Routes.discover);
        }
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    handleDeepLink();
    Provider.of<TrustsProvider>(context, listen: false).initAmountController();
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    disposeClient = theme.disposeClient;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final transactions =
        Provider.of<TransactionsProvider>(context, listen: false);
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
          const Duration(milliseconds: 800),
          () => Toasts.showInfoToast(lang.wcRequest1, lang.wcRequest2,
              theme.isDark, theme.textDirection));
    }
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
    transactionListener = transactions.transactionStream.listen((txs) {
      if (txs.isNotEmpty) {
        List<otx.Transaction> pendingTxs = txs
            .where((t) =>
                t.status != otx.Status.complete &&
                t.status != otx.Status.failed)
            .toList();
        if (pendingTxs.isNotEmpty) {
          Timer.periodic(Utils.queryFeesDuration, (t) async {
            List<String> alreadyQueried = [];
            for (var txz in pendingTxs) {
              if (txz.type == otx.TransactionType.bridge) {
                if (txz.blockNumber > 0) {
                  if (txz.secondBlockNumber == 0) {
                    var targetChain = txz.destinationChain!;
                    var targetAlias = Aliases.getAlias(targetChain);
                    var tempClient =
                        Web3Client(targetAlias.rpcUrl, http.Client());
                    var secondTxHash = txz.secondTransactionHash.isEmpty
                        ? await BridgeUtils.fetchLzeroSecondTx(
                            source: txz.c, txHash: txz.transactionHash)
                        : txz.secondTransactionHash;
                    if (secondTxHash != null) {
                      TransactionReceipt? i =
                          await ChainUtils.getTransactionInformation(
                              txz.c, secondTxHash, tempClient);
                      if (txz.secondTransactionHash.isEmpty) {
                        transactions.modifyBridgeTransactionStatus2(
                            id: txz.id,
                            s: otx.Status.omnifyReceived,
                            blockNumber2: 0,
                            hash2: secondTxHash);
                      }
                      if (i != null) {
                        transactions.modifyBridgeTransactionStatus2(
                            id: txz.id,
                            s: i.status!
                                ? otx.Status.complete
                                : otx.Status.failed,
                            blockNumber2: i.blockNumber.blockNum,
                            hash2: secondTxHash);
                        TransactionUtils.handleTransactionToast(txz,
                            theme.isDark, theme.textDirection, false, lang);
                        tempClient.dispose();
                      } else {
                        tempClient.dispose();
                      }
                    } else {
                      tempClient.dispose();
                    }
                  }
                } else {
                  TransactionReceipt? i =
                      await ChainUtils.getTransactionInformation(
                          txz.c,
                          txz.transactionHash,
                          Provider.of<ThemeProvider>(context, listen: false)
                              .client);
                  if (i != null) {
                    transactions.modifyTransactionStatus(
                      txz.id,
                      i.status! ? otx.Status.omnifySent : otx.Status.failed,
                      i.blockNumber.blockNum,
                    );
                    TransactionUtils.handleTransactionToast(
                        txz, theme.isDark, theme.textDirection, false, lang);
                  }
                }
              } else {
                if (!alreadyQueried.contains(txz.transactionHash)) {
                  if (txz.status != otx.Status.complete &&
                      txz.status != otx.Status.failed) {
                    alreadyQueried.add(txz.transactionHash);
                    TransactionReceipt? i =
                        await ChainUtils.getTransactionInformation(
                            txz.c,
                            txz.transactionHash,
                            Provider.of<ThemeProvider>(context, listen: false)
                                .client);
                    if (i != null) {
                      List<otx.Transaction> _commonHashTxs = pendingTxs
                          .where(
                              (tt) => tt.transactionHash == txz.transactionHash)
                          .toList();
                      for (var common in _commonHashTxs) {
                        transactions.modifyTransactionStatus(
                            common.id,
                            i.status! ? otx.Status.complete : otx.Status.failed,
                            i.blockNumber.blockNum);
                      }
                      TransactionUtils.handleTransactionToast(
                          txz, theme.isDark, theme.textDirection, false, lang);
                    } else {}
                  }
                }
              }
            }
          });
        }
      }
    });
    transactionListener.resume();

    _stateWcClient.onProposalExpire.subscribe((proposalExpire) {
      if (proposalExpire != null) {
        // print('proposal expired');
      }
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
      if (update != null) {
        //TODO HANDLE NETWORK CHANGE FROM WALLET
        print(update.toString());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    _stateWcClient.onSessionConnect.unsubscribe((_) {});
    _stateWcClient.onProposalExpire.unsubscribe((_) {});
    _stateWcClient.onSessionDelete.unsubscribe((_) {});
    _stateWcClient.onSessionExpire.unsubscribe((_) {});
    _stateWcClient.onSessionUpdate.unsubscribe((_) {});
    transactionListener.cancel();
    disposeClient();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final dir = Provider.of<ThemeProvider>(context).textDirection;
    final bool widthQuery = Utils.widthQuery(context);
    return SelectionArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: widthQuery
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (dir == TextDirection.ltr)
                        MySidebar(
                            indexHandler: pageHandler,
                            currentIndex: _currentIndex),
                      buildBody(widthQuery, isDark),
                      if (dir == TextDirection.rtl)
                        MySidebar(
                            indexHandler: pageHandler,
                            currentIndex: _currentIndex),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [buildBody(widthQuery, isDark)]),
          ),
        ),
      ),
    );
  }
}
