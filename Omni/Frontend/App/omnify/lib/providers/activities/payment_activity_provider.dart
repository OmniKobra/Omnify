import 'package:decimal/decimal.dart';
import 'package:jiffy/jiffy.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/foundation.dart';

import '../../languages/app_language.dart';
import '../../models/receipt.dart';
import '../../models/withdrawal.dart';
import '../../utils.dart';
import '../../crypto/features/payment_utils.dart';

class PaymentActivityProvider with ChangeNotifier {
  Chain _currentChain = Chain.Avalanche;
  Decimal _balance = Decimal.parse("0.0");
  Decimal _revenue = Decimal.parse("0.0");
  Decimal _spending = Decimal.parse("0.0");
  Decimal _refunds = Decimal.parse("0.0");
  Decimal _withdrawals = Decimal.parse("0.0");
  int _paymentsMade = 0;
  int _paymentsReceived = 0;
  int _refundsNum = 0;
  int _withdrawalsNum = 0;
  List<Receipt> _allReceipts = [];
  List<Receipt> _receipts = [];
  List<Withdrawal> _allWithdrawals = [];
  List<Withdrawal> _withdrawalsList = [];
  Future<void>? _fetchPaymentProfile;
  Chain get currentChain => _currentChain;
  Decimal get balance => _balance;
  Decimal get revenue => _revenue;
  Decimal get spending => _spending;
  Decimal get refunds => _refunds;
  Decimal get withdrawals => _withdrawals;
  int get paymentsMade => _paymentsMade;
  int get paymentsReceived => _paymentsReceived;
  int get refundsNum => _refundsNum;
  int get withdrawalsNum => _withdrawalsNum;
  List<Receipt> get receipts => _receipts;
  List<Receipt> get allReceipts => _allReceipts;
  List<Withdrawal> get withdrawalList => _withdrawalsList;
  List<Withdrawal> get allWithdrawalsList => _allWithdrawals;
  Future<void>? get fetchPaymentProfile => _fetchPaymentProfile;
  void setChain(Chain c, AppLanguage lang, Web3Client client,
      [String? address, bool? setFuture]) {
    _currentChain = c;
    final Decimal zero = Decimal.parse("0.0");
    _balance = zero;
    _revenue = zero;
    _spending = zero;
    _refunds = zero;
    _withdrawals = zero;
    _paymentsMade = 0;
    _paymentsReceived = 0;
    _refundsNum = 0;
    _withdrawalsNum = 0;
    _receipts.clear();
    _allReceipts.clear();
    _withdrawalsList.clear();
    _allWithdrawals.clear();
    if (setFuture != null) {
      _fetchPaymentProfile = PaymentUtils.fetchPaymentProfile(
          c: c,
          client: client,
          walletAddress: address!,
          initProfile: initPaymentProfile);
    }
    notifyListeners();
  }

  void setBalance(Decimal b) {
    _balance = b;
    notifyListeners();
  }

  void issueRefund(Decimal amount) {
    _balance -= amount;
    _refunds += amount;
    notifyListeners();
  }

  void setRevenue(Decimal r) {
    _revenue = r;
    notifyListeners();
  }

  void setSpending(Decimal s) {
    _spending = s;
    notifyListeners();
  }

  void setRefunds(Decimal r) {
    _refunds = r;
    notifyListeners();
  }

