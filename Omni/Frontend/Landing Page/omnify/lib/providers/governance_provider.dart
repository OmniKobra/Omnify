// ignore_for_file: prefer_const_constructors

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';

import '../crypto/features/gov_utils.dart';
import '../languages/app_language.dart';
import '../models/distribution_round.dart';
import '../models/milestone.dart';
import '../models/proposal.dart';
import '../utils.dart';

class GovernanceProvider with ChangeNotifier {
  Chain _currentChain = Chain.Avalanche;
  Decimal _feePerProposal = Decimal.parse("0.00");
  int _yourShares = 0;
  DateTime _dateCoinsReceived = DateTime.now();
  Decimal _yourProfitsWithdrawn = Decimal.parse("0.00");
  Decimal _totalProfitsDistributed = Decimal.parse("0.000");
  Decimal _currentProfits = Decimal.parse("0.0");
  Duration _roundInterval = Duration(days: 7);
  Duration _coinHoldingPeriod = Duration(days: 8);
  List<Proposal> _allProposals = [];
  List<Proposal> _proposals = [];
  List<Milestone> _allMilestones = [];
  List<Milestone> _milestones = [];
  List<DistributionRound> _allRounds = [];
  List<DistributionRound> _rounds = [];
  Future<void>? _fetchGovernance;

  Chain get currentChain => _currentChain;
  Decimal get feePerProposal => _feePerProposal;
  int get yourShares => _yourShares;
  Decimal get yourProfitsWithdrawn => _yourProfitsWithdrawn;
  Decimal get totalProfitsDistributed => _totalProfitsDistributed;
  Decimal get currentProfits => _currentProfits;
  Duration get roundInterval => _roundInterval;
  Duration get coinHoldingPeriod => _coinHoldingPeriod;
  List<Proposal> get proposals => _proposals;
  List<Proposal> get allProposals => _allProposals;
  List<Milestone> get milestones => _milestones;
  List<Milestone> get allMilestones => _allMilestones;
  List<DistributionRound> get rounds => _rounds;
  List<DistributionRound> get allRounds => _allRounds;
  Future<void>? get fetchGovernance => _fetchGovernance;

  void setFeePerProposal(Decimal fee) {
    _feePerProposal = fee;
    notifyListeners();
  }

  Duration getDurationCoinHoldWait() {
    var now = DateTime.now();
    var _unlock = _dateCoinsReceived.add(_coinHoldingPeriod);
    if (_unlock.isBefore(now)) {
      return const Duration();
    } else {
      return _unlock.difference(now);
    }
  }

  void setDateCoinsReceived(DateTime d) {
    _dateCoinsReceived = d;
    notifyListeners();
  }

  void setYourShares(int s) {
    _yourShares = s;
    notifyListeners();
  }

  void setYourProfitsWithdrawn(Decimal yp) {
    _yourProfitsWithdrawn = yp;
    notifyListeners();
  }

  void setTotalProfitsDistributed(Decimal dp) {
    _totalProfitsDistributed = dp;
    notifyListeners();
  }

  void setCurrentProfits(Decimal cp) {
    _currentProfits = cp;
    notifyListeners();
  }

  void setRoundInterval(Duration ds) {
    _roundInterval = ds;
    notifyListeners();
  }

  void setCoinHoldingPeriod(Duration c) {
    _coinHoldingPeriod = c;
    notifyListeners();
  }

  void setChain(Chain c, AppLanguage lang, Web3Client client,
      [String? address, bool? setFuture]) {
    _currentChain = c;
    _milestones.clear();
    _proposals.clear();
    _rounds.clear();
    _feePerProposal = Decimal.parse("0.0");
    _yourShares = 0;
    _yourProfitsWithdrawn = Decimal.parse("0.0");
    _totalProfitsDistributed = Decimal.parse("0.0");
    _currentProfits = Decimal.parse("0.0");
    if (setFuture != null) {
      _fetchGovernance = GovUtils.initGovernanceTab(
          c: c, client: client, walletAddress: address!, initGov: initGov);
    }
    notifyListeners();
  }

