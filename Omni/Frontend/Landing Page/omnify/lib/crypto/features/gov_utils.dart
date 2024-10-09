import 'package:decimal/decimal.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../models/distribution_round.dart';
import '../../models/milestone.dart';
import '../../models/proposal.dart';
import '../../utils.dart';
import '../utils/aliases.dart';
import '../utils/chain_utils.dart';

class GovUtils {
  static Future<List<Proposal>> getProposals({
    required Chain c,
    required Web3Client client,
    required String walletAddress,
  }) async {
    var alias = Aliases.getAlias(c);
    var govContract = alias.omnifyContract(c, client);
    List<Proposal> proposals = [];
    var proposalCount = await govContract.proposalCount();
    var _proposalCount = proposalCount.toInt();
    EthereumAddress _myAddress = ChainUtils.ethAddressFromHex(c, walletAddress);
    var now = DateTime.now();
    var _coinsReceivedDate =
        await govContract.dateCoinsReceived(($param9: _myAddress));
    var _proposalPeriodBig = await govContract.proposalVotingPeriod();
    var _proposalPeriodSeconds = _proposalPeriodBig.toInt();
    var _proposalPeriodDays = _proposalPeriodSeconds / 86400;
    var _proposalPeriodDuration = Duration(days: _proposalPeriodDays.toInt());
    var _dateReceived = ChainUtils.chainDateToDt(_coinsReceivedDate);
    var _dateC = _dateReceived.add(_proposalPeriodDuration);
    var _dateCanVote = _dateC.add(const Duration(days: 1));
    if (_proposalCount > 1) {
      for (var i = 1; i < _proposalCount; i++) {
        var _id = BigInt.from(i);
        var _title = await govContract.lookupProposalTitle((id: _id));
        var _description =
            await govContract.lookupProposalDescription((id: _id));
        var _submitter = await govContract.lookupProposalProposer((id: _id));
        var _submitterAddress = ChainUtils.hexFromEthAddress(c, _submitter);
        var d = await govContract.lookupProposalDate((id: _id));
        var _date = ChainUtils.chainDateToDt(d);
        var _proposalExpiry = _date.add(_proposalPeriodDuration);
        var _hasVoted =
            await govContract.checkHasVoted((id: _id, voter: _myAddress));
        var _yayBig = await govContract.lookupProposalYesses((id: _id));
        var _yay = _yayBig.toInt();
        var _nayBig = await govContract.lookupProposalNos((id: _id));
        var _nay = _nayBig.toInt();
        var _allowedToVote =
            _dateCanVote.isBefore(now) && _proposalExpiry.isAfter(now);
        var _proposal = Proposal(
            proposalId: i.toString(),
            title: _title,
            description: _description,
            submitter: _submitterAddress,
            network: c,
            dateSubmitted: _date,
            hasVoted: _hasVoted,
            allowedToVote: _allowedToVote,
            expiration: _proposalExpiry,
            yay: _yay,
            nay: _nay);
        if (!proposals.any((p) => p.proposalId == i.toString())) {
          proposals.add(_proposal);
        }
      }
      return proposals;
    } else {
      return proposals;
    }
  }

  static Future<List<Milestone>> getMilestones({
    required Chain c,
    required Web3Client client,
  }) async {
    var alias = Aliases.getAlias(c);
    var govContract = alias.omnifyContract(c, client);
    List<Milestone> milestones = [];
    List<dynamic> lookupMilestones = await govContract.lookupMilestones();
    if (lookupMilestones.isNotEmpty) {
      for (var m in lookupMilestones) {
        var title = m[0];
        var description = m[1];
        var d = m[2];
        var date = ChainUtils.chainDateToDt(d);
        var milestone = Milestone(title, description, date);
        if (title.isNotEmpty && description.isNotEmpty) {
          milestones.add(milestone);
        }
      }
      return milestones;
    } else {
      return milestones;
    }
  }

  static Future<Duration> getRoundInterval({
    required Chain c,
    required Web3Client client,
  }) async {
    var alias = Aliases.getAlias(c);
    var govContract = alias.omnifyContract(c, client);
    var roundIntervalInBigSeconds =
        await govContract.distributionRoundInterval();
    var roundIntervalSeconds = roundIntervalInBigSeconds.toInt();
    var roundIntervalInDays = roundIntervalSeconds / 86400;
    return Duration(days: roundIntervalInDays.toInt());
  }

  static Future<Duration> getCoinHoldingPeriod({
    required Chain c,
    required Web3Client client,
  }) async {
    var alias = Aliases.getAlias(c);
    var govContract = alias.omnifyContract(c, client);
    var coinHoldingInBigSeconds = await govContract.coinHoldingPeriod();
    var coinHoldingSeconds = coinHoldingInBigSeconds.toInt();
    var coinHoldingDays = coinHoldingSeconds / 86400;
    return Duration(days: coinHoldingDays.toInt());
  }

