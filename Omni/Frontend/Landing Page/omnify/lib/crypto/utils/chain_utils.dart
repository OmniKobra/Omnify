// ignore_for_file: constant_identifier_names
import 'dart:math';
import 'dart:typed_data';

import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:decimal/decimal.dart';
import 'package:hex/hex.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../languages/app_language.dart';
import '../../models/asset.dart';
import '../../toasts.dart';
import '../../utils.dart';
import '../contracts/omnicoinAbi.g.dart';
import '../utils/network_utils.dart';
import 'aliases.dart';

class ChainUtils {
  //TODO ADD NEXT SUPPORTED NETWORKS HERE

  // static String tronEvmAddress(String address, bool isReverse) {
  //   if (!isReverse) {
  //     //starts with T
  //     final Uint8List decodedBase58 = bs58check.decode(address);
  //     String encodedHex = HEX.encode(decodedBase58);
  //     String replaced = encodedHex.replaceFirst("41", "0x");
  //     return replaced;
  //   } else {
  //     //starts with 0x
  //     String theHex = address.replaceFirst("0x", "41");
  //     final decoded = HEX.decode(theHex) as Uint8List;
  //     final String bs58Address = bs58check.encode(decoded);
  //     return bs58Address;
  //   }
  // }

  //TODO ADD NEXT SUPPORTED NETWORKS HERE
  static bool isL2(Chain c) =>
      c == Chain.Optimism ||
      c == Chain.Arbitrum ||
      c == Chain.Polygon ||
      c == Chain.Base ||
      c == Chain.Linea ||
      c == Chain.Zksync ||
      c == Chain.Scroll ||
      c == Chain.Gnosis ||
      c == Chain.Blast ||
      c == Chain.Ape;

  static EthereumAddress ethAddressFromHex(Chain c, String _address) {
    String hex = "";
    if (_address == Utils.zeroAddress) {
      hex = Utils.zeroAddress;
    } else {
      if (c == Chain.Ronin) {
        if (_address.startsWith("ronin:")) {
          hex = _address.replaceFirst("ronin:", "0x");
        } else {
          hex = _address;
        }
      } else if (c == Chain.Tron) {
        final Uint8List decodedBase58 = bs58check.decode(_address);
        String encodedHex = HEX.encode(decodedBase58);
        String replaced = encodedHex.replaceFirst("41", "0x");
        hex = replaced;
      } else {
        hex = _address;
      }
    }
    return EthereumAddress.fromHex(hex);
  }

  static String hexFromEthAddress(Chain c, EthereumAddress a) {
    if (a.hex == Utils.zeroAddress) {
      return a.hex;
    } else {
      if (c == Chain.Tron) {
        String theHex = a.hex.replaceFirst("0x", "41");
        final decoded = HEX.decode(theHex) as Uint8List;
        final String bs58Address = bs58check.encode(decoded);
        return bs58Address;
      }
      return a.hex;
    }
  }

  static Decimal ercToDecimal(int decimals, BigInt b) {
    final factor = BigInt.from(pow(10, decimals));
    final nbr = Decimal.fromBigInt(b) / Decimal.fromBigInt(factor);
    return nbr.toDecimal();
  }

  static Decimal nativeUintToDecimal(Chain c, BigInt b) {
    final factor = BigInt.from(pow(10, Utils.nativeTokenDecimals(c)));
    final nbr = Decimal.fromBigInt(b) / Decimal.fromBigInt(factor);
    return nbr.toDecimal();
  }

  static BigInt nativeDecimalToUint(Chain c, Decimal d) {
    final factor = BigInt.from(pow(10, Utils.nativeTokenDecimals(c)));
    final nbr = d * Decimal.fromBigInt(factor);
    return nbr.toBigInt();
  }

  static BigInt decimalToERC(int decimals, Decimal d) {
    final factor = BigInt.from(pow(10, decimals));
    final nbr = d * Decimal.fromBigInt(factor);
    return nbr.toBigInt();
  }

  static BigInt decimalToUint(Chain c, CryptoAsset a, Decimal d) {
    if (a.address == Utils.zeroAddress) {
      return nativeDecimalToUint(c, d);
    } else {
      return decimalToERC(a.decimals, d);
    }
  }

  static Decimal uintToDecimal(Chain c, CryptoAsset a, BigInt b) {
    if (a.address == Utils.zeroAddress) {
      return nativeUintToDecimal(c, b);
    } else {
      return ercToDecimal(a.decimals, b);
    }
  }

