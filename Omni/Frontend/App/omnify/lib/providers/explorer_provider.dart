// ignore_for_file: constant_identifier_names

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../languages/app_language.dart';
import '../models/explorer_bridge.dart';
import '../models/explorer_escrow.dart';
import '../models/explorer_payment.dart';
import '../models/explorer_transfer.dart';
import '../models/explorer_trust.dart';
import '../utils.dart';

enum TableMode { Transfers, Deposits, Withdrawals, Lottery, Loans }

class ExplorerProvider with ChangeNotifier {
  Chain _currentChain = Chain.Avalanche;
  TableMode _mode = TableMode.Transfers;
  String _description = "";
  int _lotteryDraws = 0;
  int _winners = 0;
  Decimal _nextPrize = Decimal.parse("0.0");
  Decimal _prizesDistributed = Decimal.parse("0.0");
  Decimal _valueLoaned = Decimal.parse("0.0");
  Decimal _valueBorrowed = Decimal.parse("0.0");
  Decimal _valueDeposited = Decimal.parse("0.0");
  Decimal _valueWithdrawn = Decimal.parse("0.0");
  Decimal _valueTransfered = Decimal.parse("10000000000000.12");
  int _deposits = 0;
  int _withdrawals = 0;
  int _transfers = 0;
  List<ExplorerTransfer> _transferTable = [];
  List<ExplorerPayment> _paymentTable = [];
  List<ExplorerTrust> _trustTable = [];
  List<ExplorerBridge> _bridgeTable = [];
  List<ExplorerEscrow> _escrowTable = [];

  Chain get currentChain => _currentChain;
  TableMode get mode => _mode;
  String get description => _description;
  String get name => _currentChain.toString();
  int get lotteryDraws => _lotteryDraws;
  int get winners => _winners;
  int get deposits => _deposits;
  int get withdrawals => _withdrawals;
  int get transfers => _transfers;
  Decimal get nextPrize => _nextPrize;
  Decimal get prizesDistributed => _prizesDistributed;
  Decimal get valueLoaned => _valueLoaned;
  Decimal get valueBorrowed => _valueBorrowed;
  Decimal get valueDeposited => _valueDeposited;
  Decimal get valueWithdrawn => _valueWithdrawn;
  Decimal get valueTransfered => _valueTransfered;
  List<ExplorerTransfer> get transferTable => _transferTable;
  List<ExplorerPayment> get paymentTable => _paymentTable;
  List<ExplorerTrust> get trustTable => _trustTable;
  List<ExplorerBridge> get bridgeTable => _bridgeTable;
  List<ExplorerEscrow> get escrowTable => _escrowTable;

  void setCurrentChain(Chain c, AppLanguage lang) {
    if (c != _currentChain) {
      _currentChain = c;
      initExplorer(
          paramDescription: "paramDescription",
          paramDraws: 0,
          paramWinners: 0,
          paramNextPrize: Decimal.parse("0.0"),
          paramPrizesDistributed: Decimal.parse("0.0"),
          paramValueLoaned: Decimal.parse("0.0"),
          paramValueBorrowed: Decimal.parse("0.0"),
          paramValueDeposited: Decimal.parse("0.0"),
          paramValueWithdrawn: Decimal.parse("0.0"),
          paramValueTransfered: Decimal.parse("0.0"),
          paramDeposits: 0,
          paramWithdrawals: 0,
          paramTransfers: 0,
          paramTransferTable: []);
      _transferTable = [];
      _paymentTable = [];
      _trustTable = [];
      _bridgeTable = [];
      _escrowTable = [];
      setDescription(
          lang.avalancheDescription,
          lang.optimismDescription,
          lang.ethereumDescription,
          lang.bscDescription,
          lang.arbitrumDescription,
          lang.polygonDescription,
          lang.fantomDescription,
          lang.tronDescription,
          lang.baseDescription,
          lang.lineaDescription,
          lang.cronosDescription,
          lang.mantleDescription,
          lang.gnosisDescription,
          lang.kavaDescription,
          lang.roninDescription,
          lang.zksyncDescription,
          lang.celoDescription,
          lang.scrollDescription,
          lang.hederaDescription,
          lang.blastDescription);
      notifyListeners();
    }
  }

