import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';

import '../crypto/utils/aliases.dart';
import '../crypto/utils/chain_utils.dart';
import '../languages/app_language.dart';
import '../utils.dart';

class FeesProvider with ChangeNotifier {
  Chain _currentChain = Chain.Fuji;
  late Future<void> _getAndSetFees;
  FeeTier _transferFeeTier1 = FeeTier(
      lowThreshold: Decimal.parse("0.001"),
      highThreshold: Decimal.parse("9999.9999999999"),
      fee: Decimal.parse("0.03"));
  FeeTier _transferFeeTier2 = FeeTier(
      lowThreshold: Decimal.parse("10000"),
      highThreshold: Decimal.parse("99999.9999999999"),
      fee: Decimal.parse("0.3"));
  FeeTier _transferFeeTier3 = FeeTier(
      lowThreshold: Decimal.parse("100000"),
      highThreshold: Decimal.parse("999999.9999999999"),
      fee: Decimal.parse("3"));
  FeeTier _transferFeeTier4 = FeeTier(
      lowThreshold: Decimal.parse("1000000"),
      highThreshold: null,
      fee: Decimal.parse("5"));
  Decimal _altcoinTransferFee = Decimal.parse("0.06");
  PaymentFeeRow _paymentFees = PaymentFeeRow(
      amountPerPayment: Decimal.parse("0.01274"),
      amountPerInstallment: Decimal.parse("0.15"));
  TrustFeeRow _trustFees = TrustFeeRow(
      amountPerDeposit: Decimal.parse("0.12"),
      amountPerBeneficiary: Decimal.parse("0.03"));
  BridgeFeeRow _bridgeFees =
      BridgeFeeRow(feePerTransaction: Decimal.parse("0.15"));
  EscrowFeeRow _escrowFees =
      EscrowFeeRow(feePerContract: Decimal.parse("0.15"));

  FeeTier get transferFeeTier1 => _transferFeeTier1;
  FeeTier get transferFeeTier2 => _transferFeeTier2;
  FeeTier get transferFeeTier3 => _transferFeeTier3;
  FeeTier get transferFeeTier4 => _transferFeeTier4;
  Decimal get altcoinTransferFee => _altcoinTransferFee;
  PaymentFeeRow get paymentfees => _paymentFees;
  TrustFeeRow get trustFees => _trustFees;
  BridgeFeeRow get bridgeFees => _bridgeFees;
  Chain get currentChain => _currentChain;
  EscrowFeeRow get escrowFees => _escrowFees;
  Future<void> get getAndSetFeesFuture => _getAndSetFees;
  EthereumAddress addr(Chain c, String s) => ChainUtils.ethAddressFromHex(c, s);

  void setChain(Chain c, AppLanguage lang, Web3Client client) {
    if (c != _currentChain) {
      _currentChain = c;
      setFuture(true, client);
      notifyListeners();
    }
  }

  void setTransferTier1(FeeTier t1) {
    _transferFeeTier1 = t1;
    notifyListeners();
  }

  void setTransferTier2(FeeTier t2) {
    _transferFeeTier2 = t2;
    notifyListeners();
  }

  void setTransferTier3(FeeTier t3) {
    _transferFeeTier3 = t3;
    notifyListeners();
  }

  void setTransferTier4(FeeTier t4) {
    _transferFeeTier4 = t4;
    notifyListeners();
  }

  void setAltcoinFee(Decimal f) {
    _altcoinTransferFee = f;
    notifyListeners();
  }

  void setPaymentFees(PaymentFeeRow f) {
    _paymentFees = f;
    notifyListeners();
  }

  void setTrustFees(TrustFeeRow f) {
    _trustFees = f;
    notifyListeners();
  }

  void setBridgeFees(BridgeFeeRow f) {
    _bridgeFees = f;
    notifyListeners();
  }

  void setEscrowFees(EscrowFeeRow f) {
    _escrowFees = f;
    notifyListeners();
  }

