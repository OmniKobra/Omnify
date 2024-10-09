// ignore_for_file: constant_identifier_names

import 'package:web3dart/web3dart.dart';

import '../../utils.dart';
import '../contracts/bridgesAbi.g.dart';
import '../contracts/coinsellerAbi.g.dart';
import '../contracts/escrowAbi.g.dart';
import '../contracts/governAbi.g.dart';
import '../contracts/omnicoinAbi.g.dart';
import '../contracts/paymentsAbi.g.dart';
import '../contracts/transfersAbi.g.dart';
import '../contracts/trustAbi.g.dart';
import 'chain_utils.dart';
import 'sensitive.dart';

//TODO ADD NEXT SUPPORTED NETWORKS HERE
class Aliases {
  static const OmnifyAlias fujiAlias = OmnifyAlias(
      omnifyAddress: "0x0a187D975624dE816e4FbeFbD3e2Ac4Bb686eD20",
      transfersAddress: "0x46A536beDe3C736Fa23f6725d4FC16F770A508d1",
      paymentsAddress: "0x0728a761eFE78Eb8FEf02f0754A0C4BBCc041BA1",
      trustAddress: "0x36acbeEa5c54044c27603d1632657C6A5CBAADff",
      bridgeAddress: "0x375875470085bD524BBF05e7931Aa0882886A278",
      escrowAddress: "0x548eD112D78528D2EB6d84228751Ab22527e456b",
      omnicoinAddress: "0x7c617746Be398758ba704CAb7c4D8523587fbaEe",
      coinSellerAddress: "0x5a3A1b445D359b3d1998aff075C73A2c88c29F1C",
      refuelerAddress: "",
      wss: Sensitive.fujiWss,
      rpcUrl: Sensitive.fujiRPC);