  void setDescription(
      String avalanche,
      String optimism,
      String ethereum,
      String bsc,
      String arbitrum,
      String polygon,
      String fantom,
      String tron,
      String base,
      String linea,
      String cronos,
      String mantle,
      String gnosis,
      String kava,
      String ronin,
      String zksync,
      String celo,
      String scroll,
      String hedera,
      String blast) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (_currentChain) {
      case Chain.Blast:
        _description = blast;
      case Chain.Avalanche:
        _description = avalanche;
        break;
      case Chain.Optimism:
        _description = optimism;
        break;
      case Chain.Ethereum:
        _description = ethereum;
        break;
      case Chain.BSC:
        _description = bsc;
        break;
      case Chain.Arbitrum:
        _description = arbitrum;
        break;
      case Chain.Polygon:
        _description = polygon;
        break;
      case Chain.Fantom:
        _description = fantom;
        break;
      case Chain.Tron:
        _description = tron;
      case Chain.Base:
        _description = base;
      case Chain.Linea:
        _description = linea;
      case Chain.Cronos:
        _description = cronos;
      case Chain.Mantle:
        _description = mantle;
      case Chain.Gnosis:
        _description = gnosis;
      case Chain.Kava:
        _description = kava;
      case Chain.Ronin:
        _description = ronin;
      case Chain.Zksync:
        _description = zksync;
      case Chain.Celo:
        _description = celo;
      case Chain.Scroll:
        _description = scroll;
      case Chain.Hedera:
        _description = hedera;
      default:
        _description = avalanche;
    }
    notifyListeners();
  }

  void setDraws(int dr) {
    _lotteryDraws = dr;
    notifyListeners();
  }

  void setPrize(Decimal p) {
    _nextPrize = p;
    notifyListeners();
  }

  void setDistributed(Decimal dist) {
    _prizesDistributed = dist;
    notifyListeners();
  }

  void setWinners(int w) {
    _winners = w;
    notifyListeners();
  }

  void setValueLoaned(Decimal v) {
    _valueLoaned = v;
    notifyListeners();
  }

  void setValueBorrowed(Decimal b) {
    _valueBorrowed = b;
    notifyListeners();
  }

  void setValueDeposited(Decimal v) {
    _valueDeposited = v;
    notifyListeners();
  }

  void setValueWithdrawn(Decimal v) {
    _valueWithdrawn = v;
    notifyListeners();
  }

  void setNumDeposits(int n) {
    _deposits = n;
    notifyListeners();
  }

  void setNumWithdrawals(int n) {
    _withdrawals = n;
    notifyListeners();
  }

  void setValueTransfered(Decimal v) {
    _valueTransfered = v;
    notifyListeners();
  }

  void setTransfers(int t) {
    _transfers = t;
    notifyListeners();
  }

  void setMode(TableMode tm) {
    _mode = tm;
    notifyListeners();
  }

  void setTransferTable(List<ExplorerTransfer> t) {
    _transferTable = t;
    notifyListeners();
  }

  void setPaymentTable(List<ExplorerPayment> p) {
    _paymentTable = p;
    notifyListeners();
  }

  void setTrustTable(List<ExplorerTrust> tr) {
    _trustTable = tr;
    notifyListeners();
  }

  void setBridgeTable(List<ExplorerBridge> b) {
    _bridgeTable = b;
    notifyListeners();
  }

  void setEscrowTable(List<ExplorerEscrow> e) {
    _escrowTable = e;
    notifyListeners();
  }

  void initExplorer({
    required String paramDescription,
    required int paramDraws,
    required int paramWinners,
    required Decimal paramNextPrize,
    required Decimal paramPrizesDistributed,
    required Decimal paramValueLoaned,
    required Decimal paramValueBorrowed,
    required Decimal paramValueDeposited,
    required Decimal paramValueWithdrawn,
    required Decimal paramValueTransfered,
    required int paramDeposits,
    required int paramWithdrawals,
    required int paramTransfers,
    required List<ExplorerTransfer> paramTransferTable,
  }) {
    setDraws(paramDraws);
    setWinners(paramWinners);
    setPrize(paramNextPrize);
    setDistributed(paramPrizesDistributed);
    setValueLoaned(paramValueLoaned);
    setValueBorrowed(paramValueBorrowed);
    setValueDeposited(paramValueDeposited);
    setValueWithdrawn(paramValueWithdrawn);
    setValueTransfered(paramValueTransfered);
    setNumDeposits(paramDeposits);
    setNumWithdrawals(paramWithdrawals);
    setTransfers(paramTransfers);
    setTransferTable(paramTransferTable);
  }
}
