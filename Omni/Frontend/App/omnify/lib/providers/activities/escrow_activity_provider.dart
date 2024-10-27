import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../crypto/features/escrow_utils.dart';
import '../../models/escrow_contract.dart';
import '../../languages/app_language.dart';
import '../../utils.dart';

class EscrowActivityProvider with ChangeNotifier {
  EscrowContract? _searchedContract;
  bool _hasSearched = false;
  Chain _currentChain = Chain.Avalanche;
  int _contracts = 0;
  int _completedContracts = 0;
  int _deletedContracts = 0;
  int _bidsMade = 0;
  int _bidsReceived = 0;
  List<EscrowContract> _escrowContracts = [];
  Chain get currentChain => _currentChain;
  Future<void>? _fetchEscrowProfile;
  List<EscrowContract> get escrowContracts => _escrowContracts;
  bool get hasSearched => _hasSearched;
  EscrowContract? get searchedContract => _searchedContract;
  int get contracts => _contracts;
  int get completedContracts => _completedContracts;
  int get deletedContracts => _deletedContracts;
  int get bidsMade => _bidsMade;
  int get bidsReceived => _bidsReceived;
  Future<void>? get fetchEscrowProfile => _fetchEscrowProfile;
  void setHasSearched(bool h) {
    _hasSearched = h;
    notifyListeners();
  }

  void setSearchedContract(EscrowContract? c) {
    _searchedContract = c;
    notifyListeners();
  }

  void setChain(Chain c, AppLanguage lang, Web3Client client,
      [String? address, bool? setFuture]) {
    _currentChain = c;
    _escrowContracts.clear();
    _contracts = 0;
    _completedContracts = 0;
    _deletedContracts = 0;
    _bidsMade = 0;
    _bidsReceived = 0;
    _searchedContract = null;
    _hasSearched = false;
    if (setFuture != null) {
      _fetchEscrowProfile = EscrowUtils.fetchEscrowActivityProfile(
          c: c,
          client: client,
          walletAddress: address!,
          initEscrowActivityProfile: initEscrowActivityProfile);
    }
    notifyListeners();
  }

  void setFuture(Chain c, String address, bool notify, Web3Client client) {
    _fetchEscrowProfile = EscrowUtils.fetchEscrowActivityProfile(
        c: c,
        client: client,
        walletAddress: address,
        initEscrowActivityProfile: initEscrowActivityProfile);
    _searchedContract = null;
    _hasSearched = false;
    if (notify) notifyListeners();
  }

  void setEscrowContracts(List<EscrowContract> c) {
    _escrowContracts = c;
    notifyListeners();
  }

  void setContracts(int c) {
    _contracts = c;
    notifyListeners();
  }

  void setCompletedContracts(int cc) {
    _completedContracts = cc;
    notifyListeners();
  }

  void setDeletedContracts(int dc) {
    _deletedContracts = dc;
    notifyListeners();
  }

  void setBidsMade(int bm) {
    _bidsMade = bm;
    notifyListeners();
  }

  void setBidsReceived(int br) {
    _bidsReceived = br;
    notifyListeners();
  }

  void initEscrowActivityProfile({
    required int paramContracts,
    required int paramCompletes,
    required int paramDeleteds,
    required int paramBidsMade,
    required int paramBidsReceived,
    required List<EscrowContract> paramEscrowContracts,
  }) {
    setContracts(paramContracts);
    setCompletedContracts(paramCompletes);
    setDeletedContracts(paramDeleteds);
    setBidsMade(paramBidsMade);
    setBidsReceived(paramBidsReceived);
    setEscrowContracts(paramEscrowContracts);
  }
}
