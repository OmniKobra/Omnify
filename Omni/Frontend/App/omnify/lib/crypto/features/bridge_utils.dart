// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../models/asset.dart';
import '../../models/bridge_asset.dart';
import '../../utils.dart';
import '../utils/aliases.dart';
import '../utils/chain_utils.dart';

class BridgeUtils {
  static Future<List<String>?> migrateAssets({
    required Chain c,
    required Chain targetChain,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    // required Decimal nativeGas,
    required Decimal omnifyFee,
    required Decimal amount,
    required CryptoAsset asset,
    required String recipient,
    required String walletAddress,
  }) async {
    var alias = Aliases.getAlias(c);
    var bridgesContract = alias.bridgesContract(c, client);
    var currentContractCount = await bridgesContract.transactionCount();
    int _count = currentContractCount.toInt();
    _count++;
    var _omnifyFee = ChainUtils.nativeDecimalToUint(c, omnifyFee);
    var nativeGas = await quoteNativeGas(
        c: c,
        targetChain: targetChain,
        client: client,
        wcClient: wcClient,
        sessionTopic: sessionTopic,
        omnifyFee: omnifyFee,
        amount: amount,
        asset: asset,
        recipient: recipient,
        walletAddress: walletAddress);
    var _nativeGas = ChainUtils.nativeDecimalToUint(c, nativeGas);
    var _totalMsgValue = _omnifyFee + _nativeGas;
    var _asset = ChainUtils.ethAddressFromHex(c, asset.address);
    var _recipient = ChainUtils.ethAddressFromHex(targetChain, recipient);
    int _targetChain = Utils.chainToLzEID(targetChain);
    BigInt _target = BigInt.from(_targetChain);
    var _amount = ChainUtils.decimalToUint(c, asset, amount);
    var _sender = ChainUtils.ethAddressFromHex(c, walletAddress);
    final transaction = Transaction.callContract(
        contract: bridgesContract.self,
        function: bridgesContract.self.function('migrateAssets'),
        from: _sender,
        value: EtherAmount.inWei(_totalMsgValue),
        parameters: [
          _asset,
          _amount,
          _target,
          _recipient,
        ]);
    try {
      var senTx = await wcClient.request(
          topic: sessionTopic,
          chainId: ChainUtils.getChainIdString(c),
          request: SessionRequestParams(
              method: ChainUtils.getSendTransactionString(c),
              params: [transaction.toJson()]));
      return [senTx, _count.toString()];
    } catch (_) {
      return null;
    }
  }

  static Future<List<dynamic>> fetchAssetEquivalent({
    required Chain c,
    required Chain targetChain,
    required Web3Client client,
    required Web3App wcClient,
    required CryptoAsset asset,
  }) async {
    CryptoAsset? destinationAsset;
    bool isReturningBridgedAsset = false;
    var alias = Aliases.getAlias(c);
    var bridgesContract = alias.bridgesContract(c, client);
    var targetAlias = Aliases.getAlias(targetChain);
    var tempClient = Web3Client(targetAlias.rpcUrl, http.Client());
    var targetBridgesContract =
        targetAlias.bridgesContract(targetChain, tempClient);
    int _targetChain = Utils.chainToLzEID(targetChain);
    BigInt _target = BigInt.from(_targetChain);
    var _asset = ChainUtils.ethAddressFromHex(c, asset.address);
    var foreignEquivalent = await bridgesContract
        .lookupBridgedTokenForeignEquivalent(
            (asset: _asset, sourceChain: _target));
    var bridgedEquivalent = await bridgesContract
        .lookupForeignTokenBridgedEquivalent(
            (asset: foreignEquivalent, sourceChain: _target));
    var bridgedEquivalentAddress =
        ChainUtils.hexFromEthAddress(c, bridgedEquivalent);
    isReturningBridgedAsset = bridgedEquivalentAddress != Utils.zeroAddress &&
        bridgedEquivalent == _asset;
    if (isReturningBridgedAsset) {
      var assetAddress =
          ChainUtils.hexFromEthAddress(targetChain, foreignEquivalent);
      destinationAsset = await ChainUtils.getCoinFromAddress(
          targetChain, assetAddress, tempClient);
    } else {
      int _sourceChain = Utils.chainToLzEID(c);
      BigInt _source = BigInt.from(_sourceChain);
      var targetForeignEquivalent = await targetBridgesContract
          .lookupForeignTokenBridgedEquivalent(
              (asset: _asset, sourceChain: _source));
      var targetForeignEquivalentAddress =
          ChainUtils.hexFromEthAddress(targetChain, targetForeignEquivalent);
      if (targetForeignEquivalentAddress == Utils.zeroAddress) {
        destinationAsset = null;
      } else {
        destinationAsset = await ChainUtils.getCoinFromAddress(
            targetChain, targetForeignEquivalentAddress, tempClient);
      }
    }
    tempClient.dispose();
    return [destinationAsset, isReturningBridgedAsset];
  }

