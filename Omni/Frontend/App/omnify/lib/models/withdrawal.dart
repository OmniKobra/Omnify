import 'package:decimal/decimal.dart';

class Withdrawal {
  final Decimal amount;
  final DateTime date;
  const Withdrawal(this.amount, this.date);
}
