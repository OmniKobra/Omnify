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
      omnifyAddress: '0x7e688b0a2eE53B3136EDE687Fe4260d7Dc578674',
      transfersAddress: '0x8eAC1C3eD1e78bd373965818816987d525158148',
      paymentsAddress: '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724',
      trustAddress: '0xBdc066F91b9DB3b854e3Ec15b6816944896974CD',
      bridgeAddress: '0x27Efe83C0629D5c3B1C3554EaB3E2B3645d2465e',
      escrowAddress: '0xaA01ED5B276A1B61850799FFD8d42f9bc7fe8CC5',
      omnicoinAddress: '0x946e2B2f3E94d621fc8016e28EdA655448831021',
      coinSellerAddress: "0xd0AdC46C8Af67382b23AB68b330BDbc3bb6A326a",
      refuelerAddress: '',
      wss: Sensitive.avalancheWss,
      rpcUrl: Sensitive.avalancheRPC);
  static const optimismAlias = OmnifyAlias(
      omnifyAddress: '0x9753c27106BE0b7562E1fA87800A674fA760e5b9',
      transfersAddress: '0x946e2B2f3E94d621fc8016e28EdA655448831021',
      paymentsAddress: '0xd0AdC46C8Af67382b23AB68b330BDbc3bb6A326a',
      trustAddress: '0xB1d282ca4181d120b5C834cd559129d59b3A2a66',
      bridgeAddress: '0x7E6630282a88AE7318fa00658Ba4a8665303C455',
      escrowAddress: '0xE9766989587d7DE44f9061Dc1a3dB70A2Bc3a96e',
      omnicoinAddress: '0x105097f01655e18c5986B42469E7a92524ba5664',
      coinSellerAddress: "0xd73151f3a6aA783B1e90bdCd634b4eF72ca0323B",
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
      omnifyAddress: '0xC94bbe8954C960ca26782Fb7A63ad0e8e0a98Ba9',
      transfersAddress: '0x786190b138A61b216baF7Bc6E0F2713A4950fa75',
      paymentsAddress: '0xda37db53eBEf86a2760B64C62C2bC567c657d554',
      trustAddress: '0xB75Df341363E58C0B3684B263af629fe6cc73610',
      bridgeAddress: '0x855b3389f56Ed63A00684AF8522fadba4A14984b',
      escrowAddress: '0x8eAC1C3eD1e78bd373965818816987d525158148',
      omnicoinAddress: '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724',
      coinSellerAddress: "0xBdc066F91b9DB3b854e3Ec15b6816944896974CD",
      refuelerAddress: '',
      wss: Sensitive.bnbWss,
      rpcUrl: Sensitive.bnbRPC);
  static const arbitrumAlias = OmnifyAlias(
      omnifyAddress: '0x855b3389f56Ed63A00684AF8522fadba4A14984b',
      transfersAddress: '0x7e688b0a2eE53B3136EDE687Fe4260d7Dc578674',
      paymentsAddress: '0xeB05bC1A286f5b7591B4A74cA49697c7bE43B7cf',
      trustAddress: '0x423ADe67745ef3380297a88CF206A0A24147E84B',
      bridgeAddress: '0xA1A9698513201768357C6d05e939cc684e6Daf4B',
      escrowAddress: '0x17b25673F16EedF8646C4b0bf8924700b443f4fD',
      omnicoinAddress: '0x9753c27106BE0b7562E1fA87800A674fA760e5b9',
      coinSellerAddress: "0x9e4bbd964FB2B0B77E7a0103b7559d9544d896a6",
      refuelerAddress: '',
      wss: Sensitive.arbitrumeWss,
      rpcUrl: Sensitive.arbitrumRPC);
  static const polygonAlias = OmnifyAlias(
      omnifyAddress: '0xDc78DAe441E2d6997Ec177bbe2F6BCa42850dE01',
      transfersAddress: '0x06a6BB60dfd9EaD066594bb1d772e0c647483912',
      paymentsAddress: '0x786190b138A61b216baF7Bc6E0F2713A4950fa75',
      trustAddress: '0xda37db53eBEf86a2760B64C62C2bC567c657d554',
      bridgeAddress: '0xB75Df341363E58C0B3684B263af629fe6cc73610',
      escrowAddress: '0x855b3389f56Ed63A00684AF8522fadba4A14984b',
      omnicoinAddress: '0x8eAC1C3eD1e78bd373965818816987d525158148',
      coinSellerAddress: "0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724",
      refuelerAddress: '',
      wss: Sensitive.polygonWss,
      rpcUrl: Sensitive.polygonRPC);
  static const fantomAlias = OmnifyAlias(
      omnifyAddress: '0xDc78DAe441E2d6997Ec177bbe2F6BCa42850dE01',
      transfersAddress: '0x06a6BB60dfd9EaD066594bb1d772e0c647483912',
      paymentsAddress: '0x786190b138A61b216baF7Bc6E0F2713A4950fa75',
      trustAddress: '0xda37db53eBEf86a2760B64C62C2bC567c657d554',
      bridgeAddress: '0xB75Df341363E58C0B3684B263af629fe6cc73610',
      escrowAddress: '0x855b3389f56Ed63A00684AF8522fadba4A14984b',
      omnicoinAddress: '0x8eAC1C3eD1e78bd373965818816987d525158148',
      coinSellerAddress: "0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724",
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
      omnifyAddress: '0xDc78DAe441E2d6997Ec177bbe2F6BCa42850dE01',
      transfersAddress: '0x06a6BB60dfd9EaD066594bb1d772e0c647483912',
      paymentsAddress: '0x786190b138A61b216baF7Bc6E0F2713A4950fa75',
      trustAddress: '0xda37db53eBEf86a2760B64C62C2bC567c657d554',
      bridgeAddress: '0xB75Df341363E58C0B3684B263af629fe6cc73610',
      escrowAddress: '0x855b3389f56Ed63A00684AF8522fadba4A14984b',
      omnicoinAddress: '0x8eAC1C3eD1e78bd373965818816987d525158148',
      coinSellerAddress: "0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724",
      refuelerAddress: '',
      wss: Sensitive.baseWss,
      rpcUrl: Sensitive.baseRPC);
  static const lineaAlias = OmnifyAlias(
      omnifyAddress: '0xaA01ED5B276A1B61850799FFD8d42f9bc7fe8CC5',
      transfersAddress: '0x9753c27106BE0b7562E1fA87800A674fA760e5b9',
      paymentsAddress: '0x9e4bbd964FB2B0B77E7a0103b7559d9544d896a6',
      trustAddress: '0x8e2928b54c6986BC5Ebf4308E4F6D361f4029804',
      bridgeAddress: '0x787dA54f5C1b003969B9639B71e104A433431266',
      escrowAddress: '0xACb7E243506d7Ab7d9Bc1BA5DF340AD5ee704aeE',
      omnicoinAddress: '0x3Da72342e70440Fa3fd2C5105FB778a4E511040f',
      coinSellerAddress: "0xF9b3CBb3D2BCAafA30F04B033B88F9f353bb1003",
      refuelerAddress: '',
      wss: Sensitive.lineaWss,
      rpcUrl: Sensitive.lineaRPC);
  static const mantleAlias = OmnifyAlias(
      omnifyAddress: '0xBa39542aD2A115A2a86e2127a51A7674f8c8E3b9',
      transfersAddress: '0x0f2E150ab8321d54C5216F89C2116B44206BD511',
      paymentsAddress: '0x16044fC5CD74a90f3187f9988925A3D74F17049A',
      trustAddress: '0x4c01E342261B6eA5a63f63C458A3D0b7c4715235',
      bridgeAddress: '0xA79E2c0F5F5c3Ec5399855e5129e468034161E00',
      escrowAddress: '0x4C279c15e9595E44Be496841350fc90CFf5C2e5b',
      omnicoinAddress: '0x1540Fdeb5A7D7759Bec11D4557921D9046F22605',
      coinSellerAddress: "0xadAAA1F6b6e729B341C95D654eBb4d1c65B441eC",
      refuelerAddress: '',
      wss: Sensitive.mantleWss,
      rpcUrl: Sensitive.mantleRPC);
  static const gnosisAlias = OmnifyAlias(
      omnifyAddress: '0xd0AdC46C8Af67382b23AB68b330BDbc3bb6A326a',
      transfersAddress: '0x8e2928b54c6986BC5Ebf4308E4F6D361f4029804',
      paymentsAddress: '0x787dA54f5C1b003969B9639B71e104A433431266',
      trustAddress: '0xACb7E243506d7Ab7d9Bc1BA5DF340AD5ee704aeE',
      bridgeAddress: '0x3Da72342e70440Fa3fd2C5105FB778a4E511040f',
      escrowAddress: '0xF9b3CBb3D2BCAafA30F04B033B88F9f353bb1003',
      omnicoinAddress: '0x2d4563680b9edB817204f015Ee3C09C5959fE33D',
      coinSellerAddress: "0xf6eDE440FC5524d680C0465f27D0A2E36b8aCB7e",
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
      omnifyAddress: '0xDCde411FacD5081fa304542f57bF1B0A731a8B50',
      transfersAddress: '0x39C415b1a29cfc9e6D823552c1844CC1fd067a3C',
      paymentsAddress: '0xAd5F31cb68039699Ff37A50d84e180bb41ae709F',
      trustAddress: '0x9b8923238061530c0a83e432A058f2e9423C2bA1',
      bridgeAddress: '0x57835D82CBfd964Fa18CB7E488dB3e7c39B003F0',
      escrowAddress: '0xe606E88d7d628Cf705BdE837f77EdC71b9E2709D',
      omnicoinAddress: '0x73999642A049d49688499c7D12412f51F01d64cD',
      coinSellerAddress: "0xDFc727aB34D89Ef83B4698731a06f9136ab0ffeB",
      refuelerAddress: '',
      wss: Sensitive.zksyncWss,
      rpcUrl: Sensitive.zksyncRPC);
  static const celoAlias = OmnifyAlias(
      omnifyAddress: '0xDc78DAe441E2d6997Ec177bbe2F6BCa42850dE01',
      transfersAddress: '0x06a6BB60dfd9EaD066594bb1d772e0c647483912',
      paymentsAddress: '0x786190b138A61b216baF7Bc6E0F2713A4950fa75',
      trustAddress: '0xda37db53eBEf86a2760B64C62C2bC567c657d554',
      bridgeAddress: '0xB75Df341363E58C0B3684B263af629fe6cc73610',
      escrowAddress: '0x855b3389f56Ed63A00684AF8522fadba4A14984b',
      omnicoinAddress: '0x8eAC1C3eD1e78bd373965818816987d525158148',
      coinSellerAddress: "0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724",
      refuelerAddress: '',
      wss: Sensitive.celoWss,
      rpcUrl: Sensitive.celoRPC);
  static const scrollAlias = OmnifyAlias(
      omnifyAddress: '0xd0AdC46C8Af67382b23AB68b330BDbc3bb6A326a',
      transfersAddress: '0x8e2928b54c6986BC5Ebf4308E4F6D361f4029804',
      paymentsAddress: '0x787dA54f5C1b003969B9639B71e104A433431266',
      trustAddress: '0xACb7E243506d7Ab7d9Bc1BA5DF340AD5ee704aeE',
      bridgeAddress: '0x3Da72342e70440Fa3fd2C5105FB778a4E511040f',
      escrowAddress: '0xF9b3CBb3D2BCAafA30F04B033B88F9f353bb1003',
      omnicoinAddress: '0x2d4563680b9edB817204f015Ee3C09C5959fE33D',
      coinSellerAddress: "0xf6eDE440FC5524d680C0465f27D0A2E36b8aCB7e",
      refuelerAddress: '',
      wss: Sensitive.scrollWss,
      rpcUrl: Sensitive.scrollRPC);
  static const blastAlias = OmnifyAlias(
      omnifyAddress: '0x5762D178F6A449BE90C6f98EB94769F792f8e9E2',
      transfersAddress: '0x855b3389f56Ed63A00684AF8522fadba4A14984b',
      paymentsAddress: '0x8eAC1C3eD1e78bd373965818816987d525158148',
      trustAddress: '0xEe47e2484342eA7Bcf13B9e6d4F9d53B28F1b724',
      bridgeAddress: '0xBdc066F91b9DB3b854e3Ec15b6816944896974CD',
      escrowAddress: '0x27Efe83C0629D5c3B1C3554EaB3E2B3645d2465e',
      omnicoinAddress: '0xaA01ED5B276A1B61850799FFD8d42f9bc7fe8CC5',
      coinSellerAddress: "0x946e2B2f3E94d621fc8016e28EdA655448831021",
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
//EIP-3855 is not supported in one or more of the RPCs used.