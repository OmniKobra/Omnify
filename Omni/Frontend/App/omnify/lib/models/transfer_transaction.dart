import 'package:decimal/decimal.dart';

import 'asset.dart';

class TransferActivityTransaction {
  final CryptoAsset asset;
  final String address;
  final bool isOutgoing;
  final DateTime date;
  final String id;
  final Decimal amount;
  const TransferActivityTransaction(
      {required this.asset,
      required this.address,
      required this.isOutgoing,
      required this.date,
      required this.id,
      required this.amount});
}