  Future<List<dynamic>> getAndSetTransferFees(
    Chain c,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    final transferContract = alias.transfersContract(c, client);
    final _tier1 = await transferContract.tier1();
    final _tier2 = await transferContract.tier2();
    final _tier3 = await transferContract.tier3();
    final _tier4 = await transferContract.tier4();
    final _altcoinFee = await transferContract.altcoinFee();
    var t1 = FeeTier(
        lowThreshold: Utils.dec(c, _tier1.lowerThreshold),
        highThreshold: Utils.dec(c, _tier1.higherThreshold),
        fee: Utils.dec(c, _tier1.fee));
    var t2 = FeeTier(
        lowThreshold: Utils.dec(c, _tier2.lowerThreshold),
        highThreshold: Utils.dec(c, _tier2.higherThreshold),
        fee: Utils.dec(c, _tier2.fee));
    var t3 = FeeTier(
        lowThreshold: Utils.dec(c, _tier3.lowerThreshold),
        highThreshold: Utils.dec(c, _tier3.higherThreshold),
        fee: Utils.dec(c, _tier3.fee));
    var t4 = FeeTier(
        lowThreshold: Utils.dec(c, _tier4.lowerThreshold),
        highThreshold: null,
        fee: Utils.dec(c, _tier4.fee));
    setTransferTier1(t1);
    setTransferTier2(t2);
    setTransferTier3(t3);
    setTransferTier4(t4);
    setAltcoinFee(Utils.dec(c, _altcoinFee));
    return [t1, t2, t3, t4, Utils.dec(c, _altcoinFee)];
  }

  Future<void> getAndSetPaymentFees(
    Chain c,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    final paymentContract = alias.paymentsContract(c, client);
    final feePerPayment = await paymentContract.feePerPayment();
    final feePerInstallment = await paymentContract.feePerInstallment();
    setPaymentFees(PaymentFeeRow(
        amountPerPayment: Utils.dec(c, feePerPayment),
        amountPerInstallment: Utils.dec(c, feePerInstallment)));
  }

  Future<void> getAndSetTrustFees(
    Chain c,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    final trustContract = alias.trustContract(c, client);
    final depositFee = await trustContract.depositFee();
    final benefFee = await trustContract.beneficiaryFee();
    setTrustFees(TrustFeeRow(
        amountPerDeposit: Utils.dec(c, depositFee),
        amountPerBeneficiary: Utils.dec(c, benefFee)));
  }

  Future<void> getAndSetBridgeFees(
    Chain c,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    final bridgesContract = alias.bridgesContract(c, client);
    final bridgeFee = await bridgesContract.bridgeFee();
    setBridgeFees(BridgeFeeRow(feePerTransaction: Utils.dec(c, bridgeFee)));
  }

  Future<void> getAndSetEscrowFees(
    Chain c,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    final escrowContract = alias.escrowContract(c, client);
    final escrowFee = await escrowContract.contractFee();
    setEscrowFees(EscrowFeeRow(feePerContract: Utils.dec(c, escrowFee)));
  }

  Future<void> setFuture(bool notify, Web3Client client) async {
    _getAndSetFees = getAndSetFees(_currentChain, client);
    if (notify) notifyListeners();
  }

  Future<void> getAndSetFees(
    Chain c,
    Web3Client client,
  ) async {
    //TODO ADD NEW FEATURE HERE
    await getAndSetTransferFees(c, client);
    await getAndSetPaymentFees(c, client);
    await getAndSetTrustFees(c, client);
    await getAndSetBridgeFees(c, client);
    await getAndSetEscrowFees(c, client);
  }
}

class FeeTier {
  final Decimal lowThreshold;
  final Decimal? highThreshold;
  final Decimal fee;
  const FeeTier(
      {required this.lowThreshold,
      required this.highThreshold,
      required this.fee});
}

class PaymentFeeRow {
  final Decimal amountPerPayment;
  final Decimal amountPerInstallment;
  const PaymentFeeRow(
      {required this.amountPerPayment, required this.amountPerInstallment});
}

class TrustFeeRow {
  final Decimal amountPerDeposit;
  final Decimal amountPerBeneficiary;
  const TrustFeeRow(
      {required this.amountPerDeposit, required this.amountPerBeneficiary});
}

class BridgeFeeRow {
  final Decimal feePerTransaction;
  const BridgeFeeRow({required this.feePerTransaction});
}

class EscrowFeeRow {
  final Decimal feePerContract;
  const EscrowFeeRow({required this.feePerContract});
}
