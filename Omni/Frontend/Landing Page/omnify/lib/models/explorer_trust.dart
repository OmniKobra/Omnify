import 'package:decimal/decimal.dart';
import 'asset.dart';

class ExplorerTrust {
  final String id;
  final String depositor;
  final String status;
  final Decimal amount;
  final DateTime date;
  final CryptoAsset asset;
  final List<String> owners;
  final List<Beneficiary> beneficiaries;
  const ExplorerTrust(
      {required this.id,
      required this.depositor,
      required this.status,
      required this.amount,
      required this.asset,
      required this.date,
      required this.owners,
      required this.beneficiaries});
}

class Beneficiary {
  final String address;
  final Decimal allowancePerDay;
  final bool isLimited;
  final DateTime dateLastWithdrawal;
  const Beneficiary(
      {required this.address,
      required this.allowancePerDay,
      required this.isLimited,
      required this.dateLastWithdrawal});
}