  static Future<int> getYourShares({
    required Chain c,
    required Web3Client client,
    required String walletAddress,
  }) async {
    var alias = Aliases.getAlias(c);
    var myAddress = ChainUtils.ethAddressFromHex(c, walletAddress);
    var ofyContract = alias.omnicoinContract(c, client);
    var ofyBalance = await ofyContract.balanceOf((account: myAddress));
    var _balance = ofyBalance.toInt();
    return _balance;
  }

  static Future<List<DistributionRound>> getDistributionRounds({
    required Chain c,
    required Web3Client client,
    required String walletAddress,
  }) async {
    var alias = Aliases.getAlias(c);
    var govContract = alias.omnifyContract(c, client);
    var myAddress = ChainUtils.ethAddressFromHex(c, walletAddress);
    var ofyContract = alias.omnicoinContract(c, client);
    var ofyBalance = await ofyContract.balanceOf((account: myAddress));
    var _balance = ofyBalance.toInt();
    var _balanceString = _balance.toString();
    var _balanceDecimal = Decimal.parse(_balanceString);
    var _roundInterval = await getRoundInterval(c: c, client: client);
    var _coinHoldPeriod = await getCoinHoldingPeriod(c: c, client: client);
    var now = DateTime.now();
    var _coinsReceivedDate =
        await govContract.dateCoinsReceived(($param9: myAddress));
    var _dateReceived = ChainUtils.chainDateToDt(_coinsReceivedDate);
    var _dateAllowWithdraw = _dateReceived.add(_coinHoldPeriod);
    var _hasHeldTokensEnough = now.isAfter(_dateAllowWithdraw);
    List<DistributionRound> rounds = [];
    var _roundCountBig = await govContract.currentRoundNumber();
    var _roundCount = _roundCountBig.toInt();
    if (_roundCount > 0) {
      for (var i = 1; i <= _roundCount; i++) {
        var _id = BigInt.from(i);
        var _feesCollected =
            await govContract.lookupRoundFeesCollected((roundNum: _id));
        var _collected = ChainUtils.nativeUintToDecimal(c, _feesCollected);
        var _profitPerShare =
            await govContract.lookupRoundProfitPerShare((roundNum: _id));
        var _perShare = ChainUtils.nativeUintToDecimal(c, _profitPerShare);
        var _yourCut = _perShare * _balanceDecimal;
        var _profitsWithdrawn =
            await govContract.lookupAmountWithdrawn((roundNum: _id));
        var _withdrawn = ChainUtils.nativeUintToDecimal(c, _profitsWithdrawn);
        var _profitsRemaining =
            await govContract.lookupAmountRemaining((roundNum: _id));
        var _remaining = ChainUtils.nativeUintToDecimal(c, _profitsRemaining);
        var _hasWithdrawn = await govContract.lookupHasWithdrawnFromRound(
            (address: myAddress, roundNumber: _id));
        var d = await govContract.lookupRoundDate((roundNum: _id));
        var _date = ChainUtils.chainDateToDt(d);
        var _closingDate = _date.add(_roundInterval);
        var _roundOpen = _closingDate.isAfter(now);
        var round = DistributionRound(
            roundNumber: i,
            feesCollected: _collected,
            profitPerShare: _perShare,
            profitsWithdrawn: _withdrawn,
            profitsRemaining: _remaining,
            yourCut: _yourCut,
            hasWithdrawn: _hasWithdrawn,
            roundOpen: _roundOpen,
            hasHeldTokensEnough: _hasHeldTokensEnough,
            date: _date);
        if (!rounds.any((r) => r.roundNumber == i)) {
          rounds.add(round);
        }
      }
      return rounds;
    } else {
      return rounds;
    }
  }

  static Future<Decimal> fetchProposalFee({
    required Chain c,
    required Web3Client client,
  }) async {
    var alias = Aliases.getAlias(c);
    var govContract = alias.omnifyContract(c, client);
    var _fee = await govContract.proposalFee();
    Decimal _proposalFee = ChainUtils.nativeUintToDecimal(c, _fee);
    return _proposalFee;
  }

