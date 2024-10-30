// @dart=3.0
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_local_variable, unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"type":"constructor","inputs":[{"name":"_omnifyAddress","type":"address","internalType":"address"},{"name":"_paramWad","type":"uint256","internalType":"uint256"},{"name":"_paramNativeDecimals","type":"uint8","internalType":"uint8"},{"name":"_paramAltcoinFee","type":"uint256","internalType":"uint256"},{"name":"_paramTier1Fee","type":"uint256","internalType":"uint256"},{"name":"_paramtier2Fee","type":"uint256","internalType":"uint256"},{"name":"_paramTier3Fee","type":"uint256","internalType":"uint256"},{"name":"_paramTier4Fee","type":"uint256","internalType":"uint256"},{"name":"_paramTier1HigherThreshold","type":"uint256","internalType":"uint256"},{"name":"_paramTier2HigherThreshold","type":"uint256","internalType":"uint256"},{"name":"_paramTier3HigherThreshold","type":"uint256","internalType":"uint256"}],"stateMutability":"nonpayable"},{"type":"function","name":"altcoinFee","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"conductTransfers","inputs":[{"name":"_trz","type":"tuple[]","internalType":"struct Transfers.ParamTransfer[]","components":[{"name":"asset","type":"address","internalType":"address"},{"name":"amount","type":"uint256","internalType":"uint256"},{"name":"recipient","type":"address","internalType":"address payable"},{"name":"id","type":"string","internalType":"string"}]}],"outputs":[],"stateMutability":"payable"},{"type":"function","name":"feeKeeperAddress","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"getMinAmount","inputs":[{"name":"_decimals","type":"uint8","internalType":"uint8"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"pure"},{"type":"function","name":"lookupTransfer","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"tuple","internalType":"struct Transfers.Transfer","components":[{"name":"id","type":"string","internalType":"string"},{"name":"sender","type":"address","internalType":"address"},{"name":"recipient","type":"address","internalType":"address"},{"name":"assetAddress","type":"address","internalType":"address"},{"name":"amount","type":"uint256","internalType":"uint256"},{"name":"date","type":"uint256","internalType":"uint256"},{"name":"exists","type":"bool","internalType":"bool"}]}],"stateMutability":"view"},{"type":"function","name":"lookupTransferAssetFromProfile","inputs":[{"name":"_profile","type":"address","internalType":"address"},{"name":"_count","type":"uint256","internalType":"uint256"}],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"lookupTransferProfileAssetStats","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"tuple[]","internalType":"struct Transfers.AssetStat[]","components":[{"name":"sent","type":"uint256","internalType":"uint256"},{"name":"received","type":"uint256","internalType":"uint256"}]}],"stateMutability":"view"},{"type":"function","name":"lookupTransferProfileReceiveds","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupTransferProfileSents","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupTransferProfileTransfers","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"tuple[]","internalType":"struct Transfers.ProfileTransfer[]","components":[{"name":"id","type":"string","internalType":"string"}]}],"stateMutability":"view"},{"type":"function","name":"nativeCoinDecimals","inputs":[],"outputs":[{"name":"","type":"uint8","internalType":"uint8"}],"stateMutability":"view"},{"type":"function","name":"omnifyAddress","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"owner","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"renounceOwnership","inputs":[],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setAltcoinFee","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setAltcoinFeeByFeeKeeper","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setFeeKeeperAddress","inputs":[{"name":"_feeKeeper","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setOmnifyAddress","inputs":[{"name":"_newaddress","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setTier1","inputs":[{"name":"_lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"_higherThreshold","type":"uint256","internalType":"uint256"},{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setTier1ByFeeKeeper","inputs":[{"name":"_lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"_higherThreshold","type":"uint256","internalType":"uint256"},{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setTier2","inputs":[{"name":"_lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"_higherThreshold","type":"uint256","internalType":"uint256"},{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setTier2ByFeeKeeper","inputs":[{"name":"_lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"_higherThreshold","type":"uint256","internalType":"uint256"},{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setTier3","inputs":[{"name":"_lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"_higherThreshold","type":"uint256","internalType":"uint256"},{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setTier3ByFeeKeeper","inputs":[{"name":"_lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"_higherThreshold","type":"uint256","internalType":"uint256"},{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setTier4","inputs":[{"name":"_lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"_higherThreshold","type":"uint256","internalType":"uint256"},{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setTier4ByFeeKeeper","inputs":[{"name":"_lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"_higherThreshold","type":"uint256","internalType":"uint256"},{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"tier1","inputs":[],"outputs":[{"name":"lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"higherThreshold","type":"uint256","internalType":"uint256"},{"name":"fee","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"tier2","inputs":[],"outputs":[{"name":"lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"higherThreshold","type":"uint256","internalType":"uint256"},{"name":"fee","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"tier3","inputs":[],"outputs":[{"name":"lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"higherThreshold","type":"uint256","internalType":"uint256"},{"name":"fee","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"tier4","inputs":[],"outputs":[{"name":"lowerThreshold","type":"uint256","internalType":"uint256"},{"name":"higherThreshold","type":"uint256","internalType":"uint256"},{"name":"fee","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"totalAssetsTransferred","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"totalNumerOfTransfers","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"totalRecipientsUnique","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"totalSendersUnique","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"transferOwnership","inputs":[{"name":"newOwner","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"transferProfiles","inputs":[{"name":"","type":"address","internalType":"address"}],"outputs":[{"name":"transfersSent","type":"uint256","internalType":"uint256"},{"name":"transfersReceived","type":"uint256","internalType":"uint256"},{"name":"exists","type":"bool","internalType":"bool"},{"name":"transfersCount","type":"uint256","internalType":"uint256"},{"name":"assetCount","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"transfers","inputs":[{"name":"","type":"string","internalType":"string"}],"outputs":[{"name":"id","type":"string","internalType":"string"},{"name":"sender","type":"address","internalType":"address"},{"name":"recipient","type":"address","internalType":"address"},{"name":"assetAddress","type":"address","internalType":"address"},{"name":"amount","type":"uint256","internalType":"uint256"},{"name":"date","type":"uint256","internalType":"uint256"},{"name":"exists","type":"bool","internalType":"bool"}],"stateMutability":"view"},{"type":"event","name":"AssetsReceived","inputs":[{"name":"_id","type":"string","indexed":false,"internalType":"string"},{"name":"_sender","type":"address","indexed":false,"internalType":"address"},{"name":"_recipient","type":"address","indexed":false,"internalType":"address"},{"name":"_asset","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"event","name":"AssetsSent","inputs":[{"name":"_id","type":"string","indexed":false,"internalType":"string"},{"name":"_sender","type":"address","indexed":false,"internalType":"address"},{"name":"_recipient","type":"address","indexed":false,"internalType":"address"},{"name":"_asset","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"event","name":"OwnershipTransferred","inputs":[{"name":"previousOwner","type":"address","indexed":true,"internalType":"address"},{"name":"newOwner","type":"address","indexed":true,"internalType":"address"}],"anonymous":false},{"type":"event","name":"TransferComplete","inputs":[{"name":"_id","type":"string","indexed":false,"internalType":"string"},{"name":"_sender","type":"address","indexed":false,"internalType":"address"},{"name":"_recipient","type":"address","indexed":false,"internalType":"address"},{"name":"_asset","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"error","name":"OwnableInvalidOwner","inputs":[{"name":"owner","type":"address","internalType":"address"}]},{"type":"error","name":"OwnableUnauthorizedAccount","inputs":[{"name":"account","type":"address","internalType":"address"}]}]',
  'TransfersAbi',
);

class TransfersAbi extends _i1.GeneratedContract {
  TransfersAbi({
    required _i1.EthereumAddress address,
    required _i1.Web3Client client,
    int? chainId,
  }) : super(
          _i1.DeployedContract(
            _contractAbi,
            address,
          ),
          client,
          chainId,
        );

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> altcoinFee({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'c80cb746'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> conductTransfers(
    ({List<dynamic> trz}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'dcaeb1ec'));
    final params = [args.trz];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> feeKeeperAddress({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'de2231da'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getMinAmount(
    ({BigInt decimals}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '1906f343'));
    final params = [args.decimals];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> lookupTransfer(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '6552ecd0'));
    final params = [args.id];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as dynamic);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> lookupTransferAssetFromProfile(
    ({_i1.EthereumAddress profile, BigInt count}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, 'f36c28d0'));
    final params = [
      args.profile,
      args.count,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<dynamic>> lookupTransferProfileAssetStats(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '885ab539'));
    final params = [args.profile];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<dynamic>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> lookupTransferProfileReceiveds(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, 'b1227776'));
    final params = [args.profile];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> lookupTransferProfileSents(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, 'cb4599f2'));
    final params = [args.profile];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<dynamic>> lookupTransferProfileTransfers(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, '46e21b32'));
    final params = [args.profile];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<dynamic>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> nativeCoinDecimals({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, '6318ac64'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> omnifyAddress({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, '17b6dd42'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> owner({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[13];
    assert(checkSignature(function, '8da5cb5b'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> renounceOwnership({
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[14];
    assert(checkSignature(function, '715018a6'));
    final params = [];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setAltcoinFee(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[15];
    assert(checkSignature(function, 'b096d3f7'));
    final params = [args.fee];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setAltcoinFeeByFeeKeeper(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[16];
    assert(checkSignature(function, '60db2595'));
    final params = [args.fee];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setFeeKeeperAddress(
    ({_i1.EthereumAddress feeKeeper}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[17];
    assert(checkSignature(function, 'f4ed4c84'));
    final params = [args.feeKeeper];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setOmnifyAddress(
    ({_i1.EthereumAddress newaddress}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[18];
    assert(checkSignature(function, 'c342cac3'));
    final params = [args.newaddress];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setTier1(
    ({BigInt lowerThreshold, BigInt higherThreshold, BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[19];
    assert(checkSignature(function, '3d8219c0'));
    final params = [
      args.lowerThreshold,
      args.higherThreshold,
      args.fee,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setTier1ByFeeKeeper(
    ({BigInt lowerThreshold, BigInt higherThreshold, BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[20];
    assert(checkSignature(function, 'fd056ca9'));
    final params = [
      args.lowerThreshold,
      args.higherThreshold,
      args.fee,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setTier2(
    ({BigInt lowerThreshold, BigInt higherThreshold, BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[21];
    assert(checkSignature(function, '624d11fc'));
    final params = [
      args.lowerThreshold,
      args.higherThreshold,
      args.fee,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setTier2ByFeeKeeper(
    ({BigInt lowerThreshold, BigInt higherThreshold, BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[22];
    assert(checkSignature(function, '5db74a3c'));
    final params = [
      args.lowerThreshold,
      args.higherThreshold,
      args.fee,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setTier3(
    ({BigInt lowerThreshold, BigInt higherThreshold, BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[23];
    assert(checkSignature(function, '43412cc7'));
    final params = [
      args.lowerThreshold,
      args.higherThreshold,
      args.fee,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setTier3ByFeeKeeper(
    ({BigInt lowerThreshold, BigInt higherThreshold, BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[24];
    assert(checkSignature(function, 'e0224f1d'));
    final params = [
      args.lowerThreshold,
      args.higherThreshold,
      args.fee,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setTier4(
    ({BigInt lowerThreshold, BigInt higherThreshold, BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[25];
    assert(checkSignature(function, 'c1623c4b'));
    final params = [
      args.lowerThreshold,
      args.higherThreshold,
      args.fee,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setTier4ByFeeKeeper(
    ({BigInt lowerThreshold, BigInt higherThreshold, BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[26];
    assert(checkSignature(function, 'd6fc55d5'));
    final params = [
      args.lowerThreshold,
      args.higherThreshold,
      args.fee,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<Tier1> tier1({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[27];
    assert(checkSignature(function, 'bb6b13a1'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Tier1(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<Tier2> tier2({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[28];
    assert(checkSignature(function, '3806153e'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Tier2(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<Tier3> tier3({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[29];
    assert(checkSignature(function, '4b1740ad'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Tier3(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<Tier4> tier4({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[30];
    assert(checkSignature(function, '33ae7166'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Tier4(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> totalAssetsTransferred({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[31];
    assert(checkSignature(function, 'b5d8561d'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> totalNumerOfTransfers({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[32];
    assert(checkSignature(function, '9d57c891'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> totalRecipientsUnique({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[33];
    assert(checkSignature(function, 'be67fd0d'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> totalSendersUnique({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[34];
    assert(checkSignature(function, 'd09ec9e6'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> transferOwnership(
    ({_i1.EthereumAddress newOwner}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[35];
    assert(checkSignature(function, 'f2fde38b'));
    final params = [args.newOwner];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<TransferProfiles> transferProfiles(
    ({_i1.EthereumAddress $param38}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[36];
    assert(checkSignature(function, '75301403'));
    final params = [args.$param38];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return TransferProfiles(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<Transfers> transfers(
    ({String $param39}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[37];
    assert(checkSignature(function, '84a1c233'));
    final params = [args.$param39];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Transfers(response);
  }

  /// Returns a live stream of all AssetsReceived events emitted by this contract.
  Stream<AssetsReceived> assetsReceivedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('AssetsReceived');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return AssetsReceived(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all AssetsSent events emitted by this contract.
  Stream<AssetsSent> assetsSentEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('AssetsSent');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return AssetsSent(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all OwnershipTransferred events emitted by this contract.
  Stream<OwnershipTransferred> ownershipTransferredEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OwnershipTransferred');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return OwnershipTransferred(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all TransferComplete events emitted by this contract.
  Stream<TransferComplete> transferCompleteEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('TransferComplete');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return TransferComplete(
        decoded,
        result,
      );
    });
  }
}

class Tier1 {
  Tier1(List<dynamic> response)
      : lowerThreshold = (response[0] as BigInt),
        higherThreshold = (response[1] as BigInt),
        fee = (response[2] as BigInt);

  final BigInt lowerThreshold;

  final BigInt higherThreshold;

  final BigInt fee;
}

class Tier2 {
  Tier2(List<dynamic> response)
      : lowerThreshold = (response[0] as BigInt),
        higherThreshold = (response[1] as BigInt),
        fee = (response[2] as BigInt);

  final BigInt lowerThreshold;

  final BigInt higherThreshold;

  final BigInt fee;
}

class Tier3 {
  Tier3(List<dynamic> response)
      : lowerThreshold = (response[0] as BigInt),
        higherThreshold = (response[1] as BigInt),
        fee = (response[2] as BigInt);

  final BigInt lowerThreshold;

  final BigInt higherThreshold;

  final BigInt fee;
}

class Tier4 {
  Tier4(List<dynamic> response)
      : lowerThreshold = (response[0] as BigInt),
        higherThreshold = (response[1] as BigInt),
        fee = (response[2] as BigInt);

  final BigInt lowerThreshold;

  final BigInt higherThreshold;

  final BigInt fee;
}

class TransferProfiles {
  TransferProfiles(List<dynamic> response)
      : transfersSent = (response[0] as BigInt),
        transfersReceived = (response[1] as BigInt),
        exists = (response[2] as bool),
        transfersCount = (response[3] as BigInt),
        assetCount = (response[4] as BigInt);

  final BigInt transfersSent;

  final BigInt transfersReceived;

  final bool exists;

  final BigInt transfersCount;

  final BigInt assetCount;
}

class Transfers {
  Transfers(List<dynamic> response)
      : id = (response[0] as String),
        sender = (response[1] as _i1.EthereumAddress),
        recipient = (response[2] as _i1.EthereumAddress),
        assetAddress = (response[3] as _i1.EthereumAddress),
        amount = (response[4] as BigInt),
        date = (response[5] as BigInt),
        exists = (response[6] as bool);

  final String id;

  final _i1.EthereumAddress sender;

  final _i1.EthereumAddress recipient;

  final _i1.EthereumAddress assetAddress;

  final BigInt amount;

  final BigInt date;

  final bool exists;
}

class AssetsReceived {
  AssetsReceived(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as String),
        sender = (response[1] as _i1.EthereumAddress),
        recipient = (response[2] as _i1.EthereumAddress),
        asset = (response[3] as _i1.EthereumAddress),
        amount = (response[4] as BigInt),
        blockNumber = (response[5] as BigInt),
        date = (response[6] as BigInt);

  final String id;

  final _i1.EthereumAddress sender;

  final _i1.EthereumAddress recipient;

  final _i1.EthereumAddress asset;

  final BigInt amount;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}

class AssetsSent {
  AssetsSent(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as String),
        sender = (response[1] as _i1.EthereumAddress),
        recipient = (response[2] as _i1.EthereumAddress),
        asset = (response[3] as _i1.EthereumAddress),
        amount = (response[4] as BigInt),
        blockNumber = (response[5] as BigInt),
        date = (response[6] as BigInt);

  final String id;

  final _i1.EthereumAddress sender;

  final _i1.EthereumAddress recipient;

  final _i1.EthereumAddress asset;

  final BigInt amount;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}

class OwnershipTransferred {
  OwnershipTransferred(
    List<dynamic> response,
    this.event,
  )   : previousOwner = (response[0] as _i1.EthereumAddress),
        newOwner = (response[1] as _i1.EthereumAddress);

  final _i1.EthereumAddress previousOwner;

  final _i1.EthereumAddress newOwner;

  final _i1.FilterEvent event;
}

class TransferComplete {
  TransferComplete(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as String),
        sender = (response[1] as _i1.EthereumAddress),
        recipient = (response[2] as _i1.EthereumAddress),
        asset = (response[3] as _i1.EthereumAddress),
        amount = (response[4] as BigInt),
        blockNumber = (response[5] as BigInt),
        date = (response[6] as BigInt);

  final String id;

  final _i1.EthereumAddress sender;

  final _i1.EthereumAddress recipient;

  final _i1.EthereumAddress asset;

  final BigInt amount;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}
