import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';

import '../crypto/features/ico_utils.dart';
import '../languages/app_language.dart';
import '../utils.dart';

class IcoProvider with ChangeNotifier {
  Chain _currentChain = Chain.Avalanche;
  DateTime _icoStart = DateTime.now();
  DateTime _icoEnd = DateTime.now();
  Decimal _startingPrice = Decimal.parse("0.0");
  String _omnicoinAddress = "";
  Future<void>? _initializeIco;

  int _remainingCoins = 0;
  int _soldCoins = 0;
  final int _offeredCoins = 218750;

  int get totalSupply => 250000;
  int get soldCoins => _soldCoins;
  int get offeredCoins => _offeredCoins;
  int get remainingCoins => _remainingCoins;

  Chain get currentChain => _currentChain;
  Decimal get startingPrice => _startingPrice;
  DateTime get icoStart => _icoStart;
  DateTime get icoEnd => _icoEnd;
  String get omnicoinAddress => _omnicoinAddress;
  Future<void>? get initializeIco => _initializeIco;

  void setChain(Chain c, AppLanguage lang, Web3Client client,
      [String? address, bool? setFuture]) {
    _currentChain = c;
    if (setFuture != null) {
      _initializeIco =
          IcoUtils.fetchIco(c: c, client: client, initialize: initIco);
    }
    notifyListeners();
  }

  void setFuture(Chain c, Web3Client client, bool notify) {
    _initializeIco =
        IcoUtils.fetchIco(c: c, client: client, initialize: initIco);
    if (notify) notifyListeners();
  }

  void setIcoStart(DateTime d) {
    _icoStart = d;
    notifyListeners();
  }

  void setIcoEnd(DateTime d) {
    _icoEnd = d;
    notifyListeners();
  }

  void setStartingPrice(Decimal p) {
    _startingPrice = p;
    notifyListeners();
  }

  void setRemainingCoins(int r) {
    _remainingCoins = r;
    notifyListeners();
  }

  void setSoldCoins(int s) {
    _soldCoins = s;
    notifyListeners();
  }

  void buyCoins(int amount) {
    _soldCoins += amount;
    _remainingCoins -= amount;
    notifyListeners();
  }

  void setOmnicoinAddress(String addr) {
    _omnicoinAddress = addr;
    notifyListeners();
  }

  void initIco({
    required int paramAvailableCoins,
    required int paramSoldCoins,
    required Decimal paramPricePerCoin,
    required DateTime paramIcoStart,
    required DateTime paramIcoEnd,
    required String paramOmnicoinAddress,
  }) {
    setRemainingCoins(paramAvailableCoins);
    setSoldCoins(paramSoldCoins);
    setStartingPrice(paramPricePerCoin);
    setIcoStart(paramIcoStart);
    setIcoEnd(paramIcoEnd);
    setOmnicoinAddress(paramOmnicoinAddress);
  }
}
