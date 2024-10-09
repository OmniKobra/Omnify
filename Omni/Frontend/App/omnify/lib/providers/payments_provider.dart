import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';

import '../languages/app_language.dart';
import '../utils.dart';

class PaymentsProvider with ChangeNotifier {
  Decimal _balance = Decimal.parse("12340.2310");
  Decimal _balanceWithdrawn = Decimal.parse("12340.2310");
  Decimal _totalRevenue = Decimal.parse("12340.2310");
  Decimal _totalSpent = Decimal.parse("21340.0");
  Decimal _amountRefunded = Decimal.parse("12340.2310");
  int _paymentsMade = 77;
  int _paymentsReceived = 1234;
  int _refunds = 250;
  Chain _currentChain = Chain.Avalanche;

  Decimal get balance => _balance;
  Decimal get balanceWithdrawn => _balanceWithdrawn;
  Decimal get totalRevenue => _totalRevenue;
  Decimal get totalSpent => _totalSpent;
  Decimal get amountRefunded => _amountRefunded;
  int get paymentsMade => _paymentsMade;
  int get paymentsReceived => _paymentsReceived;
  int get refunds => _refunds;
  Chain get currentChain => _currentChain;
  void setChain(Chain c, AppLanguage lang) {
    _currentChain = c;
    notifyListeners();
  }

  void setBalance(Decimal b) {
    _balance = b;
    notifyListeners();
  }

  void setBalanceWithdrawn(Decimal bw) {
    _balanceWithdrawn = bw;
    notifyListeners();
  }

  void setRevenue(Decimal r) {
    _totalRevenue = r;
    notifyListeners();
  }

  void setTotalSpent(Decimal ts) {
    _totalSpent = ts;
    notifyListeners();
  }

  void setAmountRefunded(Decimal ar) {
    _amountRefunded = ar;
    notifyListeners();
  }

  void setPaymentsMade(int pm) {
    _paymentsMade = pm;
    notifyListeners();
  }

  void setPaymentsReceived(int pr) {
    _paymentsReceived = pr;
    notifyListeners();
  }

  void setRefunds(int r) {
    _refunds = r;
    notifyListeners();
  }
}
