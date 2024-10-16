// @dart=3.0
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_local_variable, unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"type":"constructor","inputs":[{"name":"_paramOmnifyAddress","type":"address","internalType":"address"},{"name":"_paramWad","type":"uint256","internalType":"uint256"},{"name":"_paramNativeDecimals","type":"uint8","internalType":"uint8"},{"name":"_paramDepositFee","type":"uint256","internalType":"uint256"},{"name":"_paramBenefFee","type":"uint256","internalType":"uint256"}],"stateMutability":"nonpayable"},{"type":"function","name":"amountAssetsDeposited","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"amountAssetsWithdrawn","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"beneficiaryFee","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"createDeposit","inputs":[{"name":"_id","type":"string","internalType":"string"},{"name":"_amount","type":"uint256","internalType":"uint256"},{"name":"_asset","type":"address","internalType":"address"},{"name":"_depositType","type":"bool","internalType":"bool"},{"name":"_liquidity","type":"bool","internalType":"bool"},{"name":"_isActive","type":"bool","internalType":"bool"},{"name":"_owners","type":"tuple[]","internalType":"struct Trust.Owner[]","components":[{"name":"owner","type":"address","internalType":"address"},{"name":"isOwner","type":"bool","internalType":"bool"}]},{"name":"_beneficiaries","type":"tuple[]","internalType":"struct Trust.Beneficiary[]","components":[{"name":"benef","type":"address","internalType":"address"},{"name":"allowance","type":"uint256","internalType":"uint256"},{"name":"isLimited","type":"bool","internalType":"bool"},{"name":"dateLastWithdrawal","type":"uint256","internalType":"uint256"}]}],"outputs":[],"stateMutability":"payable"},{"type":"function","name":"depositFee","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"depositIntoExistingDeposit","inputs":[{"name":"_id","type":"string","internalType":"string"},{"name":"_asset","type":"address","internalType":"address"},{"name":"_amount","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"payable"},{"type":"function","name":"deposits","inputs":[{"name":"","type":"string","internalType":"string"}],"outputs":[{"name":"id","type":"string","internalType":"string"},{"name":"initialAmount","type":"uint256","internalType":"uint256"},{"name":"remainingAmount","type":"uint256","internalType":"uint256"},{"name":"asset","type":"address","internalType":"address"},{"name":"depositType","type":"bool","internalType":"bool"},{"name":"liquidity","type":"bool","internalType":"bool"},{"name":"isActive","type":"bool","internalType":"bool"},{"name":"dateCreated","type":"uint256","internalType":"uint256"},{"name":"exists","type":"bool","internalType":"bool"}],"stateMutability":"view"},{"type":"function","name":"feeKeeperAddress","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"getMinAmount","inputs":[{"name":"_decimals","type":"uint8","internalType":"uint8"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"pure"},{"type":"function","name":"lookupDepositActivity","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"bool","internalType":"bool"}],"stateMutability":"view"},{"type":"function","name":"lookupDepositAsset","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"lookupDepositBeneficiaries","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"tuple[]","internalType":"struct Trust.Beneficiary[]","components":[{"name":"benef","type":"address","internalType":"address"},{"name":"allowance","type":"uint256","internalType":"uint256"},{"name":"isLimited","type":"bool","internalType":"bool"},{"name":"dateLastWithdrawal","type":"uint256","internalType":"uint256"}]}],"stateMutability":"view"},{"type":"function","name":"lookupDepositDateCreated","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupDepositExists","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"bool","internalType":"bool"}],"stateMutability":"view"},{"type":"function","name":"lookupDepositInitialAmount","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupDepositLiquidity","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"bool","internalType":"bool"}],"stateMutability":"view"},{"type":"function","name":"lookupDepositOwners","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"tuple[]","internalType":"struct Trust.Owner[]","components":[{"name":"owner","type":"address","internalType":"address"},{"name":"isOwner","type":"bool","internalType":"bool"}]}],"stateMutability":"view"},{"type":"function","name":"lookupDepositRemainingAmount","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupDepositType","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"bool","internalType":"bool"}],"stateMutability":"view"},{"type":"function","name":"lookupTrustProfileAssets","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"tuple[]","internalType":"struct Trust.TrustAssetProfile[]","components":[{"name":"asset","type":"address","internalType":"address"},{"name":"amountWithdrawn","type":"uint256","internalType":"uint256"}]}],"stateMutability":"view"},{"type":"function","name":"lookupTrustProfileDeposits","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"tuple[]","internalType":"struct Trust.TrustProfileDeposit[]","components":[{"name":"id","type":"string","internalType":"string"},{"name":"isOwner","type":"bool","internalType":"bool"}]}],"stateMutability":"view"},{"type":"function","name":"modifyDeposit","inputs":[{"name":"_id","type":"string","internalType":"string"},{"name":"_newIsActive","type":"bool","internalType":"bool"},{"name":"_newBeneficiaries","type":"tuple[]","internalType":"struct Trust.Beneficiary[]","components":[{"name":"benef","type":"address","internalType":"address"},{"name":"allowance","type":"uint256","internalType":"uint256"},{"name":"isLimited","type":"bool","internalType":"bool"},{"name":"dateLastWithdrawal","type":"uint256","internalType":"uint256"}]}],"outputs":[],"stateMutability":"payable"},{"type":"function","name":"nativeCoinDecimals","inputs":[],"outputs":[{"name":"","type":"uint8","internalType":"uint8"}],"stateMutability":"view"},{"type":"function","name":"numberBeneficiaries","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"numberDeposits","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"numberOwners","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"numberWithdrawals","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"omnifyAddress","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"owner","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"renounceOwnership","inputs":[],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"retractDeposit","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setBeneficiaryFee","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setBeneficiaryFeeByFeeKeeper","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setDepositActiveVal","inputs":[{"name":"_id","type":"string","internalType":"string"},{"name":"_val","type":"bool","internalType":"bool"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setDepositFee","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setDepositFeeByFeeKeeper","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setFeeKeeperAddress","inputs":[{"name":"_feeKeeper","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setOmnifyAddress","inputs":[{"name":"_newaddress","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"transferOwnership","inputs":[{"name":"newOwner","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"trustProfiles","inputs":[{"name":"","type":"address","internalType":"address"}],"outputs":[{"name":"assetCount","type":"uint256","internalType":"uint256"},{"name":"depositCount","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"withdrawFromDeposit","inputs":[{"name":"_id","type":"string","internalType":"string"},{"name":"_amount","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"event","name":"OwnershipTransferred","inputs":[{"name":"previousOwner","type":"address","indexed":true,"internalType":"address"},{"name":"newOwner","type":"address","indexed":true,"internalType":"address"}],"anonymous":false},{"type":"event","name":"TrustDeposit","inputs":[{"name":"_id","type":"string","indexed":false,"internalType":"string"},{"name":"_initiator","type":"address","indexed":false,"internalType":"address"},{"name":"_asset","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"event","name":"TrustModified","inputs":[{"name":"_id","type":"string","indexed":false,"internalType":"string"},{"name":"_initiator","type":"address","indexed":false,"internalType":"address"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"event","name":"TrustRetraction","inputs":[{"name":"_id","type":"string","indexed":false,"internalType":"string"},{"name":"_initiator","type":"address","indexed":false,"internalType":"address"},{"name":"_asset","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"event","name":"TrustWithdrawal","inputs":[{"name":"_id","type":"string","indexed":false,"internalType":"string"},{"name":"_initiator","type":"address","indexed":false,"internalType":"address"},{"name":"_asset","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"error","name":"OwnableInvalidOwner","inputs":[{"name":"owner","type":"address","internalType":"address"}]},{"type":"error","name":"OwnableUnauthorizedAccount","inputs":[{"name":"account","type":"address","internalType":"address"}]}]',
  'TrustAbi',
);

class TrustAbi extends _i1.GeneratedContract {
  TrustAbi({
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
  Future<BigInt> amountAssetsDeposited({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '475b9051'));
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
  Future<BigInt> amountAssetsWithdrawn({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '4fabf9e7'));
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
  Future<BigInt> beneficiaryFee({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '1f810ead'));
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
  Future<String> createDeposit(
    ({
      String id,
      BigInt amount,
      _i1.EthereumAddress asset,
      bool depositType,
      bool liquidity,
      bool isActive,
      List<dynamic> owners,
      List<dynamic> beneficiaries
    }) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'c5a416e6'));
    final params = [
      args.id,
      args.amount,
      args.asset,
      args.depositType,
      args.liquidity,
      args.isActive,
      args.owners,
      args.beneficiaries,
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
  Future<BigInt> depositFee({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '67a52793'));
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
  Future<String> depositIntoExistingDeposit(
    ({String id, _i1.EthereumAddress asset, BigInt amount}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '8d69167d'));
    final params = [
      args.id,
      args.asset,
      args.amount,
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
  Future<Deposits> deposits(
    ({String $param11}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, 'b9a8a4fd'));
    final params = [args.$param11];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Deposits(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> feeKeeperAddress({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[8];
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
    final function = self.abi.functions[9];
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
  Future<bool> lookupDepositActivity(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, 'a0514de5'));
    final params = [args.id];
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
  Future<_i1.EthereumAddress> lookupDepositAsset(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, 'a8c80947'));
    final params = [args.id];
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
  Future<List<dynamic>> lookupDepositBeneficiaries(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, '39c7365e'));
    final params = [args.id];
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
  Future<BigInt> lookupDepositDateCreated(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[13];
    assert(checkSignature(function, 'c3745543'));
    final params = [args.id];
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
  Future<bool> lookupDepositExists(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[14];
    assert(checkSignature(function, 'a7469af1'));
    final params = [args.id];
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
  Future<BigInt> lookupDepositInitialAmount(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[15];
    assert(checkSignature(function, '2fdd44c7'));
    final params = [args.id];
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
  Future<bool> lookupDepositLiquidity(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[16];
    assert(checkSignature(function, 'f972f2ae'));
    final params = [args.id];
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
  Future<List<dynamic>> lookupDepositOwners(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[17];
    assert(checkSignature(function, 'a47af535'));
    final params = [args.id];
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
  Future<BigInt> lookupDepositRemainingAmount(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[18];
    assert(checkSignature(function, 'd203f2bf'));
    final params = [args.id];
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
  Future<bool> lookupDepositType(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[19];
    assert(checkSignature(function, '68e4e9b8'));
    final params = [args.id];
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
  Future<List<dynamic>> lookupTrustProfileAssets(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[20];
    assert(checkSignature(function, 'e9485e63'));
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
  Future<List<dynamic>> lookupTrustProfileDeposits(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[21];
    assert(checkSignature(function, '62b0896a'));
    final params = [args.profile];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<dynamic>();
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> modifyDeposit(
    ({String id, bool newIsActive, List<dynamic> newBeneficiaries}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[22];
    assert(checkSignature(function, '69002f7c'));
    final params = [
      args.id,
      args.newIsActive,
      args.newBeneficiaries,
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
  Future<BigInt> nativeCoinDecimals({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[23];
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
  Future<BigInt> numberBeneficiaries({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[24];
    assert(checkSignature(function, 'bae85b91'));
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
  Future<BigInt> numberDeposits({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[25];
    assert(checkSignature(function, 'bcdc6e64'));
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
  Future<BigInt> numberOwners({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[26];
    assert(checkSignature(function, '76d1d35e'));
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
  Future<BigInt> numberWithdrawals({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[27];
    assert(checkSignature(function, 'e9867687'));
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
    final function = self.abi.functions[28];
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
    final function = self.abi.functions[29];
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
    final function = self.abi.functions[30];
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
  Future<String> retractDeposit(
    ({String id}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[31];
    assert(checkSignature(function, 'ab50769a'));
    final params = [args.id];
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
  Future<String> setBeneficiaryFee(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[32];
    assert(checkSignature(function, 'bf4ab743'));
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
  Future<String> setBeneficiaryFeeByFeeKeeper(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[33];
    assert(checkSignature(function, 'b1ea9aa8'));
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
  Future<String> setDepositActiveVal(
    ({String id, bool val}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[34];
    assert(checkSignature(function, '7e34ff5a'));
    final params = [
      args.id,
      args.val,
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
  Future<String> setDepositFee(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[35];
    assert(checkSignature(function, '490ae210'));
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
  Future<String> setDepositFeeByFeeKeeper(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[36];
    assert(checkSignature(function, '21cdc5f7'));
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
    final function = self.abi.functions[37];
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
    final function = self.abi.functions[38];
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
  Future<String> transferOwnership(
    ({_i1.EthereumAddress newOwner}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[39];
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
  Future<TrustProfiles> trustProfiles(
    ({_i1.EthereumAddress $param38}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[40];
    assert(checkSignature(function, '0fbcb48a'));
    final params = [args.$param38];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return TrustProfiles(response);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> withdrawFromDeposit(
    ({String id, BigInt amount}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[41];
    assert(checkSignature(function, '268736f1'));
    final params = [
      args.id,
      args.amount,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
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

  /// Returns a live stream of all TrustDeposit events emitted by this contract.
  Stream<TrustDeposit> trustDepositEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('TrustDeposit');
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
      return TrustDeposit(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all TrustModified events emitted by this contract.
  Stream<TrustModified> trustModifiedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('TrustModified');
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
      return TrustModified(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all TrustRetraction events emitted by this contract.
  Stream<TrustRetraction> trustRetractionEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('TrustRetraction');
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
      return TrustRetraction(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all TrustWithdrawal events emitted by this contract.
  Stream<TrustWithdrawal> trustWithdrawalEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('TrustWithdrawal');
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
      return TrustWithdrawal(
        decoded,
        result,
      );
    });
  }
}

class Deposits {
  Deposits(List<dynamic> response)
      : id = (response[0] as String),
        initialAmount = (response[1] as BigInt),
        remainingAmount = (response[2] as BigInt),
        asset = (response[3] as _i1.EthereumAddress),
        depositType = (response[4] as bool),
        liquidity = (response[5] as bool),
        isActive = (response[6] as bool),
        dateCreated = (response[7] as BigInt),
        exists = (response[8] as bool);

  final String id;

  final BigInt initialAmount;

  final BigInt remainingAmount;

  final _i1.EthereumAddress asset;

  final bool depositType;

  final bool liquidity;

  final bool isActive;

  final BigInt dateCreated;

  final bool exists;
}

class TrustProfiles {
  TrustProfiles(List<dynamic> response)
      : assetCount = (response[0] as BigInt),
        depositCount = (response[1] as BigInt);

  final BigInt assetCount;

  final BigInt depositCount;
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

class TrustDeposit {
  TrustDeposit(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as String),
        initiator = (response[1] as _i1.EthereumAddress),
        asset = (response[2] as _i1.EthereumAddress),
        amount = (response[3] as BigInt),
        blockNumber = (response[4] as BigInt),
        date = (response[5] as BigInt);

  final String id;

  final _i1.EthereumAddress initiator;

  final _i1.EthereumAddress asset;

  final BigInt amount;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}

class TrustModified {
  TrustModified(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as String),
        initiator = (response[1] as _i1.EthereumAddress),
        blockNumber = (response[2] as BigInt),
        date = (response[3] as BigInt);

  final String id;

  final _i1.EthereumAddress initiator;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}

class TrustRetraction {
  TrustRetraction(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as String),
        initiator = (response[1] as _i1.EthereumAddress),
        asset = (response[2] as _i1.EthereumAddress),
        amount = (response[3] as BigInt),
        blockNumber = (response[4] as BigInt),
        date = (response[5] as BigInt);

  final String id;

  final _i1.EthereumAddress initiator;

  final _i1.EthereumAddress asset;

  final BigInt amount;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}

class TrustWithdrawal {
  TrustWithdrawal(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as String),
        initiator = (response[1] as _i1.EthereumAddress),
        asset = (response[2] as _i1.EthereumAddress),
        amount = (response[3] as BigInt),
        blockNumber = (response[4] as BigInt),
        date = (response[5] as BigInt);

  final String id;

  final _i1.EthereumAddress initiator;

  final _i1.EthereumAddress asset;

  final BigInt amount;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}
