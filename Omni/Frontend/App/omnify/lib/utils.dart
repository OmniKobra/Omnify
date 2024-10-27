// ignore_for_file: constant_identifier_names, deprecated_member_use, prefer_if_null_operators

import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rational/rational.dart';

import 'crypto/utils/sensitive.dart';
import 'languages/app_language.dart';
import 'models/asset.dart';
import 'providers/theme_provider.dart';
import 'widgets/my_image.dart';

//bloc  k time is the number of seconds that have passed since January 1st 1970
//1 day is 86400 seconds
enum Chain {
  //TODO ADD NEXT SUPPORTED NETWORKS HERE
  Avalanche,
  Optimism,
  Ethereum,
  BSC,
  Arbitrum,
  Polygon,
  Fantom,
  Tron,
  Base,
  Linea,
  Cronos,
  Mantle,
  Gnosis,
  Kava,
  Ronin,
  Zksync,
  Celo,
  Scroll,
  Hedera,
  Blast,
  Ape,
  ApeCoin,
  Fuji,
  BNBT,
  Xdai,
  TronEnergy
}

class Utils {
  static const String inchUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/1inch.png?raw=true";
  static const String arbitrumUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/arbitrum.png?raw=true";
  static const String avalancheUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/avalanche.png?raw=true";
  static const String axelarUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/axelar.png?raw=true";
  static const String bscUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/bsc.png?raw=true";
  static const String ethUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/eth.png?raw=true";
  static const String fantomUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/fantom.png?raw=true";
  static const String tronUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/tron.png?raw=true";
  static const String baseUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/base.png?raw=true";
  static const String lineaUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/linea.png?raw=true";
  static const String cronosUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/cronos.png?raw=true";
  static const String mantleUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/mantle.png?raw=true";
  static const String gnosisUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/gnosis.png?raw=true";
  static const String kavaUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/kava.png?raw=true";
  static const String roninUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/ronin.png?raw=true";
  static const String zksyncUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/zksync.png?raw=true";
  static const String celoUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/celo.png?raw=true";
  static const String scrollUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/scroll.png?raw=true";
  static const String hederaUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/hedera.png?raw=true";
  static const String xDaiUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/xdai.png?raw=true";
  static const String linkUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/link.png?raw=true";
  static const String optimismUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/optimism.png?raw=true";
  static const String polygonUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/polygon.png?raw=true";
  static const String blastUrl =
      'https://github.com/OmniKobra/Omnify/blob/main/assets/networks/blast_logo.png?raw=true';
  static const String logo =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/logo3.png?raw=true";
  static const String bridgeUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/omnibridge.png?raw=true";
  static const String escrowUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/omniescrow.png?raw=true";
  static const String payUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/omnipay.png?raw=true";
  static const String transferUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/omnitransfer.png?raw=true";
  static const String trustUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/omnitrust.png?raw=true";
  static const String zeroAddress =
      "0x0000000000000000000000000000000000000000";
  static const wcBannerDark =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/wcBannerDark.png?raw=true";
  static const wcBannerLight =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/wcBannerLight.png?raw=true";
  static const wcEmblemDark =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/wcEmblemDark.png?raw=true";
  static const wcEmblemLight =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/wcEmblemLight.png?raw=true";
  static const bolt1 =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/bolt1.png?raw=true";
  static const bolt2 =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/bolt2.jpg?raw=true";
  static const String refuelUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/refuel.png?raw=true";
  static const String apeCoinUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/apecoin.png?raw=true";
  static const String apeChainUrl =
      "https://github.com/OmniKobra/Omnify/blob/main/assets/networks/ApeChain.png?raw=true";
  static const wcProjectId = Sensitive.walletConnectID;
  static const Duration queryFeesDuration = Duration(seconds: 25);
  static const int pageSize = 25;

