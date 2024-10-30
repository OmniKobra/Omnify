import 'package:decimal/decimal.dart';

import '../utils.dart';

class BridgeAsset {
  final String symbol;
  final Decimal amount;
  final String imageUrl;
  final int decimals;
  final String address;
  const BridgeAsset(
      this.address, this.symbol, this.amount, this.imageUrl, this.decimals);
}

class BridgeTransaction {
  final String id;
  final bool isOutgoing;
  final Chain sourceChain;
  final Decimal assetAmount;
  final String assetImage;
  final String assetAddress;
  final int decimals;
  final String assetSymbol;
  final Chain destinationChain;
  final DateTime date;
  final String sender;
  final String recipient;
  const BridgeTransaction(
      {required this.id,
      required this.isOutgoing,
      required this.sourceChain,
      required this.assetAmount,
      required this.assetImage,
      required this.assetSymbol,
      required this.assetAddress,
      required this.decimals,
      required this.destinationChain,
      required this.date,
      required this.sender,
      required this.recipient});
}
