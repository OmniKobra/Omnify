import 'package:flutter/foundation.dart';
import '../languages/app_language.dart';
import '../models/transaction.dart';
import '../utils.dart';
import 'package:rxdart/rxdart.dart';

class TransactionsProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  Chain _currentChain = Chain.Avalanche;
  List<Transaction> get transactions => _transactions;
  Chain get currentChain => _currentChain;
  final BehaviorSubject<List<Transaction>> _transactionStream =
      BehaviorSubject<List<Transaction>>.seeded([]);
  ValueStream<List<Transaction>> get transactionStream =>
      _transactionStream.stream;

  void setTransactions(List<Transaction> t) {
    _transactions = t;
    notifyListeners();
  }

  void addTransaction(Transaction t) {
    _transactions.add(t);
    addTransactionStream(t);
    notifyListeners();
  }

  void setChain(Chain c, AppLanguage l) {
    if (c != _currentChain) {
      _currentChain = c;
      notifyListeners();
    }
  }

  void modifyTransactionStatus(String id, Status s, int blockNumber) {
    var _index = _transactions.indexWhere((t) => t.id == id);
    _transactions[_index].setStatus(s);
    _transactionStream.value[_index].setStatus(s);
    _transactions[_index].setBlockNum(blockNumber);
    _transactionStream.value[_index].setBlockNum(blockNumber);
    notifyListeners();
  }

  void modifyBridgeTransactionStatus2(
      {required String id,
      required Status s,
      required int blockNumber2,
      required String hash2}) {
    var _index = _transactions.indexWhere((t) => t.id == id);
    _transactions[_index].setStatus(s);
    _transactionStream.value[_index].setStatus(s);
    _transactions[_index].setSecondBlockNumber(blockNumber2);
    _transactionStream.value[_index].setSecondHash(hash2);
    notifyListeners();
  }

  void addTransactionStream(Transaction tz) {
    _transactionStream.add([tz]);
  }
}