  void setFuture(Chain c, String address, bool notify, Web3Client client) {
    _fetchGovernance = GovUtils.initGovernanceTab(
        c: c, client: client, walletAddress: address, initGov: initGov);
    if (notify) notifyListeners();
  }

  void setProposals(List<Proposal> p) {
    _allProposals = p;
    _allProposals.sort((a, b) => b.dateSubmitted.compareTo(a.dateSubmitted));
    if (_allProposals.length > Utils.pageSize) {
      _proposals = _allProposals.take(Utils.pageSize).toList();
    } else {
      _proposals = p;
    }
    // notifyListeners();
  }

  void showMoreProposals() {
    var difference = _allProposals.length - _proposals.length;
    var lastShownId = _proposals.last.proposalId;
    var indexInAll =
        _allProposals.indexWhere((p) => p.proposalId == lastShownId);
    if (difference > Utils.pageSize) {
      var nextItems =
          _allProposals.getRange(indexInAll + 1, indexInAll + Utils.pageSize);
      _proposals.addAll(nextItems);
    } else {
      var nextItems =
          _allProposals.getRange(indexInAll + 1, _allProposals.length);
      _proposals.addAll(nextItems);
    }
    notifyListeners();
  }

  void setMilestones(List<Milestone> m) {
    _allMilestones = m;
    _allMilestones.sort((a, b) => b.dateCompleted.compareTo(a.dateCompleted));
    if (_allMilestones.length > Utils.pageSize) {
      _milestones = _allMilestones.take(Utils.pageSize).toList();
    } else {
      _milestones = m;
    }
    // notifyListeners();
  }

  void showMoreMilestones() {
    var difference = _allMilestones.length - _milestones.length;
    var last = _milestones.last;
    var index = _milestones.indexOf(last);
    if (difference > Utils.pageSize) {
      var nextItems =
          _allMilestones.getRange(index + 1, index + Utils.pageSize);
      _milestones.addAll(nextItems);
    } else {
      var nextItems = _allMilestones.getRange(index + 1, _allMilestones.length);
      _milestones.addAll(nextItems);
    }
    notifyListeners();
  }

  void setRounds(List<DistributionRound> r) {
    _allRounds = r;
    _allRounds.sort((a, b) => b.date.compareTo(a.date));
    if (_allRounds.length > Utils.pageSize) {
      _rounds = _allRounds.take(Utils.pageSize).toList();
    } else {
      _rounds = r;
    }
    // notifyListeners();
  }

  void showMoreRounds() {
    var difference = _allRounds.length - _rounds.length;
    var last = _rounds.last;
    var index = _rounds.indexOf(last);
    if (difference > Utils.pageSize) {
      var nextItems = _allRounds.getRange(index + 1, index + Utils.pageSize);
      _rounds.addAll(nextItems);
    } else {
      var nextItems = _allRounds.getRange(index + 1, _allRounds.length);
      _rounds.addAll(nextItems);
    }
    notifyListeners();
  }

  void initGov({
    required List<Proposal> paramProposals,
    required List<Milestone> paramMilestones,
    required List<DistributionRound> paramRounds,
    required Decimal paramFeePerProposal,
    required int paramYourShares,
    required Decimal paramYourProfitsWithdrawn,
    required Decimal paramTotalProfitsDistributed,
    required Decimal currentProfits,
    required Duration paramRoundInterval,
    required Duration paramCoinHoldingPeriod,
    required DateTime paramDateCoinsReceived,
  }) {
    setProposals(paramProposals);
    setMilestones(paramMilestones);
    setRounds(paramRounds);
    setFeePerProposal(paramFeePerProposal);
    setYourShares(paramYourShares);
    setYourProfitsWithdrawn(paramYourProfitsWithdrawn);
    setTotalProfitsDistributed(paramTotalProfitsDistributed);
    setCurrentProfits(currentProfits);
    setRoundInterval(paramRoundInterval);
    setCoinHoldingPeriod(paramCoinHoldingPeriod);
    setDateCoinsReceived(paramDateCoinsReceived);
  }
}
