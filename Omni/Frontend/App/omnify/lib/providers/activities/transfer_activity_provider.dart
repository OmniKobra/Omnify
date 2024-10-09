// ignore_for_file: non_constant_identifier_names, prefer_final_fields

import 'dart:collection';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';
import 'package:omnify/crypto/features/transfer_utils.dart';
import 'package:web3dart/web3dart.dart';

import '../../languages/app_language.dart';
import '../../models/asset.dart';
import '../../models/transfer_transaction.dart';
import '../../utils.dart';

class TransferActivityProvider with ChangeNotifier {
  int _sentNum = 0;
  int _receivedNum = 0;
  Future<void>? _fetchTransferProfile;
  CryptoAsset _currentAsset = CryptoAsset(
      logoUrl: "",
      address: '0x0000000000000000000000000000000000000000',
      name: '',
      symbol: 'Avax',
      decimals: 18);
  List<TransferActivityTransaction> _allTransactions = [];
  List<TransferActivityTransaction> _transactions = [];
  Chain _currentChain = Chain.Avalanche;
  Chain get currentChain => _currentChain;
  int get sentNum => _sentNum;
  int get receivedNum => _receivedNum;
  CryptoAsset get currentAsset => _currentAsset;
  List<TransferActivityTransaction> get transactions => _transactions;
  List<TransferActivityTransaction> get allTransactions => _allTransactions;
  Future<void>? get fetchTransferProfile => _fetchTransferProfile;
  void setChain(Chain c, AppLanguage lang, Web3Client client,
      [String? address, bool? setFuture]) {
    _currentChain = c;
    _sentNum = 0;
    _receivedNum = 0;
    _transactions.clear();
    _allTransactions.clear();
    if (setFuture != null) {
      _fetchTransferProfile =
          TransferUtils.fetchTransferProfile(c, client, address!, initProfile);
    }
    notifyListeners();
  }

  Map<String, double> getSentPieChart() {
    if (_allTransactions.isNotEmpty) {
      var sentTrxs = [..._allTransactions.where((t) => t.isOutgoing)];
      if (sentTrxs.isNotEmpty) {
        Map<String, Decimal> _vals = {};
        for (var tx in sentTrxs) {
          if (!_vals.containsKey(tx.asset.address)) {
            _vals[tx.asset.address] = Decimal.parse("0.0") + tx.amount;
          } else {
            _vals[tx.asset.address] = _vals[tx.asset.address]! + tx.amount;
          }
        }
        if (_vals.length > 1) {
          var splayed = SplayTreeMap<String, Decimal>.from(
              _vals, (key1, key2) => _vals[key2]!.compareTo(_vals[key1]!));
          if (splayed.length > 5) {
            Map<String, double> subMap = {};
            var splayedKeys = splayed.keys.toList().take(5);
            for (var k in splayedKeys) {
              var asset =
                  sentTrxs.firstWhere((t) => t.asset.address == k).asset;
              subMap[asset.symbol +
                      " " +
                      Utils.removeTrailingZeros(
                          splayed[k]!.toStringAsFixed(asset.decimals))] =
                  splayed[k]!.toDouble();
            }
            return subMap;
          } else {
            return splayed.map((k, v) {
              var trx = sentTrxs.firstWhere((t) => t.asset.address == k);
              var asset = trx.asset;
              return MapEntry(
                  asset.symbol +
                      " " +
                      Utils.removeTrailingZeros(
                          v.toStringAsFixed(asset.decimals)),
                  v.toDouble());
            });
          }
        } else {
          return _vals.map((k, v) {
            var trx = sentTrxs.firstWhere((t) => t.asset.address == k);
            var asset = trx.asset;
            return MapEntry(
                asset.symbol +
                    " " +
                    Utils.removeTrailingZeros(
                        v.toStringAsFixed(asset.decimals)),
                v.toDouble());
          });
        }
      } else {
        return {"": 0};
      }
    } else {
      return {"": 0};
    }
  }

