import 'package:decimal/decimal.dart';

import 'beneficiary.dart';
import '../utils.dart';
import '../models/asset.dart';

class Deposit {
  final Chain chain;
  final String id;
  final CryptoAsset asset;
  final Decimal amountInitial;
  Decimal amountRemaining;
  // final Decimal myAllowance;
  final bool isFixed;
  final bool isRetractable;
  bool isActive;
  List<Beneficiary> beneficiaries;
  final List<String> owners;
  final DateTime dateCreated;
  Deposit(
      {required this.chain,
      required this.id,
      required this.asset,
      required this.amountInitial,
      required this.amountRemaining,
      // required this.myAllowance,
      required this.isFixed,
      required this.isRetractable,
      required this.isActive,
      required this.beneficiaries,
      required this.dateCreated,
      required this.owners});
  void withdrawAmount(Decimal a) {
    amountRemaining -= a;
  }

  void retractDeposit() {
    isActive = false;
    amountRemaining = Decimal.parse("0.0");
  }

  void depositAmount(Decimal a) {
    amountRemaining += a;
  }

  void modifyDeposit(List<Beneficiary> newBenefs, bool newActive) {
    beneficiaries = newBenefs;
    isActive = newActive;
  }
}
