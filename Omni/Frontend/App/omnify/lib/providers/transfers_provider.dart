import 'package:card_swiper/card_swiper.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../languages/app_language.dart';
import '../models/transfer.dart';
import '../utils.dart';

class TransfersProvider with ChangeNotifier {
  Vision _vision = Vision.transfer;
  Chain _currentChain = Chain.Avalanche;
  final SwiperController _swiperController = SwiperController();
  List<TransferFormModel> _transfers = [];
  int _currentIndex = 0;
  Chain get currentChain => _currentChain;

  List<TransferFormModel> get transfers => _transfers;
  int get currentIndex => _currentIndex;
  SwiperController get swiperController => _swiperController;
  Vision get vision => _vision;
  void setChain(Chain c, AppLanguage lang, String address) {
    _currentChain = c;
    clearTransfers(address);
    notifyListeners();
  }

  void setTransfers(List<TransferFormModel> t) {
    _transfers = t;
    // notifyListeners();
  }

  void setIndex(int i) {
    _currentIndex = i;
    notifyListeners();
  }

  void setVision(Vision v) {
    _vision = v;
    notifyListeners();
  }

  void addTransfer(String address) {
    _transfers.add(TransferFormModel(
        asset: _transfers.isEmpty
            ? Utils.generateNativeToken(_currentChain)
            : _transfers.last.asset,
        id: Utils.generateID(address, DateTime.now()),
        amount: TextEditingController(),
        recipient: TextEditingController(),
        day: TextEditingController(),
        month: TextEditingController(),
        year: TextEditingController(),
        hour: TextEditingController(),
        minute: TextEditingController(),
        formkey: GlobalKey<FormState>(),
        isInstant: true,
        isScheduled: false,
        am: true,
        pm: false,
        vision: Vision.transfer,
        gasFee: Decimal.parse("0"),
        omnifyFee: Decimal.parse("0"),
        totalFee: Decimal.parse("0")));
    notifyListeners();
  }

  void removeTransfer() {
    _transfers.removeAt(currentIndex);
    notifyListeners();
  }

  void disposer() {
    for (var transfer in _transfers) {
      transfer.recipient.dispose();
      transfer.amount.removeListener(() {});
      transfer.amount.dispose();
      transfer.day.dispose();
      transfer.month.dispose();
      transfer.year.dispose();
      transfer.hour.dispose();
      transfer.minute.dispose();
    }
  }

  void clearTransfers(String address) {
    for (var transfer in _transfers) {
      transfer.recipient.dispose();
      transfer.amount.removeListener(() {});
      transfer.amount.dispose();
      transfer.day.dispose();
      transfer.month.dispose();
      transfer.year.dispose();
      transfer.hour.dispose();
      transfer.minute.dispose();
    }
    final id = Utils.generateID(address, DateTime.now());
    _transfers.clear();
    _transfers.add(TransferFormModel(
        asset: Utils.generateNativeToken(_currentChain),
        id: id,
        amount: TextEditingController(),
        recipient: TextEditingController(),
        day: TextEditingController(),
        month: TextEditingController(),
        year: TextEditingController(),
        hour: TextEditingController(),
        formkey: GlobalKey<FormState>(),
        minute: TextEditingController(),
        isInstant: true,
        isScheduled: false,
        am: true,
        pm: false,
        vision: Vision.transfer,
        gasFee: Decimal.parse("0"),
        omnifyFee: Decimal.parse("0"),
        totalFee: Decimal.parse("0")));
    _currentIndex = 0;
    notifyListeners();
  }

  void changeIndex(bool isAddition) {
    if (isAddition) {
      if (_currentIndex < _transfers.length - 1) {
        _currentIndex++;
      }
    } else {
      if (_currentIndex > 0 && _currentIndex - 1 > 0) {
        _currentIndex--;
      }
    }
  }
}
