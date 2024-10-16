import 'package:flutter/foundation.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../crypto/features/bridge_utils.dart';
import '../../languages/app_language.dart';
import '../../models/bridge_asset.dart';
import '../../utils.dart';

class BridgeActivityProvider with ChangeNotifier {
  Chain _currentChain = Chain.Avalanche;
  List<BridgeAsset> _migratedAssets = [];
  List<BridgeAsset> _receivedAssets = [];
  List<BridgeTransaction> _allTransactions = [];
  List<BridgeTransaction> _transactions = [];
  Future<void>? _fetchBridgeProfile;
  Chain get currentChain => _currentChain;
  List<BridgeAsset> get migratedAssets => _migratedAssets;
  List<BridgeAsset> get receivedAssets => _receivedAssets;
  List<BridgeTransaction> get transactions => _transactions;
  List<BridgeTransaction> get allTransactions => _allTransactions;
  Future<void>? get fetchBridgeProfile => _fetchBridgeProfile;
  void setChain(Chain c, AppLanguage lang, Web3Client client,
      [String? address, bool? setFuture]) {
    if (c == Chain.Hedera || c == Chain.Ronin || c == Chain.Cronos) {
      _currentChain = Chain.Avalanche;
    } else {
      _currentChain = c;
    }
    _migratedAssets.clear();
    _receivedAssets.clear();
    _allTransactions.clear();
    _transactions.clear();
    if (setFuture != null) {
      _fetchBridgeProfile = BridgeUtils.fetchBridgeProfile(
          c: c,
          client: client,
          walletAddress: address!,
          initBridgeProfile: initBridgeProfile);
    }
    notifyListeners();
  }

  void setFuture(Chain c, String address, bool notify, Web3Client client) {
    _fetchBridgeProfile = BridgeUtils.fetchBridgeProfile(
        c: c,
        client: client,
        walletAddress: address,
        initBridgeProfile: initBridgeProfile);
    if (notify) notifyListeners();
  }

  void setMigratedAssets(List<BridgeAsset> a) {
    _migratedAssets = a;
    notifyListeners();
  }

  void setReceivedAssets(List<BridgeAsset> a) {
    _receivedAssets = a;
    notifyListeners();
  }

  void setTransactions(List<BridgeTransaction> t) {
    _allTransactions = t;
    _allTransactions.sort((a, b) => b.date.compareTo(a.date));
    if (_allTransactions.length > Utils.pageSize) {
      _transactions = _allTransactions.take(Utils.pageSize).toList();
    } else {
      _transactions = _allTransactions;
    }
    // notifyListeners();
  }

  void showMore() {
    var difference = _allTransactions.length - _transactions.length;
    var lastShownId = _transactions.last.id;
    var indexInAll = _allTransactions.indexWhere((e) => e.id == lastShownId);
    if (difference > Utils.pageSize) {
      var nextItems = _allTransactions.getRange(
          indexInAll + 1, indexInAll + Utils.pageSize);
      _transactions.addAll(nextItems);
    } else {
      var nextItems =
          _allTransactions.getRange(indexInAll + 1, _allTransactions.length);
      _transactions.addAll(nextItems);
    }
    notifyListeners();
  }

  void initBridgeProfile({
    required List<BridgeAsset> paramMigratedAssets,
    required List<BridgeAsset> paramReceivedAssets,
    required List<BridgeTransaction> paramTransactions,
  }) {
    setMigratedAssets(paramMigratedAssets);
    setReceivedAssets(paramReceivedAssets);
    setTransactions(paramTransactions);
  }
}