  static Future<Decimal> quoteNativeGas({
    required Chain c,
    required Chain targetChain,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required Decimal omnifyFee,
    required Decimal amount,
    required CryptoAsset asset,
    required String recipient,
    required String walletAddress,
  }) async {
    var alias = Aliases.getAlias(c);
    var bridgesContract = alias.bridgesContract(c, client);
    var MAX_GAS = await bridgesContract.GAS_LIMIT();
    var options = await bridgesContract
        .createLzReceiveOption((gas: MAX_GAS, value: BigInt.from(0)));
    int _thisChain = Utils.chainToLzEID(c);
    int _targetChain = Utils.chainToLzEID(targetChain);
    BigInt _target = BigInt.from(_targetChain);
    CryptoAsset? bufferAsset =
        await ChainUtils.getCoinFromAddress(c, asset.address, client);
    CryptoAsset trueAsset = bufferAsset ?? Utils.generateNativeToken(c);
    var _asset = ChainUtils.ethAddressFromHex(c, asset.address);
    var _sender = ChainUtils.ethAddressFromHex(c, walletAddress);
    var _recipient = ChainUtils.ethAddressFromHex(targetChain, recipient);
    var _amount = ChainUtils.decimalToUint(c, asset, amount);
    List<dynamic> equivalents = await fetchAssetEquivalent(
        c: c,
        targetChain: targetChain,
        asset: asset,
        client: client,
        wcClient: wcClient);
    CryptoAsset? foreignAsset = equivalents[0];
    EthereumAddress foreignEthAddress = foreignAsset != null
        ? ChainUtils.ethAddressFromHex(targetChain, foreignAsset.address)
        : ChainUtils.ethAddressFromHex(targetChain, Utils.zeroAddress);
    bool isReturning = equivalents[1];
    String payload =
        '${_asset.hex}.${_thisChain.toString()}.${_sender.hex}.${_recipient.hex}.${_amount.toString()}.${trueAsset.name}.${trueAsset.symbol}.${trueAsset.decimals.toString()}.${isReturning.toString()}.${foreignEthAddress.hex}';
    var quote = await bridgesContract.quote((
      dstEid: _target,
      message: payload,
      options: options,
      payInLzToken: false
    ));
    var nativeFee = quote.nativeFee;
    var nativeGas = ChainUtils.nativeUintToDecimal(c, nativeFee);
    return nativeGas;
  }

  static Future<Decimal> quoteGasFee({
    required Chain c,
    required Web3Client client,
    required bool isFirstBridging,
  }) async {
    if (isFirstBridging) {
      final gasPrice = await client.getGasPrice();
      final price = gasPrice.getInWei;
      bool isL2 = ChainUtils.isL2(c);
      final BigInt roughGas = BigInt.from(750000);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    } else {
      final gasPrice = await client.getGasPrice();
      final price = gasPrice.getInWei;
      bool isL2 = ChainUtils.isL2(c);
      final BigInt roughGas = BigInt.from(580000);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    }
  }