  Map<String, double> getReceivedPieChart() {
    if (_allTransactions.isNotEmpty) {
      var sentTrxs = [..._allTransactions.where((t) => t.isOutgoing == false)];
      if (sentTrxs.isNotEmpty) {
        Map<String, Decimal> _vals = {};
        for (var tx in sentTrxs) {
          if (!_vals.containsKey(tx.asset.address)) {
            _vals[tx.asset.address] = Decimal.parse("0.0") + tx.amount;
          } else {
            _vals[tx.asset.address] = _vals[tx.asset.address]! + tx.amount;
          }
        }
        if (_vals.length > 1) {
          var splayed = SplayTreeMap<String, Decimal>.from(
              _vals, (key1, key2) => _vals[key2]!.compareTo(_vals[key1]!));
          if (splayed.length > 5) {
            Map<String, double> subMap = {};
            var splayedKeys = splayed.keys.toList().take(5);
            for (var k in splayedKeys) {
              var asset =
                  sentTrxs.firstWhere((t) => t.asset.address == k).asset;
              subMap[asset.symbol +
                      " " +
                      Utils.removeTrailingZeros(
                          splayed[k]!.toStringAsFixed(asset.decimals))] =
                  splayed[k]!.toDouble();
            }
            return subMap;
          } else {
            return splayed.map((k, v) {
              var trx = sentTrxs.firstWhere((t) => t.asset.address == k);
              var asset = trx.asset;
              return MapEntry(
                  asset.symbol +
                      " " +
                      Utils.removeTrailingZeros(
                          v.toStringAsFixed(asset.decimals)),
                  v.toDouble());
            });
          }
        } else {
          return _vals.map((k, v) {
            var trx = sentTrxs.firstWhere((t) => t.asset.address == k);
            var asset = trx.asset;
            return MapEntry(
                asset.symbol +
                    " " +
                    Utils.removeTrailingZeros(
                        v.toStringAsFixed(asset.decimals)),
                v.toDouble());
          });
        }
      } else {
        return {"": 0};
      }
    } else {
      return {"": 0};
    }
  }

  List<TransferActivityTransaction> getSents(
          List<TransferActivityTransaction> txs) =>
      txs.where((t) => t.isOutgoing).toList();
  List<TransferActivityTransaction> getReceiveds(
          List<TransferActivityTransaction> txs) =>
      txs.where((t) => !t.isOutgoing).toList();
  double folder(List<TransferActivityTransaction> ls) =>
      ls.fold(0.0, (previous, t) {
        var buffer = Utils.removeTrailingZeros(
            t.amount.toStringAsFixed(t.asset.decimals));
        return previous + double.parse(buffer);
      });

  Map<int, List<double>> getCurrentAssetDailies() {
    if (_allTransactions.isNotEmpty) {
      final _thisAssetTxs = [
        ..._allTransactions
            .where((t) => t.asset.address == _currentAsset.address)
      ];
      final nowDate = DateTime.now();
      final _now = Jiffy.parseFromDateTime(DateTime(
          nowDate.year, nowDate.month, nowDate.day, 23, 59, 59, 999, 999));
      List<TransferActivityTransaction> getDayTxs(int d) {
        return _thisAssetTxs.where((t) {
          final tDate = Jiffy.parseFromDateTime(t.date);
          var theDayAfter = _now.subtract(
              days: d - 1,
              hours: 23,
              minutes: 59,
              seconds: 59,
              milliseconds: 999,
              microseconds: 999);
          var theDayBefore = _now.subtract(days: d + 1);
          return tDate.isAfter(theDayBefore) && tDate.isBefore(theDayAfter);
        }).toList();
      }

      var txs_today = _thisAssetTxs.where((t) {
        final tdate = Jiffy.parseFromDateTime(t.date);
        return _now.diff(tdate, unit: Unit.day) < 1;
      }).toList();
      var sent_today = getSents(txs_today);
      var received_today = getReceiveds(txs_today);
      var txs_1 = getDayTxs(1);
      var sent_txs_1 = getSents(txs_1);
      var received_txs_1 = getReceiveds(txs_1);
      var txs_2 = getDayTxs(2);
      var sent_txs_2 = getSents(txs_2);
      var received_txs_2 = getReceiveds(txs_2);
      var txs_3 = getDayTxs(3);
      var sent_txs_3 = getSents(txs_3);
      var received_txs_3 = getReceiveds(txs_3);
      var txs_4 = getDayTxs(4);
      var sent_txs_4 = getSents(txs_4);
      var received_txs_4 = getReceiveds(txs_4);
      var txs_5 = getDayTxs(5);
      var sent_txs_5 = getSents(txs_5);
      var received_txs_5 = getReceiveds(txs_5);
      var txs_6 = getDayTxs(6);
      var sent_txs_6 = getSents(txs_6);
      var received_txs_6 = getReceiveds(txs_6);
      final map = {
        0: [folder(received_txs_6), folder(sent_txs_6)],
        1: [folder(received_txs_5), folder(sent_txs_5)],
        2: [folder(received_txs_4), folder(sent_txs_4)],
        3: [folder(received_txs_3), folder(sent_txs_3)],
        4: [folder(received_txs_2), folder(sent_txs_2)],
        5: [folder(received_txs_1), folder(sent_txs_1)],
        6: [folder(received_today), folder(sent_today)]
      };
      return map;
    }
    var z = [0.00, 0.00];
    return {0: z, 1: z, 2: z, 3: z, 4: z, 5: z, 6: z};
  }