  static DateTime chainDateToDt(BigInt d) {
    final milliseconds = d * BigInt.from(1000);
    return DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt());
  }

  static Future<CryptoAsset?> getCoinFromAddress(
    Chain c,
    String _address,
    Web3Client client,
  ) async {
    if (_address == Utils.zeroAddress) {
      return Utils.generateNativeToken(c);
    } else {
      try {
        final coin = OmnicoinAbi(
            address: ethAddressFromHex(c, _address), client: client);
        final symbol = await coin.symbol();
        final decimals = await coin.decimals();
        final String logoUrl =
            await ScannerUtils.getAssetFromAddress(c, _address, true);
        return CryptoAsset(
            address: _address,
            symbol: symbol,
            decimals: decimals.toInt(),
            logoUrl: logoUrl);
      } catch (e) {
        return null;
      }
    }
  }

  static String getChainIdString(Chain c) => c == Chain.Tron
      ? 'tron:0x2b6653dc'
      : "eip155:${Utils.chainToId(c).toString()}";
  static String getSendTransactionString(Chain c) =>
      c == Chain.Tron ? "tron_sendTransaction" : "eth_sendTransaction";

  static Future<TransactionReceipt?> getTransactionInformation(
    Chain c,
    String _txHash,
    Web3Client client,
  ) async {
    try {
      TransactionReceipt? info = await client.getTransactionReceipt(_txHash);
      return info;
    } catch (e) {
      return null;
    }
  }

  static Future<Decimal> getAssetBalance(
    Chain c,
    String walletAddress,
    CryptoAsset asset,
    Web3Client client,
  ) async {
    try {
      if (asset.address == Utils.zeroAddress) {
        final nativeBalance = await client
            .getBalance(ChainUtils.ethAddressFromHex(c, walletAddress));
        return ChainUtils.uintToDecimal(c, asset, nativeBalance.getInWei);
      } else {
        final coin = asset.assetContract(c, client);
        final bigBalance = await coin.balanceOf(
            (account: ChainUtils.ethAddressFromHex(c, walletAddress)));
        return ChainUtils.uintToDecimal(c, asset, bigBalance);
      }
    } catch (e) {
      return Decimal.parse("0.0");
    }
  }

  //TODO ADD NEW FEATURES HERE
  static Future<Decimal> getErcAllowance(
      {required Chain c,
      required Web3Client client,
      required String owner,
      required CryptoAsset asset,
      required isTransfers,
      required isTrust,
      required isBridges,
      required isEscrow,
      required isDark,
      required widthQuery,
      required dir,
      required AppLanguage lang,
      required void Function() popDialog}) async {
    final alias = Aliases.getAlias(c);
    String contractHex = '';
    EthereumAddress coin = ethAddressFromHex(c, asset.address);
    EthereumAddress _owner = ethAddressFromHex(c, owner);
    if (isTransfers) {
      contractHex = alias.transfersAddress;
    }
    if (isTrust) {
      contractHex = alias.trustAddress;
    }
    if (isBridges) {
      contractHex = alias.bridgeAddress;
    }
    if (isEscrow) {
      contractHex = alias.escrowAddress;
    }
    EthereumAddress contractAddress = ethAddressFromHex(c, contractHex);
    try {
      final tokenContract = OmnicoinAbi(address: coin, client: client);
      final allowance = await tokenContract
          .allowance((owner: _owner, spender: contractAddress));
      return ercToDecimal(asset.decimals, allowance);
    } catch (e) {
      Toasts.showErrorToast(lang.toasts21,
          lang.toasts22 + "\$${asset.symbol} " + lang.toasts23, isDark, dir);
      return Decimal.parse("0.0");
    }
  }

  //TODO ADD NEW FEATURES HERE
  static Future<void> requestApprovals(
      {required Chain c,
      required Web3Client client,
      required List<String> keys,
      required Map<String, Decimal> allowances,
      required isTransfers,
      required isTrust,
      required isBridges,
      required isEscrow,
      required String sessionTopic,
      required Web3App wcClient,
      required String walletAddress,
      required isDark,
      required dir,
      required AppLanguage lang}) async {
    final alias = Aliases.getAlias(c);
    String contractHex = '';
    if (isTransfers) {
      contractHex = alias.transfersAddress;
    }
    if (isTrust) {
      contractHex = alias.trustAddress;
    }
    if (isBridges) {
      contractHex = alias.bridgeAddress;
    }
    if (isEscrow) {
      contractHex = alias.escrowAddress;
    }
    EthereumAddress contractAddress = ethAddressFromHex(c, contractHex);
    try {
      Toasts.showInfoToast(lang.toast11, lang.toast12, isDark, dir);
      for (var address in keys) {
        final tokenContract =
            OmnicoinAbi(address: ethAddressFromHex(c, address), client: client);
        Decimal wanted = allowances[address]!;
        final decimals = await tokenContract.decimals();
        BigInt wantedUint = decimalToERC(decimals.toInt(), wanted);
        final transaction = Transaction.callContract(
          contract: tokenContract.self,
          function: tokenContract.self.function("approve"),
          value: EtherAmount.zero(),
          from: ethAddressFromHex(c, walletAddress),
          parameters: [contractAddress, wantedUint],
        );
        wcClient
            .request(
                topic: sessionTopic,
                chainId: getChainIdString(c),
                request: SessionRequestParams(
                  method: getSendTransactionString(c),
                  params: [transaction.toJson()],
                ))
            .catchError((e) {
          Toasts.showErrorToast(lang.toasts24, lang.toasts25, isDark, dir);
        });
      }
    } catch (e) {
      Toasts.showErrorToast(lang.toasts24, lang.toasts25, isDark, dir);
    }
  }
}
