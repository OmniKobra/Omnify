import 'package:decimal/decimal.dart';

class EscrowContract {
  final Decimal amount;
  final String escrowID;
  final String ownerAddress;
  final String assetAddress;
  final String coinName;
  final int decimals;
  final String imageUrl;
  final List<EscrowBid> bids;
  bool isDeleted;
  final DateTime dateCreated;
  DateTime dateDeleted;
  EscrowContract(
      {required this.amount,
      required this.escrowID,
      required this.ownerAddress,
      required this.assetAddress,
      required this.coinName,
      required this.decimals,
      required this.imageUrl,
      required this.bids,
      required this.isDeleted,
      required this.dateCreated,
      required this.dateDeleted});
  void deleteContract() {
    isDeleted = true;
    dateDeleted = DateTime.now();
  }
}

class EscrowBid {
  final String bidderAddress;
  final Decimal amount;
  final String assetAddress;
  final String coinName;
  final String imageUrl;
  final int decimals;
  final DateTime dateBid;
  bool bidAccepted;
  bool bidCancelled;
  EscrowBid(
      {required this.amount,
      required this.bidderAddress,
      required this.assetAddress,
      required this.coinName,
      required this.imageUrl,
      required this.bidAccepted,
      required this.bidCancelled,
      required this.decimals,
      required this.dateBid});
  void acceptBid() {
    bidAccepted = true;
  }

  void cancelBid() {
    bidCancelled = true;
  }
}
