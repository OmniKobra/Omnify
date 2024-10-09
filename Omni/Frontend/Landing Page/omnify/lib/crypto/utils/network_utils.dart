import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/asset.dart';
import "../../utils.dart";
import 'sensitive.dart';

//TODO ADD NEXT SUPPORTED NETWORKS HERE
class ScannerUtils {
  String chainToEndpoint(Chain c) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (c) {
      case Chain.Blast:
        return Sensitive.blastEndpoint;
      case Chain.Fuji:
        return Sensitive.fujiEndPoint;
      case Chain.BNBT:
        return Sensitive.bnbtEndpoint;
      case Chain.Avalanche:
        return Sensitive.avalancheEndpoint;
      case Chain.Optimism:
        return Sensitive.optimismEndpoint;
      case Chain.Ethereum:
        return Sensitive.ethereumEndpoint;
      case Chain.BSC:
        return Sensitive.bscEndpoint;
      case Chain.Arbitrum:
        return Sensitive.arbitrumEndpoint;
      case Chain.Polygon:
        return Sensitive.polygonEndpoint;
      case Chain.Fantom:
        return Sensitive.fantomEndpoint;
      case Chain.Tron:
        return Sensitive.tronEndpoint;
      case Chain.Base:
        return Sensitive.baseEndpoint;
      case Chain.Linea:
        return Sensitive.lineaEndpoint;
      case Chain.Mantle:
        return Sensitive.mantleEndpoint;
      case Chain.Gnosis:
        return Sensitive.gnosisEndpoint;
      case Chain.Kava:
        return Sensitive.kavaEndpoint;
      case Chain.Zksync:
        return Sensitive.zksyncEndpoint;
      case Chain.Celo:
        return Sensitive.celoEndpoint;
      case Chain.Scroll:
        return Sensitive.scrollEndpoint;
      case Chain.Xdai:
        return "";
      case Chain.Cronos:
        return Sensitive.cronosEndpoint;
      case Chain.Ronin:
        return Sensitive.roninEndpoint;
      case Chain.Hedera:
        return Sensitive.hederaEndpoint;
      default:
        return Sensitive.avalancheEndpoint;
    }
  }

  String chainToApiKey(Chain c) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (c) {
      case Chain.Blast:
        return Sensitive.blastKey;
      case Chain.Fuji:
        return Sensitive.avalancheKey;
      case Chain.BNBT:
        return Sensitive.bscKey;
      case Chain.Avalanche:
        return Sensitive.avalancheKey;
      case Chain.Optimism:
        return Sensitive.optimismKey;
      case Chain.Ethereum:
        return Sensitive.ethereumKey;
      case Chain.BSC:
        return Sensitive.bscKey;
      case Chain.Arbitrum:
        return Sensitive.arbitrumKey;
      case Chain.Polygon:
        return Sensitive.polygonKey;
      case Chain.Fantom:
        return Sensitive.fantomKey;
      case Chain.Tron:
        return Sensitive.tronKey;
      case Chain.Base:
        return Sensitive.baseKey;
      case Chain.Linea:
        return Sensitive.lineaKey;
      case Chain.Mantle:
        return Sensitive.mantleKey;
      case Chain.Gnosis:
        return Sensitive.gnosisKey;
      case Chain.Kava:
        return Sensitive.kavaKey;
      case Chain.Zksync:
        return Sensitive.zksyncKey;
      case Chain.Celo:
        return Sensitive.celoKey;
      case Chain.Scroll:
        return Sensitive.scrollKey;
      case Chain.Xdai:
        return "";
      case Chain.Cronos:
        return Sensitive.cronosKey;
      case Chain.Ronin:
        return Sensitive.roninKey;
      case Chain.Hedera:
        return Sensitive.hederaKey;
      default:
        return Sensitive.avalancheKey;
    }
  }

  static String chainToGoldrushName(Chain c) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (c) {
      case Chain.Blast:
        return "blast-mainnet";
      case Chain.Fuji:
        return "avalanche-testnet";
      case Chain.Avalanche:
        return "avalanche-mainnet";
      case Chain.Optimism:
        return "optimism-mainnet";
      case Chain.Ethereum:
        return "eth-mainnet";
      case Chain.BNBT:
        return "bsc-testnet";
      case Chain.BSC:
        return "bsc-mainnet";
      case Chain.Arbitrum:
        return "arbitrum-mainnet";
      case Chain.Polygon:
        return "matic-mainnet";
      case Chain.Fantom:
        return "fantom-mainnet";
      case Chain.Tron:
        return "";
      case Chain.Base:
        return "base-mainnet";
      case Chain.Linea:
        return "linea-mainnet";
      case Chain.Mantle:
        return "mantle-mainnet";
      case Chain.Gnosis:
        return "gnosis-mainnet";
      case Chain.Kava:
        return "";
      case Chain.Zksync:
        return "zksync-mainnet";
      case Chain.Celo:
        return "celo-mainnet";
      case Chain.Scroll:
        return "scroll-mainnet";
      case Chain.Xdai:
        return "";
      case Chain.Cronos:
        return "";
      case Chain.Ronin:
        return "axie-mainnet";
      case Chain.Hedera:
        return "";
      default:
        return "avalanche-mainnet";
    }
  }

  static Future<List<CryptoAsset>> getTokenHoldings(
      String address, Chain c) async {
    late String key;
    List<CryptoAsset> _assets = [];
    if (address.isNotEmpty) {
      if (c == Chain.Tron) {
        try {
          key = Sensitive.tronKey;
          var response = await http.get(
              Uri.parse(
                  "${Sensitive.tronEndpoint}/account/tokens?address=$address&start=0&limit=200&hidden=0&show=2&sortType=0&sortBy=0&token="),
              headers: {"TRON-PRO-API-KEY": key});
          Map<String, dynamic> body = jsonDecode(response.body);
          final int total = body['total'] ?? 0;
          if (total > 0) {
            final items = body['data'] as List<dynamic>;
            if (items.isNotEmpty) {
              for (Map<String, dynamic> item in items) {
                final String address = item['tokenId'] ?? "_";
                if (address != '_') {
                  if (item['tokenAbbr'] != null &&
                      item['tokenDecimal'] != null) {
                    final String symbol = item['tokenAbbr'] ?? "NULL";
                    final int decimals = item['tokenDecimal'] ?? 0;
                    final String logo = item['tokenLogo'] ?? "NULL";
                    final String symbol2 =
                        symbol.length > 10 ? symbol.substring(0, 9) : symbol;
                    _assets.add(CryptoAsset(
                        address: address,
                        symbol: symbol2,
                        decimals: decimals,
                        logoUrl: logo));
                  }
                }
              }
            }
          }
        } catch (e) {
          return _assets;
        }
      } else {
        try {
          key = Sensitive.goldrushKey;
          String chainName = chainToGoldrushName(c);
          var response = await http.get(Uri.parse(
              "${Sensitive.goldrushEndpoint}/$chainName/address/$address/balances_v2/?key=$key"));
          Map<String, dynamic>? body = jsonDecode(response.body);
          final Map<String, dynamic>? data = body?['data'];
          final List<dynamic>? items = data?['items'] ?? [];
          if (items != null && items.isNotEmpty) {
            for (Map<String, dynamic> item in items) {
              final supportsErc = item['supports_erc'];
              if (supportsErc != null) {
                if (supportsErc.contains("erc20")) {
                  if (item['native_token'] == false) {
                    if (item['contract_address'] != null &&
                        item['contract_decimals'] != null &&
                        item['contract_ticker_symbol'] != null) {
                      final String address = item['contract_address'] ?? "NULL";
                      final int decimals = item['contract_decimals'] ?? 0;
                      final String symbol =
                          item['contract_ticker_symbol'] ?? "NULL";
                      final String logo = item['logo_url'] ?? "NULL";
                      final String symbol2 =
                          symbol.length > 10 ? symbol.substring(0, 9) : symbol;
                      _assets.add(CryptoAsset(
                          address: address,
                          symbol: symbol2,
                          decimals: decimals,
                          logoUrl: logo));
                    }
                  }
                }
              }
            }
          }
        } catch (e) {
          return _assets;
        }
      }
    }
    return _assets;
  }

  static Future<dynamic> getAssetFromAddress(
      Chain c, String assetAddress, bool returnLogo) async {
    late String key;
    CryptoAsset? asset;
    String _logo = '';
    if (assetAddress.isNotEmpty) {
      if (c == Chain.Tron) {
        try {
          key = Sensitive.tronKey;
          var response = await http.get(
              Uri.parse(
                  "${Sensitive.tronEndpoint}/token_trc20?contract=$assetAddress&showAll=1&start=&limit="),
              headers: {"TRON-PRO-API-KEY": key});
          Map<String, dynamic> body = jsonDecode(response.body);
          final items = body['trc20_tokens'] as List<dynamic>? ?? [];
          if (items.isNotEmpty) {
            Map<String, dynamic> details = items[0];
            final String logo = details['icon_url'] ?? "NULL";
            _logo = logo;
            final String symbol = details['symbol'] ?? "NULL";
            final int decimals = details['decimals'] ?? 0;
            final String symbol2 =
                symbol.length > 10 ? symbol.substring(0, 9) : symbol;
            asset = CryptoAsset(
                address: assetAddress,
                symbol: symbol2,
                decimals: decimals,
                logoUrl: logo);
          }
        } catch (e) {
          return returnLogo ? _logo : asset;
        }
      } else {
        try {
          key = Sensitive.goldrushKey;
          String chainName = chainToGoldrushName(c);
          var response = await http.get(Uri.parse(
              "${Sensitive.goldrushEndpoint}/$chainName/tokens/$assetAddress/token_holders_v2/?key=$key"));
          Map<String, dynamic>? body = jsonDecode(response.body);
          final Map<String, dynamic>? data = body?['data'];
          final List<dynamic>? items = data?['items'] ?? [];
          if (items != null && items.isNotEmpty) {
            final details = items[0];
            final decimals = details['contract_decimals'] ?? 0;
            final symbol = details['contract_ticker_symbol'] ?? "NULL";
            final logo = details['logo_url'] ?? "NULL";
            _logo = logo;
            final String symbol2 =
                symbol.length > 10 ? symbol.substring(0, 9) : symbol;
            asset = CryptoAsset(
                address: assetAddress,
                symbol: symbol2,
                decimals: decimals,
                logoUrl: logo);
          }
        } catch (e) {
          return returnLogo ? _logo : asset;
        }
      }
    }
    return returnLogo ? _logo : asset;
  }

  Future<bool> getTransactionSuccessful(Chain c, String hash) async {
    late String key;
    if (hash.isNotEmpty) {
      if (c == Chain.Tron) {
        key = Sensitive.tronKey;
        var response = await http.get(
            Uri.parse("${Sensitive.tronEndpoint}/transaction-info?hash=$hash"),
            headers: {"TRON-PRO-API-KEY": key});
        Map<String, dynamic> body = jsonDecode(response.body);
        print(body);
        return true;
      } else {
        key = Sensitive.goldrushKey;
        String chainName = chainToGoldrushName(c);
        var response = await http.get(Uri.parse(
            "${Sensitive.goldrushEndpoint}/$chainName/transaction_v2/$hash/?key=$key"));
        Map<String, dynamic> body = jsonDecode(response.body);
        print(body);
        return true;
      }
    }
    return false;
  }
}