  static const bsc_testnetAlias = OmnifyAlias(
      omnifyAddress: "0x9CEA849181e0E8938791beC142C568b135543E17",
      transfersAddress: "0x3514DBdBe9E147898009E8842373d7D7dc987265",
      paymentsAddress: "0x49F6AC875c5B743813276311cC029939fefb2E7F",
      trustAddress: "0x9469b2f2FEdA433aCBf5DeC6b26cEdB2545A53DB",
      bridgeAddress: "0x0BBC093c2100ac2392634DeC60E2724e9c9996b3",
      escrowAddress: "0xD8338dcB9491D2e16454a7cDB54cEbc4b7bBA808",
      omnicoinAddress: "0xBd35edE9E130A889Dc9c8c08B5378dD359E8121b",
      coinSellerAddress: "",
      refuelerAddress: "",
      wss: Sensitive.bnbtWss,
      rpcUrl: Sensitive.bnbtRPC);
  static const avalancheAlias = OmnifyAlias(
      omnifyAddress: '0x67b306745b6679778Dc4bB488be3a56655DFA939',
      transfersAddress: '0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE',
      paymentsAddress: '0x8D19256c92DCfad71aDCC7573de4817D31F18B14',
      trustAddress: '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136',
      bridgeAddress: '0x6e819151184D165686D2DC46B77d6271A4b70270',
      escrowAddress: '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9',
      omnicoinAddress: '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05',
      coinSellerAddress: "0x135d68d97081A7132eb41E107E6b7Ed94202a9A4",
      refuelerAddress: '',
      wss: Sensitive.avalancheWss,
      rpcUrl: Sensitive.avalancheRPC);
  static const optimismAlias = OmnifyAlias(
      omnifyAddress: '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05',
      transfersAddress: '0xf46a15a9916201aA753a62E736035eff2eDe4127',
      paymentsAddress: '0x7a0aB69093Edd8b5A8B5CD96f34a0a1EaFedfc50',
      trustAddress: '0x84aE4158aF61B92be8b84C7993D069575ABab0A4',
      bridgeAddress: '0xCC404532787c9E1D478F6aa14DF1C4219939145E',
      escrowAddress: '0xB0A50b25949dC9ac16524ac97a48565c08F7C643',
      omnicoinAddress: '0x92Ac7055FAB975C29059493408aA7965cad43E23',
      coinSellerAddress: "0x2300aD45C2BA39c08bb45BE75c1a6C0fe88962Bf",
      refuelerAddress: '',
      wss: Sensitive.optimismWss,
      rpcUrl: Sensitive.optimismRPC);
  static const ethereumAlias = OmnifyAlias(
      omnifyAddress: '',
      transfersAddress: '',
      paymentsAddress: '',
      trustAddress: '',
      bridgeAddress: '',
      escrowAddress: '',
      omnicoinAddress: '',
      coinSellerAddress: "",
      refuelerAddress: '',
      wss: Sensitive.ethereumWss,
      rpcUrl: Sensitive.ethereumRPC);
  static const bscAlias = OmnifyAlias(
      omnifyAddress: '0x883bA282D409e0E984Bef70B338f641D0045942F',
      transfersAddress: '0x06d7307E9678816d256036354866Ab9490355a05',
      paymentsAddress: '0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE',
      trustAddress: '0x8D19256c92DCfad71aDCC7573de4817D31F18B14',
      bridgeAddress: '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136',
      escrowAddress: '0x6e819151184D165686D2DC46B77d6271A4b70270',
      omnicoinAddress: '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9',
      coinSellerAddress: "0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05",
      refuelerAddress: '',
      wss: Sensitive.bnbWss,
      rpcUrl: Sensitive.bnbRPC);
  static const arbitrumAlias = OmnifyAlias(
      omnifyAddress: '0x883bA282D409e0E984Bef70B338f641D0045942F',
      transfersAddress: '0x06d7307E9678816d256036354866Ab9490355a05',
      paymentsAddress: '0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE',
      trustAddress: '0x8D19256c92DCfad71aDCC7573de4817D31F18B14',
      bridgeAddress: '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136',
      escrowAddress: '0x6e819151184D165686D2DC46B77d6271A4b70270',
      omnicoinAddress: '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9',
      coinSellerAddress: "0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05",
      refuelerAddress: '',
      wss: Sensitive.arbitrumeWss,
      rpcUrl: Sensitive.arbitrumRPC);
  static const polygonAlias = OmnifyAlias(
      omnifyAddress: '0x883bA282D409e0E984Bef70B338f641D0045942F',
      transfersAddress: '0x06d7307E9678816d256036354866Ab9490355a05',
      paymentsAddress: '0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE',
      trustAddress: '0x8D19256c92DCfad71aDCC7573de4817D31F18B14',
      bridgeAddress: '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136',
      escrowAddress: '0x6e819151184D165686D2DC46B77d6271A4b70270',
      omnicoinAddress: '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9',
      coinSellerAddress: "0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05",
      refuelerAddress: '',
      wss: Sensitive.polygonWss,
      rpcUrl: Sensitive.polygonRPC);
  static const fantomAlias = OmnifyAlias(
      omnifyAddress: '0x883bA282D409e0E984Bef70B338f641D0045942F',
      transfersAddress: '0x06d7307E9678816d256036354866Ab9490355a05',
      paymentsAddress: '0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE',
      trustAddress: '0x8D19256c92DCfad71aDCC7573de4817D31F18B14',
      bridgeAddress: '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136',
      escrowAddress: '0x6e819151184D165686D2DC46B77d6271A4b70270',
      omnicoinAddress: '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9',
      coinSellerAddress: "0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05",
      refuelerAddress: '',
      wss: Sensitive.fantomWss,
      rpcUrl: Sensitive.fantomRPC);
  static const tronAlias = OmnifyAlias(
      omnifyAddress: '',
      transfersAddress: '',
      paymentsAddress: '',
      trustAddress: '',
      bridgeAddress: '',
      escrowAddress: '',
      omnicoinAddress: '',
      coinSellerAddress: "",
      refuelerAddress: '',
      wss: Sensitive.tronWss,
      rpcUrl: Sensitive.tronRPC);
  static const baseAlias = OmnifyAlias(
      omnifyAddress: '0x883bA282D409e0E984Bef70B338f641D0045942F',
      transfersAddress: '0x06d7307E9678816d256036354866Ab9490355a05',
      paymentsAddress: '0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE',
      trustAddress: '0x8D19256c92DCfad71aDCC7573de4817D31F18B14',
      bridgeAddress: '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136',
      escrowAddress: '0x6e819151184D165686D2DC46B77d6271A4b70270',
      omnicoinAddress: '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9',
      coinSellerAddress: "0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05",
      refuelerAddress: '',
      wss: Sensitive.baseWss,
      rpcUrl: Sensitive.baseRPC);
  static const lineaAlias = OmnifyAlias(
      omnifyAddress: '0x0490b255168549725a1cb880A44Dc9B090f88E07',
      transfersAddress: '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05',
      paymentsAddress: '0x135d68d97081A7132eb41E107E6b7Ed94202a9A4',
      trustAddress: '0x82aC8B7071253eCf72F18CFA9cC4F3e33b8d16Fb',
      bridgeAddress: '0x6445CE5e7F342eA217bf08781dBd53876F3BF383',
      escrowAddress: '0xc91B8172eBC46285A36cB7bB63aBeb8374Eb45cC',
      omnicoinAddress: '0xa1B6863BC753FfCE82c3e606D9BC1fBcBbCa40Ae',
      coinSellerAddress: "0x2aC581f649D69259AD03ec79A2184e9Eabe805Ad",
      refuelerAddress: '',
      wss: Sensitive.lineaWss,
      rpcUrl: Sensitive.lineaRPC);
  static const mantleAlias = OmnifyAlias(
      omnifyAddress: '0x883bA282D409e0E984Bef70B338f641D0045942F',
      transfersAddress: '0x06d7307E9678816d256036354866Ab9490355a05',
      paymentsAddress: '0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE',
      trustAddress: '0x8D19256c92DCfad71aDCC7573de4817D31F18B14',
      bridgeAddress: '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136',
      escrowAddress: '0x6e819151184D165686D2DC46B77d6271A4b70270',
      omnicoinAddress: '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9',
      coinSellerAddress: "0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05",
      refuelerAddress: '',
      wss: Sensitive.mantleWss,
      rpcUrl: Sensitive.mantleRPC);
  static const gnosisAlias = OmnifyAlias(
      omnifyAddress: '0x67b306745b6679778Dc4bB488be3a56655DFA939',
      transfersAddress: '0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE',
      paymentsAddress: '0x8D19256c92DCfad71aDCC7573de4817D31F18B14',
      trustAddress: '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136',
      bridgeAddress: '0x6e819151184D165686D2DC46B77d6271A4b70270',
      escrowAddress: '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9',
      omnicoinAddress: '0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05',
      coinSellerAddress: "0x135d68d97081A7132eb41E107E6b7Ed94202a9A4",
      refuelerAddress: '',
      wss: Sensitive.gnosisWss,
      rpcUrl: Sensitive.gnosisRPC);
  static const roninAlias = OmnifyAlias(
      omnifyAddress: '',
      transfersAddress: '',
      paymentsAddress: '',
      trustAddress: '',
      bridgeAddress: '',
      escrowAddress: '',
      omnicoinAddress: '',
      coinSellerAddress: "",
      refuelerAddress: '',
      wss: Sensitive.roninWss,
      rpcUrl: Sensitive.roninRPC);
  static const zksyncAlias = OmnifyAlias(
      omnifyAddress: '0xf87048C473E7A4952252E63b8531230dcEB4081B',
      transfersAddress: '0xF8cA6A28BdF059958AE6bbd9F27F429e3a74183F',
      paymentsAddress: '0xa6975a55af47169a065f34aeCf5cA4f9B1d47531',
      trustAddress: '0x14210E73dC72f7E02aC9d79D4a3d6Cf0F7b75967',
      bridgeAddress: '0x8363091e979B1cfdc9f08b45A46d175781ceD884',
      escrowAddress: '0cF8d1570e4744BFdDb5c1F7B34C82ea819d0A60',
      omnicoinAddress: '0x626cb53cD4A51F04B3701f2029B452732F897479',
      coinSellerAddress: "0x92609A128FFF40e14d57e15CFE90f764a4A6edaC",
      refuelerAddress: '',
      wss: Sensitive.zksyncWss,
      rpcUrl: Sensitive.zksyncRPC);
  static const celoAlias = OmnifyAlias(
      omnifyAddress: '0x883bA282D409e0E984Bef70B338f641D0045942F',
      transfersAddress: '0x06d7307E9678816d256036354866Ab9490355a05',
      paymentsAddress: '0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE',
      trustAddress: '0x8D19256c92DCfad71aDCC7573de4817D31F18B14',
      bridgeAddress: '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136',
      escrowAddress: '0x6e819151184D165686D2DC46B77d6271A4b70270',
      omnicoinAddress: '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9',
      coinSellerAddress: "0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05",
      refuelerAddress: '',
      wss: Sensitive.celoWss,
      rpcUrl: Sensitive.celoRPC);
  static const scrollAlias = OmnifyAlias(
      omnifyAddress: '0x135d68d97081A7132eb41E107E6b7Ed94202a9A4',
      transfersAddress: '0x7a0aB69093Edd8b5A8B5CD96f34a0a1EaFedfc50',
      paymentsAddress: '0x84aE4158aF61B92be8b84C7993D069575ABab0A4',
      trustAddress: '0xCC404532787c9E1D478F6aa14DF1C4219939145E',
      bridgeAddress: '0xB0A50b25949dC9ac16524ac97a48565c08F7C643',
      escrowAddress: '0x92Ac7055FAB975C29059493408aA7965cad43E23',
      omnicoinAddress: '0x2300aD45C2BA39c08bb45BE75c1a6C0fe88962Bf',
      coinSellerAddress: "0x901c0D640aa4E3163cDbc2C86157D66d49BcD7BF",
      refuelerAddress: '',
      wss: Sensitive.scrollWss,
      rpcUrl: Sensitive.scrollRPC);
  static const blastAlias = OmnifyAlias(
      omnifyAddress: '0x883bA282D409e0E984Bef70B338f641D0045942F',
      transfersAddress: '0x06d7307E9678816d256036354866Ab9490355a05',
      paymentsAddress: '0xcEeC51f724d25Ce6BA0E4aA2DFc55eEa336ee8BE',
      trustAddress: '0x8D19256c92DCfad71aDCC7573de4817D31F18B14',
      bridgeAddress: '0x5Cf9d1E8A96ab2118A129010BAFD3EA9b414A136',
      escrowAddress: '0x6e819151184D165686D2DC46B77d6271A4b70270',
      omnicoinAddress: '0xe6C211a8b4F32D0EA16389D282A199D29A1366D9',
      coinSellerAddress: "0x16ca26646Fc4E1Aba79272b056e1D720cfBC0d05",
      refuelerAddress: '',
      wss: Sensitive.blastWss,
      rpcUrl: Sensitive.blastRPC);

