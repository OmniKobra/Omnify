import 'package:decimal/decimal.dart';

import 'asset.dart';

class ExplorerTransfer {
  final String id;
  final String sender;
  final String recipient;
  final Decimal amount;
  final CryptoAsset asset;
  final String status;
  final DateTime date;
  const ExplorerTransfer(
      {required this.id,
      required this.recipient,
      required this.sender,
      required this.amount,
      required this.asset,
      required this.status,
      required this.date});
}
