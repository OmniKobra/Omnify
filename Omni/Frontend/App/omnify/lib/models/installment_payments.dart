import 'package:decimal/decimal.dart';

class InstallmentPayment {
  final Decimal amount;
  final DateTime dateDue;
  DateTime dateSettled;
  bool isPaid;
  InstallmentPayment(
      {required this.amount,
      required this.dateDue,
      required this.dateSettled,
      required this.isPaid});
  void payIt() {
    isPaid = true;
    dateSettled = DateTime.now();
  }
}