  int getMonthLastDay(int mo, int y) {
    if (mo == 2) {
      final div = y % 4;
      return div == 0 ? 29 : 28;
    } else {
      if (mo == 1 ||
          mo == 3 ||
          mo == 5 ||
          mo == 7 ||
          mo == 8 ||
          mo == 10 ||
          mo == 12) {
        return 31;
      } else {
        return 30;
      }
    }
  }

  Map<int, List<double>> getCurrentAssetMonthlies() {
    if (_allTransactions.isNotEmpty) {
      final _thisAssetTxs = [
        ..._allTransactions
            .where((t) => t.asset.address == _currentAsset.address)
      ];
      final nowDate = DateTime.now();
      final _now = Jiffy.parseFromDateTime(DateTime(nowDate.year, nowDate.month,
          getMonthLastDay(nowDate.month, nowDate.year), 23, 59, 59, 999, 999));
      List<TransferActivityTransaction> getMonthTxs(int m) {
        return _thisAssetTxs.where((t) {
          final tDate = Jiffy.parseFromDateTime(t.date);
          var theMonthAfter = _now.subtract(
              months: m - 1,
              days: getMonthLastDay(m - 1, nowDate.year),
              hours: 23,
              minutes: 59,
              seconds: 59,
              milliseconds: 999,
              microseconds: 999);
          var theMonthBefore = _now.subtract(months: m + 1);
          return tDate.isAfter(theMonthBefore) && tDate.isBefore(theMonthAfter);
        }).toList();
      }

      var txs_thisMonth = _thisAssetTxs.where((t) {
        final tdate = Jiffy.parseFromDateTime(t.date);
        return _now.diff(tdate, unit: Unit.month) < 1;
      }).toList();
      var sent_thisMonth = getSents(txs_thisMonth);
      var received_thisMonth = getReceiveds(txs_thisMonth);
      var txs_1 = getMonthTxs(1);
      var sent_txs_1 = getSents(txs_1);
      var received_txs_1 = getReceiveds(txs_1);
      var txs_2 = getMonthTxs(2);
      var sent_txs_2 = getSents(txs_2);
      var received_txs_2 = getReceiveds(txs_2);
      var txs_3 = getMonthTxs(3);
      var sent_txs_3 = getSents(txs_3);
      var received_txs_3 = getReceiveds(txs_3);
      var txs_4 = getMonthTxs(4);
      var sent_txs_4 = getSents(txs_4);
      var received_txs_4 = getReceiveds(txs_4);
      var txs_5 = getMonthTxs(5);
      var sent_txs_5 = getSents(txs_5);
      var received_txs_5 = getReceiveds(txs_5);
      var txs_6 = getMonthTxs(6);
      var sent_txs_6 = getSents(txs_6);
      var received_txs_6 = getReceiveds(txs_6);
      final map = {
        0: [folder(received_txs_6), folder(sent_txs_6)],
        1: [folder(received_txs_5), folder(sent_txs_5)],
        2: [folder(received_txs_4), folder(sent_txs_4)],
        3: [folder(received_txs_3), folder(sent_txs_3)],
        4: [folder(received_txs_2), folder(sent_txs_2)],
        5: [folder(received_txs_1), folder(sent_txs_1)],
        6: [folder(received_thisMonth), folder(sent_thisMonth)]
      };
      return map;
    }
    var z = [0.00, 0.00];
    return {0: z, 1: z, 2: z, 3: z, 4: z, 5: z, 6: z};
  }

  int daysThatYear(int y) {
    final div = y % 4;
    final daysInYear = div == 0 ? 366 : 365;
    return daysInYear;
  }