  static const List<Chain> ourChains = [
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    //TODO REMOVE TESTERS BEFORE DEPLOYMENT
    //TODO REMOVE CHAIN SUPPORT HERE

    // Chain.Fuji,
    // Chain.BNBT,
    Chain.Avalanche,
    Chain.Optimism,
    // Chain.Ethereum,
    Chain.BSC,
    Chain.Blast,
    Chain.Arbitrum,
    Chain.Ape,
    Chain.Polygon,
    Chain.Fantom,
    // Chain.Tron,
    Chain.Base,
    Chain.Linea,
    Chain.Mantle,
    Chain.Gnosis,
    // Chain.Ronin,
    Chain.Zksync,
    Chain.Celo,
    Chain.Scroll,
  ];

  static bool widthQuery(context) => MediaQuery.of(context).size.width > 650;
  static String timeStamp(
      DateTime postedDate, String locale, BuildContext context) {
    final String datewithYear = locale == 'ar'
        ? DateFormat('d MMMM yyyy  - h:mm (a)', locale).format(postedDate)
        : DateFormat('MMMM d, yyyy hh:mm a', locale).format(postedDate);
    return datewithYear;
  }

  // static String decimaltoString(Decimal source) {
  //   final bigInt = BigInt.from(source * pow(10, 18));

  //   var d = bigInt.toInt() / pow(10, 18);
  //   return Decimal.parse(d.toString()).toStringAsFixed(18);
  // }

  // static Decimal decimalToDouble(String source) {
  //   var d = Decimal.tryParse(source) ?? Decimal.fromInt(0);
  //   return d.toDouble();
  // }

