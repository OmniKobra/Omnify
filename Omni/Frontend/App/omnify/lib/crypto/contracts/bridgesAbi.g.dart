// @dart=3.0
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_local_variable, unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"type":"constructor","inputs":[{"name":"_endpoint","type":"address","internalType":"address"},{"name":"_paramBridgeFee","type":"uint256","internalType":"uint256"},{"name":"_paramChainId","type":"uint32","internalType":"uint32"},{"name":"_paramOmnifyAddress","type":"address","internalType":"address"},{"name":"_paramWad","type":"uint256","internalType":"uint256"}],"stateMutability":"nonpayable"},{"type":"function","name":"GAS_LIMIT","inputs":[],"outputs":[{"name":"","type":"uint128","internalType":"uint128"}],"stateMutability":"view"},{"type":"function","name":"allowInitializePath","inputs":[{"name":"origin","type":"tuple","internalType":"struct Origin","components":[{"name":"srcEid","type":"uint32","internalType":"uint32"},{"name":"sender","type":"bytes32","internalType":"bytes32"},{"name":"nonce","type":"uint64","internalType":"uint64"}]}],"outputs":[{"name":"","type":"bool","internalType":"bool"}],"stateMutability":"view"},{"type":"function","name":"amountMigratedAssets","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"amountReceivedAssets","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"bridgeFee","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"bridgeProfiles","inputs":[{"name":"","type":"address","internalType":"address"}],"outputs":[{"name":"person","type":"address","internalType":"address"},{"name":"transactionCount","type":"uint256","internalType":"uint256"},{"name":"migratedAssetCount","type":"uint256","internalType":"uint256"},{"name":"receivedAssetCount","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"bridgeTransactions","inputs":[{"name":"","type":"uint256","internalType":"uint256"}],"outputs":[{"name":"asset","type":"address","internalType":"address"},{"name":"amount","type":"uint256","internalType":"uint256"},{"name":"sourceChain","type":"uint32","internalType":"uint32"},{"name":"destinationChain","type":"uint32","internalType":"uint32"},{"name":"sourceAddress","type":"address","internalType":"address"},{"name":"destinationAddress","type":"address","internalType":"address"},{"name":"date","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"bridgedTokenForeignEquivalent","inputs":[{"name":"","type":"address","internalType":"address"},{"name":"","type":"uint32","internalType":"uint32"}],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"changeOmnifyAddressOnBridgedCoin","inputs":[{"name":"_bridgedCoinAddress","type":"address","internalType":"address"},{"name":"_newAddress","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"compare","inputs":[{"name":"str1","type":"string","internalType":"string"},{"name":"str2","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"bool","internalType":"bool"}],"stateMutability":"pure"},{"type":"function","name":"composeMsgSender","inputs":[],"outputs":[{"name":"sender","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"createLzReceiveOption","inputs":[{"name":"_gas","type":"uint128","internalType":"uint128"},{"name":"_value","type":"uint128","internalType":"uint128"}],"outputs":[{"name":"","type":"bytes","internalType":"bytes"}],"stateMutability":"pure"},{"type":"function","name":"endpoint","inputs":[],"outputs":[{"name":"","type":"address","internalType":"contract ILayerZeroEndpointV2"}],"stateMutability":"view"},{"type":"function","name":"feeKeeperAddress","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"foreignTokenBridgedEquivalent","inputs":[{"name":"","type":"uint32","internalType":"uint32"},{"name":"","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"getMinAmount","inputs":[{"name":"_decimals","type":"uint8","internalType":"uint8"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"pure"},{"type":"function","name":"lookupBridgeProfileMigratedAssets","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"tuple[]","internalType":"struct Bridges.ProfileMigratedAsset[]","components":[{"name":"asset","type":"address","internalType":"address"},{"name":"amountMigrated","type":"uint256","internalType":"uint256"}]}],"stateMutability":"view"},{"type":"function","name":"lookupBridgeProfileReceivedAssets","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"tuple[]","internalType":"struct Bridges.ProfileReceivedAsset[]","components":[{"name":"asset","type":"address","internalType":"address"},{"name":"amountReceived","type":"uint256","internalType":"uint256"}]}],"stateMutability":"view"},{"type":"function","name":"lookupBridgeProfileTransactions","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256[]","internalType":"uint256[]"}],"stateMutability":"view"},{"type":"function","name":"lookupBridgeTransaction","inputs":[{"name":"_id","type":"uint256","internalType":"uint256"}],"outputs":[{"name":"","type":"tuple","internalType":"struct Bridges.BridgeTransaction","components":[{"name":"asset","type":"address","internalType":"address"},{"name":"amount","type":"uint256","internalType":"uint256"},{"name":"sourceChain","type":"uint32","internalType":"uint32"},{"name":"destinationChain","type":"uint32","internalType":"uint32"},{"name":"sourceAddress","type":"address","internalType":"address"},{"name":"destinationAddress","type":"address","internalType":"address"},{"name":"date","type":"uint256","internalType":"uint256"}]}],"stateMutability":"view"},{"type":"function","name":"lookupBridgedTokenForeignEquivalent","inputs":[{"name":"_asset","type":"address","internalType":"address"},{"name":"_sourceChain","type":"uint32","internalType":"uint32"}],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"lookupForeignTokenBridgedEquivalent","inputs":[{"name":"_asset","type":"address","internalType":"address"},{"name":"_sourceChain","type":"uint32","internalType":"uint32"}],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"lzReceive","inputs":[{"name":"_origin","type":"tuple","internalType":"struct Origin","components":[{"name":"srcEid","type":"uint32","internalType":"uint32"},{"name":"sender","type":"bytes32","internalType":"bytes32"},{"name":"nonce","type":"uint64","internalType":"uint64"}]},{"name":"_guid","type":"bytes32","internalType":"bytes32"},{"name":"_message","type":"bytes","internalType":"bytes"},{"name":"_executor","type":"address","internalType":"address"},{"name":"_extraData","type":"bytes","internalType":"bytes"}],"outputs":[],"stateMutability":"payable"},{"type":"function","name":"migrateAssets","inputs":[{"name":"_sourceAsset","type":"address","internalType":"address"},{"name":"_amount","type":"uint256","internalType":"uint256"},{"name":"_destinationChain","type":"uint32","internalType":"uint32"},{"name":"_recipient","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"payable"},{"type":"function","name":"nextNonce","inputs":[{"name":"","type":"uint32","internalType":"uint32"},{"name":"","type":"bytes32","internalType":"bytes32"}],"outputs":[{"name":"nonce","type":"uint64","internalType":"uint64"}],"stateMutability":"view"},{"type":"function","name":"numberMigrationTransactions","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"numberReceivedTransactions","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"oAppVersion","inputs":[],"outputs":[{"name":"senderVersion","type":"uint64","internalType":"uint64"},{"name":"receiverVersion","type":"uint64","internalType":"uint64"}],"stateMutability":"pure"},{"type":"function","name":"omnifyAddress","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"owner","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"peers","inputs":[{"name":"eid","type":"uint32","internalType":"uint32"}],"outputs":[{"name":"peer","type":"bytes32","internalType":"bytes32"}],"stateMutability":"view"},{"type":"function","name":"publicSetDelegate","inputs":[{"name":"_delegate","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"publicSetPeer","inputs":[{"name":"_eid","type":"uint32","internalType":"uint32"},{"name":"_peer","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"quote","inputs":[{"name":"_dstEid","type":"uint32","internalType":"uint32"},{"name":"_message","type":"string","internalType":"string"},{"name":"_options","type":"bytes","internalType":"bytes"},{"name":"_payInLzToken","type":"bool","internalType":"bool"}],"outputs":[{"name":"nativeFee","type":"uint256","internalType":"uint256"},{"name":"lzTokenFee","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"renounceOwnership","inputs":[],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setBridgeFee","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setBridgeFeeByFeeKeeper","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setFeeKeeperAddress","inputs":[{"name":"_feeKeeper","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setGasLimit","inputs":[{"name":"_limit","type":"uint128","internalType":"uint128"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setGasLimitByFeeKeeper","inputs":[{"name":"_limit","type":"uint128","internalType":"uint128"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setOmnifyAddress","inputs":[{"name":"_newaddress","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"stringToAddress","inputs":[{"name":"_address","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"pure"},{"type":"function","name":"thisChainEid","inputs":[],"outputs":[{"name":"","type":"uint32","internalType":"uint32"}],"stateMutability":"view"},{"type":"function","name":"transactionCount","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"transferOwnership","inputs":[{"name":"newOwner","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"event","name":"AssetsMigrated","inputs":[{"name":"_id","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_asset","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_sourceChain","type":"uint32","indexed":false,"internalType":"uint32"},{"name":"_sourceAddress","type":"address","indexed":false,"internalType":"address"},{"name":"_destinationChain","type":"uint32","indexed":false,"internalType":"uint32"},{"name":"_destinationAddress","type":"address","indexed":false,"internalType":"address"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"event","name":"AssetsReceived","inputs":[{"name":"_id","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_asset","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_sourceChain","type":"uint32","indexed":false,"internalType":"uint32"},{"name":"_sourceAddress","type":"address","indexed":false,"internalType":"address"},{"name":"_destinationChain","type":"uint32","indexed":false,"internalType":"uint32"},{"name":"_destinationAddress","type":"address","indexed":false,"internalType":"address"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"event","name":"NewBridgedTokenCreated","inputs":[{"name":"_sourceChainId","type":"uint32","indexed":false,"internalType":"uint32"},{"name":"_thisChainId","type":"uint32","indexed":false,"internalType":"uint32"},{"name":"_creator","type":"address","indexed":false,"internalType":"address"},{"name":"_bridgedAssetAddress","type":"address","indexed":false,"internalType":"address"},{"name":"_bridgedAssetName","type":"string","indexed":false,"internalType":"string"},{"name":"_bridgedAssetSymbol","type":"string","indexed":false,"internalType":"string"},{"name":"_sourceAssetAddress","type":"address","indexed":false,"internalType":"address"},{"name":"_sourceAssetName","type":"string","indexed":false,"internalType":"string"},{"name":"_sourceAssetSymbol","type":"string","indexed":false,"internalType":"string"}],"anonymous":false},{"type":"event","name":"OwnershipTransferred","inputs":[{"name":"previousOwner","type":"address","indexed":true,"internalType":"address"},{"name":"newOwner","type":"address","indexed":true,"internalType":"address"}],"anonymous":false},{"type":"event","name":"PeerSet","inputs":[{"name":"eid","type":"uint32","indexed":false,"internalType":"uint32"},{"name":"peer","type":"bytes32","indexed":false,"internalType":"bytes32"}],"anonymous":false},{"type":"error","name":"AddressEmptyCode","inputs":[{"name":"target","type":"address","internalType":"address"}]},{"type":"error","name":"AddressInsufficientBalance","inputs":[{"name":"account","type":"address","internalType":"address"}]},{"type":"error","name":"FailedInnerCall","inputs":[]},{"type":"error","name":"InvalidDelegate","inputs":[]},{"type":"error","name":"InvalidEndpointCall","inputs":[]},{"type":"error","name":"InvalidOptionType","inputs":[{"name":"optionType","type":"uint16","internalType":"uint16"}]},{"type":"error","name":"LzTokenUnavailable","inputs":[]},{"type":"error","name":"NoPeer","inputs":[{"name":"eid","type":"uint32","internalType":"uint32"}]},{"type":"error","name":"NotEnoughNative","inputs":[{"name":"msgValue","type":"uint256","internalType":"uint256"}]},{"type":"error","name":"OnlyEndpoint","inputs":[{"name":"addr","type":"address","internalType":"address"}]},{"type":"error","name":"OnlyPeer","inputs":[{"name":"eid","type":"uint32","internalType":"uint32"},{"name":"sender","type":"bytes32","internalType":"bytes32"}]},{"type":"error","name":"OwnableInvalidOwner","inputs":[{"name":"owner","type":"address","internalType":"address"}]},{"type":"error","name":"OwnableUnauthorizedAccount","inputs":[{"name":"account","type":"address","internalType":"address"}]},{"type":"error","name":"SafeCastOverflowedUintDowncast","inputs":[{"name":"bits","type":"uint8","internalType":"uint8"},{"name":"value","type":"uint256","internalType":"uint256"}]},{"type":"error","name":"SafeERC20FailedOperation","inputs":[{"name":"token","type":"address","internalType":"address"}]},{"type":"error","name":"StringsInsufficientHexLength","inputs":[{"name":"value","type":"uint256","internalType":"uint256"},{"name":"length","type":"uint256","internalType":"uint256"}]}]',
  'BridgesAbi',
);

class BridgesAbi extends _i1.GeneratedContract {
  BridgesAbi({
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
  Future<BigInt> GAS_LIMIT({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '091d2788'));
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
  Future<bool> allowInitializePath(
    ({dynamic origin}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'ff7bd03d'));
    final params = [args.origin];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> amountMigratedAssets({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '9c234851'));
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
  Future<BigInt> amountReceivedAssets({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '6e2313cf'));
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
  Future<BigInt> bridgeFee({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '82b12dd7'));
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
  Future<BridgeProfiles> bridgeProfiles(
    ({_i1.EthereumAddress $param1}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '5f82a514'));
    final params = [args.$param1];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return BridgeProfiles(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BridgeTransactions> bridgeTransactions(
    ({BigInt $param2}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, 'f73cf99c'));
    final params = [args.$param2];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return BridgeTransactions(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> bridgedTokenForeignEquivalent(
    ({_i1.EthereumAddress $param3, BigInt $param4}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, 'e9a270c8'));
    final params = [
      args.$param3,
      args.$param4,
    ];
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
  Future<String> changeOmnifyAddressOnBridgedCoin(
    ({
      _i1.EthereumAddress bridgedCoinAddress,
      _i1.EthereumAddress newAddress
    }) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, '735ea4e7'));
    final params = [
      args.bridgedCoinAddress,
      args.newAddress,
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
  Future<bool> compare(
    ({String str1, String str2}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, '3a96fdd7'));
    final params = [
      args.str1,
      args.str2,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> composeMsgSender({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, 'b92d0eff'));
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
  Future<_i2.Uint8List> createLzReceiveOption(
    ({BigInt gas, BigInt value}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, 'c72242b2'));
    final params = [
      args.gas,
      args.value,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> endpoint({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[13];
    assert(checkSignature(function, '5e280f11'));
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
  Future<_i1.EthereumAddress> feeKeeperAddress({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[14];
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
  Future<_i1.EthereumAddress> foreignTokenBridgedEquivalent(
    ({BigInt $param11, _i1.EthereumAddress $param12}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[15];
    assert(checkSignature(function, '32bff022'));
    final params = [
      args.$param11,
      args.$param12,
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
  Future<BigInt> getMinAmount(
    ({BigInt decimals}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[16];
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
  Future<List<dynamic>> lookupBridgeProfileMigratedAssets(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[17];
    assert(checkSignature(function, '8b907f06'));
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
  Future<List<dynamic>> lookupBridgeProfileReceivedAssets(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[18];
    assert(checkSignature(function, 'cd5bb419'));
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
  Future<List<BigInt>> lookupBridgeProfileTransactions(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[19];
    assert(checkSignature(function, 'd3fc6e11'));
    final params = [args.profile];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<BigInt>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> lookupBridgeTransaction(
    ({BigInt id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[20];
    assert(checkSignature(function, 'eaa3f182'));
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
  Future<_i1.EthereumAddress> lookupBridgedTokenForeignEquivalent(
    ({_i1.EthereumAddress asset, BigInt sourceChain}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[21];
    assert(checkSignature(function, 'b6698fc2'));
    final params = [
      args.asset,
      args.sourceChain,
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
  Future<_i1.EthereumAddress> lookupForeignTokenBridgedEquivalent(
    ({_i1.EthereumAddress asset, BigInt sourceChain}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[22];
    assert(checkSignature(function, '592c08bf'));
    final params = [
      args.asset,
      args.sourceChain,
    ];
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
  Future<String> lzReceive(
    ({
      dynamic origin,
      _i2.Uint8List guid,
      _i2.Uint8List message,
      _i1.EthereumAddress executor,
      _i2.Uint8List extraData
    }) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[23];
    assert(checkSignature(function, '13137d65'));
    final params = [
      args.origin,
      args.guid,
      args.message,
      args.executor,
      args.extraData,
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
  Future<String> migrateAssets(
    ({
      _i1.EthereumAddress sourceAsset,
      BigInt amount,
      BigInt destinationChain,
      _i1.EthereumAddress recipient
    }) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[24];
    assert(checkSignature(function, '903ff6aa'));
    final params = [
      args.sourceAsset,
      args.amount,
      args.destinationChain,
      args.recipient,
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
  Future<BigInt> nextNonce(
    ({BigInt $param31, _i2.Uint8List $param32}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[25];
    assert(checkSignature(function, '7d25a05e'));
    final params = [
      args.$param31,
      args.$param32,
    ];
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
  Future<BigInt> numberMigrationTransactions({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[26];
    assert(checkSignature(function, '65377ee5'));
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
  Future<BigInt> numberReceivedTransactions({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[27];
    assert(checkSignature(function, '7d20941c'));
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
  Future<OAppVersion> oAppVersion({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[28];
    assert(checkSignature(function, '17442b70'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return OAppVersion(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> omnifyAddress({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[29];
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
    final function = self.abi.functions[30];
    assert(checkSignature(function, '8da5cb5b'));
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
  Future<_i2.Uint8List> peers(
    ({BigInt eid}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[31];
    assert(checkSignature(function, 'bb0b6a53'));
    final params = [args.eid];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> publicSetDelegate(
    ({_i1.EthereumAddress delegate}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[32];
    assert(checkSignature(function, '75b0984e'));
    final params = [args.delegate];
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
  Future<String> publicSetPeer(
    ({BigInt eid, _i1.EthereumAddress peer}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[33];
    assert(checkSignature(function, 'ffbfa81c'));
    final params = [
      args.eid,
      args.peer,
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
  Future<Quote> quote(
    ({
      BigInt dstEid,
      String message,
      _i2.Uint8List options,
      bool payInLzToken
    }) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[34];
    assert(checkSignature(function, 'f77e5dd3'));
    final params = [
      args.dstEid,
      args.message,
      args.options,
      args.payInLzToken,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Quote(response);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> renounceOwnership({
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[35];
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
  Future<String> setBridgeFee(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[36];
    assert(checkSignature(function, '998cdf83'));
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
  Future<String> setBridgeFeeByFeeKeeper(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[37];
    assert(checkSignature(function, 'ee213869'));
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
    final function = self.abi.functions[38];
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
  Future<String> setGasLimit(
    ({BigInt limit}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[39];
    assert(checkSignature(function, 'a1da9dae'));
    final params = [args.limit];
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
  Future<String> setGasLimitByFeeKeeper(
    ({BigInt limit}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[40];
    assert(checkSignature(function, '0180a023'));
    final params = [args.limit];
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
    final function = self.abi.functions[41];
    assert(checkSignature(function, 'c342cac3'));
    final params = [args.newaddress];
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
  Future<_i1.EthereumAddress> stringToAddress(
    ({String address}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[42];
    assert(checkSignature(function, '15706fdf'));
    final params = [args.address];
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
  Future<BigInt> thisChainEid({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[43];
    assert(checkSignature(function, '64dd2730'));
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
  Future<BigInt> transactionCount({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[44];
    assert(checkSignature(function, 'b77bf600'));
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
    final function = self.abi.functions[45];
    assert(checkSignature(function, 'f2fde38b'));
    final params = [args.newOwner];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// Returns a live stream of all AssetsMigrated events emitted by this contract.
  Stream<AssetsMigrated> assetsMigratedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('AssetsMigrated');
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
      return AssetsMigrated(
        decoded,
        result,
      );
    });
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

  /// Returns a live stream of all NewBridgedTokenCreated events emitted by this contract.
  Stream<NewBridgedTokenCreated> newBridgedTokenCreatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('NewBridgedTokenCreated');
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
      return NewBridgedTokenCreated(
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

  /// Returns a live stream of all PeerSet events emitted by this contract.
  Stream<PeerSet> peerSetEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('PeerSet');
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
      return PeerSet(
        decoded,
        result,
      );
    });
  }
}

class BridgeProfiles {
  BridgeProfiles(List<dynamic> response)
      : person = (response[0] as _i1.EthereumAddress),
        transactionCount = (response[1] as BigInt),
        migratedAssetCount = (response[2] as BigInt),
        receivedAssetCount = (response[3] as BigInt);

  final _i1.EthereumAddress person;

  final BigInt transactionCount;

  final BigInt migratedAssetCount;

  final BigInt receivedAssetCount;
}

class BridgeTransactions {
  BridgeTransactions(List<dynamic> response)
      : asset = (response[0] as _i1.EthereumAddress),
        amount = (response[1] as BigInt),
        sourceChain = (response[2] as BigInt),
        destinationChain = (response[3] as BigInt),
        sourceAddress = (response[4] as _i1.EthereumAddress),
        destinationAddress = (response[5] as _i1.EthereumAddress),
        date = (response[6] as BigInt);

  final _i1.EthereumAddress asset;

  final BigInt amount;

  final BigInt sourceChain;

  final BigInt destinationChain;

  final _i1.EthereumAddress sourceAddress;

  final _i1.EthereumAddress destinationAddress;

  final BigInt date;
}

class OAppVersion {
  OAppVersion(List<dynamic> response)
      : senderVersion = (response[0] as BigInt),
        receiverVersion = (response[1] as BigInt);

  final BigInt senderVersion;

  final BigInt receiverVersion;
}

class Quote {
  Quote(List<dynamic> response)
      : nativeFee = (response[0] as BigInt),
        lzTokenFee = (response[1] as BigInt);

  final BigInt nativeFee;

  final BigInt lzTokenFee;
}

class AssetsMigrated {
  AssetsMigrated(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as BigInt),
        asset = (response[1] as _i1.EthereumAddress),
        amount = (response[2] as BigInt),
        sourceChain = (response[3] as BigInt),
        sourceAddress = (response[4] as _i1.EthereumAddress),
        destinationChain = (response[5] as BigInt),
        destinationAddress = (response[6] as _i1.EthereumAddress),
        blockNumber = (response[7] as BigInt),
        date = (response[8] as BigInt);

  final BigInt id;

  final _i1.EthereumAddress asset;

  final BigInt amount;

  final BigInt sourceChain;

  final _i1.EthereumAddress sourceAddress;

  final BigInt destinationChain;

  final _i1.EthereumAddress destinationAddress;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}

class AssetsReceived {
  AssetsReceived(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as BigInt),
        asset = (response[1] as _i1.EthereumAddress),
        amount = (response[2] as BigInt),
        sourceChain = (response[3] as BigInt),
        sourceAddress = (response[4] as _i1.EthereumAddress),
        destinationChain = (response[5] as BigInt),
        destinationAddress = (response[6] as _i1.EthereumAddress),
        blockNumber = (response[7] as BigInt),
        date = (response[8] as BigInt);

  final BigInt id;

  final _i1.EthereumAddress asset;

  final BigInt amount;

  final BigInt sourceChain;

  final _i1.EthereumAddress sourceAddress;

  final BigInt destinationChain;

  final _i1.EthereumAddress destinationAddress;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}

class NewBridgedTokenCreated {
  NewBridgedTokenCreated(
    List<dynamic> response,
    this.event,
  )   : sourceChainId = (response[0] as BigInt),
        thisChainId = (response[1] as BigInt),
        creator = (response[2] as _i1.EthereumAddress),
        bridgedAssetAddress = (response[3] as _i1.EthereumAddress),
        bridgedAssetName = (response[4] as String),
        bridgedAssetSymbol = (response[5] as String),
        sourceAssetAddress = (response[6] as _i1.EthereumAddress),
        sourceAssetName = (response[7] as String),
        sourceAssetSymbol = (response[8] as String);

  final BigInt sourceChainId;

  final BigInt thisChainId;

  final _i1.EthereumAddress creator;

  final _i1.EthereumAddress bridgedAssetAddress;

  final String bridgedAssetName;

  final String bridgedAssetSymbol;

  final _i1.EthereumAddress sourceAssetAddress;

  final String sourceAssetName;

  final String sourceAssetSymbol;

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

class PeerSet {
  PeerSet(
    List<dynamic> response,
    this.event,
  )   : eid = (response[0] as BigInt),
        peer = (response[1] as _i2.Uint8List);

  final BigInt eid;

  final _i2.Uint8List peer;

  final _i1.FilterEvent event;
}