  Map<int, List<double>> getCurrentAssetYearlies() {
    if (_allTransactions.isNotEmpty) {
      final _thisAssetTxs = [
        ..._allTransactions
            .where((t) => t.asset.address == _currentAsset.address)
      ];
      final nowDate = DateTime.now();
      final _now = Jiffy.parseFromDateTime(
          DateTime(nowDate.year, 12, 31, 23, 59, 59, 999, 999));
      List<TransferActivityTransaction> getYearTxs(int y) {
        return _thisAssetTxs.where((t) {
          final tDate = Jiffy.parseFromDateTime(t.date);
          var theYearAfter = _now.subtract(
              years: y - 1,
              days: daysThatYear(y - 1),
              hours: 23,
              minutes: 59,
              seconds: 59,
              milliseconds: 999,
              microseconds: 999);
          var theYearBefore = _now.subtract(years: y + 1);
          return tDate.isAfter(theYearBefore) && tDate.isBefore(theYearAfter);
        }).toList();
      }

      var txs_thisYear = _thisAssetTxs.where((t) {
        final tdate = Jiffy.parseFromDateTime(t.date);
        return _now.diff(tdate, unit: Unit.year) < 1;
      }).toList();
      var sent_ThisYear = getSents(txs_thisYear);
      var received_ThisYear = getReceiveds(txs_thisYear);
      var txs_1 = getYearTxs(1);
      var sent_txs_1 = getSents(txs_1);
      var received_txs_1 = getReceiveds(txs_1);
      var txs_2 = getYearTxs(2);
      var sent_txs_2 = getSents(txs_2);
      var received_txs_2 = getReceiveds(txs_2);
      var txs_3 = getYearTxs(3);
      var sent_txs_3 = getSents(txs_3);
      var received_txs_3 = getReceiveds(txs_3);
      var txs_4 = getYearTxs(4);
      var sent_txs_4 = getSents(txs_4);
      var received_txs_4 = getReceiveds(txs_4);
      var txs_5 = getYearTxs(5);
      var sent_txs_5 = getSents(txs_5);
      var received_txs_5 = getReceiveds(txs_5);
      var txs_6 = getYearTxs(6);
      var sent_txs_6 = getSents(txs_6);
      var received_txs_6 = getReceiveds(txs_6);
      final map = {
        0: [folder(received_txs_6), folder(sent_txs_6)],
        1: [folder(received_txs_5), folder(sent_txs_5)],
        2: [folder(received_txs_4), folder(sent_txs_4)],
        3: [folder(received_txs_3), folder(sent_txs_3)],
        4: [folder(received_txs_2), folder(sent_txs_2)],
        5: [folder(received_txs_1), folder(sent_txs_1)],
        6: [folder(received_ThisYear), folder(sent_ThisYear)]
      };
      return map;
    }
    var z = [0.00, 0.00];
    return {0: z, 1: z, 2: z, 3: z, 4: z, 5: z, 6: z};
  }

  void setFuture(Chain c, String address, bool notify, Web3Client client) {
    _fetchTransferProfile =
        TransferUtils.fetchTransferProfile(c, client, address, initProfile);
    if (notify) notifyListeners();
  }

  List<CryptoAsset> getTransactionAssets() {
    List<CryptoAsset> _assets = [];
    _assets.add(Utils.generateNativeToken(_currentChain));
    if (_allTransactions.isNotEmpty) {
      for (var transaction in _allTransactions) {
        if (!_assets.any((a) => a.address == transaction.asset.address)) {
          _assets.add(transaction.asset);
        }
      }
    }
    return _assets;
  }

  void setCurrentAsset(CryptoAsset a) {
    _currentAsset = a;
    notifyListeners();
  }

  void setSentNum(int sn) {
    _sentNum = sn;
    notifyListeners();
  }

  void setReceivedNum(int rn) {
    _receivedNum = rn;
    notifyListeners();
  }

  void setTransactions(List<TransferActivityTransaction> t) {
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

  void initProfile({
    required int paramSentNum,
    required int paramReceivedNum,
    required List<TransferActivityTransaction> paramTransactions,
    required CryptoAsset paramCryptoAsset,
  }) {
    setSentNum(paramSentNum);
    setReceivedNum(paramReceivedNum);
    setTransactions(paramTransactions);
    setCurrentAsset(paramCryptoAsset);
  }
}
