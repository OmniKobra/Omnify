import 'package:decimal/decimal.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart'
    hide Web3Client, EthereumAddress;
import 'package:web3dart/web3dart.dart';

import '../../models/asset.dart';
import '../../models/transfer.dart';
import '../../models/transfer_transaction.dart';
import '../../utils.dart';
import '../utils/aliases.dart';
import '../utils/chain_utils.dart';

class TransferUtils {
  static Future<String?> conductTransfers(
    Chain c,
    List<TransferFormModel> transfers,
    String sessionTopic,
    Web3App wcClient,
    String walletAddress,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    final transferContract = alias.transfersContract(c, client);
    List<dynamic> parameters = [];
    BigInt totalMsgVal = BigInt.from(0);
    try {
      for (var currentTransfer in transfers) {
        Decimal totalValue = currentTransfer.omnifyFee;
        final inputAmount = Decimal.tryParse(currentTransfer.amount.text) ??
            Decimal.parse("0.0");
        bool isNative = currentTransfer.asset.address == Utils.zeroAddress;
        if (isNative) {
          totalValue += inputAmount;
        }
        final _recipient = currentTransfer.recipient.text;
        final _amount =
            ChainUtils.decimalToUint(c, currentTransfer.asset, inputAmount);
        final msgValue = ChainUtils.nativeDecimalToUint(c, totalValue);
        totalMsgVal += msgValue;
        parameters.add([
          currentTransfer.asset.assetEthAddress(c),
          _amount,
          ChainUtils.ethAddressFromHex(c, _recipient),
          currentTransfer.id
        ]);
      }

      final transaction = Transaction.callContract(
          contract: transferContract.self,
          function: transferContract.self.function("conductTransfers"),
          value: EtherAmount.inWei(totalMsgVal),
          from: ChainUtils.ethAddressFromHex(c, walletAddress),
          parameters: [parameters]);
      var sentTx = await wcClient.request(
          topic: sessionTopic,
          chainId: ChainUtils.getChainIdString(c),
          request: SessionRequestParams(
            method: ChainUtils.getSendTransactionString(c),
            params: [transaction.toJson()],
          ));
      return sentTx;
    } catch (e) {
      return null;
    }
  }

  static Future<void> fetchTransferProfile(
      Chain c,
      Web3Client client,
      String address,
      void Function({
        required int paramSentNum,
        required int paramReceivedNum,
        required List<TransferActivityTransaction> paramTransactions,
        required CryptoAsset paramCryptoAsset,
      }) initProfile) async {
    if (address.isNotEmpty) {
      final alias = Aliases.getAlias(c);
      EthereumAddress addr = ChainUtils.ethAddressFromHex(c, address);
      final transferContract = alias.transfersContract(c, client);
      var sentNum =
          await transferContract.lookupTransferProfileSents((profile: addr));
      var receivedNum = await transferContract
          .lookupTransferProfileReceiveds((profile: addr));
      var transactions = await transferContract
          .lookupTransferProfileTransfers((profile: addr));
      List<TransferActivityTransaction> txs = [];
      for (var t in transactions) {
        var id = t[0];
        var res = await transferContract.lookupTransfer((id: id));
        var sender = ChainUtils.hexFromEthAddress(c, res[1]);
        var recipient = ChainUtils.hexFromEthAddress(c, res[2]);
        var asset = ChainUtils.hexFromEthAddress(c, res[3]);
        CryptoAsset? cAsset =
            await ChainUtils.getCoinFromAddress(c, asset, client);
        CryptoAsset a = cAsset ?? Utils.generateNativeToken(c);
        var amount = res[4];
        var date = ChainUtils.chainDateToDt(res[5]);
        var tx = TransferActivityTransaction(
            asset: a,
            address: recipient == address ? sender : recipient,
            isOutgoing: recipient != address,
            date: date,
            id: id,
            amount: ChainUtils.uintToDecimal(c, a, amount));
        txs.add(tx);
      }
      initProfile(
        paramSentNum: sentNum.toInt(),
        paramReceivedNum: receivedNum.toInt(),
        paramCryptoAsset: Utils.generateNativeToken(c),
        paramTransactions: txs,
      );
    }
  }

  static Future<Decimal> quoteTransferFee(
    Chain c,
    TransferFormModel currentTransfer,
    String walletAddress,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    final transferContract = alias.transfersContract(c, client);
    Decimal totalValue = currentTransfer.omnifyFee;
    final inputAmount =
        Decimal.tryParse(currentTransfer.amount.text) ?? Decimal.parse("0.0");
    bool isNative = currentTransfer.asset.address == Utils.zeroAddress;
    if (isNative) {
      totalValue += inputAmount;
    }
    final _recipient = currentTransfer.recipient.text;
    final _amount =
        ChainUtils.decimalToUint(c, currentTransfer.asset, inputAmount);
    final msgValue = ChainUtils.nativeDecimalToUint(c, totalValue);
    final gasPrice = await client.getGasPrice();
    bool isL2 = ChainUtils.isL2(c);
    try {
      final price = gasPrice.getInWei;
      final gasFee = await client.estimateGas(
        sender: ChainUtils.ethAddressFromHex(c, walletAddress),
        to: transferContract.self.address,
        data: transferContract.self.function('conductTransfers').encodeCall([
          [
            [
              currentTransfer.asset.assetEthAddress(c),
              _amount,
              ChainUtils.ethAddressFromHex(c, _recipient),
              currentTransfer.id,
            ]
          ]
        ]),
        value: EtherAmount.inWei(msgValue),
      );
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, gasFee * price);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    } catch (e) {
      final BigInt price = gasPrice.getInWei;
      final BigInt roughGas = BigInt.from(
          currentTransfer.asset.address == Utils.zeroAddress ? 350000 : 450000);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    }
  }
}
