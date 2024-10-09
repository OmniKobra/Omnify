import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../crypto/utils/chain_utils.dart';
import '../crypto/utils/network_utils.dart';
import '../models/asset.dart';
import '../widgets/common/connect_wallet_sheet.dart';
import '../utils.dart';
// import '../widgets/common/connect_wallet_sheet.dart';

class WalletProvider with ChangeNotifier {
  bool _walletConnected = false;
  bool _tronWalletConnected = false;
  bool _walletSheetOpen = false;
  int _addressEnergyAmount = 0;

  List<CryptoAsset> _myAssets = [];
  Map<Chain, String> _myAddresses = {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    //TODO REMOVE TESTERS BEFORE DEPLOYMENT
    //TODO REMOVE CHAIN SUPPORT HERE

    // Chain.Fuji: '',
    // Chain.BNBT: '',
    Chain.Avalanche: '',
    Chain.Optimism: '',
    // Chain.Ethereum: '',
    Chain.BSC: '',
    Chain.Arbitrum: '',
    Chain.Polygon: '',
    Chain.Fantom: '',
    // Chain.Tron: '',
    Chain.Base: '',
    Chain.Linea: '',
    Chain.Mantle: '',
    Chain.Gnosis: '',
    // Chain.Ronin: '',
    Chain.Zksync: '',
    Chain.Celo: '',
    Chain.Scroll: '',
    Chain.Blast: '',
  };
  List<Chain> _supportedChains = [
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    //TODO REMOVE TESTERS BEFORE DEPLOYMENT
    //TODO REMOVE CHAIN SUPPORT HERE

    // Chain.Fuji,
    // Chain.BNBT,
    Chain.Avalanche,
    Chain.Optimism,
    // Chain.Ethereum,
    Chain.BSC,
    Chain.Arbitrum,
    Chain.Polygon,
    Chain.Fantom,
    // Chain.Tron,
    Chain.Base,
    Chain.Linea,
    Chain.Mantle,
    Chain.Gnosis,
    // Chain.Ronin,
    Chain.Zksync,
    Chain.Celo,
    Chain.Scroll,
    Chain.Blast
  ];

  // bool get walletConnected => _walletConnected;
  // bool get tronWalletConnected => _tronWalletConnected;
  bool get isWalletConnected => _walletConnected || _tronWalletConnected;
  bool get walletSheetOpen => _walletSheetOpen;
  // String get walletAddress => _walletAddress;
  // String get tronWalletAddress => _tronWalletAddress;
  int get addressEnergyAmount => _addressEnergyAmount;
  Map<Chain, String> get myAddresses => _myAddresses;
  String addressSubstring(Chain c) {
    if (c != Chain.Tron) {
      if (_myAddresses[c]!.isEmpty) {
        return '';
      } else {
        return _myAddresses[c]!.substring(0, 4) +
            ".." +
            _myAddresses[c]!.substring(38, 42);
      }
    } else {
      if (_myAddresses[c]!.isEmpty) {
        return '';
      } else {
        return _myAddresses[c]!.substring(0, 4) +
            ".." +
            _myAddresses[c]!.substring(30, 34);
      }
    }
  }

  String getAddressString(Chain c) {
    if (c == Chain.Tron) {
      return _myAddresses[c]!;
    } else {
      return _myAddresses[c]!;
    }
  }

  List<CryptoAsset> get myAssets => _myAssets;
  List<Chain> get supportedChains => _supportedChains;
  void walletSheetClose() {
    _walletSheetOpen = false;
    notifyListeners();
  }

