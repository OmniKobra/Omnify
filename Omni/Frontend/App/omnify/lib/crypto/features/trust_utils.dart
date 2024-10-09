import 'package:decimal/decimal.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../models/asset.dart';
import '../../models/beneficiary.dart';
import '../../models/deposit.dart';
import '../../utils.dart';
import '../../models/bridge_asset.dart';
import '../utils/aliases.dart';
import '../utils/chain_utils.dart';

class TrustUtils {
  //  string memory _id,
  //  uint256 _amount,
  //  address _asset,
  //  bool _depositType,
  //  bool _liquidity,
  //  bool _isActive,
  //  Owner[] calldata _owners,
  //  Beneficiary[] calldata _beneficiaries

  static Future<String?> createDeposit({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String id,
    required Decimal amount,
    required CryptoAsset asset,
    required bool isModifiable,
    required bool isRetractable,
    required bool isActive,
    required List<String> owners,
    required List<Beneficiary> beneficiaries,
    required String walletAddress,
    required Decimal omnifyFee,
  }) async {
    final alias = Aliases.getAlias(c);
    final trustContract = alias.trustContract(c, client);
    EthereumAddress customer = ChainUtils.ethAddressFromHex(c, walletAddress);
    final BigInt _omnifyFee = ChainUtils.nativeDecimalToUint(c, omnifyFee);
    List<dynamic> _owners = [];
    List<dynamic> _beneficiaries = [];
    final _amount = ChainUtils.decimalToUint(c, asset, amount);
    final _asset = ChainUtils.ethAddressFromHex(c, asset.address);
    BigInt totalMsgValue = BigInt.from(0);
    totalMsgValue += _omnifyFee;
    if (asset.address == Utils.zeroAddress) {
      totalMsgValue += _amount;
    }
    for (var o in owners) {
      _owners.add([ChainUtils.ethAddressFromHex(c, o), true]);
    }
    for (var b in beneficiaries) {
      _beneficiaries.add([
        ChainUtils.ethAddressFromHex(c, b.address),
        ChainUtils.decimalToUint(c, asset, b.allowancePerDay),
        b.isLimited,
        BigInt.from(0)
      ]);
    }
    try {
      final transaction = Transaction.callContract(
          contract: trustContract.self,
          function: trustContract.self.function('createDeposit'),
          from: customer,
          value: EtherAmount.inWei(totalMsgValue),
          parameters: [
            id,
            _amount,
            _asset,
            isModifiable,
            isRetractable,
            isActive,
            _owners,
            _beneficiaries,
          ]);
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

  static Future<String?> retractDeposit({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String id,
    required String walletAddress,
  }) async {
    final alias = Aliases.getAlias(c);
    final trustContract = alias.trustContract(c, client);
    EthereumAddress customer = ChainUtils.ethAddressFromHex(c, walletAddress);
    final transaction = Transaction.callContract(
        contract: trustContract.self,
        function: trustContract.self.function('retractDeposit'),
        from: customer,
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

  static Future<String?> withdrawFromDeposit({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String id,
    required String walletAddress,
    required CryptoAsset asset,
    required Decimal amount,
  }) async {
    final alias = Aliases.getAlias(c);
    final trustContract = alias.trustContract(c, client);
    EthereumAddress customer = ChainUtils.ethAddressFromHex(c, walletAddress);
    final _amount = ChainUtils.decimalToUint(c, asset, amount);
    final transaction = Transaction.callContract(
        contract: trustContract.self,
        function: trustContract.self.function('withdrawFromDeposit'),
        from: customer,
        value: EtherAmount.inWei(BigInt.from(0)),
        parameters: [id, _amount]);
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

  static Future<String?> depositIntoExisting({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String id,
    required CryptoAsset asset,
    required Decimal omnifyFee,
    required Decimal amount,
    required String walletAddress,
  }) async {
    final alias = Aliases.getAlias(c);
    final trustContract = alias.trustContract(c, client);
    EthereumAddress customer = ChainUtils.ethAddressFromHex(c, walletAddress);
    final BigInt _omnifyFee = ChainUtils.nativeDecimalToUint(c, omnifyFee);
    final _amount = ChainUtils.decimalToUint(c, asset, amount);
    final _asset = ChainUtils.ethAddressFromHex(c, asset.address);
    BigInt totalMsgValue = BigInt.from(0);
    totalMsgValue += _omnifyFee;
    if (asset.address == Utils.zeroAddress) {
      totalMsgValue += _amount;
    }
    final transaction = Transaction.callContract(
        contract: trustContract.self,
        function: trustContract.self.function('depositIntoExistingDeposit'),
        from: customer,
        value: EtherAmount.inWei(totalMsgValue),
        parameters: [id, _asset, _amount]);
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

  static Future<String?> modifyDeposit({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String id,
    required bool isJustActivation,
    required bool newActive,
    required Decimal omnifyFee,
    required String walletAddress,
    required CryptoAsset asset,
    required List<Beneficiary> benefs,
  }) async {
    final alias = Aliases.getAlias(c);
    final trustContract = alias.trustContract(c, client);
    EthereumAddress customer = ChainUtils.ethAddressFromHex(c, walletAddress);
    if (isJustActivation) {
      final transaction = Transaction.callContract(
          contract: trustContract.self,
          function: trustContract.self.function('setDepositActiveVal'),
          from: customer,
          value: EtherAmount.inWei(BigInt.from(0)),
          parameters: [
            id,
            newActive,
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
    } else {
      List<dynamic> _benefs = [];
      for (var b in benefs) {
        _benefs.add([
          ChainUtils.ethAddressFromHex(c, b.address),
          ChainUtils.decimalToUint(c, asset, b.allowancePerDay),
          b.isLimited,
          BigInt.from(0)
        ]);
      }
      BigInt msgValue = ChainUtils.nativeDecimalToUint(c, omnifyFee);
      final transaction = Transaction.callContract(
          contract: trustContract.self,
          function: trustContract.self.function('modifyDeposit'),
          from: customer,
          value: EtherAmount.inWei(msgValue),
          parameters: [
            id,
            newActive,
            _benefs,
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
  }

  static Future<Decimal> quoteGas({
    required Chain c,
    required Web3Client client,
    required bool isCreation,
    required int benefLength,
    required int ownerLength,
    required bool isModification,
  }) async {
    final gasPrice = await client.getGasPrice();
    final price = gasPrice.getInWei;
    bool isL2 = ChainUtils.isL2(c);
    if (isCreation) {
      final int totalBenefs = benefLength * 145000;
      final int totalOwners = ownerLength * 100000;
      final totalGas = 350000 + totalBenefs + totalOwners;
      final BigInt roughGas = BigInt.from(totalGas);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    } else if (isModification) {
      final int totalBenefs = benefLength * 145000;
      final totalGas = totalBenefs + 5000;
      final BigInt roughGas = BigInt.from(totalGas);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    } else {
      final BigInt roughGas = BigInt.from(30000);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    }
  }

  static Future<Deposit?> fetchDeposit({
    required Chain c,
    required Web3Client client,
    required String id,
  }) async {
    final alias = Aliases.getAlias(c);
    final trustContract = alias.trustContract(c, client);
    final exists = await trustContract.lookupDepositExists((id: id));
    if (exists) {
      var _asset = await trustContract.lookupDepositAsset((id: id));
      var asset = await ChainUtils.getCoinFromAddress(
          c, ChainUtils.hexFromEthAddress(c, _asset), client);
      var _amountInitial =
          await trustContract.lookupDepositInitialAmount((id: id));
      var _amountRemaining =
          await trustContract.lookupDepositRemainingAmount((id: id));
      var _isModifiable = await trustContract.lookupDepositType((id: id));
      var _isRetractable = await trustContract.lookupDepositLiquidity((id: id));
      var _isActive = await trustContract.lookupDepositActivity((id: id));
      var _dateCreated = await trustContract.lookupDepositDateCreated((id: id));
      var _owners = await trustContract.lookupDepositOwners((id: id));
      List<String> owners = [];
      for (var o in _owners) {
        var _address = ChainUtils.hexFromEthAddress(c, o[0]);
        var _isOwner = o[1];
        if (_isOwner && !owners.contains(_address)) {
          owners.add(_address);
        }
      }
      var _beneficiaries =
          await trustContract.lookupDepositBeneficiaries((id: id));
      List<Beneficiary> beneficiaries = [];
      for (var b in _beneficiaries) {
        var _address = ChainUtils.hexFromEthAddress(c, b[0]);
        var _allowance = ChainUtils.uintToDecimal(c, asset!, b[1]);
        var _isLimited = b[2];
        var _dateLastWithdrawal = await trustContract
            .lookupDepositBenefDateLastWithdrawal((b: b[0], id: id));
        var _lastWithdrawal = ChainUtils.chainDateToDt(_dateLastWithdrawal);
        if (!beneficiaries.any((be) => be.address == _address)) {
          Beneficiary benef = Beneficiary(
              address: _address,
              allowancePerDay: _allowance,
              isLimited: _isLimited,
              dateLastWithdrawal: _lastWithdrawal);
          beneficiaries.add(benef);
        }
      }
      final d = Deposit(
          chain: c,
          id: id,
          asset: asset!,
          amountInitial: ChainUtils.uintToDecimal(c, asset, _amountInitial),
          amountRemaining: ChainUtils.uintToDecimal(c, asset, _amountRemaining),
          isFixed: !_isModifiable,
          isRetractable: _isRetractable,
          isActive: _isActive,
          beneficiaries: beneficiaries,
          dateCreated: ChainUtils.chainDateToDt(_dateCreated),
          owners: owners);
      return d;
    } else {
      return null;
    }
  }

// struct TrustAssetProfile {
//         address asset;
//         uint256 amountWithdrawn;
//     }
  static Future<void> fetchTrustProfile(
      {required Chain c,
      required Web3Client client,
      required String walletAddress,
      required void Function({
        required List<BridgeAsset> paramWithdrawnAssets,
        required List<BridgeAsset> paramAvailableAssets,
        required List<Deposit> paramDeposits,
      }) initTrustProfile}) async {
    final alias = Aliases.getAlias(c);
    final trustContract = alias.trustContract(c, client);
    var assetsWithdrawn = await trustContract.lookupTrustProfileAssets(
        (profile: ChainUtils.ethAddressFromHex(c, walletAddress)));
    var profileDeposits = await trustContract.lookupTrustProfileDeposits(
        (profile: ChainUtils.ethAddressFromHex(c, walletAddress)));
    List<BridgeAsset> bufferAssetsWithdrawn = [];
    List<BridgeAsset> bufferAssetsAvailable = [];
    List<Deposit> profileDepositsIsOwner = [];
    List<Deposit> profileDepositsIsBenef = [];
    for (var asset in assetsWithdrawn) {
      var address = ChainUtils.hexFromEthAddress(c, asset[0]);
      var cryptoAsset = await ChainUtils.getCoinFromAddress(c, address, client);
      var ca = cryptoAsset ?? Utils.generateNativeToken(c);
      var _amountWithdrawn = ChainUtils.uintToDecimal(c, ca, asset[1]);
      if (bufferAssetsWithdrawn.any((ass) => ass.address == address)) {
        var ba =
            bufferAssetsWithdrawn.firstWhere((ass) => ass.address == address);
        var index = bufferAssetsWithdrawn.indexOf(ba);
        var amount = _amountWithdrawn + ba.amount;
        bufferAssetsWithdrawn[index] = BridgeAsset(
            address, "\$${ca.symbol}", amount, ca.logoUrl, ca.decimals);
      } else {
        bufferAssetsWithdrawn.add(BridgeAsset(address, "\$${ca.symbol}",
            _amountWithdrawn, ca.logoUrl, ca.decimals));
      }
    }
    for (var d in profileDeposits) {
      var id = d[0];
      var isOwner = d[1];
      Deposit? dep = await fetchDeposit(c: c, client: client, id: id);
      if (dep != null) {
        if (isOwner) {
          if (!profileDepositsIsOwner.any((de) => de.id == id) &&
              !profileDepositsIsBenef.any((de) => de.id == id)) {
            profileDepositsIsOwner.add(dep);
          }
        } else {
          if (!profileDepositsIsBenef.any((de) => de.id == id) &&
              !profileDepositsIsOwner.any((de) => de.id == id)) {
            profileDepositsIsBenef.add(dep);
          }
        }
      }
    }
    for (var po in profileDepositsIsOwner) {
      if (po.amountRemaining > Decimal.parse("0.0") && po.isRetractable) {
        if (bufferAssetsAvailable
            .any((ass) => ass.address == po.asset.address)) {
          var ba = bufferAssetsAvailable
              .firstWhere((ass) => ass.address == po.asset.address);
          var index = bufferAssetsAvailable.indexOf(ba);
          var amount = po.amountRemaining + ba.amount;
          bufferAssetsAvailable[index] = BridgeAsset(
              po.asset.address,
              "\$${po.asset.symbol}",
              amount,
              po.asset.logoUrl,
              po.asset.decimals);
        } else {
          bufferAssetsAvailable.add(BridgeAsset(
              po.asset.address,
              "\$${po.asset.symbol}",
              po.amountRemaining,
              po.asset.logoUrl,
              po.asset.decimals));
        }
      }
    }
    for (var po in profileDepositsIsBenef) {
      if (po.beneficiaries.any((ben) => ben.address == walletAddress)) {
        var now = DateTime.now();
        var myBenef =
            po.beneficiaries.firstWhere((ben) => ben.address == walletAddress);
        var lastWithdrawal = myBenef.dateLastWithdrawal;
        var allowed = lastWithdrawal.add(const Duration(minutes: 1440));
        var canWithdraw = now.isAfter(allowed);
        if (po.amountRemaining > Decimal.parse("0.0") && po.isActive) {
          if (!myBenef.isLimited) {
            if (bufferAssetsAvailable
                .any((ass) => ass.address == po.asset.address)) {
              var ba = bufferAssetsAvailable
                  .firstWhere((ass) => ass.address == po.asset.address);
              var index = bufferAssetsAvailable.indexOf(ba);
              var amount = po.amountRemaining + ba.amount;
              bufferAssetsAvailable[index] = BridgeAsset(
                  po.asset.address,
                  "\$${po.asset.symbol}",
                  amount,
                  po.asset.logoUrl,
                  po.asset.decimals);
            } else {
              bufferAssetsAvailable.add(BridgeAsset(
                  po.asset.address,
                  "\$${po.asset.symbol}",
                  po.amountRemaining,
                  po.asset.logoUrl,
                  po.asset.decimals));
            }
          }
          if (myBenef.isLimited && canWithdraw) {
            if (bufferAssetsAvailable
                .any((ass) => ass.address == po.asset.address)) {
              var ba = bufferAssetsAvailable
                  .firstWhere((ass) => ass.address == po.asset.address);
              var index = bufferAssetsAvailable.indexOf(ba);
              var amount = myBenef.allowancePerDay + ba.amount;
              bufferAssetsAvailable[index] = BridgeAsset(
                  po.asset.address,
                  "\$${po.asset.symbol}",
                  amount,
                  po.asset.logoUrl,
                  po.asset.decimals);
            } else {
              bufferAssetsAvailable.add(BridgeAsset(
                  po.asset.address,
                  "\$${po.asset.symbol}",
                  myBenef.allowancePerDay,
                  po.asset.logoUrl,
                  po.asset.decimals));
            }
          }
        }
      }
    }
    profileDepositsIsOwner
        .sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    profileDepositsIsBenef
        .sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    var spreadList = [...profileDepositsIsOwner, ...profileDepositsIsBenef];
    spreadList.sort((a, b) => b.amountRemaining.compareTo(a.amountRemaining));
    initTrustProfile(
        paramDeposits: spreadList,
        paramWithdrawnAssets: bufferAssetsWithdrawn,
        paramAvailableAssets: bufferAssetsAvailable);
  }
}
// 0x06c90B3D5D75372a2b99f2aCDcBebc728BB03e9F