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
import '../models/carousel_item.dart';
import '../theme_preference.dart';
import '../toasts.dart';
import '../utils.dart';
import 'explorer_provider.dart';
import 'fees_provider.dart';
import 'governance_provider.dart';
import 'ico_provider.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  String _langCode = 'en';
  String _walletTopic = '';
  String _sessionTopic = '';
  TextDirection _textDirection = TextDirection.ltr;
  Chain _startingChain = Chain.Avalanche;
  AppLanguage _appLanguage = EN_Language();
  final ThemePreferences _preferences = ThemePreferences();
  late Web3Client _client;
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

  void setWalletClient(Web3App _wc) {
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

  void setClient(String rpc, String wss, [bool? avoidDispose]) {
    if (avoidDispose == null) {
      _client.dispose();
    }
    _client = Web3Client(rpc, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wss).cast<String>();
    });
  }

  void disposeClient() {
    _client.dispose();
  }

  void setTopic(String newTopic) {
    _preferences.setPairingTopic(newTopic);
    _walletTopic = newTopic;
    // notifyListeners();
  }

  void setSessionTopic(String s) {
    _sessionTopic = s;
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

  void initializer(BuildContext context, [Chain? c]) {
    var alias = Aliases.getAlias(c ?? _startingChain);
    setClient(alias.rpcUrl, alias.wss);
    Provider.of<ExplorerProvider>(context, listen: false)
        .setCurrentChain(c ?? _startingChain, appLanguage, _client);
    Provider.of<FeesProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage, _client);
    Provider.of<GovernanceProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage, _client);
    Provider.of<IcoProvider>(context, listen: false)
        .setChain(c ?? _startingChain, appLanguage, _client);
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
      initializer(context);
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

  ThemeProvider(BuildContext context, dynamic setItems, dynamic setChain) {
    getPreferences(context, setItems, setChain);
  }

  void setStartingChain(Chain c, BuildContext context,
      [void Function()? handler]) {
    Future.delayed(
        const Duration(milliseconds: 50),
        () => Utils.showLoadingDialog(
            context, _appLanguage, Utils.widthQuery(context), true));
    _preferences.setChain(c);
    _startingChain = c;
    initializer(context);
    notifyListeners();
    if (handler != null) handler();
    Future.delayed((const Duration(milliseconds: 100)), () {
      Navigator.pop(context);
    });
  }

  getPreferences(context, dynamic setCarouselItems,
      Function(Chain, AppLanguage, Web3Client) setChain) async {
    List<dynamic> prefs = await _preferences.getTheme(context);
    var thisLangCode = prefs[0];
    var thisDarkMode = prefs[1];
    var thisChain = prefs[2];
    var theTopic = prefs[3];
    _isDark = thisDarkMode;
    _startingChain = thisChain;
    var alias = Aliases.getAlias(_startingChain);
    setClient(alias.rpcUrl, alias.wss, false);
    handleLangCodeToClass(thisLangCode, true);
    setTopic(theTopic);
    initializer(context);
    List<CarouselItem> i = [
      CarouselItem(
          _appLanguage.carTitle0, _appLanguage.carDescription0, Utils.logo),
      CarouselItem(_appLanguage.carTitle1, _appLanguage.carDescription1,
          Utils.transferUrl),
      CarouselItem(
          _appLanguage.carTitle7, _appLanguage.carDescription2, Utils.payUrl),
      CarouselItem(
          _appLanguage.carTitle2, _appLanguage.carDescription3, Utils.trustUrl),
      CarouselItem(_appLanguage.carTitle3, _appLanguage.carDescription4,
          Utils.bridgeUrl),
      CarouselItem(_appLanguage.carTitle8, _appLanguage.carDescription8,
          Utils.escrowUrl),
      CarouselItem(_appLanguage.carTitle9, _appLanguage.carDescription9,
          Utils.refuelUrl),
      CarouselItem(_appLanguage.carTitle6, _appLanguage.carDescription7,
          Utils.governUrl),
    ];
    setCarouselItems(i);
    notifyListeners();
  }
}