  void connectWallet(BuildContext context) async {
    if (!_walletConnected) {
      FocusScope.of(context).unfocus();
      _walletSheetOpen = true;
      showBottomSheet(
          context: context,
          enableDrag: false,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return const ConnectWalletSheet();
          });
      notifyListeners();
    }
  }

  void setChainAddress(Chain c, String address) {
    _myAddresses[c] = address;
    // notifyListeners();
  }

  void setSupportedChains(List<Chain> cs) {
    _supportedChains = cs;
    notifyListeners();
  }

  void addSupportedChain(Chain c) {
    if (!_supportedChains.contains(c)) {
      _supportedChains.add(c);
      notifyListeners();
    }
  }

  void resetSupportedChains() {
    _supportedChains = [
      //TODO ADD NEXT SUPPORTED NETWORKS HERE
      //TODO REMOVE TESTERS BEFORE DEPLOYMENT
      //TODO REMOVE CHAIN SUPPORT HERE

      // Chain.Fuji,
      // Chain.BNBT,
      Chain.Avalanche,
      Chain.Optimism,
      // Chain.Ethereum,
      Chain.BSC,
      Chain.Arbitrum,
      Chain.Polygon,
      Chain.Fantom,
      // Chain.Tron,
      Chain.Base,
      Chain.Linea,
      Chain.Mantle,
      Chain.Gnosis,
      // Chain.Ronin,
      Chain.Zksync,
      Chain.Celo,
      Chain.Scroll,
      Chain.Blast
    ];
    notifyListeners();
  }

  void removeSupportedChain(Chain c) {
    _supportedChains.remove(c);
    notifyListeners();
  }

  void removeEvmChains() {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    //TODO REMOVE TESTERS BEFORE DEPLOYMENT
    //TODO REMOVE CHAIN SUPPORT HERE

    // _supportedChains.remove(Chain.Fuji);
    // _supportedChains.remove(Chain.BNBT);
    _supportedChains.remove(Chain.Avalanche);
    _supportedChains.remove(Chain.Optimism);
    // _supportedChains.remove(Chain.Ethereum);
    _supportedChains.remove(Chain.BSC);
    _supportedChains.remove(Chain.Arbitrum);
    _supportedChains.remove(Chain.Polygon);
    _supportedChains.remove(Chain.Fantom);
    _supportedChains.remove(Chain.Base);
    _supportedChains.remove(Chain.Linea);
    _supportedChains.remove(Chain.Mantle);
    _supportedChains.remove(Chain.Gnosis);
    // _supportedChains.remove(Chain.Tron);
    // _supportedChains.remove(Chain.Ronin);
    _supportedChains.remove(Chain.Zksync);
    _supportedChains.remove(Chain.Celo);
    _supportedChains.remove(Chain.Scroll);
    _supportedChains.remove(Chain.Blast);
    notifyListeners();
  }

  void setAddressEnergy(int e) {
    _addressEnergyAmount = e;
    notifyListeners();
  }

  bool? useTronEnergy(int energyGasFee) {
    if (_walletConnected &&
        _addressEnergyAmount > 0 &&
        _addressEnergyAmount >= energyGasFee) {
      return true;
    }
    return null;
  }

  void deductTronEnergy(int energyGasFee) {
    if (_addressEnergyAmount >= energyGasFee) {
      _addressEnergyAmount -= energyGasFee;
    }
  }

  void setMyAssets(List<CryptoAsset> ma, Chain c) async {
    _myAssets.clear();
    if (!_myAssets.any((a) => a.address == Utils.zeroAddress)) {
      _myAssets.add(Utils.generateNativeToken(c));
    }
    _myAssets.addAll(ma);
    notifyListeners();
  }

  void setWalletConnected(String address, bool notify) {
    _walletConnected = true;
    if (notify) notifyListeners();
  }

  void setTronWalletConnected(String a, bool notify) {
    _tronWalletConnected = true;
    if (notify) notifyListeners();
  }

  EthereumAddress walletEthAddress(Chain c) =>
      ChainUtils.ethAddressFromHex(c, _myAddresses[c]!);

  Future<void> getAndSetAssets(Chain c) async {
    if (_walletConnected) {
      try {
        _myAssets = [Utils.generateNativeToken(c)];
        List<CryptoAsset> assets =
            await ScannerUtils.getTokenHoldings(_myAddresses[c]!, c);
        setMyAssets(assets, c);
      } catch (e) {
        _myAssets = [Utils.generateNativeToken(c)];
        print("error while getting assets: $e");
        //TODO TELL USER COULDNT GET THEIR ASSETS
      }
    } else {
      _myAssets = [Utils.generateNativeToken(c)];
    }
  }

  void disconnectWallet(Chain c) {
    _walletConnected = false;
    _tronWalletConnected = false;
    _supportedChains = Utils.ourChains;
    _myAddresses = {
      //TODO ADD NEXT SUPPORTED NETWORKS HERE
      //TODO REMOVE TESTERS BEFORE DEPLOYMENT
      //TODO REMOVE CHAIN SUPPORT HERE

      // Chain.Fuji: '',
      // Chain.BNBT: '',
      Chain.Avalanche: '',
      Chain.Optimism: '',
      // Chain.Ethereum: '',
      Chain.BSC: '',
      Chain.Arbitrum: '',
      Chain.Polygon: '',
      Chain.Fantom: '',
      // Chain.Tron: '',
      Chain.Base: '',
      Chain.Linea: '',
      Chain.Mantle: '',
      Chain.Gnosis: '',
      // Chain.Ronin: '',
      Chain.Zksync: '',
      Chain.Celo: '',
      Chain.Scroll: '',
      Chain.Blast: '',
    };
    _myAssets = [Utils.generateNativeToken(c)];
    notifyListeners();
  }
}
