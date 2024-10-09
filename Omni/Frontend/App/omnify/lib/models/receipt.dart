import 'package:decimal/decimal.dart';

class Receipt {
  final String id;
  final String vendor;
  final String payer;
  final Decimal amount;
  bool isRefunded;
  final DateTime date;
  final String transactionHash;
  final int blockNumber;
  Receipt(
      {required this.id,
      required this.vendor,
      required this.payer,
      required this.amount,
      required this.isRefunded,
      required this.date,
      required this.transactionHash,
      required this.blockNumber});
  void refundPayment() {
    isRefunded = true;
  }
}
