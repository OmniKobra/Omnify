// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'crypto/utils/sensitive.dart';
import '../../utils.dart';

class ThemePreferences {
  static const isDark = 'dark';
  static const lang = 'lang';
  static const homeChain = 'homeChain';
  static const pairingTopic = Sensitive.pairingTopic;
  static const sessionTopic = Sensitive.sessionTopic;
  static Chain stringToChain(String chainName) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (chainName) {
      case 'Blast':
        return Chain.Blast;
      case 'Fuji':
        return Chain.Fuji;
      case 'BNBT':
        return Chain.BNBT;
      case 'Avalanche':
        return Chain.Avalanche;
      case 'Optimism':
        return Chain.Optimism;
      case 'Ethereum':
        return Chain.Ethereum;
      case 'BSC':
        return Chain.BSC;
      case 'Arbitrum':
        return Chain.Arbitrum;
      case 'Polygon':
        return Chain.Polygon;
      case 'Fantom':
        return Chain.Fantom;
      case 'Tron':
        return Chain.Tron;
      case 'Base':
        return Chain.Base;
      case 'Linea':
        return Chain.Linea;
      case 'Cronos':
        return Chain.Cronos;
      case 'Mantle':
        return Chain.Mantle;
      case 'Gnosis':
        return Chain.Gnosis;
      case 'Kava':
        return Chain.Kava;
      case 'Ronin':
        return Chain.Ronin;
      case 'Zksync':
        return Chain.Zksync;
      case 'Celo':
        return Chain.Celo;
      case 'Scroll':
        return Chain.Scroll;
      case 'Hedera':
        return Chain.Hedera;
      default:
        return Chain.Avalanche;
    }
  }

  setSessionProperties(Map<String, String> seshProps) {}
  setChain(Chain c) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(homeChain, c.name);
  }

  setDarkMode(bool mode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(isDark, mode);
  }

  setLanguage(String newCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(lang, newCode);
  }

  setPairingTopic(String newTopic) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(pairingTopic, newTopic);
  }

  setSessionTopic(String newSessionTopic) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(sessionTopic, newSessionTopic);
  }

  String giveLanguageFromCode(String code) {
    // all lang codes are here https://www.iana.org/assignments/language-subtag-registry
    switch (code) {
      case 'en':
        return 'en';
      case 'ar':
        return 'ar';
      case 'tr':
        return 'tr';
      case 'fr':
        return 'fr';
      default:
        return 'en';
    }
  }

  String determineStartingLanguage(BuildContext context) {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final lang = locale.languageCode;
    return giveLanguageFromCode(lang);
  }

  bool determineTheme() {
    if (ThemeMode.system == ThemeMode.dark) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<dynamic>> getTheme(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var appLang =
        sharedPreferences.getString(lang) ?? determineStartingLanguage(context);
    var darkMode = sharedPreferences.getBool(isDark) ?? determineTheme();
    var chain = sharedPreferences.getString(homeChain) ?? "Avalanche";
    var theTopic = sharedPreferences.getString(pairingTopic) ?? "";
    var theSessionTopic = sharedPreferences.getString(sessionTopic) ?? "";
    var networkChain = stringToChain(chain);
    return [appLang, darkMode, networkChain, theTopic, theSessionTopic];
  }
}
