import 'package:decimal/decimal.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../utils.dart';
import '../utils/aliases.dart';
import '../utils/chain_utils.dart';

class IcoUtils {
  static Future<String?> buyCoins({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required int want,
  }) async {
    var alias = Aliases.getAlias(c);
    var coinseller = alias.coinsellerContract(c, client);
    EthereumAddress _myAddress = ChainUtils.ethAddressFromHex(c, walletAddress);
    var _bigWant = BigInt.from(want);
    var _wantDecimal = Decimal.fromInt(want);
    var _price = await coinseller.pricePerCoin();
    var _priceDecimal = ChainUtils.nativeUintToDecimal(c, _price);
    var _msgVal = _wantDecimal * _priceDecimal;
    var _bigMsgVal = ChainUtils.nativeDecimalToUint(c, _msgVal);
    final transaction = Transaction.callContract(
        contract: coinseller.self,
        function: coinseller.self.function("buyCoins"),
        value: EtherAmount.inWei(_bigMsgVal),
        from: _myAddress,
        parameters: [_bigWant]);
    try {
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

  static Future<void> fetchIco({
    required Chain c,
    required Web3Client client,
    required void Function({
      required int paramAvailableCoins,
      required int paramSoldCoins,
      required Decimal paramPricePerCoin,
      required DateTime paramIcoStart,
      required DateTime paramIcoEnd,
      required String paramOmnicoinAddress,
    }) initialize,
  }) async {
    var alias = Aliases.getAlias(c);
    var coinseller = alias.coinsellerContract(c, client);
    final _availableCoinsBig = await coinseller.availableCoins();
    final _availableCoins = _availableCoinsBig.toInt();
    final _soldCoinsBig = await coinseller.soldCoins();
    final _soldCoins = _soldCoinsBig.toInt();
    final _pricePerCoinBig = await coinseller.pricePerCoin();
    final _pricePerCoin = ChainUtils.nativeUintToDecimal(c, _pricePerCoinBig);
    final _chainDateOffered = await coinseller.dateOffered();
    final _dateOffered = ChainUtils.chainDateToDt(_chainDateOffered);
    final unlockDuration = await coinseller.unlockDuration();
    final _unlockDuration = unlockDuration.toInt() / 86400;
    final Duration _duration = Duration(days: _unlockDuration.toInt());
    final _icoStart = _dateOffered.add(_duration);
    final _endDate = await coinseller.endDate();
    final _icoEnd = ChainUtils.chainDateToDt(_endDate);
    initialize(
      paramAvailableCoins: _availableCoins,
      paramSoldCoins: _soldCoins,
      paramPricePerCoin: _pricePerCoin,
      paramIcoStart: _icoStart,
      paramIcoEnd: _icoEnd,
      paramOmnicoinAddress: alias.omnicoinAddress,
    );
  }
}
