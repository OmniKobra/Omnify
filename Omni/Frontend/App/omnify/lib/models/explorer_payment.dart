import 'package:decimal/decimal.dart';

class ExplorerPayment {
  final String id;
  final String payer;
  final Decimal amount;
  final String status;
  final String recipient;
  final DateTime date;
  const ExplorerPayment(
      {required this.payer,
      required this.id,
      required this.amount,
      required this.status,
      required this.recipient,
      required this.date});
}