  static Future<String?> fetchLzeroSecondTx(
      {required Chain source, required String txHash}) async {
    var mainnetScan = "https://scan.layerzero-api.com/v1";
    var testnetScan = "https://scan-testnet.layerzero-api.com/v1";
    var endpoint = source == Chain.Fuji || source == Chain.BNBT
        ? testnetScan
        : mainnetScan;
    var response = await http.get(Uri.parse("$endpoint/messages/tx/$txHash"));
    Map<String, dynamic>? body = jsonDecode(response.body);
    dynamic data = body?['data'] ?? [];
    if (data.isNotEmpty) {
      Map<String, dynamic> nested = data[0];
      Map<String, dynamic> destination = nested['destination'];
      var status = destination['status'];
      if (status == 'VALIDATING_TX' ||
          status == 'SUCCEEDED' ||
          status == 'FAILED') {
        return destination['tx']['txHash'];
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<BridgeTransaction> fetchBridgeTransaction({
    required Chain c,
    required Web3Client client,
    required int id,
  }) async {
    var alias = Aliases.getAlias(c);
    var bridgesContract = alias.bridgesContract(c, client);
    var details =
        await bridgesContract.lookupBridgeTransaction((id: BigInt.from(id)));
    var asset = details[0];
    var assetAddress = ChainUtils.hexFromEthAddress(c, asset);
    CryptoAsset? _asset =
        await ChainUtils.getCoinFromAddress(c, assetAddress, client);
    var cAsset = _asset ?? Utils.generateNativeToken(c);
    var amount = details[1];
    var _amount = ChainUtils.uintToDecimal(c, cAsset, amount);
    var sourceChain = details[2];
    var _sourceChain = Utils.lzEidToChain(sourceChain.toInt());
    var destinationChain = details[3];
    var _destinationChain = Utils.lzEidToChain(destinationChain.toInt());
    var sourceAddress = details[4];
    var sender = ChainUtils.hexFromEthAddress(_sourceChain, sourceAddress);
    var destinationAddress = details[5];
    var recipient =
        ChainUtils.hexFromEthAddress(_destinationChain, destinationAddress);
    var date = details[6];
    var _date = ChainUtils.chainDateToDt(date);
    return BridgeTransaction(
        id: id.toString(),
        sourceChain: _sourceChain,
        destinationChain: _destinationChain,
        isOutgoing: _sourceChain == c,
        assetAmount: _amount,
        assetImage: cAsset.logoUrl,
        assetSymbol: "\$${cAsset.symbol}",
        assetAddress: cAsset.address,
        decimals: cAsset.decimals,
        date: _date,
        sender: sender,
        recipient: recipient);
  }

  static Future<void> fetchBridgeProfile(
      {required Chain c,
      required Web3Client client,
      required String walletAddress,
      required void Function({
        required List<BridgeAsset> paramMigratedAssets,
        required List<BridgeAsset> paramReceivedAssets,
        required List<BridgeTransaction> paramTransactions,
      }) initBridgeProfile}) async {
    var alias = Aliases.getAlias(c);
    var bridgesContract = alias.bridgesContract(c, client);
    var _profile = ChainUtils.ethAddressFromHex(c, walletAddress);
    var txIDs = await bridgesContract
        .lookupBridgeProfileTransactions((profile: _profile));
    List<BridgeTransaction> bridgeTransactions = [];
    for (var id in txIDs) {
      var _id = id.toInt();
      var tx = await fetchBridgeTransaction(c: c, client: client, id: _id);
      if (!bridgeTransactions.any((btx) => btx.id == _id.toString())) {
        bridgeTransactions.add(tx);
      }
    }

    List<BridgeAsset> migratedAssets = [];
    var migrateds = await bridgesContract
        .lookupBridgeProfileMigratedAssets((profile: _profile));
    for (var m in migrateds) {
      var ass = m[0];
      var assAddress = ChainUtils.hexFromEthAddress(c, ass);
      CryptoAsset? _cryptoAss =
          await ChainUtils.getCoinFromAddress(c, assAddress, client);
      var cAss = _cryptoAss ?? Utils.generateNativeToken(c);
      var amo = m[1];
      migratedAssets.add(BridgeAsset(cAss.address, "\$${cAss.symbol}",
          ChainUtils.uintToDecimal(c, cAss, amo), cAss.logoUrl, cAss.decimals));
    }
    migratedAssets.sort((a, b) => b.amount.compareTo(a.amount));
    List<BridgeAsset> receivedAssets = [];
    var receiveds = await bridgesContract
        .lookupBridgeProfileReceivedAssets((profile: _profile));
    for (var r in receiveds) {
      var ass = r[0];
      var assAddress = ChainUtils.hexFromEthAddress(c, ass);
      CryptoAsset? _cryptoAss =
          await ChainUtils.getCoinFromAddress(c, assAddress, client);
      var cAss = _cryptoAss ?? Utils.generateNativeToken(c);
      var amo = r[1];
      receivedAssets.add(BridgeAsset(cAss.address, "\$${cAss.symbol}",
          ChainUtils.uintToDecimal(c, cAss, amo), cAss.logoUrl, cAss.decimals));
    }
    receivedAssets.sort((a, b) => b.amount.compareTo(a.amount));
    initBridgeProfile(
        paramTransactions: bridgeTransactions,
        paramMigratedAssets: migratedAssets,
        paramReceivedAssets: receivedAssets);
  }
}
