// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

import '../languages/app_language.dart';
import '../models/asset.dart';
import '../models/beneficiary.dart';
import '../models/deposit.dart';
import '../utils.dart';

enum TrustFocus { search, deposit }

class TrustsProvider with ChangeNotifier {
  TrustFocus _withdrawalFocus = TrustFocus.search;
  TrustFocus _manageFocus = TrustFocus.search;
  Chain _currentChain = Chain.Avalanche;
  TextEditingController? _amountController;
  CryptoAsset _currentAsset = CryptoAsset(
      logoUrl: "",
      address: '0x0000000000000000000000000000000000000000',
      name: '',
      symbol: 'Avax',
      decimals: 18);
  Deposit? _withdrawalTabDeposit;
  Deposit? _manageTabDeposit;
  List<Beneficiary> _beneficiaries = [];
  List<String> _owners = [];
  Chain get currentChain => _currentChain;
  CryptoAsset get currentAsset => _currentAsset;
  TrustFocus get withdrawalFocus => _withdrawalFocus;
  TrustFocus get manageFocus => _manageFocus;
  Deposit? get withdrawalTabDeposit => _withdrawalTabDeposit;
  Deposit? get manageTabDeposit => _manageTabDeposit;
  TextEditingController get amountController => _amountController!;
  List<Beneficiary> get beneficiaries => _beneficiaries;
  List<String> get owners => _owners;

  void setWithdrawalFocus() {
    _withdrawalFocus = TrustFocus.deposit;
    notifyListeners();
  }

  void setManageFocus() {
    _manageFocus = TrustFocus.deposit;
    notifyListeners();
  }

  void initAmountController() {
    _amountController = TextEditingController();
  }

  void disposeAmountController() {
    _amountController?.dispose();
  }

  void setChain(Chain c, AppLanguage lang) {
    if (c != currentChain) {
      _currentChain = c;
      _beneficiaries.clear();
      _owners.clear();
      if (_amountController != null) {
        _amountController!.clear();
      }
      setCurrentAsset(Utils.generateNativeToken(c));
      _withdrawalFocus = TrustFocus.search;
      _manageFocus = TrustFocus.search;
      _withdrawalTabDeposit = null;
      _manageTabDeposit = null;
      notifyListeners();
    }
  }
  

  void setCurrentAsset(CryptoAsset a) {
    _currentAsset = a;
    notifyListeners();
  }

  void addBeneficiary(Beneficiary b) {
    if (!_beneficiaries.any((bd) => bd.address == b.address)) {
      _beneficiaries.add(b);
      notifyListeners();
    }
  }

  void removeBeneficiary(Beneficiary b) {
    if (_beneficiaries.contains(b)) {
      _beneficiaries.remove(b);
      notifyListeners();
    }
  }

  void modifyBeneficiary(Beneficiary current, Beneficiary b) {
    if (_beneficiaries.contains(current)) {
      final i = _beneficiaries.indexOf(current);
      _beneficiaries[i] = b;
      notifyListeners();
    }
  }

  void addOwner(String a, [bool? dontNotify]) {
    if (!_owners.contains(a)) {
      _owners.add(a);
      if (dontNotify == null) {
        notifyListeners();
      }
    }
  }

  void removeOwner(String a) {
    if (_owners.contains(a)) {
      _owners.remove(a);
      notifyListeners();
    }
  }

  void setWithdrawalDeposit(Deposit d) {
    _withdrawalTabDeposit = d;
    notifyListeners();
  }

  void setManageDeposit(Deposit d) {
    _manageTabDeposit = d;
    notifyListeners();
  }
}