  static OmnifyAlias getAlias(Chain c) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (c) {
      case Chain.Blast:
        return blastAlias;
      case Chain.Fuji:
        return fujiAlias;
      case Chain.BNBT:
        return bsc_testnetAlias;
      case Chain.Avalanche:
        return avalancheAlias;
      case Chain.Optimism:
        return optimismAlias;
      case Chain.Ethereum:
        return ethereumAlias;
      case Chain.BSC:
        return bscAlias;
      case Chain.Arbitrum:
        return arbitrumAlias;
      case Chain.Polygon:
        return polygonAlias;
      case Chain.Fantom:
        return fantomAlias;
      case Chain.Tron:
        return tronAlias;
      case Chain.Base:
        return baseAlias;
      case Chain.Linea:
        return lineaAlias;
      case Chain.Mantle:
        return mantleAlias;
      case Chain.Gnosis:
        return gnosisAlias;
      case Chain.Ronin:
        return roninAlias;
      case Chain.Zksync:
        return zksyncAlias;
      case Chain.Celo:
        return celoAlias;
      case Chain.Scroll:
        return scrollAlias;
      default:
        return const OmnifyAlias(
            omnifyAddress: '',
            transfersAddress: '',
            paymentsAddress: '',
            trustAddress: '',
            bridgeAddress: '',
            escrowAddress: '',
            omnicoinAddress: '',
            refuelerAddress: '',
            coinSellerAddress: "",
            wss: "",
            rpcUrl: '');
    }
  }
}

