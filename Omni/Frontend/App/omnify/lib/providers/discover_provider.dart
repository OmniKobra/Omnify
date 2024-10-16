// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:omnify/crypto/features/discover_utils.dart';
import 'package:web3dart/web3dart.dart';

import '../languages/app_language.dart';

import '../models/discover_events.dart';
import '../utils.dart';

class DiscoverProvider with ChangeNotifier {
  Chain _transferChain = Chain.Avalanche;
  Chain _paymentChain = Chain.Avalanche;
  Chain _trustChain = Chain.Avalanche;
  Chain _bridgeChain = Chain.Avalanche;
  Chain _escrowChain = Chain.Avalanche;

  void initTransferListeners() {}
  late Future<void> _getDiscoverStats;
  List<DiscoverTransferEvent> _transferEvents = [];
  List<DiscoverPaymentEvent> _paymentEvents = [];
  List<DiscoverTrustEvent> _trustEvents = [];
  List<DiscoverBridgeEvent> _bridgeEvents = [];
  List<DiscoverEscrowEvent> _escrowEvents = [];

  Map<String, dynamic> _transferStats = {
    'transfers': 0,
    'assets transferred': Decimal.parse("0.00"),
    'senders': 0,
    'recipients': 0
  };
  Map<String, dynamic> _paymentStats = {
    'payments': 0,
    'amount paid': Decimal.parse("0.00"),
    'installments': 0,
    'installments paid': 0,
    'withdrawals': 0,
    'amount withdrawn': Decimal.parse("0.00"),
    'paid in installments': Decimal.parse("0.00"),
    'customers': 0,
    'vendors': 0,
    'refunds': 0,
    'amount refunded': Decimal.parse("0.00"),
  };
  Map<String, dynamic> _trustStats = {
    'amount deposited': Decimal.parse("0.00"),
    'deposits': 0,
    'beneficiaries': 0,
    'withdrawals': 0,
    'assets withdrawn': Decimal.parse("0.00"),
    'owners': 0
  };
  Map<String, dynamic> _bridgeStats = {
    'assets received': Decimal.parse("0.00"),
    'assets migrated': Decimal.parse("0.00"),
    'received transactions': 0,
    'migration transactions': 0
  };
  Map<String, dynamic> _escrowStats = {
    'bids made': 0,
    'contracts': 0,
    'contract assets': Decimal.parse("0.00"),
    'bid assets': Decimal.parse("0.00"),
    'complete contracts': 0,
  };
  Chain get transferChain => _transferChain;
  Chain get paymentChain => _paymentChain;
  Chain get trustChain => _trustChain;
  Chain get bridgeChain => _bridgeChain;
  Chain get escrowChain => _escrowChain;
  List<DiscoverTransferEvent> get transferEvents => _transferEvents;
  List<DiscoverPaymentEvent> get paymentEvents => _paymentEvents;
  List<DiscoverTrustEvent> get trustEvents => _trustEvents;
  List<DiscoverBridgeEvent> get bridgeEvents => _bridgeEvents;
  List<DiscoverEscrowEvent> get escrowEvents => _escrowEvents;
  Map<String, dynamic> get transferStats => _transferStats;
  Map<String, dynamic> get paymentStats => _paymentStats;
  Map<String, dynamic> get trustStats => _trustStats;
  Map<String, dynamic> get bridgeStats => _bridgeStats;
  Map<String, dynamic> get escrowStats => _escrowStats;
  Future<void> get getDiscoverStats => _getDiscoverStats;
  void setDiscoverTransferChain(
      Chain c, AppLanguage lang, bool initListen, Web3Client client) {
    if (c != _transferChain) {
      _transferChain = c;
      _transferStats = {
        'transfers': 0,
        'assets transferred': Decimal.parse("0.00"),
        'senders': 0,
        'recipients': 0
      };
      _transferEvents.clear();
      if (initListen) {
        DiscoverUtils.initTransferEventListeners(
            c: _transferChain, addEvent: insertTransferEvent, client: client);
      }
      notifyListeners();
    }
  }

  void setDiscoverPaymentChain(
      Chain c, AppLanguage lang, bool initListen, Web3Client client) {
    if (c != _paymentChain) {
      _paymentChain = c;
      _paymentStats = {
        'payments': 0,
        'amount paid': Decimal.parse("0.00"),
        'installments': 0,
        'installments paid': 0,
        'withdrawals': 0,
        'amount withdrawn': Decimal.parse("0.00"),
        'paid in installments': Decimal.parse("0.00"),
        'customers': 0,
        'vendors': 0,
        'refunds': 0,
        'amount refunded': Decimal.parse("0.00"),
      };
      _paymentEvents.clear();
      if (initListen) {
        DiscoverUtils.initPaymentEventListeners(
            c: c, addEvent: insertPaymentEvent, client: client);
      }
      notifyListeners();
    }
  }

