import 'package:decimal/decimal.dart';

import 'escrow_contract.dart';
import 'asset.dart';

class ExplorerEscrow {
  final String id;
  final String owner;
  final Decimal amount;
  final CryptoAsset asset;
  final bool isDeleted;
  final bool isCompleted;
  final List<EscrowBid> bids;
  final DateTime date;
  const ExplorerEscrow(
      {required this.id,
      required this.owner,
      required this.amount,
      required this.asset,
      required this.isDeleted,
      required this.isCompleted,
      required this.bids,
      required this.date});
}