class OmnifyAlias {
  final String omnifyAddress;
  final String transfersAddress;
  final String paymentsAddress;
  final String trustAddress;
  final String bridgeAddress;
  final String escrowAddress;
  final String omnicoinAddress;
  final String refuelerAddress;
  final String coinSellerAddress;
  final String rpcUrl;
  final String wss;

  const OmnifyAlias(
      {required this.omnifyAddress,
      required this.transfersAddress,
      required this.paymentsAddress,
      required this.trustAddress,
      required this.bridgeAddress,
      required this.escrowAddress,
      required this.refuelerAddress,
      required this.omnicoinAddress,
      required this.coinSellerAddress,
      required this.rpcUrl,
      required this.wss});

  EthereumAddress addr(Chain c, String s) => ChainUtils.ethAddressFromHex(c, s);

  EthereumAddress omnifyEthAddr(Chain c) => addr(c, omnifyAddress);
  EthereumAddress transferEthAddr(Chain c) => addr(c, transfersAddress);
  EthereumAddress paymentEthAddr(Chain c) => addr(c, paymentsAddress);
  EthereumAddress trustEthAddr(Chain c) => addr(c, trustAddress);
  EthereumAddress bridgeEthAddr(Chain c) => addr(c, bridgeAddress);
  EthereumAddress escrowEthAddr(Chain c) => addr(c, escrowAddress);
  EthereumAddress omnicoinEthAddr(Chain c) => addr(c, omnicoinAddress);
  EthereumAddress refuelerEthAddr(Chain c) => addr(c, refuelerAddress);
  EthereumAddress coinSellerEthAddr(Chain c) => addr(c, coinSellerAddress);

  GovernAbi omnifyContract(Chain c, Web3Client client) =>
      GovernAbi(address: omnifyEthAddr(c), client: client);
  TransfersAbi transfersContract(Chain c, Web3Client client) =>
      TransfersAbi(address: transferEthAddr(c), client: client);
  PaymentsAbi paymentsContract(Chain c, Web3Client client) =>
      PaymentsAbi(address: paymentEthAddr(c), client: client);
  TrustAbi trustContract(Chain c, Web3Client client) =>
      TrustAbi(address: trustEthAddr(c), client: client);
  BridgesAbi bridgesContract(Chain c, Web3Client client) =>
      BridgesAbi(address: bridgeEthAddr(c), client: client);
  EscrowAbi escrowContract(Chain c, Web3Client client) =>
      EscrowAbi(address: escrowEthAddr(c), client: client);
  OmnicoinAbi omnicoinContract(Chain c, Web3Client client) =>
      OmnicoinAbi(address: omnicoinEthAddr(c), client: client);
  CoinsellerAbi coinsellerContract(Chain c, Web3Client client) =>
      CoinsellerAbi(address: coinSellerEthAddr(c), client: client);
  //TODO
  // refuelerAbi
}