  static int chainToConfirmations(Chain c) {
//TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (c) {
      case Chain.Avalanche:
        return 20;
      case Chain.Optimism:
        return 75;
      case Chain.BSC:
        return 60;
      case Chain.Arbitrum:
        return 300;
      case Chain.Ape:
        return 300;
      case Chain.Polygon:
        return 250;
      case Chain.Fantom:
        return 30;
      case Chain.Base:
        return 75;
      case Chain.Linea:
        return 40;
      case Chain.Mantle:
        return 70;
      case Chain.Gnosis:
        return 350;
      case Chain.Celo:
        return 20;
      case Chain.Scroll:
        return 150;
      case Chain.Blast:
        return 150;
      case Chain.Zksync:
        return 1200;
      default:
    }
    return 20;
  }

  static int chainToLzEID(Chain c) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (c) {
      case Chain.Blast:
        return 30243;
      case Chain.Fuji:
        return 40106;
      case Chain.Avalanche:
        return 30106;
      case Chain.Optimism:
        return 30111;
      case Chain.Ethereum:
        return 30101;
      case Chain.BNBT:
        return 40102;
      case Chain.BSC:
        return 30102;
      case Chain.Arbitrum:
        return 30110;
      case Chain.Ape:
        return 30312;
      case Chain.Polygon:
        return 30109;
      case Chain.Fantom:
        return 30112;
      case Chain.Tron:
        return 30420;
      case Chain.Base:
        return 30184;
      case Chain.Linea:
        return 30183;
      case Chain.Mantle:
        return 30181;
      case Chain.Gnosis:
        return 30145;
      case Chain.Kava:
        return 30177;
      case Chain.Zksync:
        return 30165;
      case Chain.Celo:
        return 30125;
      case Chain.Scroll:
        return 30214;
      case Chain.Xdai:
        return 30145;
      case Chain.Cronos:
        return 0;
      case Chain.Ronin:
        return 0;
      case Chain.Hedera:
        return 0;
      default:
        return 30106;
    }
  }

  static Chain lzEidToChain(int id) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (id) {
      case 30243:
        return Chain.Blast;
      case 40106:
        return Chain.Fuji;
      case 30106:
        return Chain.Avalanche;
      case 30111:
        return Chain.Optimism;
      case 30101:
        return Chain.Ethereum;
      case 40102:
        return Chain.BNBT;
      case 30102:
        return Chain.BSC;
      case 30110:
        return Chain.Arbitrum;
      case 30312:
        return Chain.Ape;
      case 30109:
        return Chain.Polygon;
      case 30112:
        return Chain.Fantom;
      case 30420:
        return Chain.Tron;
      case 30184:
        return Chain.Base;
      case 30183:
        return Chain.Linea;
      case 30181:
        return Chain.Mantle;
      case 30145:
        return Chain.Gnosis;
      case 30177:
        return Chain.Kava;
      case 30165:
        return Chain.Zksync;
      case 30125:
        return Chain.Celo;
      case 30214:
        return Chain.Scroll;
      case 30145:
        return Chain.Xdai;
      case 0:
        return Chain.Cronos;
      case 0:
        return Chain.Ronin;
      case 0:
        return Chain.Hedera;
      default:
        return Chain.Avalanche;
    }
  }

  static int chainToId(Chain c) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (c) {
      case Chain.Blast:
        return 81457;
      case Chain.Fuji:
        return 43113;
      case Chain.Avalanche:
        return 43114;
      case Chain.Optimism:
        return 10;
      case Chain.Ethereum:
        return 1;
      case Chain.BNBT:
        return 97;
      case Chain.BSC:
        return 56;
      case Chain.Arbitrum:
        return 42161;
      case Chain.Ape:
        return 33139;
      case Chain.Polygon:
        return 137;
      case Chain.Fantom:
        return 250;
      case Chain.Tron:
        return 0;
      case Chain.Base:
        return 8453;
      case Chain.Linea:
        return 59144;
      case Chain.Mantle:
        return 5000;
      case Chain.Gnosis:
        return 100;
      case Chain.Kava:
        return 0;
      case Chain.Zksync:
        return 324;
      case Chain.Celo:
        return 42220;
      case Chain.Scroll:
        return 534352;
      case Chain.Xdai:
        return 100;
      case Chain.Cronos:
        return 0;
      case Chain.Ronin:
        return 2020;
      case Chain.Hedera:
        return 0;
      default:
        return 43114;
    }
  }

  static Chain idToChain(int c) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (c) {
      case 81457:
        return Chain.Blast;
      case 43113:
        return Chain.Fuji;
      case 43114:
        return Chain.Avalanche;
      case 10:
        return Chain.Optimism;
      case 1:
        return Chain.Ethereum;
      case 97:
        return Chain.BNBT;
      case 56:
        return Chain.BSC;
      case 42161:
        return Chain.Arbitrum;
      case 33139:
        return Chain.Ape;
      case 137:
        return Chain.Polygon;
      case 250:
        return Chain.Fantom;
      case 0:
        return Chain.Tron;
      case 8453:
        return Chain.Base;
      case 59144:
        return Chain.Linea;
      case 5000:
        return Chain.Mantle;
      case 100:
        return Chain.Gnosis;
      case 0:
        return Chain.Kava;
      case 324:
        return Chain.Zksync;
      case 42220:
        return Chain.Celo;
      case 534352:
        return Chain.Scroll;
      case 0:
        return Chain.Xdai;
      case 0:
        return Chain.Cronos;
      case 2020:
        return Chain.Ronin;
      case 0:
        return Chain.Hedera;
      default:
        return Chain.Avalanche;
    }
  }

  static Chain feeLogo(Chain c, [bool? isTronEnergyToken]) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    if (c == Chain.Base ||
        c == Chain.Linea ||
        c == Chain.Zksync ||
        c == Chain.Scroll ||
        c == Chain.Optimism ||
        c == Chain.Arbitrum ||
        c == Chain.Blast) {
      return Chain.Ethereum;
    } else if (c == Chain.Gnosis) {
      return Chain.Xdai;
    } else if (c == Chain.Tron) {
      if (isTronEnergyToken != null && isTronEnergyToken == true) {
        return Chain.TronEnergy;
      } else {
        return c;
      }
    } else if (c == Chain.Ape) {
      return Chain.ApeCoin;
    } else {
      return c;
    }
  }

  //TODO ADD NEXT SUPPORTED NETWORKS HERE
  static Decimal dec(Chain c, BigInt _b) {
    final BigInt factor =
        c == Chain.Tron ? BigInt.from(pow(10, 6)) : BigInt.from(pow(10, 18));
    var res = (Decimal.fromBigInt(_b) / Decimal.fromBigInt(factor));
    return res.toDecimal(
        scaleOnInfinitePrecision: Utils.nativeTokenDecimals(c));
  }

  static String nativeTokenSymbol(Chain c) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    if (c == Chain.Base ||
        c == Chain.Linea ||
        c == Chain.Zksync ||
        c == Chain.Scroll ||
        c == Chain.Optimism ||
        c == Chain.Arbitrum ||
        c == Chain.Ethereum ||
        c == Chain.Blast) {
      return "ETH";
    }
    if (c == Chain.Avalanche || c == Chain.Fuji) {
      return "AVAX";
    } else if (c == Chain.BSC || c == Chain.BNBT) {
      return "BNB";
    } else if (c == Chain.Polygon) {
      return "POL";
    } else if (c == Chain.Fantom) {
      return "FTM";
    } else if (c == Chain.Tron) {
      return "TRX";
    } else if (c == Chain.Cronos) {
      return "CRO";
    } else if (c == Chain.Mantle) {
      return "MNT";
    } else if (c == Chain.Gnosis) {
      return "xDai";
    } else if (c == Chain.Kava) {
      return "KAVA";
    } else if (c == Chain.Ronin) {
      return "RON";
    } else if (c == Chain.Celo) {
      return "CELO";
    } else if (c == Chain.Hedera) {
      return "HBAR";
    } else if (c == Chain.Ape) {
      return "APE";
    }
    return "";
  }

  //TODO ADD NEXT SUPPORTED NETWORKS HERE
  static int nativeTokenDecimals(Chain c) {
    if (c == Chain.Tron) {
      return 6;
    } else {
      return 18;
    }
  }

  static CryptoAsset generateNativeToken(Chain c) => CryptoAsset(
      address: zeroAddress,
      name: '',
      logoUrl: getLogoUrl(feeLogo(c)),
      symbol: nativeTokenSymbol(c),
      decimals: nativeTokenDecimals(c));

  static CryptoAsset generateNativeUSDT(Chain c) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    String address = "";
    int decimals = 6;
    String symbol = "USDC";
    String logo =
        "https://github.com/OmniKobra/Omnify/blob/main/assets/usd-coin-usdc-logo.png?raw=true";
    if (c == Chain.Avalanche) {
      address = "0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E";
    }
    if (c == Chain.Fuji) {
      address = "0x5425890298aed601595a70ab815c96711a31bc65";
    }
    if (c == Chain.Optimism) {
      address = "0x7F5c764cBc14f9669B88837ca1490cCa17c31607";
      symbol = "USDC.e";
    }
    if (c == Chain.Ethereum) {
      address = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
    }
    if (c == Chain.BSC) {
      address = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56";
      decimals = 18;
      symbol = "BUSD";
      logo =
          "https://github.com/OmniKobra/Omnify/blob/main/assets/binance-usd-busd-logo.png?raw=true";
    }
    if (c == Chain.BNBT) {
      address = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56";
      decimals = 18;
      symbol = "BUSD";
      logo =
          "https://github.com/OmniKobra/Omnify/blob/main/assets/binance-usd-busd-logo.png?raw=true";
    }
    if (c == Chain.Blast) {
      address = "0x4300000000000000000000000000000000000003";
      decimals = 18;
      symbol = 'USDB';
      logo =
          'https://github.com/OmniKobra/Omnify/blob/main/assets/usdb_blast.png?raw=true';
    }
    if (c == Chain.Arbitrum) {
      address = "0xaf88d065e77c8cC2239327C5EDb3A432268e5831";
    }
    if (c == Chain.Ape) {
      address = "0xA2235d059F80e176D931Ef76b6C51953Eb3fBEf4";
      decimals = 18;
      symbol = "ApeUSD";
      logo = Utils.apeCoinUrl;
    }
    if (c == Chain.Polygon) {
      address = "0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359";
    }
    if (c == Chain.Fantom) {
      address = "0x04068DA6C83AFCFA0e13ba15A6696662335D5B75";
    }
    if (c == Chain.Tron) {
      address = "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t";
      symbol = "USDT";
      logo =
          "https://github.com/OmniKobra/Omnify/blob/main/assets/tether-usdt-logo.png?raw=true";
    }

    if (c == Chain.Base) {
      address = "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913";
    }
    if (c == Chain.Linea) {
      address = "0x176211869cA2b568f2A7D4EE941E073a821EE1ff";
      symbol = "USDC.e";
    }
    if (c == Chain.Mantle) {
      address = "0x09Bc4E0D864854c6aFB6eB9A9cdF58aC190D0dF9";
    }
    if (c == Chain.Gnosis) {
      address = "0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83";
    }
    if (c == Chain.Zksync) {
      address = "0x1d17CBcF0D6D143135aE902365D2E5e2A16538D4";
    }
    if (c == Chain.Celo) {
      address = "0xcebA9300f2b948710d2653dD7B07f33A8B32118C";
    }
    if (c == Chain.Scroll) {
      address = "0x06eFdBFf2a14a7c8E15944D1F4A48F9F95F663A4";
    }
    return CryptoAsset(
        name: '',
        address: address,
        symbol: symbol,
        decimals: decimals,
        logoUrl: logo);
  }

  static String generateID(String walletAddress, DateTime d) {
    return d
            .toString()
            .replaceAll(' ', '')
            .replaceAll('-', '')
            .replaceAll(':', '')
            .replaceAll('.', '') +
        walletAddress;
  }

  static String optimisedNumbers(dynamic value, bool isValue) {
    if (!isValue) {
      if (value == 0) {
        return '- -';
      } else if (value < 10000) {
        return value.toString();
      } else if (value >= 10000 && value < 1000000) {
        num dividedVal = value / 1000;
        return '${dividedVal.toStringAsFixed(0)}K+';
      } else if (value >= 1000000 && value < 1000000000) {
        num dividedVal = value / 1000000;
        return '${dividedVal.toStringAsFixed(0)}M+';
      } else if (value >= 1000000000) {
        num dividedVal = value / 1000000000;
        return '${dividedVal.toStringAsFixed(0)}B+';
      }
      return 'null';
    } else {
      if (value == Decimal.parse("0")) {
        return '- -';
      } else if (value < Decimal.parse("10000")) {
        return value.toStringAsFixed(0);
      } else if (value >= Decimal.parse("10000") &&
          value < Decimal.parse("1000000")) {
        Rational dividedVal = value / Decimal.parse("1000");
        return '${dividedVal.toDecimal(scaleOnInfinitePrecision: 0).floor(scale: 0).toStringAsFixed(0)}K+';
      } else if (value >= Decimal.parse("1000000") &&
          value < Decimal.parse("1000000000")) {
        Rational dividedVal = value / Decimal.parse("1000000");
        return '${dividedVal.toDecimal(scaleOnInfinitePrecision: 0).floor(scale: 0).toStringAsFixed(0)}M+';
      } else if (value >= Decimal.parse("1000000000") &&
          value < Decimal.parse("1000000000000")) {
        Rational dividedVal = value / Decimal.parse("1000000000");
        return '${dividedVal.toDecimal(scaleOnInfinitePrecision: 0).floor(scale: 0).toStringAsFixed(0)}B+';
      } else if (value >= Decimal.parse("1000000000000")) {
        Rational dividedVal = value / Decimal.parse("1000000000000");
        return '${dividedVal.toDecimal(scaleOnInfinitePrecision: 0).floor(scale: 0).toStringAsFixed(0)}T+';
      }
      return 'null';
    }
  }

  //TODO ADD NEXT SUPPORTED NETWORKS HERE
  static String getLogoUrl(Chain c) {
    switch (c) {
      case Chain.Blast:
        return Utils.blastUrl;
      case Chain.Fuji:
        return Utils.avalancheUrl;
      case Chain.BNBT:
        return Utils.bscUrl;
      case Chain.Avalanche:
        return Utils.avalancheUrl;
      case Chain.Optimism:
        return Utils.optimismUrl;
      case Chain.Ethereum:
        return Utils.ethUrl;
      case Chain.BSC:
        return Utils.bscUrl;
      case Chain.Arbitrum:
        return Utils.arbitrumUrl;
      case Chain.Ape:
        return Utils.apeChainUrl;
      case Chain.ApeCoin:
        return Utils.apeCoinUrl;
      case Chain.Polygon:
        return Utils.polygonUrl;
      case Chain.Fantom:
        return Utils.fantomUrl;
      case Chain.Tron:
        return Utils.tronUrl;
      case Chain.Base:
        return Utils.baseUrl;
      case Chain.Linea:
        return Utils.lineaUrl;
      case Chain.Cronos:
        return Utils.cronosUrl;
      case Chain.Mantle:
        return Utils.mantleUrl;
      case Chain.Gnosis:
        return Utils.gnosisUrl;
      case Chain.Kava:
        return kavaUrl;
      case Chain.Ronin:
        return roninUrl;
      case Chain.Zksync:
        return zksyncUrl;
      case Chain.Celo:
        return celoUrl;
      case Chain.Scroll:
        return scrollUrl;
      case Chain.Hedera:
        return hederaUrl;
      case Chain.Xdai:
        return xDaiUrl;
      case Chain.TronEnergy:
        return bolt1;
      default:
        return Utils.avalancheUrl;
    }
  }

  static Widget buildNetworkLogo(bool widthQuery, Chain c, bool isButton,
      [bool? isFee]) {
    final double constraints = isFee != null
        ? widthQuery
            ? 25
            : 15
        : isButton
            ? widthQuery
                ? 35
                : 25
            : widthQuery
                ? 150
                : 100;
    return ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: constraints,
            maxHeight: constraints,
            minWidth: constraints,
            maxWidth: constraints),
        child: MyImage(url: Utils.getLogoUrl(c), fit: null));
  }

  static Widget buildAssetLogo(bool widthQuery, CryptoAsset a, bool isButton,
      [bool? isFee]) {
    final double constraints = isFee != null
        ? widthQuery
            ? 25
            : 15
        : isButton
            ? widthQuery
                ? 35
                : 25
            : widthQuery
                ? 150
                : 100;
    return ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: constraints,
            maxHeight: constraints,
            minWidth: constraints,
            maxWidth: constraints),
        child: MyImage(url: a.logoUrl, fit: null));
  }

  static Widget buildAssetLogoFromUrl(
      bool widthQuery, String url, bool isButton,
      [bool? isFee]) {
    final double constraints = isFee != null
        ? widthQuery
            ? 25
            : 15
        : isButton
            ? widthQuery
                ? 35
                : 25
            : widthQuery
                ? 150
                : 100;
    return ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: constraints,
            maxHeight: constraints,
            minWidth: constraints,
            maxWidth: constraints),
        child: MyImage(url: url, fit: null));
  }

  static String removeTrailingZeros(String input) =>
      input.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");

  static showLoadingDialog(
      BuildContext context, AppLanguage lang, bool widthQuery,
      [bool? isChangeNetwork, String? label]) {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (_) {
          bool allowPop = false;
          return WillPopScope(
              onWillPop: () async {
                return allowPop;
              },
              child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.black),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding:
                                    label == null && isChangeNetwork == null
                                        ? const EdgeInsets.only(
                                            bottom: 4.0,
                                            left: 8,
                                            right: 8,
                                            top: 8)
                                        : const EdgeInsets.all(8),
                                child: LoadingAnimationWidget.flickr(
                                  leftDotColor: Colors.green,
                                  rightDotColor: Colors.red.shade600,
                                  size: widthQuery ? 75 : 50,
                                )),
                            Padding(
                                padding:
                                    label == null && isChangeNetwork == null
                                        ? const EdgeInsets.only(
                                            top: 4,
                                            left: 8,
                                            right: 8,
                                            bottom: 2.0)
                                        : const EdgeInsets.all(8),
                                child: Text(
                                    label != null
                                        ? label
                                        : isChangeNetwork != null &&
                                                isChangeNetwork
                                            ? lang.changingNetwork
                                            : lang.transacting,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                        fontSize: widthQuery ? 16 : 14))),
                            if (label == null && isChangeNetwork == null)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8, bottom: 8),
                                child: Text(lang.checkWallet,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.none,
                                        fontSize: widthQuery ? 14 : 12)),
                              )
                          ]))));
        });
  }

  static AppLanguage language(BuildContext context) =>
      Provider.of<ThemeProvider>(context).appLanguage;
}
