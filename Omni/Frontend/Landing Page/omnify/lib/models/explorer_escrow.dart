import 'package:decimal/decimal.dart';
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

class EscrowBid {
  final Decimal amount;
  final String bidderAddress;
  final String assetAddress;
  final String coinName;
  final String imageUrl;
  final int decimals;
  final DateTime dateBid;
  final bool bidAccepted;
  final bool bidCancelled;
  const EscrowBid(
      {required this.amount,
      required this.bidderAddress,
      required this.assetAddress,
      required this.coinName,
      required this.imageUrl,
      required this.decimals,
      required this.bidAccepted,
      required this.bidCancelled,
      required this.dateBid});
}