  void setWithdrawals(Decimal w) {
    _withdrawals = w;
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

  void setRefundsNum(int rn) {
    _refundsNum = rn;
    notifyListeners();
  }

  void setWithdrawalsNum(int wn) {
    _withdrawalsNum = wn;
    notifyListeners();
  }

  void setReceipts(List<Receipt> r) {
    _allReceipts = r;
    _allReceipts.sort((a, b) => b.date.compareTo(a.date));
    if (_allReceipts.length > Utils.pageSize) {
      _receipts = _allReceipts.take(Utils.pageSize).toList();
    } else {
      _receipts = _allReceipts;
    }
    // notifyListeners();
  }

  void showMoreReceipts() {
    var difference = _allReceipts.length - _receipts.length;
    var lastShownId = _receipts.last.id;
    var indexInAll = _allReceipts.indexWhere((e) => e.id == lastShownId);
    if (difference > Utils.pageSize) {
      var nextItems =
          _allReceipts.getRange(indexInAll + 1, indexInAll + Utils.pageSize);
      _receipts.addAll(nextItems);
    } else {
      var nextItems =
          _allReceipts.getRange(indexInAll + 1, _allReceipts.length);
      _receipts.addAll(nextItems);
    }
    notifyListeners();
  }

  void setWithdrawalsList(List<Withdrawal> w) {
    _allWithdrawals = w;
    _allWithdrawals.sort((a, b) => b.date.compareTo(a.date));
    if (_allWithdrawals.length > Utils.pageSize) {
      _withdrawalsList = _allWithdrawals.take(Utils.pageSize).toList();
    } else {
      _withdrawalsList = _allWithdrawals;
    }
    // notifyListeners();
  }

  void showMoreWithdrawals() {
    var difference = _allWithdrawals.length - _withdrawalsList.length;
    var last = _withdrawalsList.last;
    var index = _withdrawalsList.indexOf(last);
    if (difference > Utils.pageSize) {
      var nextItems =
          _allWithdrawals.getRange(index + 1, index + Utils.pageSize);
      _withdrawalsList.addAll(nextItems);
    } else {
      var nextItems =
          _allWithdrawals.getRange(index + 1, _allWithdrawals.length);
      _withdrawalsList.addAll(nextItems);
    }
    notifyListeners();
  }

  void setFuture(Chain c, String address, bool notify, Web3Client client) {
    _fetchPaymentProfile = PaymentUtils.fetchPaymentProfile(
        c: c,
        client: client,
        walletAddress: address,
        initProfile: initPaymentProfile);
    if (notify) notifyListeners();
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

  int daysThatYear(int y) {
    final div = y % 4;
    final daysInYear = div == 0 ? 366 : 365;
    return daysInYear;
  }

  double receiptFolder(List<Receipt> ls) => ls.fold(0.0, (previous, r) {
        var buffer = Utils.removeTrailingZeros(r.amount.toStringAsFixed(3));
        return previous + double.parse(buffer);
      });

  double withdrawalFolder(List<Withdrawal> ls) => ls.fold(0.0, (previous, w) {
        var buffer = Utils.removeTrailingZeros(w.amount.toStringAsFixed(3));
        return previous + double.parse(buffer);
      });

  List<Receipt> getDayReceipts(int d) {
    final nowDate = DateTime.now();
    final _now = Jiffy.parseFromDateTime(DateTime(
        nowDate.year, nowDate.month, nowDate.day, 23, 59, 59, 999, 999));
    return _allReceipts.where((r) {
      final tDate = Jiffy.parseFromDateTime(r.date);
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

  List<Receipt> getMonthReceipts(int m) {
    final nowDate = DateTime.now();
    final _now = Jiffy.parseFromDateTime(DateTime(nowDate.year, nowDate.month,
        getMonthLastDay(nowDate.month, nowDate.year), 23, 59, 59, 999, 999));
    return _allReceipts.where((r) {
      final tDate = Jiffy.parseFromDateTime(r.date);
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

  List<Receipt> getYearReceipts(int y) {
    final nowDate = DateTime.now();
    final _now = Jiffy.parseFromDateTime(
        DateTime(nowDate.year, 12, 31, 23, 59, 59, 999, 999));
    return _allReceipts.where((r) {
      final tDate = Jiffy.parseFromDateTime(r.date);
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

  List<Withdrawal> getDayWithdrawals(int d) {
    final nowDate = DateTime.now();
    final _now = Jiffy.parseFromDateTime(DateTime(
        nowDate.year, nowDate.month, nowDate.day, 23, 59, 59, 999, 999));
    return _allWithdrawals.where((w) {
      final tDate = Jiffy.parseFromDateTime(w.date);
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

  List<Withdrawal> getMonthWithdrawals(int m) {
    final nowDate = DateTime.now();
    final _now = Jiffy.parseFromDateTime(DateTime(nowDate.year, nowDate.month,
        getMonthLastDay(nowDate.month, nowDate.year), 23, 59, 59, 999, 999));
    return _allWithdrawals.where((w) {
      final tDate = Jiffy.parseFromDateTime(w.date);
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

  List<Withdrawal> getYearWithdrawals(int y) {
    final nowDate = DateTime.now();
    final _now = Jiffy.parseFromDateTime(
        DateTime(nowDate.year, 12, 31, 23, 59, 59, 999, 999));
    return _allWithdrawals.where((w) {
      final tDate = Jiffy.parseFromDateTime(w.date);
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

  List<Receipt> getPaymentsMadeChart(String myAddress, List<Receipt> ls) =>
      ls.where((r) => r.payer == myAddress).toList();
  List<Receipt> getPaymentsReceivedChart(String myAddress, List<Receipt> ls) =>
      ls.where((r) => r.vendor == myAddress).toList();
  List<Receipt> getPaymentsRefundedChart(String myAddress, List<Receipt> ls) =>
      ls.where((r) => r.vendor == myAddress && r.isRefunded).toList();

  Map<int, List<double>> getPaymentChartDailies(String myAddress) {
    //0 = payments received, 1= refunds , 2 = withdrawals, 3 = payments made
    var z0 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z1 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z2 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z3 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z4 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z5 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z6 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    Map<int, List<double>> chart = {
      0: z0,
      1: z1,
      2: z2,
      3: z3,
      4: z4,
      5: z5,
      6: z6,
    };
    final nowDate = DateTime.now();
    final _now = Jiffy.parseFromDateTime(DateTime(
        nowDate.year, nowDate.month, nowDate.day, 23, 59, 59, 999, 999));
    if (_allReceipts.isNotEmpty) {
      var receiptsToday = _allReceipts.where((r) {
        final tdate = Jiffy.parseFromDateTime(r.date);
        return _now.diff(tdate, unit: Unit.day) < 1;
      }).toList();
      var receipts_1 = getDayReceipts(1);
      var receipts_2 = getDayReceipts(2);
      var receipts_3 = getDayReceipts(3);
      var receipts_4 = getDayReceipts(4);
      var receipts_5 = getDayReceipts(5);
      var receipts_6 = getDayReceipts(6);
      var refundsToday = getPaymentsRefundedChart(myAddress, receiptsToday);
      chart[6]![1] = receiptFolder(refundsToday);
      var refunds_1 = getPaymentsRefundedChart(myAddress, receipts_1);
      chart[5]![1] = receiptFolder(refunds_1);
      var refunds_2 = getPaymentsRefundedChart(myAddress, receipts_2);
      chart[4]![1] = receiptFolder(refunds_2);
      var refunds_3 = getPaymentsRefundedChart(myAddress, receipts_3);
      chart[3]![1] = receiptFolder(refunds_3);
      var refunds_4 = getPaymentsRefundedChart(myAddress, receipts_4);
      chart[2]![1] = receiptFolder(refunds_4);
      var refunds_5 = getPaymentsRefundedChart(myAddress, receipts_5);
      chart[1]![1] = receiptFolder(refunds_5);
      var refunds_6 = getPaymentsRefundedChart(myAddress, receipts_6);
      chart[0]![1] = receiptFolder(refunds_6);
      var paymentsMadeToday = getPaymentsMadeChart(myAddress, receiptsToday);
      chart[6]![3] = receiptFolder(paymentsMadeToday);
      var paymentsMade_1 = getPaymentsMadeChart(myAddress, receipts_1);
      chart[5]![3] = receiptFolder(paymentsMade_1);
      var paymentsMade_2 = getPaymentsMadeChart(myAddress, receipts_2);
      chart[4]![3] = receiptFolder(paymentsMade_2);
      var paymentsMade_3 = getPaymentsMadeChart(myAddress, receipts_3);
      chart[3]![3] = receiptFolder(paymentsMade_3);
      var paymentsMade_4 = getPaymentsMadeChart(myAddress, receipts_4);
      chart[2]![3] = receiptFolder(paymentsMade_4);
      var paymentsMade_5 = getPaymentsMadeChart(myAddress, receipts_5);
      chart[1]![3] = receiptFolder(paymentsMade_5);
      var paymentsMade_6 = getPaymentsMadeChart(myAddress, receipts_6);
      chart[0]![3] = receiptFolder(paymentsMade_6);
      var paymentsReceivedToday =
          getPaymentsReceivedChart(myAddress, receiptsToday);
      chart[6]![0] = receiptFolder(paymentsReceivedToday);
      var paymentsReceived_1 = getPaymentsReceivedChart(myAddress, receipts_1);
      chart[5]![0] = receiptFolder(paymentsReceived_1);
      var paymentsReceived_2 = getPaymentsReceivedChart(myAddress, receipts_2);
      chart[4]![0] = receiptFolder(paymentsReceived_2);
      var paymentsReceived_3 = getPaymentsReceivedChart(myAddress, receipts_3);
      chart[3]![0] = receiptFolder(paymentsReceived_3);
      var paymentsReceived_4 = getPaymentsReceivedChart(myAddress, receipts_4);
      chart[2]![0] = receiptFolder(paymentsReceived_4);
      var paymentsReceived_5 = getPaymentsReceivedChart(myAddress, receipts_5);
      chart[1]![0] = receiptFolder(paymentsReceived_5);
      var paymentsReceived_6 = getPaymentsReceivedChart(myAddress, receipts_6);
      chart[0]![0] = receiptFolder(paymentsReceived_6);
    }
    if (_allWithdrawals.isNotEmpty) {
      var withdrawalsToday = _allWithdrawals.where((w) {
        final tdate = Jiffy.parseFromDateTime(w.date);
        return _now.diff(tdate, unit: Unit.day) < 1;
      }).toList();
      chart[6]![2] = withdrawalFolder(withdrawalsToday);
      var withdrawals_1 = getDayWithdrawals(1);
      chart[5]![2] = withdrawalFolder(withdrawals_1);
      var withdrawals_2 = getDayWithdrawals(2);
      chart[4]![2] = withdrawalFolder(withdrawals_2);
      var withdrawals_3 = getDayWithdrawals(3);
      chart[3]![2] = withdrawalFolder(withdrawals_3);
      var withdrawals_4 = getDayWithdrawals(4);
      chart[2]![2] = withdrawalFolder(withdrawals_4);
      var withdrawals_5 = getDayWithdrawals(5);
      chart[1]![2] = withdrawalFolder(withdrawals_5);
      var withdrawals_6 = getDayWithdrawals(6);
      chart[0]![2] = withdrawalFolder(withdrawals_6);
    }
    return chart;
  }

  Map<int, List<double>> getPaymentChartMonthlies(String myAddress) {
    final nowDate = DateTime.now();
    final _now = Jiffy.parseFromDateTime(DateTime(nowDate.year, nowDate.month,
        getMonthLastDay(nowDate.month, nowDate.year), 23, 59, 59, 999, 999));
    var z0 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z1 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z2 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z3 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z4 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z5 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z6 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    Map<int, List<double>> chart = {
      0: z0,
      1: z1,
      2: z2,
      3: z3,
      4: z4,
      5: z5,
      6: z6,
    };
    if (_allReceipts.isNotEmpty) {
      var receiptsThisMonth = _allReceipts.where((r) {
        final tdate = Jiffy.parseFromDateTime(r.date);
        return _now.diff(tdate, unit: Unit.month) < 1;
      }).toList();
      var receipts_1 = getMonthReceipts(1);
      var receipts_2 = getMonthReceipts(2);
      var receipts_3 = getMonthReceipts(3);
      var receipts_4 = getMonthReceipts(4);
      var receipts_5 = getMonthReceipts(5);
      var receipts_6 = getMonthReceipts(6);
      var refundsThisMonth =
          getPaymentsRefundedChart(myAddress, receiptsThisMonth);
      chart[6]![1] = receiptFolder(refundsThisMonth);
      var refunds_1 = getPaymentsRefundedChart(myAddress, receipts_1);
      chart[5]![1] = receiptFolder(refunds_1);
      var refunds_2 = getPaymentsRefundedChart(myAddress, receipts_2);
      chart[4]![1] = receiptFolder(refunds_2);
      var refunds_3 = getPaymentsRefundedChart(myAddress, receipts_3);
      chart[3]![1] = receiptFolder(refunds_3);
      var refunds_4 = getPaymentsRefundedChart(myAddress, receipts_4);
      chart[2]![1] = receiptFolder(refunds_4);
      var refunds_5 = getPaymentsRefundedChart(myAddress, receipts_5);
      chart[1]![1] = receiptFolder(refunds_5);
      var refunds_6 = getPaymentsRefundedChart(myAddress, receipts_6);
      chart[0]![1] = receiptFolder(refunds_6);
      var paymentsMadeThisMonth =
          getPaymentsMadeChart(myAddress, receiptsThisMonth);
      chart[6]![3] = receiptFolder(paymentsMadeThisMonth);
      var paymentsMade_1 = getPaymentsMadeChart(myAddress, receipts_1);
      chart[5]![3] = receiptFolder(paymentsMade_1);
      var paymentsMade_2 = getPaymentsMadeChart(myAddress, receipts_2);
      chart[4]![3] = receiptFolder(paymentsMade_2);
      var paymentsMade_3 = getPaymentsMadeChart(myAddress, receipts_3);
      chart[3]![3] = receiptFolder(paymentsMade_3);
      var paymentsMade_4 = getPaymentsMadeChart(myAddress, receipts_4);
      chart[2]![3] = receiptFolder(paymentsMade_4);
      var paymentsMade_5 = getPaymentsMadeChart(myAddress, receipts_5);
      chart[1]![3] = receiptFolder(paymentsMade_5);
      var paymentsMade_6 = getPaymentsMadeChart(myAddress, receipts_6);
      chart[0]![3] = receiptFolder(paymentsMade_6);
      var paymentsReceivedThisMonth =
          getPaymentsReceivedChart(myAddress, receiptsThisMonth);
      chart[6]![0] = receiptFolder(paymentsReceivedThisMonth);
      var paymentsReceived_1 = getPaymentsReceivedChart(myAddress, receipts_1);
      chart[5]![0] = receiptFolder(paymentsReceived_1);
      var paymentsReceived_2 = getPaymentsReceivedChart(myAddress, receipts_2);
      chart[4]![0] = receiptFolder(paymentsReceived_2);
      var paymentsReceived_3 = getPaymentsReceivedChart(myAddress, receipts_3);
      chart[3]![0] = receiptFolder(paymentsReceived_3);
      var paymentsReceived_4 = getPaymentsReceivedChart(myAddress, receipts_4);
      chart[2]![0] = receiptFolder(paymentsReceived_4);
      var paymentsReceived_5 = getPaymentsReceivedChart(myAddress, receipts_5);
      chart[1]![0] = receiptFolder(paymentsReceived_5);
      var paymentsReceived_6 = getPaymentsReceivedChart(myAddress, receipts_6);
      chart[0]![0] = receiptFolder(paymentsReceived_6);
    }
    if (_allWithdrawals.isNotEmpty) {
      var withdrawalsThisMonth = _allWithdrawals.where((w) {
        final tdate = Jiffy.parseFromDateTime(w.date);
        return _now.diff(tdate, unit: Unit.month) < 1;
      }).toList();
      chart[6]![2] = withdrawalFolder(withdrawalsThisMonth);
      var withdrawals_1 = getMonthWithdrawals(1);
      chart[5]![2] = withdrawalFolder(withdrawals_1);
      var withdrawals_2 = getMonthWithdrawals(2);
      chart[4]![2] = withdrawalFolder(withdrawals_2);
      var withdrawals_3 = getMonthWithdrawals(3);
      chart[3]![2] = withdrawalFolder(withdrawals_3);
      var withdrawals_4 = getMonthWithdrawals(4);
      chart[2]![2] = withdrawalFolder(withdrawals_4);
      var withdrawals_5 = getMonthWithdrawals(5);
      chart[1]![2] = withdrawalFolder(withdrawals_5);
      var withdrawals_6 = getMonthWithdrawals(6);
      chart[0]![2] = withdrawalFolder(withdrawals_6);
    }
    return chart;
  }

  Map<int, List<double>> getPaymentChartYearlies(String myAddress) {
    final nowDate = DateTime.now();
    final _now = Jiffy.parseFromDateTime(
        DateTime(nowDate.year, 12, 31, 23, 59, 59, 999, 999));
    var z0 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z1 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z2 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z3 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z4 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z5 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    var z6 = [
      0.00,
      0.00,
      0.00,
      0.00,
    ];
    Map<int, List<double>> chart = {
      0: z0,
      1: z1,
      2: z2,
      3: z3,
      4: z4,
      5: z5,
      6: z6,
    };
    if (_allReceipts.isNotEmpty) {
      var receiptsThisYear = _allReceipts.where((r) {
        final tdate = Jiffy.parseFromDateTime(r.date);
        return _now.diff(tdate, unit: Unit.year) < 1;
      }).toList();
      var receipts_1 = getYearReceipts(1);
      var receipts_2 = getYearReceipts(2);
      var receipts_3 = getYearReceipts(3);
      var receipts_4 = getYearReceipts(4);
      var receipts_5 = getYearReceipts(5);
      var receipts_6 = getYearReceipts(6);
      var refundsThisYear =
          getPaymentsRefundedChart(myAddress, receiptsThisYear);
      chart[6]![1] = receiptFolder(refundsThisYear);
      var refunds_1 = getPaymentsRefundedChart(myAddress, receipts_1);
      chart[5]![1] = receiptFolder(refunds_1);
      var refunds_2 = getPaymentsRefundedChart(myAddress, receipts_2);
      chart[4]![1] = receiptFolder(refunds_2);
      var refunds_3 = getPaymentsRefundedChart(myAddress, receipts_3);
      chart[3]![1] = receiptFolder(refunds_3);
      var refunds_4 = getPaymentsRefundedChart(myAddress, receipts_4);
      chart[2]![1] = receiptFolder(refunds_4);
      var refunds_5 = getPaymentsRefundedChart(myAddress, receipts_5);
      chart[1]![1] = receiptFolder(refunds_5);
      var refunds_6 = getPaymentsRefundedChart(myAddress, receipts_6);
      chart[0]![1] = receiptFolder(refunds_6);
      var paymentsMadeThisYear =
          getPaymentsMadeChart(myAddress, receiptsThisYear);
      chart[6]![3] = receiptFolder(paymentsMadeThisYear);
      var paymentsMade_1 = getPaymentsMadeChart(myAddress, receipts_1);
      chart[5]![3] = receiptFolder(paymentsMade_1);
      var paymentsMade_2 = getPaymentsMadeChart(myAddress, receipts_2);
      chart[4]![3] = receiptFolder(paymentsMade_2);
      var paymentsMade_3 = getPaymentsMadeChart(myAddress, receipts_3);
      chart[3]![3] = receiptFolder(paymentsMade_3);
      var paymentsMade_4 = getPaymentsMadeChart(myAddress, receipts_4);
      chart[2]![3] = receiptFolder(paymentsMade_4);
      var paymentsMade_5 = getPaymentsMadeChart(myAddress, receipts_5);
      chart[1]![3] = receiptFolder(paymentsMade_5);
      var paymentsMade_6 = getPaymentsMadeChart(myAddress, receipts_6);
      chart[0]![3] = receiptFolder(paymentsMade_6);
      var paymentsReceivedThisYear =
          getPaymentsReceivedChart(myAddress, receiptsThisYear);
      chart[6]![0] = receiptFolder(paymentsReceivedThisYear);
      var paymentsReceived_1 = getPaymentsReceivedChart(myAddress, receipts_1);
      chart[5]![0] = receiptFolder(paymentsReceived_1);
      var paymentsReceived_2 = getPaymentsReceivedChart(myAddress, receipts_2);
      chart[4]![0] = receiptFolder(paymentsReceived_2);
      var paymentsReceived_3 = getPaymentsReceivedChart(myAddress, receipts_3);
      chart[3]![0] = receiptFolder(paymentsReceived_3);
      var paymentsReceived_4 = getPaymentsReceivedChart(myAddress, receipts_4);
      chart[2]![0] = receiptFolder(paymentsReceived_4);
      var paymentsReceived_5 = getPaymentsReceivedChart(myAddress, receipts_5);
      chart[1]![0] = receiptFolder(paymentsReceived_5);
      var paymentsReceived_6 = getPaymentsReceivedChart(myAddress, receipts_6);
      chart[0]![0] = receiptFolder(paymentsReceived_6);
    }
    if (_allWithdrawals.isNotEmpty) {
      var withdrawalsThisYear = _allWithdrawals.where((w) {
        final tdate = Jiffy.parseFromDateTime(w.date);
        return _now.diff(tdate, unit: Unit.year) < 1;
      }).toList();
      chart[6]![2] = withdrawalFolder(withdrawalsThisYear);
      var withdrawals_1 = getYearWithdrawals(1);
      chart[5]![2] = withdrawalFolder(withdrawals_1);
      var withdrawals_2 = getYearWithdrawals(2);
      chart[4]![2] = withdrawalFolder(withdrawals_2);
      var withdrawals_3 = getYearWithdrawals(3);
      chart[3]![2] = withdrawalFolder(withdrawals_3);
      var withdrawals_4 = getYearWithdrawals(4);
      chart[2]![2] = withdrawalFolder(withdrawals_4);
      var withdrawals_5 = getYearWithdrawals(5);
      chart[1]![2] = withdrawalFolder(withdrawals_5);
      var withdrawals_6 = getYearWithdrawals(6);
      chart[0]![2] = withdrawalFolder(withdrawals_6);
    }
    return chart;
  }

  void initPaymentProfile({
    required Decimal paramBalance,
    required Decimal paramRevenue,
    required Decimal paramSpending,
    required Decimal paramRefunds,
    required Decimal paramWithdrawals,
    required int paramPaymentsMadeNum,
    required int paramPaymentsReceivedNum,
    required int paramRefundsNum,
    required int paramWihdrawalsNum,
    required List<Receipt> paramReceiptsList,
    required List<Withdrawal> paramWithdrawalsList,
  }) {
    setBalance(paramBalance);
    setRevenue(paramRevenue);
    setSpending(paramSpending);
    setRefunds(paramRefunds);
    setWithdrawals(paramWithdrawals);
    setPaymentsMade(paramPaymentsMadeNum);
    setPaymentsReceived(paramPaymentsReceivedNum);
    setRefundsNum(paramRefundsNum);
    setWithdrawalsNum(paramWihdrawalsNum);
    setReceipts(paramReceiptsList);
    setWithdrawalsList(paramWithdrawalsList);
  }
}
