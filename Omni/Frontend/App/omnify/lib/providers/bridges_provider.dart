import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../crypto/features/bridge_utils.dart';
import '../languages/app_language.dart';
import '../models/asset.dart';
import '../utils.dart';

class BridgesProvider with ChangeNotifier {
  Chain _currentSourceChain = Chain.Avalanche;
  Chain _currentTargetChain = Chain.Celo;
  TextEditingController? _amountController;
  TextEditingController? _addressController;
  bool _isReturningBridgedAsset = false;
  CryptoAsset _currentSourceAsset = CryptoAsset(
      logoUrl:
          "https://github.com/OmniKobra/Omnify/blob/main/assets/usd-coin-usdc-logo.png?raw=true",
      address: "0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E",
      name: '',
      symbol: 'USDC',
      decimals: 6);
  CryptoAsset? _currentDestinationAsset;
  Chain get currentSourceChain => _currentSourceChain;
  Chain get currentTargetChain => _currentTargetChain;
  CryptoAsset get currentSourceAsset => _currentSourceAsset;
  CryptoAsset? get currentDestinationAsset => _currentDestinationAsset;
  bool get isReturningBridgedAsset => _isReturningBridgedAsset;
  TextEditingController get amountController => _amountController!;
  TextEditingController get addressController => _addressController!;

  void initControllers() {
    _amountController = TextEditingController();
    _addressController = TextEditingController();
  }

  void disposeAmountController() {
    _amountController?.dispose();
  }

  void disposeAddressController() {
    _addressController?.dispose();
  }

  void setSourceChain(Chain c, AppLanguage lang, bool notify,
      [Web3Client? client, Web3App? wcClient]) {
    // if (c != _currentSourceChain && c != _currentTargetChain) {
    if (c == Chain.Hedera || c == Chain.Ronin || c == Chain.Cronos) {
      _currentSourceChain = Chain.Avalanche;
      if (client != null && wcClient != null) {
        setSourceAsset(Utils.generateNativeUSDT(c), client, wcClient);
      } else {
        _currentSourceAsset = Utils.generateNativeUSDT(c);
      }
    } else {
      _currentSourceChain = c;
      if (client != null && wcClient != null) {
        setSourceAsset(Utils.generateNativeUSDT(c), client, wcClient);
      } else {
        _currentSourceAsset = Utils.generateNativeUSDT(c);
      }
    }
    if (_amountController != null) {
      _amountController!.clear();
    }
    if (notify) notifyListeners();
    // }
  }

  void setTargetChain(Chain c, AppLanguage lang, bool notify,
      [Web3Client? client, Web3App? wcClient]) async {
    if (c == Chain.Hedera ||
        c == Chain.Ronin ||
        c == Chain.Cronos ||
        c == _currentSourceChain) {
      if (c != _currentTargetChain) {
      } else {
        if (_currentSourceChain == Chain.Avalanche) {
          _currentTargetChain = Chain.Celo;
        } else {
          _currentTargetChain = Chain.Avalanche;
        }
      }
    } else {
      _currentTargetChain = c;
    }
    if (_addressController != null) {
      _addressController!.clear();
    }
    if (notify) notifyListeners();
    if (client != null && wcClient != null) {
      var fetch = await BridgeUtils.fetchAssetEquivalent(
          c: _currentSourceChain,
          targetChain: _currentTargetChain,
          client: client,
          wcClient: wcClient,
          asset: _currentSourceAsset);
      setDestinationAsset(fetch[0], fetch[1]);
    }
  }

  Future<void> setSourceAsset(
      CryptoAsset a, Web3Client client, Web3App wcClient) async {
    _currentSourceAsset = a;
    notifyListeners();
    var fetch = await BridgeUtils.fetchAssetEquivalent(
        c: _currentSourceChain,
        targetChain: _currentTargetChain,
        client: client,
        wcClient: wcClient,
        asset: _currentSourceAsset);
    setDestinationAsset(fetch[0], fetch[1]);
  }

  void setDestinationAsset(CryptoAsset? a, bool _isReturn) {
    _currentDestinationAsset = a;
    _isReturningBridgedAsset = _isReturn;
    Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
