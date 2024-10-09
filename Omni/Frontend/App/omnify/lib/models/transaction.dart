import '../utils.dart';

enum TransactionType { transfer, payment, trust, bridge, escrow }

enum Status { pending, omnifyReceived, omnifySent, complete, failed }

class Transaction {
  final Chain c;
  final Chain? destinationChain;
  final TransactionType type;
  final String id;
  final DateTime date;
  final String transactionHash;
  int blockNumber;
  String secondTransactionHash;
  int secondBlockNumber;
  String thirdTransactionHash;
  int thirdBlockNumber;
  Status status;
  Transaction(
      {required this.c,
      required this.type,
      required this.id,
      required this.date,
      required this.status,
      required this.transactionHash,
      required this.blockNumber,
      required this.secondTransactionHash,
      required this.secondBlockNumber,
      required this.thirdTransactionHash,
      required this.thirdBlockNumber,
      this.destinationChain});
  void setStatus(Status s) {
    status = s;
  }

  void setBlockNum(int nb) {
    blockNumber = nb;
  }

  void setSecondHash(String txn2) {
    secondTransactionHash = txn2;
  }

  void setSecondBlockNumber(int b2) {
    secondBlockNumber = b2;
  }
}
