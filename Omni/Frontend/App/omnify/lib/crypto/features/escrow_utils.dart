import 'package:decimal/decimal.dart';
import 'package:omnify/models/escrow_contract.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../models/asset.dart';
import '../../utils.dart';
import '../utils/aliases.dart';
import '../utils/chain_utils.dart';

class EscrowUtils {
  static Future<String?> createEscrowContract({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required String id,
    required CryptoAsset asset,
    required Decimal amount,
    required Decimal omnifyFee,
  }) async {
    var alias = Aliases.getAlias(c);
    var escrowContract = alias.escrowContract(c, client);
    var _asset = ChainUtils.ethAddressFromHex(c, asset.address);
    var _amount = ChainUtils.decimalToUint(c, asset, amount);
    var _sender = ChainUtils.ethAddressFromHex(c, walletAddress);
    var _omnifyFee = ChainUtils.nativeDecimalToUint(c, omnifyFee);
    var totalMsgValue = BigInt.from(0);
    totalMsgValue += _omnifyFee;
    if (asset.address == Utils.zeroAddress) {
      totalMsgValue += _amount;
    }
    final transaction = Transaction.callContract(
        contract: escrowContract.self,
        function: escrowContract.self.function('newContract'),
        from: _sender,
        value: EtherAmount.inWei(totalMsgValue),
        parameters: [
          id,
          _asset,
          _amount,
        ]);
    try {
      var senTx = await wcClient.request(
          topic: sessionTopic,
          chainId: ChainUtils.getChainIdString(c),
          request: SessionRequestParams(
              method: ChainUtils.getSendTransactionString(c),
              params: [transaction.toJson()]));
      return senTx;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> submitBid({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required String id,
    required CryptoAsset asset,
    required Decimal amount,
  }) async {
    var alias = Aliases.getAlias(c);
    var escrowContract = alias.escrowContract(c, client);
    var _asset = ChainUtils.ethAddressFromHex(c, asset.address);
    var _amount = ChainUtils.decimalToUint(c, asset, amount);
    var _sender = ChainUtils.ethAddressFromHex(c, walletAddress);
    var totalMsgValue = BigInt.from(0);
    if (asset.address == Utils.zeroAddress) {
      totalMsgValue += _amount;
    }
    final transaction = Transaction.callContract(
        contract: escrowContract.self,
        function: escrowContract.self.function('newBid'),
        from: _sender,
        value: EtherAmount.inWei(totalMsgValue),
        parameters: [
          id,
          _asset,
          _amount,
        ]);
    try {
      var senTx = await wcClient.request(
          topic: sessionTopic,
          chainId: ChainUtils.getChainIdString(c),
          request: SessionRequestParams(
              method: ChainUtils.getSendTransactionString(c),
              params: [transaction.toJson()]));
      return senTx;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> acceptBid({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required String id,
    required int acceptedBidCount,
  }) async {
    var alias = Aliases.getAlias(c);
    var escrowContract = alias.escrowContract(c, client);
    var _sender = ChainUtils.ethAddressFromHex(c, walletAddress);
    var bidCount = BigInt.from(acceptedBidCount);
    final transaction = Transaction.callContract(
        contract: escrowContract.self,
        function: escrowContract.self.function('acceptBid'),
        from: _sender,
        value: EtherAmount.inWei(BigInt.from(0)),
        parameters: [id, bidCount]);
    try {
      var senTx = await wcClient.request(
          topic: sessionTopic,
          chainId: ChainUtils.getChainIdString(c),
          request: SessionRequestParams(
              method: ChainUtils.getSendTransactionString(c),
              params: [transaction.toJson()]));
      return senTx;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> cancelBid({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required String id,
    required int cancelledBidCount,
  }) async {
    var alias = Aliases.getAlias(c);
    var escrowContract = alias.escrowContract(c, client);
    var _sender = ChainUtils.ethAddressFromHex(c, walletAddress);
    var bidCount = BigInt.from(cancelledBidCount);
    final transaction = Transaction.callContract(
        contract: escrowContract.self,
        function: escrowContract.self.function('cancelBid'),
        from: _sender,
        value: EtherAmount.inWei(BigInt.from(0)),
        parameters: [id, bidCount]);
    try {
      var senTx = await wcClient.request(
          topic: sessionTopic,
          chainId: ChainUtils.getChainIdString(c),
          request: SessionRequestParams(
              method: ChainUtils.getSendTransactionString(c),
              params: [transaction.toJson()]));
      return senTx;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> deleteContract({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required String id,
  }) async {
    var alias = Aliases.getAlias(c);
    var escrowContract = alias.escrowContract(c, client);
    var _sender = ChainUtils.ethAddressFromHex(c, walletAddress);
    final transaction = Transaction.callContract(
        contract: escrowContract.self,
        function: escrowContract.self.function('deleteContract'),
        from: _sender,
        value: EtherAmount.inWei(BigInt.from(0)),
        parameters: [id]);
    try {
      var senTx = await wcClient.request(
          topic: sessionTopic,
          chainId: ChainUtils.getChainIdString(c),
          request: SessionRequestParams(
              method: ChainUtils.getSendTransactionString(c),
              params: [transaction.toJson()]));
      return senTx;
    } catch (_) {
      return null;
    }
  }

  static Future<EscrowContract?> fetchContract({
    required Chain c,
    required Web3Client client,
    required String id,
  }) async {
    final alias = Aliases.getAlias(c);
    final escrowContract = alias.escrowContract(c, client);
    var owner = await escrowContract.lookupContractOwner((id: id));
    var ownerAddress = ChainUtils.hexFromEthAddress(c, owner);
    if (ownerAddress != Utils.zeroAddress) {
      var _asset = await escrowContract.lookupContractAsset((id: id));
      CryptoAsset? cAsset = await ChainUtils.getCoinFromAddress(
          c, ChainUtils.hexFromEthAddress(c, _asset), client);
      CryptoAsset ca = cAsset ?? Utils.generateNativeToken(c);
      var _amount = await escrowContract.lookupContractAssetAmount((id: id));
      var cAmount = ChainUtils.uintToDecimal(c, ca, _amount);
      var isDeleted = await escrowContract.lookupContractIsDeleted((id: id));
      var dDeleted = await escrowContract.lookupContractDateDeleted((id: id));
      var d = await escrowContract.lookupContractDateCreated((id: id));
      var date = ChainUtils.chainDateToDt(d);
      var dateDeleted = ChainUtils.chainDateToDt(dDeleted);
      List<EscrowBid> bids = [];
      var chainBids = await escrowContract.lookupContractBids((id: id));
      if (chainBids.isNotEmpty) {
        for (var bid in chainBids) {
          var exists = bid[6];
          if (exists) {
            var bidder = bid[0];
            var bidderAddress = ChainUtils.hexFromEthAddress(c, bidder);
            var asset = bid[1];
            var assetAddress = ChainUtils.hexFromEthAddress(c, asset);
            CryptoAsset? bAsset =
                await ChainUtils.getCoinFromAddress(c, assetAddress, client);
            CryptoAsset ba = bAsset ?? Utils.generateNativeToken(c);
            var bAmount = bid[2];
            var amountVal = ChainUtils.uintToDecimal(c, ba, bAmount);
            var dateBid = bid[3];
            var bidDate = ChainUtils.chainDateToDt(dateBid);
            var isAccepted = bid[4];
            var isCancelled = bid[5];
            bids.add(EscrowBid(
                amount: amountVal,
                bidderAddress: bidderAddress,
                assetAddress: ba.address,
                coinName: ba.symbol,
                imageUrl: ba.logoUrl,
                bidAccepted: isAccepted,
                bidCancelled: isCancelled,
                decimals: ba.decimals,
                dateBid: bidDate));
          }
        }
      }
      return EscrowContract(
          amount: cAmount,
          escrowID: id,
          ownerAddress: ownerAddress,
          assetAddress: ca.address,
          coinName: ca.symbol,
          decimals: ca.decimals,
          imageUrl: ca.logoUrl,
          bids: bids,
          isDeleted: isDeleted,
          dateCreated: date,
          dateDeleted: dateDeleted);
    }
    return null;
  }

  static Future<List<EscrowContract>> fetchTabContracts({
    required Chain c,
    required Web3Client client,
    required String walletAddress,
  }) async {
    final alias = Aliases.getAlias(c);
    final escrowContract = alias.escrowContract(c, client);
    var profile = ChainUtils.ethAddressFromHex(c, walletAddress);
    var ids =
        await escrowContract.lookupEscrowProfileContracts((profile: profile));
    List<EscrowContract> buffer = [];
    for (var id in ids) {
      var contract = await fetchContract(c: c, client: client, id: id);
      if (contract != null) {
        if (!buffer.any((c) => c.escrowID == contract.escrowID)) {
          buffer.add(contract);
        }
      }
    }
    return buffer;
  }

  static EscrowContract? searchProfileContract(
      List<EscrowContract> profileContracts, String searchedID) {
    if (profileContracts.isNotEmpty) {
      var index = profileContracts.indexWhere((c) => c.escrowID == searchedID);
      if (index == -1) {
        return null;
      } else {
        return profileContracts[index];
      }
    } else {
      return null;
    }
  }

  static Future<Decimal> quoteGasFee({
    required Chain c,
    required Web3Client client,
    required bool isCreation,
    required bool isDelete,
  }) async {
    final gasPrice = await client.getGasPrice();
    final price = gasPrice.getInWei;
    bool isL2 = ChainUtils.isL2(c);
    if (isCreation) {
      final BigInt roughGas = BigInt.from(300000);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    } else if (isDelete) {
      final BigInt roughGas = BigInt.from(100000);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    } else {
      final BigInt roughGas = BigInt.from(310000);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    }
  }

  static Future<void> fetchEscrowActivityProfile(
      {required Chain c,
      required Web3Client client,
      required String walletAddress,
      required void Function({
        required int paramContracts,
        required int paramCompletes,
        required int paramDeleteds,
        required int paramBidsMade,
        required int paramBidsReceived,
        required List<EscrowContract> paramEscrowContracts,
      }) initEscrowActivityProfile}) async {
    final alias = Aliases.getAlias(c);
    final escrowContract = alias.escrowContract(c, client);
    var profile = ChainUtils.ethAddressFromHex(c, walletAddress);
    var _contractsNum = await escrowContract
        .lookupEscrowProfileContractCount((profile: profile));
    var _paramContracts = _contractsNum.toInt();
    var _completesNum = await escrowContract
        .lookupEscrowProfileCompleteContracts((profile: profile));
    var _paramCompletes = _completesNum.toInt();
    var _deletedsNum = await escrowContract
        .lookupEscrowProfileDeletedContracts((profile: profile));
    var _paramDeleteds = _deletedsNum.toInt();
    var _bidsMade =
        await escrowContract.lookupEscrowProfileBidsMade((profile: profile));
    var _paramBidsMade = _bidsMade.toInt();
    var _bidsReceived = await escrowContract
        .lookupEscrowProfileBidsReceived((profile: profile));
    var _paramBidsReceived = _bidsReceived.toInt();
    var _tabContracts = await fetchTabContracts(
        c: c, client: client, walletAddress: walletAddress);
    var _paramEscrowContracts = [..._tabContracts];
    _paramEscrowContracts
        .sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    initEscrowActivityProfile(
      paramContracts: _paramContracts,
      paramCompletes: _paramCompletes,
      paramDeleteds: _paramDeleteds,
      paramBidsMade: _paramBidsMade,
      paramBidsReceived: _paramBidsReceived,
      paramEscrowContracts: _paramEscrowContracts,
    );
  }
}