  void setDiscoverTrustChain(
      Chain c, AppLanguage lang, bool initListen, Web3Client client) {
    if (c != _trustChain) {
      _trustChain = c;
      _trustStats = {
        'amount deposited': Decimal.parse("0.00"),
        'deposits': 0,
        'beneficiaries': 0,
        'withdrawals': 0,
        'assets withdrawn': Decimal.parse("0.00"),
        'owners': 0
      };
      _trustEvents.clear();
      if (initListen) {
        DiscoverUtils.initTrustEventListeners(
            c: c, addEvent: insertTrustEvent, client: client);
      }
      notifyListeners();
    }
  }

  void setDiscoverBridgeChain(
      Chain c, AppLanguage lang, bool initListen, Web3Client client) {
    if (c != _bridgeChain) {
      if (c == Chain.Hedera || c == Chain.Ronin || c == Chain.Cronos) {
        _bridgeChain = Chain.Avalanche;
      } else {
        _bridgeChain = c;
      }
      _bridgeStats = {
        'assets received': Decimal.parse("0.00"),
        'assets migrated': Decimal.parse("0.00"),
        'received transactions': 0,
        'migration transactions': 0
      };
      _bridgeEvents.clear();
      if (initListen) {
        DiscoverUtils.initBridgesEventListeners(
            c: c, addEvent: insertBridgeEvent, client: client);
      }
      notifyListeners();
    }
  }

  void setDiscoverEscrowChain(
      Chain c, AppLanguage lang, bool initListen, Web3Client client) {
    if (c != _escrowChain) {
      _escrowChain = c;
      _escrowStats = {
        'bids made': 0,
        'contracts': 0,
        'contract assets': Decimal.parse("0.00"),
        'bid assets': Decimal.parse("0.00"),
        'complete contracts': 0,
      };
      _escrowEvents.clear();
      if (initListen) {
        DiscoverUtils.initEscrowEventListeners(
            c: c, addEvent: insertEscrowEvent, client: client);
      }
      notifyListeners();
    }
  }

  void setDiscoverChain(Chain c, AppLanguage lang, Web3Client client) {
    setDiscoverTransferChain(c, lang, false, client);
    setDiscoverPaymentChain(c, lang, false, client);
    setDiscoverTrustChain(c, lang, false, client);
    setDiscoverBridgeChain(c, lang, false, client);
    setDiscoverEscrowChain(c, lang, false, client);
    notifyListeners();
  }

  void setLooperFuture(Chain c, bool notify, Web3Client client) {
    _getDiscoverStats = DiscoverUtils.getLooperStats(
        c: c,
        setTransferStats: setTransferStats,
        setPaymentStats: setPaymentStats,
        setTrustStats: setTrustStats,
        setBridgeStats: setBridgeStats,
        setEscrowStats: setEscrowStats,
        client: client);
    if (notify) notifyListeners();
  }

  void insertTransferEvent(DiscoverTransferEvent t) {
    _transferEvents.insert(0, t);
    notifyListeners();
  }

  void insertPaymentEvent(DiscoverPaymentEvent p) {
    _paymentEvents.insert(0, p);
    notifyListeners();
  }

  void insertTrustEvent(DiscoverTrustEvent t) {
    _trustEvents.insert(0, t);
    notifyListeners();
  }

  void insertBridgeEvent(DiscoverBridgeEvent b) {
    _bridgeEvents.insert(0, b);
    notifyListeners();
  }

  void insertEscrowEvent(DiscoverEscrowEvent e) {
    _escrowEvents.insert(0, e);
    notifyListeners();
  }

  void setTransferStats(Map<String, dynamic> ts) {
    _transferStats = ts;
    notifyListeners();
  }

  void setPaymentStats(Map<String, dynamic> ps) {
    _paymentStats = ps;
    notifyListeners();
  }

  void setTrustStats(Map<String, dynamic> ts) {
    _trustStats = ts;
    notifyListeners();
  }

  void setBridgeStats(Map<String, dynamic> bs) {
    _bridgeStats = bs;
    notifyListeners();
  }

  void setEscrowStats(Map<String, dynamic> es) {
    _escrowStats = es;
    notifyListeners();
  }
}
