import 'package:decimal/decimal.dart';
import 'package:web3dart/web3dart.dart';

import '../crypto/contracts/omnicoinAbi.g.dart';
import '../crypto/utils/chain_utils.dart';
import '../utils.dart';

class CryptoAsset {
  final String address;
  final String symbol;
  final int decimals;
  final String logoUrl;
  Decimal maxBalance = Decimal.parse("0.0");
  void deductMaxBalance(Decimal amount) {
    maxBalance -= amount;
  }

  CryptoAsset(
      {required this.address,
      required this.symbol,
      required this.decimals,
      required this.logoUrl});

  EthereumAddress assetEthAddress(Chain c) =>
      ChainUtils.ethAddressFromHex(c, address);
  OmnicoinAbi assetContract(Chain c, Web3Client client) =>
      OmnicoinAbi(address: assetEthAddress(c), client: client);
}