  static Future<String?> submitProposal({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required String title,
    required String description,
  }) async {
    var alias = Aliases.getAlias(c);
    var govContract = alias.omnifyContract(c, client);
    var _fee = await govContract.proposalFee();
    final transaction = Transaction.callContract(
        contract: govContract.self,
        function: govContract.self.function("submitProposal"),
        value: EtherAmount.inWei(_fee),
        from: ChainUtils.ethAddressFromHex(c, walletAddress),
        parameters: [title, description]);
    try {
      var sentTx = await wcClient.request(
          topic: sessionTopic,
          chainId: ChainUtils.getChainIdString(c),
          request: SessionRequestParams(
            method: ChainUtils.getSendTransactionString(c),
            params: [transaction.toJson()],
          ));
      return sentTx;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> voteYes({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required String proposalID,
  }) async {
    var alias = Aliases.getAlias(c);
    var govContract = alias.omnifyContract(c, client);
    var _intId = int.parse(proposalID);
    var _bigID = BigInt.from(_intId);
    final transaction = Transaction.callContract(
        contract: govContract.self,
        function: govContract.self.function("voteYes"),
        value: EtherAmount.inWei(BigInt.from(0)),
        from: ChainUtils.ethAddressFromHex(c, walletAddress),
        parameters: [_bigID]);
    try {
      var sentTx = await wcClient.request(
          topic: sessionTopic,
          chainId: ChainUtils.getChainIdString(c),
          request: SessionRequestParams(
            method: ChainUtils.getSendTransactionString(c),
            params: [transaction.toJson()],
          ));
      return sentTx;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> voteNo({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required String proposalID,
  }) async {
    var alias = Aliases.getAlias(c);
    var govContract = alias.omnifyContract(c, client);
    var _intId = int.parse(proposalID);
    var _bigID = BigInt.from(_intId);
    final transaction = Transaction.callContract(
        contract: govContract.self,
        function: govContract.self.function("voteNo"),
        value: EtherAmount.inWei(BigInt.from(0)),
        from: ChainUtils.ethAddressFromHex(c, walletAddress),
        parameters: [_bigID]);
    try {
      var sentTx = await wcClient.request(
          topic: sessionTopic,
          chainId: ChainUtils.getChainIdString(c),
          request: SessionRequestParams(
            method: ChainUtils.getSendTransactionString(c),
            params: [transaction.toJson()],
          ));
      return sentTx;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> withdrawProfits({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
  }) async {
    var alias = Aliases.getAlias(c);
    var govContract = alias.omnifyContract(c, client);
    final transaction = Transaction.callContract(
        contract: govContract.self,
        function: govContract.self.function("withdrawProfits"),
        value: EtherAmount.inWei(BigInt.from(0)),
        from: ChainUtils.ethAddressFromHex(c, walletAddress),
        parameters: []);
    try {
      var sentTx = await wcClient.request(
          topic: sessionTopic,
          chainId: ChainUtils.getChainIdString(c),
          request: SessionRequestParams(
            method: ChainUtils.getSendTransactionString(c),
            params: [transaction.toJson()],
          ));
      return sentTx;
    } catch (e) {
      return null;
    }
  }

  static Future<void> initGovernanceTab(
      {required Chain c,
      required Web3Client client,
      required String walletAddress,
      required void Function(
              {required List<Proposal> paramProposals,
              required List<Milestone> paramMilestones,
              required List<DistributionRound> paramRounds,
              required Decimal paramFeePerProposal,
              required int paramYourShares,
              required Decimal paramYourProfitsWithdrawn,
              required Decimal paramTotalProfitsDistributed,
              required Decimal currentProfits,
              required Duration paramRoundInterval,
              required Duration paramCoinHoldingPeriod,
              required DateTime paramDateCoinsReceived})
          initGov}) async {
    var alias = Aliases.getAlias(c);
    var govContract = alias.omnifyContract(c, client);
    var myAddress = ChainUtils.ethAddressFromHex(c, walletAddress);
    var proposals =
        await getProposals(c: c, client: client, walletAddress: walletAddress);
    var milestones = await getMilestones(c: c, client: client);
    var rounds = await getDistributionRounds(
        c: c, client: client, walletAddress: walletAddress);
    var feePerProposal = await fetchProposalFee(c: c, client: client);
    var yourShares =
        await getYourShares(c: c, client: client, walletAddress: walletAddress);
    var yourProfitsWithdrawn =
        await govContract.lookupAddressProfits((address: myAddress));
    var _yourProfitsWithdrawn =
        ChainUtils.nativeUintToDecimal(c, yourProfitsWithdrawn);
    var totalProfitsDistributed = await govContract.totalProfitsDistributed();
    var _totalProfitsDistributed =
        ChainUtils.nativeUintToDecimal(c, totalProfitsDistributed);
    var currentProfits = await govContract.currentProfitsCollected();
    var _currentProfits = ChainUtils.nativeUintToDecimal(c, currentProfits);
    var roundInterval = await getRoundInterval(c: c, client: client);
    var coinHoldingPeriod = await getCoinHoldingPeriod(c: c, client: client);
    var _coinsReceivedDate =
        await govContract.dateCoinsReceived(($param9: myAddress));
    var _dateReceived = ChainUtils.chainDateToDt(_coinsReceivedDate);
    initGov(
        paramProposals: proposals,
        paramMilestones: milestones,
        paramRounds: rounds,
        paramFeePerProposal: feePerProposal,
        paramYourShares: yourShares,
        paramYourProfitsWithdrawn: _yourProfitsWithdrawn,
        paramTotalProfitsDistributed: _totalProfitsDistributed,
        currentProfits: _currentProfits,
        paramRoundInterval: roundInterval,
        paramCoinHoldingPeriod: coinHoldingPeriod,
        paramDateCoinsReceived: _dateReceived);
  }
}
