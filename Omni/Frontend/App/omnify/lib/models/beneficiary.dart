import 'package:decimal/decimal.dart';

class Beneficiary {
  final String address;
  final Decimal allowancePerDay;
  final bool isLimited;
  DateTime dateLastWithdrawal;
  Beneficiary(
      {required this.address,
      required this.allowancePerDay,
      required this.isLimited,
      required this.dateLastWithdrawal});
  void setHasWithdrawn() {
    dateLastWithdrawal = DateTime.now();
  }
}
