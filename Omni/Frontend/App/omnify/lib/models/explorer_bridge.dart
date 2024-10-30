import 'package:decimal/decimal.dart';

import '../utils.dart';
import 'asset.dart';

class ExplorerBridge {
  final String id;
  final Chain sourceChain;
  final Chain destinationChain;
  final String sourceAddress;
  final String destinationAddress;
  final CryptoAsset asset;
  final Decimal amount;
  final DateTime date;
  const ExplorerBridge(
      {required this.id,
      required this.sourceChain,
      required this.destinationChain,
      required this.sourceAddress,
      required this.destinationAddress,
      required this.amount,
      required this.asset,
      required this.date});
}
