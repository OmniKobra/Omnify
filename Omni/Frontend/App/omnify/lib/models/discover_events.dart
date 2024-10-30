import 'package:decimal/decimal.dart';

import '../utils.dart';

enum TransferEventType { received, sent, completed }

enum PaymentEventType { payment, withdrawal, installlmentPayment, refund }

enum TrustEventType { deposit, withdrawal, modification, retraction }

enum BridgeEventType { receive, migrate }

enum EscrowEventType { newContract, deleteContract, newBid, bidAccepted }

class DiscoverTransferEvent {
  final String id;
  final String senderAddress;
  final String recipientAddress;
  final Decimal amount;
  final String asset;
  final String transactionHash;
  final int blockNumber;
  final TransferEventType type;
  final DateTime date;
  const DiscoverTransferEvent(
      {required this.id,
      required this.senderAddress,
      required this.recipientAddress,
      required this.amount,
      required this.asset,
      required this.transactionHash,
      required this.blockNumber,
      required this.type,
      required this.date});
}

class DiscoverPaymentEvent {
  final String id;
  final String payerAddress;
  final String vendorAddress;
  final Decimal amount;
  final String transactionHash;
  final int blockNumber;
  final PaymentEventType type;
  final DateTime date;
  const DiscoverPaymentEvent(
      {required this.id,
      required this.payerAddress,
      required this.vendorAddress,
      required this.amount,
      required this.transactionHash,
      required this.blockNumber,
      required this.type,
      required this.date});
}

class DiscoverTrustEvent {
  final String id;
  final String initiatorAddress;
  final Decimal amount;
  final String asset;
  final String transactionHash;
  final int blockNumber;
  final TrustEventType type;
  final DateTime date;
  const DiscoverTrustEvent(
      {required this.id,
      required this.initiatorAddress,
      required this.amount,
      required this.asset,
      required this.transactionHash,
      required this.blockNumber,
      required this.type,
      required this.date});
}

class DiscoverBridgeEvent {
  final String id;
  final String sourceAddress;
  final String destinationAddress;
  final Chain sourceChain;
  final Chain destinationChain;
  final String asset;
  final Decimal amount;
  final String transactionHash;
  final int blockNumber;
  final BridgeEventType type;
  final DateTime date;
  const DiscoverBridgeEvent(
      {required this.id,
      required this.sourceAddress,
      required this.destinationAddress,
      required this.sourceChain,
      required this.destinationChain,
      required this.asset,
      required this.amount,
      required this.transactionHash,
      required this.blockNumber,
      required this.type,
      required this.date});
}

class DiscoverEscrowEvent {
  final String id;
  final String ownerAddress;
  final String contractID;
  final String transactionHash;
  final int blockNumber;
  final EscrowEventType type;
  final DateTime date;
  const DiscoverEscrowEvent(
      {required this.id,
      required this.ownerAddress,
      required this.contractID,
      required this.transactionHash,
      required this.blockNumber,
      required this.type,
      required this.date});
}
