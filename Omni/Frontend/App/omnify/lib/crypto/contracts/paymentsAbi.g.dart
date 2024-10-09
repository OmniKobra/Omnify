// @dart=3.0
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_local_variable, unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"type":"constructor","inputs":[{"name":"_paramOmnifyAddress","type":"address","internalType":"address"},{"name":"_paramWad","type":"uint256","internalType":"uint256"},{"name":"_paramNativeDecimals","type":"uint8","internalType":"uint8"},{"name":"_paramFeePerInstallment","type":"uint256","internalType":"uint256"},{"name":"_paramFeePerPayment","type":"uint256","internalType":"uint256"}],"stateMutability":"nonpayable"},{"type":"function","name":"amountWithdrawn","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"assetsPaid","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"feeKeeperAddress","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"feePerInstallment","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"feePerPayment","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"getMinAmount","inputs":[{"name":"_decimals","type":"uint8","internalType":"uint8"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"pure"},{"type":"function","name":"installmentAssetsPaid","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"installmentsCreated","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"installmentsPaid","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"issueRefund","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"lookupPayment","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[{"name":"","type":"tuple","internalType":"struct Payments.Payment","components":[{"name":"id","type":"string","internalType":"string"},{"name":"amount","type":"uint256","internalType":"uint256"},{"name":"customer","type":"address","internalType":"address"},{"name":"vendor","type":"address","internalType":"address"},{"name":"isPaid","type":"bool","internalType":"bool"},{"name":"isRefunded","type":"bool","internalType":"bool"},{"name":"isInstallments","type":"bool","internalType":"bool"},{"name":"fullAmount","type":"uint256","internalType":"uint256"},{"name":"amountPerInstallment","type":"uint256","internalType":"uint256"},{"name":"installmentPeriod","type":"uint8","internalType":"uint8"},{"name":"paidInstallments","type":"uint8","internalType":"uint8"},{"name":"remainingInstallments","type":"uint8","internalType":"uint8"},{"name":"datePaid","type":"uint256","internalType":"uint256"},{"name":"dateLastInstallmentPaid","type":"uint256","internalType":"uint256"}]}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileBalance","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileInstallmentPlans","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"tuple[]","internalType":"struct Payments.PaymentProfileInstallmentPlan[]","components":[{"name":"id","type":"string","internalType":"string"}]}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileNumberPaymentsMade","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileNumberPaymentsReceived","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileNumberRefunds","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileNumberWithdrawals","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileReceipts","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"tuple[]","internalType":"struct Payments.PaymentProfileReceipt[]","components":[{"name":"id","type":"string","internalType":"string"}]}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileRefundAmount","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileRevenue","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileSpending","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileWithdrawals","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"tuple[]","internalType":"struct Payments.PaymentProfileWithdrawal[]","components":[{"name":"amount","type":"uint256","internalType":"uint256"},{"name":"date","type":"uint256","internalType":"uint256"}]}],"stateMutability":"view"},{"type":"function","name":"lookupPaymentProfileWithdrawnAmount","inputs":[{"name":"_profile","type":"address","internalType":"address"}],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"makePayment","inputs":[{"name":"_id","type":"string","internalType":"string"},{"name":"_amount","type":"uint256","internalType":"uint256"},{"name":"_vendor","type":"address","internalType":"address"},{"name":"_isInstallments","type":"bool","internalType":"bool"},{"name":"_fullAmount","type":"uint256","internalType":"uint256"},{"name":"_installmentPeriod","type":"uint8","internalType":"uint8"}],"outputs":[],"stateMutability":"payable"},{"type":"function","name":"maxInstallmentPeriod","inputs":[],"outputs":[{"name":"","type":"uint8","internalType":"uint8"}],"stateMutability":"view"},{"type":"function","name":"nativeCoinDecimals","inputs":[],"outputs":[{"name":"","type":"uint8","internalType":"uint8"}],"stateMutability":"view"},{"type":"function","name":"omnifyAddress","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"owner","inputs":[],"outputs":[{"name":"","type":"address","internalType":"address"}],"stateMutability":"view"},{"type":"function","name":"payInstallment","inputs":[{"name":"_id","type":"string","internalType":"string"}],"outputs":[],"stateMutability":"payable"},{"type":"function","name":"paymentProfiles","inputs":[{"name":"","type":"address","internalType":"address"}],"outputs":[{"name":"currentBalance","type":"uint256","internalType":"uint256"},{"name":"totalRevenue","type":"uint256","internalType":"uint256"},{"name":"numberPaymentsReceived","type":"uint256","internalType":"uint256"},{"name":"numberPaymentsMade","type":"uint256","internalType":"uint256"},{"name":"totalSpending","type":"uint256","internalType":"uint256"},{"name":"numberWithdrawals","type":"uint256","internalType":"uint256"},{"name":"amountWithdrawals","type":"uint256","internalType":"uint256"},{"name":"amountRefunds","type":"uint256","internalType":"uint256"},{"name":"numberRefunds","type":"uint256","internalType":"uint256"},{"name":"exists","type":"bool","internalType":"bool"},{"name":"planCount","type":"uint256","internalType":"uint256"},{"name":"receiptCount","type":"uint256","internalType":"uint256"},{"name":"withdrawalCount","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"payments","inputs":[{"name":"","type":"string","internalType":"string"}],"outputs":[{"name":"id","type":"string","internalType":"string"},{"name":"amount","type":"uint256","internalType":"uint256"},{"name":"customer","type":"address","internalType":"address"},{"name":"vendor","type":"address","internalType":"address"},{"name":"isPaid","type":"bool","internalType":"bool"},{"name":"isRefunded","type":"bool","internalType":"bool"},{"name":"isInstallments","type":"bool","internalType":"bool"},{"name":"fullAmount","type":"uint256","internalType":"uint256"},{"name":"amountPerInstallment","type":"uint256","internalType":"uint256"},{"name":"installmentPeriod","type":"uint8","internalType":"uint8"},{"name":"paidInstallments","type":"uint8","internalType":"uint8"},{"name":"remainingInstallments","type":"uint8","internalType":"uint8"},{"name":"datePaid","type":"uint256","internalType":"uint256"},{"name":"dateLastInstallmentPaid","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"paymentsMade","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"refundsAmount","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"refundsIssued","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"renounceOwnership","inputs":[],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setFeeKeeperAddress","inputs":[{"name":"_feeKeeper","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setFeePerInstallment","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setFeePerInstallmentByFeeKeeper","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setFeePerPayment","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setFeePerPaymentByKeeper","inputs":[{"name":"_fee","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setMaxInstallmentPeriod","inputs":[{"name":"_period","type":"uint8","internalType":"uint8"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"setOmnifyAddress","inputs":[{"name":"_newaddress","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"transferOwnership","inputs":[{"name":"newOwner","type":"address","internalType":"address"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"uniqueCustomers","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"uniqueVendors","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"function","name":"withdrawBalance","inputs":[{"name":"_amount","type":"uint256","internalType":"uint256"}],"outputs":[],"stateMutability":"nonpayable"},{"type":"function","name":"withdrawalsMade","inputs":[],"outputs":[{"name":"","type":"uint256","internalType":"uint256"}],"stateMutability":"view"},{"type":"event","name":"OwnershipTransferred","inputs":[{"name":"previousOwner","type":"address","indexed":true,"internalType":"address"},{"name":"newOwner","type":"address","indexed":true,"internalType":"address"}],"anonymous":false},{"type":"event","name":"PaymentInstallmentPaid","inputs":[{"name":"_id","type":"string","indexed":false,"internalType":"string"},{"name":"_customer","type":"address","indexed":false,"internalType":"address"},{"name":"_vendor","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"event","name":"PaymentMade","inputs":[{"name":"_id","type":"string","indexed":false,"internalType":"string"},{"name":"_customer","type":"address","indexed":false,"internalType":"address"},{"name":"_vendor","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"event","name":"PaymentRefundIssued","inputs":[{"name":"_id","type":"string","indexed":false,"internalType":"string"},{"name":"_customer","type":"address","indexed":false,"internalType":"address"},{"name":"_vendor","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"event","name":"PaymentWithdrawalMade","inputs":[{"name":"_vendor","type":"address","indexed":false,"internalType":"address"},{"name":"_amount","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_blockNumber","type":"uint256","indexed":false,"internalType":"uint256"},{"name":"_date","type":"uint256","indexed":false,"internalType":"uint256"}],"anonymous":false},{"type":"error","name":"OwnableInvalidOwner","inputs":[{"name":"owner","type":"address","internalType":"address"}]},{"type":"error","name":"OwnableUnauthorizedAccount","inputs":[{"name":"account","type":"address","internalType":"address"}]}]',
  'PaymentsAbi',
);

class PaymentsAbi extends _i1.GeneratedContract {
  PaymentsAbi({
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
  Future<BigInt> amountWithdrawn({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '0d662a1f'));
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
  Future<BigInt> assetsPaid({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'c874a8f9'));
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
  Future<BigInt> feePerInstallment({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '8e9ca1ea'));
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
  Future<BigInt> feePerPayment({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, 'f2618bff'));
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
  Future<BigInt> getMinAmount(
    ({BigInt decimals}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[6];
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
  Future<BigInt> installmentAssetsPaid({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '9b467be2'));
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
  Future<BigInt> installmentsCreated({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, 'a1bfb027'));
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
  Future<BigInt> installmentsPaid({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, '4ab274ba'));
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
  Future<String> issueRefund(
    ({String id}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, '2b75bbc2'));
    final params = [args.id];
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
  Future<dynamic> lookupPayment(
    ({String id}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, '117e274b'));
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
  Future<BigInt> lookupPaymentProfileBalance(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, '1c82d0f3'));
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
  Future<List<dynamic>> lookupPaymentProfileInstallmentPlans(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[13];
    assert(checkSignature(function, '90c54943'));
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
  Future<BigInt> lookupPaymentProfileNumberPaymentsMade(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[14];
    assert(checkSignature(function, '01815c5b'));
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
  Future<BigInt> lookupPaymentProfileNumberPaymentsReceived(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[15];
    assert(checkSignature(function, 'e45594f1'));
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
  Future<BigInt> lookupPaymentProfileNumberRefunds(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[16];
    assert(checkSignature(function, 'e61ad629'));
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
  Future<BigInt> lookupPaymentProfileNumberWithdrawals(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[17];
    assert(checkSignature(function, '18b0ea20'));
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
  Future<List<dynamic>> lookupPaymentProfileReceipts(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[18];
    assert(checkSignature(function, '2de6adb3'));
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
  Future<BigInt> lookupPaymentProfileRefundAmount(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[19];
    assert(checkSignature(function, 'affaa4c9'));
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
  Future<BigInt> lookupPaymentProfileRevenue(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[20];
    assert(checkSignature(function, 'a04b81ea'));
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
  Future<BigInt> lookupPaymentProfileSpending(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[21];
    assert(checkSignature(function, '0e39a5cd'));
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
  Future<List<dynamic>> lookupPaymentProfileWithdrawals(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[22];
    assert(checkSignature(function, '6d3be85f'));
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
  Future<BigInt> lookupPaymentProfileWithdrawnAmount(
    ({_i1.EthereumAddress profile}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[23];
    assert(checkSignature(function, '19ddccf8'));
    final params = [args.profile];
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
  Future<String> makePayment(
    ({
      String id,
      BigInt amount,
      _i1.EthereumAddress vendor,
      bool isInstallments,
      BigInt fullAmount,
      BigInt installmentPeriod
    }) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[24];
    assert(checkSignature(function, 'dc71f8ae'));
    final params = [
      args.id,
      args.amount,
      args.vendor,
      args.isInstallments,
      args.fullAmount,
      args.installmentPeriod,
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
  Future<BigInt> maxInstallmentPeriod({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[25];
    assert(checkSignature(function, 'c31e2318'));
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
  Future<BigInt> nativeCoinDecimals({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[26];
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
    final function = self.abi.functions[27];
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
    final function = self.abi.functions[28];
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
  Future<String> payInstallment(
    ({String id}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[29];
    assert(checkSignature(function, '8486d5b3'));
    final params = [args.id];
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
  Future<PaymentProfiles> paymentProfiles(
    ({_i1.EthereumAddress $param22}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[30];
    assert(checkSignature(function, 'beb2e220'));
    final params = [args.$param22];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return PaymentProfiles(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<Payments> payments(
    ({String $param23}) args, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[31];
    assert(checkSignature(function, 'f9468713'));
    final params = [args.$param23];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Payments(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> paymentsMade({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[32];
    assert(checkSignature(function, '4ff59cf8'));
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
  Future<BigInt> refundsAmount({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[33];
    assert(checkSignature(function, '8f269128'));
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
  Future<BigInt> refundsIssued({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[34];
    assert(checkSignature(function, '76b33367'));
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
  Future<String> setFeeKeeperAddress(
    ({_i1.EthereumAddress feeKeeper}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[36];
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
  Future<String> setFeePerInstallment(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[37];
    assert(checkSignature(function, '30d43f04'));
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
  Future<String> setFeePerInstallmentByFeeKeeper(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[38];
    assert(checkSignature(function, 'd3c08e95'));
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
  Future<String> setFeePerPayment(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[39];
    assert(checkSignature(function, '2168d0dd'));
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
  Future<String> setFeePerPaymentByKeeper(
    ({BigInt fee}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[40];
    assert(checkSignature(function, '422bdac1'));
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
  Future<String> setMaxInstallmentPeriod(
    ({BigInt period}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[41];
    assert(checkSignature(function, '9da923f6'));
    final params = [args.period];
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
    final function = self.abi.functions[42];
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
    final function = self.abi.functions[43];
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
  Future<BigInt> uniqueCustomers({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[44];
    assert(checkSignature(function, '85620409'));
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
  Future<BigInt> uniqueVendors({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[45];
    assert(checkSignature(function, '95c301c1'));
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
  Future<String> withdrawBalance(
    ({BigInt amount}) args, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[46];
    assert(checkSignature(function, 'da76d5cd'));
    final params = [args.amount];
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
  Future<BigInt> withdrawalsMade({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[47];
    assert(checkSignature(function, '99103a92'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
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

  /// Returns a live stream of all PaymentInstallmentPaid events emitted by this contract.
  Stream<PaymentInstallmentPaid> paymentInstallmentPaidEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('PaymentInstallmentPaid');
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
      return PaymentInstallmentPaid(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all PaymentMade events emitted by this contract.
  Stream<PaymentMade> paymentMadeEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('PaymentMade');
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
      return PaymentMade(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all PaymentRefundIssued events emitted by this contract.
  Stream<PaymentRefundIssued> paymentRefundIssuedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('PaymentRefundIssued');
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
      return PaymentRefundIssued(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all PaymentWithdrawalMade events emitted by this contract.
  Stream<PaymentWithdrawalMade> paymentWithdrawalMadeEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('PaymentWithdrawalMade');
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
      return PaymentWithdrawalMade(
        decoded,
        result,
      );
    });
  }
}

class PaymentProfiles {
  PaymentProfiles(List<dynamic> response)
      : currentBalance = (response[0] as BigInt),
        totalRevenue = (response[1] as BigInt),
        numberPaymentsReceived = (response[2] as BigInt),
        numberPaymentsMade = (response[3] as BigInt),
        totalSpending = (response[4] as BigInt),
        numberWithdrawals = (response[5] as BigInt),
        amountWithdrawals = (response[6] as BigInt),
        amountRefunds = (response[7] as BigInt),
        numberRefunds = (response[8] as BigInt),
        exists = (response[9] as bool),
        planCount = (response[10] as BigInt),
        receiptCount = (response[11] as BigInt),
        withdrawalCount = (response[12] as BigInt);

  final BigInt currentBalance;

  final BigInt totalRevenue;

  final BigInt numberPaymentsReceived;

  final BigInt numberPaymentsMade;

  final BigInt totalSpending;

  final BigInt numberWithdrawals;

  final BigInt amountWithdrawals;

  final BigInt amountRefunds;

  final BigInt numberRefunds;

  final bool exists;

  final BigInt planCount;

  final BigInt receiptCount;

  final BigInt withdrawalCount;
}

class Payments {
  Payments(List<dynamic> response)
      : id = (response[0] as String),
        amount = (response[1] as BigInt),
        customer = (response[2] as _i1.EthereumAddress),
        vendor = (response[3] as _i1.EthereumAddress),
        isPaid = (response[4] as bool),
        isRefunded = (response[5] as bool),
        isInstallments = (response[6] as bool),
        fullAmount = (response[7] as BigInt),
        amountPerInstallment = (response[8] as BigInt),
        installmentPeriod = (response[9] as BigInt),
        paidInstallments = (response[10] as BigInt),
        remainingInstallments = (response[11] as BigInt),
        datePaid = (response[12] as BigInt),
        dateLastInstallmentPaid = (response[13] as BigInt);

  final String id;

  final BigInt amount;

  final _i1.EthereumAddress customer;

  final _i1.EthereumAddress vendor;

  final bool isPaid;

  final bool isRefunded;

  final bool isInstallments;

  final BigInt fullAmount;

  final BigInt amountPerInstallment;

  final BigInt installmentPeriod;

  final BigInt paidInstallments;

  final BigInt remainingInstallments;

  final BigInt datePaid;

  final BigInt dateLastInstallmentPaid;
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

class PaymentInstallmentPaid {
  PaymentInstallmentPaid(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as String),
        customer = (response[1] as _i1.EthereumAddress),
        vendor = (response[2] as _i1.EthereumAddress),
        amount = (response[3] as BigInt),
        blockNumber = (response[4] as BigInt),
        date = (response[5] as BigInt);

  final String id;

  final _i1.EthereumAddress customer;

  final _i1.EthereumAddress vendor;

  final BigInt amount;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}

class PaymentMade {
  PaymentMade(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as String),
        customer = (response[1] as _i1.EthereumAddress),
        vendor = (response[2] as _i1.EthereumAddress),
        amount = (response[3] as BigInt),
        blockNumber = (response[4] as BigInt),
        date = (response[5] as BigInt);

  final String id;

  final _i1.EthereumAddress customer;

  final _i1.EthereumAddress vendor;

  final BigInt amount;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}

class PaymentRefundIssued {
  PaymentRefundIssued(
    List<dynamic> response,
    this.event,
  )   : id = (response[0] as String),
        customer = (response[1] as _i1.EthereumAddress),
        vendor = (response[2] as _i1.EthereumAddress),
        amount = (response[3] as BigInt),
        blockNumber = (response[4] as BigInt),
        date = (response[5] as BigInt);

  final String id;

  final _i1.EthereumAddress customer;

  final _i1.EthereumAddress vendor;

  final BigInt amount;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}

class PaymentWithdrawalMade {
  PaymentWithdrawalMade(
    List<dynamic> response,
    this.event,
  )   : vendor = (response[0] as _i1.EthereumAddress),
        amount = (response[1] as BigInt),
        blockNumber = (response[2] as BigInt),
        date = (response[3] as BigInt);

  final _i1.EthereumAddress vendor;

  final BigInt amount;

  final BigInt blockNumber;

  final BigInt date;

  final _i1.FilterEvent event;
}
