import 'package:flutter/foundation.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../languages/app_language.dart';
import '../../crypto/features/trust_utils.dart';
import '../../models/bridge_asset.dart';
import '../../models/deposit.dart';
import '../../utils.dart';

class TrustActivityProvider with ChangeNotifier {
  Chain _currentChain = Chain.Avalanche;
  List<BridgeAsset> _withdrawnAssets = [];
  List<BridgeAsset> _availableAssets = [];
  List<Deposit> _deposits = [];
  Future<void>? _fetchTrustProfile;
  Chain get currentChain => _currentChain;
  List<BridgeAsset> get withdrawnAssets => _withdrawnAssets;
  List<BridgeAsset> get availableAssets => _availableAssets;
  Future<void>? get fetchTrustProfile => _fetchTrustProfile;
  List<Deposit> get deposits => _deposits;
  void setChain(Chain c, AppLanguage lang, Web3Client client,
      [String? address, bool? setFuture]) {
    _currentChain = c;
    _withdrawnAssets.clear();
    _availableAssets.clear();
    _deposits.clear();
    if (setFuture != null) {
      _fetchTrustProfile = TrustUtils.fetchTrustProfile(
          c: c,
          client: client,
          walletAddress: address!,
          initTrustProfile: initTrustProfile);
    }
    notifyListeners();
  }

  void setWithdrawnAssets(List<BridgeAsset> wa) {
    _withdrawnAssets = wa;
    notifyListeners();
  }

  void setAvailableAssets(List<BridgeAsset> as) {
    _availableAssets = as;
    notifyListeners();
  }

  void setDeposits(List<Deposit> d) {
    _deposits = d;
    notifyListeners();
  }

  void setFuture(Chain c, String address, bool notify, Web3Client client) {
    _fetchTrustProfile = TrustUtils.fetchTrustProfile(
        c: c,
        client: client,
        walletAddress: address,
        initTrustProfile: initTrustProfile);
    if (notify) notifyListeners();
  }

  void initTrustProfile({
    required List<BridgeAsset> paramWithdrawnAssets,
    required List<BridgeAsset> paramAvailableAssets,
    required List<Deposit> paramDeposits,
  }) {
    setWithdrawnAssets(paramWithdrawnAssets);
    setAvailableAssets(paramAvailableAssets);
    setDeposits(paramDeposits);
  }
}
