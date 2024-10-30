// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web_socket_channel/io.dart';

import '../crypto/utils/aliases.dart';
import '../languages/app_language.dart';
import '../languages/ar_language.dart';
import '../languages/en_language.dart';
import '../languages/fr_language.dart';
import '../languages/tr_language.dart';
import '../theme_preference.dart';
import '../toasts.dart';
import '../utils.dart';
import 'activities/bridge_activity_provider.dart';
import 'activities/escrow_activity_provider.dart';
import 'activities/payment_activity_provider.dart';
import 'activities/transfer_activity_provider.dart';
import 'activities/trust_activity_provider.dart';
import 'bridges_provider.dart';
import 'discover_provider.dart';
import 'escrows_provider.dart';
import 'explorer_provider.dart';
import 'fees_provider.dart';
import 'payments_provider.dart';
import 'transactions_provider.dart';
import 'transfers_provider.dart';
import 'trusts_provider.dart';
import 'wallet_provider.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  String _langCode = 'en';
  String _walletTopic = '';
  String _sessionTopic = '';
  TextDirection _textDirection = TextDirection.ltr;
  Chain _startingChain = Chain.Avalanche;
  late Web3Client _client;
  AppLanguage _appLanguage = EN_Language();
  final ThemePreferences _preferences = ThemePreferences();
  late Web3App _walletClient;
  bool get isDark => _isDark;
  String get langCode => _langCode;
  String get walletTopic => _walletTopic;
  String get stateSessionTopic => _sessionTopic;
  TextDirection get textDirection => _textDirection;
  AppLanguage get appLanguage => _appLanguage;
  Chain get startingChain => _startingChain;
  Web3Client get client => _client;
  Web3App get walletClient => _walletClient;

  void setClient(String rpc, String wss, [bool? avoidDispose]) {
    if (avoidDispose == null) {
      print("disposing old client");
      _client.dispose();
    }
    _client = Web3Client(rpc, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wss).cast<String>();
    });
    notifyListeners();
  }

  void disposeClient() {
    _client.dispose();
  }

  void setWalletClient(Web3App _wc) async {
    var keys = _wc.getActiveSessions().keys.toList();
    for (var key in keys) {
      await _wc.disconnectSession(
          topic: key,
          reason: const WalletConnectError(code: 1, message: "message"));
      await _wc.sessions.delete(key);
    }
    _walletClient = _wc;
    notifyListeners();
  }

  void setTopic(String newTopic) {
    _preferences.setPairingTopic(newTopic);
    _walletTopic = newTopic;
    print("theme pairing topic $_walletTopic");
    // notifyListeners();
  }

  void setSessionTopic(String s) {
    _sessionTopic = s;
    print("theme session topic $_sessionTopic");
    notifyListeners();
  }

  void disposeWalletClient() {
    //THIS FUNCTION IS UNUSED ANYWHERE, DO NOT USE
    if (_sessionTopic.isNotEmpty) {
      _walletClient.disconnectSession(
          topic: _sessionTopic,
          reason: const WalletConnectError(code: 1, message: "message"));
      _walletClient.sessions.delete(_sessionTopic);
    }
  }

  void handleLangCodeToClass(String paramlangCode, [bool? isSetup]) {
    switch (paramlangCode) {
      case 'en':
        _appLanguage = EN_Language();
        _langCode = 'en';
        _textDirection = TextDirection.ltr;
        break;
      case 'ar':
        _appLanguage = AR_Language();
        _langCode = 'ar';
        _textDirection = TextDirection.rtl;
        break;
      case 'tr':
        _appLanguage = TR_Language();
        _langCode = 'tr';
        _textDirection = TextDirection.ltr;
        break;
      case 'fr':
        _appLanguage = FR_Language();
        _langCode = 'fr';
        _textDirection = TextDirection.ltr;
        break;
      default:
        _appLanguage = EN_Language();
        _langCode = 'en';
        _textDirection = TextDirection.ltr;
        break;
    }
    if (isSetup == null) {
      Restart.restartApp();
    }
  }

  void initializer(BuildContext context, String walletAddress, [Chain? c]) {
    var alias = Aliases.getAlias(c ?? _startingChain);
    setClient(alias.rpcUrl, alias.wss);
    Provider.of<ExplorerProvider>(context, listen: false)
        .setCurrentChain(c ?? _startingChain, appLanguage);
    Provider.of<TransfersProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage, walletAddress);
    Provider.of<PaymentsProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage);
    Provider.of<TrustsProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage);
    Provider.of<BridgesProvider>(context, listen: false)
        .setSourceChain(c ?? _startingChain, appLanguage, true);
    Provider.of<BridgesProvider>(context, listen: false)
        .setTargetChain(c ?? _startingChain, appLanguage, true);
    Provider.of<EscrowsProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage, _client);
    Provider.of<BridgeActivityProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage, _client);
    Provider.of<TransferActivityProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage, _client);
    Provider.of<PaymentActivityProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage, _client);
    Provider.of<TrustActivityProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage, _client);
    Provider.of<EscrowActivityProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage, _client);
    Provider.of<TransactionsProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage);
    Provider.of<DiscoverProvider>(context, listen: false)
        .setDiscoverChain(c ?? _startingChain, appLanguage, _client);
    Provider.of<WalletProvider>(context, listen: false)
        .getAndSetAssets(c ?? _startingChain);
  }

  void setLanguage(String newCode) {
    _preferences.setLanguage(newCode);
    handleLangCodeToClass(newCode);
    notifyListeners();
  }

  void setDark() {
    _preferences.setDarkMode(!_isDark);
    _isDark = !_isDark;
    notifyListeners();
  }

  void disconnectWallet(
      BuildContext context, bool pop, void Function(Chain) walletDisconnect) {
    _walletClient
        .disconnectSession(
            topic: _sessionTopic,
            reason: const WalletConnectError(code: 1, message: "message"))
        .then((_) {
      if (pop) Navigator.popUntil(context, (route) => route.isFirst);
      _walletClient.sessions.delete(_sessionTopic);
      initializer(context, "");
      setTopic("");
      setSessionTopic("");
      walletDisconnect(_startingChain);
    }).catchError((e) {
      Navigator.pop(context);
      Toasts.showErrorToast(
          _appLanguage.toast13, _appLanguage.toast14, _isDark, _textDirection);
    });
    notifyListeners();
  }

  ThemeProvider(BuildContext context, dynamic setChain) {
    getPreferences(context, setChain);
  }

  Future<bool> setStartingChain(
      Chain c, BuildContext context, String walletAddress,
      [void Function()? handler, void Function()? failHandler]) async {
    Chain oldVal = _startingChain;
    Future.delayed(
        const Duration(milliseconds: 50),
        () => Utils.showLoadingDialog(
            context, _appLanguage, Utils.widthQuery(context), true));
    var bufferAlias = Aliases.getAlias(c);
    var bufferClient =
        Web3Client(bufferAlias.rpcUrl, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(bufferAlias.wss).cast<String>();
    });
    try {
      await Provider.of<FeesProvider>(context, listen: false)
          .getAndSetFees(c, bufferClient);
      _preferences.setChain(c);
      _startingChain = c;
      bufferClient.dispose();
      initializer(context, walletAddress);
      notifyListeners();
      if (handler != null) handler();
      Navigator.pop(context);
      return true;
    } catch (e) {
      _startingChain = oldVal;
      bufferClient.dispose();
      if (failHandler != null) failHandler();
      Future.delayed((const Duration(milliseconds: 100)), () {
        Navigator.pop(context);
        Toasts.showErrorToast(_appLanguage.changeFailed,
            _appLanguage.errorOccured, _isDark, _textDirection);
      });
      return false;
    }
  }

  getPreferences(context, Function(Chain, AppLanguage) setChain) async {
    List<dynamic> prefs = await _preferences.getTheme(context);
    var thisLangCode = prefs[0];
    var thisDarkMode = prefs[1];
    var thisChain = prefs[2];
    var theTopic = prefs[3];
    _isDark = thisDarkMode;
    _startingChain = thisChain;
    handleLangCodeToClass(thisLangCode, true);
    setTopic(theTopic);
    initializer(context, "");
    notifyListeners();
  }
}
