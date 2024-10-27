import 'package:flutter/foundation.dart';
import 'package:omnify/crypto/features/escrow_utils.dart';
import 'package:web3dart/web3dart.dart';

import '../languages/app_language.dart';
import '../models/escrow_contract.dart';
import '../utils.dart';

class EscrowsProvider with ChangeNotifier {
  bool _hasSearched = false;
  bool _isSearching = false;
  EscrowContract? _searchedContract;
  Chain _currentChain = Chain.Avalanche;
  List<EscrowContract> _escrowContracts = [];
  Future<List<EscrowContract>>? _getContracts;
  Chain get currentChain => _currentChain;
  List<EscrowContract> get escrowContracts => _escrowContracts;
  Future<List<EscrowContract>>? get getContracts => _getContracts;
  bool get hasSearched => _hasSearched;
  bool get isSearching => _isSearching;
  EscrowContract? get searchedContract => _searchedContract;
  void setChain(Chain c, AppLanguage lang, Web3Client client,
      [String? address, bool? setFuture]) {
    _currentChain = c;
    _escrowContracts.clear();
    if (setFuture != null) {
      _getContracts = EscrowUtils.fetchTabContracts(
          c: c, client: client, walletAddress: address!);
    }
    _hasSearched = false;
    _isSearching = false;
    _searchedContract = null;
    notifyListeners();
  }

  void setEscrowContracts(List<EscrowContract> c, bool notify) {
    _escrowContracts = c;
    _escrowContracts.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    if (notify) notifyListeners();
  }

  void setSearchedContract(EscrowContract? c) {
    _searchedContract = c;
    notifyListeners();
  }

  void setHasSearched(bool h) {
    _hasSearched = h;
    notifyListeners();
  }

  void setIsSearching(bool s) {
    _isSearching = s;
    notifyListeners();
  }

  void setFuture(Chain c, String address, bool notify, Web3Client client) {
    _getContracts = EscrowUtils.fetchTabContracts(
        c: c, client: client, walletAddress: address);
    _hasSearched = false;
    _isSearching = false;
    _searchedContract = null;
    if (notify) notifyListeners();
  }
}
