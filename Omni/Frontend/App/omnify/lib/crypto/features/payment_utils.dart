import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../languages/app_language.dart';
import '../../models/installment_payments.dart';
import '../../models/installment_plan.dart';
import '../../models/receipt.dart';
import '../../models/withdrawal.dart';
import '../../toasts.dart';
import '../../utils.dart';
import '../utils/aliases.dart';
import '../utils/chain_utils.dart';

class PaymentUtils {
  static Future<String?> makePayement({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required String id,
    required Decimal amountDue,
    required Decimal omnifyFee,
    required String vendorAddress,
    required bool isInstallments,
    required Decimal fullAmount,
    required int period,
    required AppLanguage lang,
    required bool isDark,
    required TextDirection dir,
  }) async {
    final alias = Aliases.getAlias(c);
    final paymentContract = alias.paymentsContract(c, client);
    BigInt _amountDue = ChainUtils.nativeDecimalToUint(c, amountDue);
    BigInt _fullAmount = ChainUtils.nativeDecimalToUint(c, fullAmount);
    BigInt _omnifyFee = ChainUtils.nativeDecimalToUint(c, omnifyFee);
    BigInt _installmentPeriod = BigInt.from(period);
    EthereumAddress vendor = ChainUtils.ethAddressFromHex(c, vendorAddress);
    EthereumAddress customer = ChainUtils.ethAddressFromHex(c, walletAddress);
    BigInt totalMsgValue = _amountDue + _omnifyFee;
    final addressBalance = await client.getBalance(customer);
    if (addressBalance.getInWei < totalMsgValue) {
      Toasts.showErrorToast(lang.toasts26,
          lang.toasts27 + "\$${Utils.nativeTokenSymbol(c)}", isDark, dir);
      return null;
    } else {
      final transaction = Transaction.callContract(
          contract: paymentContract.self,
          function: paymentContract.self.function('makePayment'),
          from: customer,
          value: EtherAmount.inWei(totalMsgValue),
          parameters: [
            id,
            _amountDue,
            vendor,
            isInstallments,
            _fullAmount,
            _installmentPeriod
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

  static Future<String?> payInstallment({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required String id,
    required Decimal omnifyFee,
    required Decimal paymentAmount,
    required AppLanguage lang,
    required bool isDark,
    required TextDirection dir,
  }) async {
    final alias = Aliases.getAlias(c);
    final paymentContract = alias.paymentsContract(c, client);
    EthereumAddress customer = ChainUtils.ethAddressFromHex(c, walletAddress);
    BigInt _paymentAmount = ChainUtils.nativeDecimalToUint(c, paymentAmount);
    BigInt _omnifyFee = ChainUtils.nativeDecimalToUint(c, omnifyFee);
    BigInt totalMsgValue = _paymentAmount + _omnifyFee;
    final transaction = Transaction.callContract(
        contract: paymentContract.self,
        function: paymentContract.self.function('payInstallment'),
        from: customer,
        value: EtherAmount.inWei(totalMsgValue),
        parameters: [id]);
    final addressBalance = await client.getBalance(customer);
    if (addressBalance.getInWei < totalMsgValue) {
      Toasts.showErrorToast(lang.toasts26,
          lang.toasts27 + "\$${Utils.nativeTokenSymbol(c)}", isDark, dir);
      return null;
    } else {
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

  static Future<String?> issueRefund(
      {required Chain c,
      required String id,
      required Web3Client client,
      required String walletAddress,
      required Web3App wcClient,
      required String sessionTopic,
      required bool isDark,
      required TextDirection dir,
      required AppLanguage lang}) async {
    final alias = Aliases.getAlias(c);
    final paymentContract = alias.paymentsContract(c, client);
    var thePayment = await paymentContract.lookupPayment((id: id));
    var isRefunded = thePayment[5];
    var _amount = thePayment[1];
    var amount = ChainUtils.nativeUintToDecimal(c, _amount);
    if (!isRefunded) {
      Decimal currentBalance = await fetchBalance(c, walletAddress, client);
      if (currentBalance < amount) {
        Toasts.showErrorToast(lang.toasts34, lang.toasts35, isDark, dir);
        return null;
      } else {
        EthereumAddress vendor = ChainUtils.ethAddressFromHex(c, walletAddress);
        final transaction = Transaction.callContract(
            contract: paymentContract.self,
            value: EtherAmount.inWei(BigInt.from(0)),
            from: vendor,
            function: paymentContract.self.function('issueRefund'),
            parameters: [id]);
        var senTx = await wcClient.request(
            topic: sessionTopic,
            chainId: ChainUtils.getChainIdString(c),
            request: SessionRequestParams(
                method: ChainUtils.getSendTransactionString(c),
                params: [transaction.toJson()]));
        return senTx;
      }
    } else {
      Toasts.showErrorToast(lang.toasts36, lang.toasts37, isDark, dir);
      return null;
    }
  }

  static Future<String?> withdrawBalance(
      {required Chain c,
      required String walletAddress,
      required Decimal amount,
      required Web3Client client,
      required Web3App wcClient,
      required String sessionTopic,
      required AppLanguage lang,
      required bool isDark,
      required TextDirection dir}) async {
    final alias = Aliases.getAlias(c);
    final paymentContract = alias.paymentsContract(c, client);
    try {
      Decimal currentBalance = await fetchBalance(c, walletAddress, client);
      if (currentBalance < amount) {
        Toasts.showErrorToast(lang.toasts34, lang.toasts35, isDark, dir);
        return null;
      } else {
        BigInt _amount = ChainUtils.nativeDecimalToUint(c, amount);
        EthereumAddress vendor = ChainUtils.ethAddressFromHex(c, walletAddress);
        final transaction = Transaction.callContract(
            contract: paymentContract.self,
            value: EtherAmount.inWei(BigInt.from(0)),
            from: vendor,
            function: paymentContract.self.function('withdrawBalance'),
            parameters: [_amount]);
        var sentTx = await wcClient.request(
            topic: sessionTopic,
            chainId: ChainUtils.getChainIdString(c),
            request: SessionRequestParams(
                method: ChainUtils.getSendTransactionString(c),
                params: [transaction.toJson()]));
        return sentTx;
      }
    } catch (_) {
      return null;
    }
  }

  static Future<bool> checkPaid(Chain c, String id, Web3Client client) async {
    try {
      final alias = Aliases.getAlias(c);
      final paymentContract = alias.paymentsContract(c, client);
      var thePayment = await paymentContract.lookupPayment((id: id));
      var isPaid = thePayment[4];
      return isPaid;
    } catch (_) {
      return false;
    }
  }

  static Future<Decimal> quotePaymentFee({
    required Chain c,
    required bool isFullPayment,
    required bool isAnInstallment,
    required Web3Client client,
  }) async {
    final gasPrice = await client.getGasPrice();
    final price = gasPrice.getInWei;
    bool isL2 = ChainUtils.isL2(c);
    if (isFullPayment) {
      final BigInt roughGas = BigInt.from(888888);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    } else if (isAnInstallment) {
      final BigInt roughGas = BigInt.from(880609);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    } else {
      final BigInt roughGas = BigInt.from(108872);
      Decimal buffer = ChainUtils.nativeUintToDecimal(c, price * roughGas);
      String stringBuffer = buffer.toStringAsFixed(isL2 ? 8 : 6);
      final gasVal = Decimal.parse(stringBuffer);
      return gasVal;
    }
  }

  static Future<Decimal> fetchBalance(
    Chain c,
    String walletAddress,
    Web3Client client,
  ) async {
    final alias = Aliases.getAlias(c);
    var paymentsContract = alias.paymentsContract(c, client);
    var balance = await paymentsContract.lookupPaymentProfileBalance(
        (profile: ChainUtils.ethAddressFromHex(c, walletAddress)));
    return ChainUtils.nativeUintToDecimal(c, balance);
  }

  static Future<void> fetchPaymentProfile(
      {required Chain c,
      required Web3Client client,
      required String walletAddress,
      required void Function(
              {required Decimal paramBalance,
              required Decimal paramRevenue,
              required Decimal paramSpending,
              required Decimal paramRefunds,
              required Decimal paramWithdrawals,
              required int paramPaymentsMadeNum,
              required int paramPaymentsReceivedNum,
              required int paramRefundsNum,
              required int paramWihdrawalsNum,
              required List<Receipt> paramReceiptsList,
              required List<Withdrawal> paramWithdrawalsList})
          initProfile}) async {
    if (walletAddress.isNotEmpty) {
      final alias = Aliases.getAlias(c);
      var paymentsContract = alias.paymentsContract(c, client);
      EthereumAddress requester =
          ChainUtils.ethAddressFromHex(c, walletAddress);
      BigInt balance = await paymentsContract
          .lookupPaymentProfileBalance((profile: requester));
      BigInt revenue = await paymentsContract
          .lookupPaymentProfileRevenue((profile: requester));
      BigInt spending = await paymentsContract
          .lookupPaymentProfileSpending((profile: requester));
      BigInt refunds = await paymentsContract
          .lookupPaymentProfileRefundAmount((profile: requester));
      BigInt withdrawals = await paymentsContract
          .lookupPaymentProfileWithdrawnAmount((profile: requester));
      BigInt paymentsNm = await paymentsContract
          .lookupPaymentProfileNumberPaymentsMade((profile: requester));
      BigInt paymentsReceivedNm = await paymentsContract
          .lookupPaymentProfileNumberPaymentsReceived((profile: requester));
      BigInt refundsNm = await paymentsContract
          .lookupPaymentProfileNumberRefunds((profile: requester));
      BigInt withdrawalsNm = await paymentsContract
          .lookupPaymentProfileNumberWithdrawals((profile: requester));
      List<Receipt> receiptList = await fetchProfileReceipts(
          c: c,
          client: client,
          walletAddress: walletAddress,
          setReceipts: (_) {},
          useSetter: false);
      List<Withdrawal> withdrawalList = await fetchProfileWithdrawals(
          c: c,
          client: client,
          walletAddress: walletAddress,
          setWithdrawals: (_) {},
          useSetter: false);
      initProfile(
          paramBalance: ChainUtils.nativeUintToDecimal(c, balance),
          paramRevenue: ChainUtils.nativeUintToDecimal(c, revenue),
          paramSpending: ChainUtils.nativeUintToDecimal(c, spending),
          paramRefunds: ChainUtils.nativeUintToDecimal(c, refunds),
          paramWithdrawals: ChainUtils.nativeUintToDecimal(c, withdrawals),
          paramPaymentsMadeNum: paymentsNm.toInt(),
          paramPaymentsReceivedNum: paymentsReceivedNm.toInt(),
          paramRefundsNum: refundsNm.toInt(),
          paramWihdrawalsNum: withdrawalsNm.toInt(),
          paramReceiptsList: receiptList,
          paramWithdrawalsList: withdrawalList);
    }
  }

  static Future<List<Receipt>> fetchProfileReceipts({
    required Chain c,
    required Web3Client client,
    required String walletAddress,
    required void Function(List<Receipt>) setReceipts,
    required bool useSetter,
  }) async {
    List<Receipt> receipts = [];
    if (walletAddress.isNotEmpty) {
      final alias = Aliases.getAlias(c);
      var paymentsContract = alias.paymentsContract(c, client);
      EthereumAddress requester =
          ChainUtils.ethAddressFromHex(c, walletAddress);
      final receiptIds = await paymentsContract
          .lookupPaymentProfileReceipts((profile: requester));
      for (var r in receiptIds) {
        var id = r[0];
        var thePayment = await paymentsContract.lookupPayment((id: id));
        var _amount = thePayment[1];
        var _payer = thePayment[2];
        var _vendor = thePayment[3];
        var isRefunded = thePayment[5];
        var _date = thePayment[12];
        Receipt _receipt = Receipt(
            id: id,
            vendor: ChainUtils.hexFromEthAddress(c, _vendor),
            payer: ChainUtils.hexFromEthAddress(c, _payer),
            amount: ChainUtils.nativeUintToDecimal(c, _amount),
            isRefunded: isRefunded,
            date: ChainUtils.chainDateToDt(_date),
            transactionHash: 'transactionHash',
            blockNumber: 0);
        if (!receipts.any((re) => re.id == id)) {
          receipts.add(_receipt);
        }
      }
      if (useSetter) setReceipts(receipts);
    }
    return receipts;
  }

  static Future<List<Withdrawal>> fetchProfileWithdrawals({
    required Chain c,
    required Web3Client client,
    required String walletAddress,
    required void Function(List<Withdrawal>) setWithdrawals,
    required bool useSetter,
  }) async {
    List<Withdrawal> withdrawals = [];
    if (walletAddress.isNotEmpty) {
      final alias = Aliases.getAlias(c);
      var paymentsContract = alias.paymentsContract(c, client);
      EthereumAddress requester =
          ChainUtils.ethAddressFromHex(c, walletAddress);
      final _withdrawals = await paymentsContract
          .lookupPaymentProfileWithdrawals((profile: requester));
      for (var w in _withdrawals) {
        var _amount = w[0];
        var _date = w[1];
        Withdrawal _withdrawal = Withdrawal(
            ChainUtils.nativeUintToDecimal(c, _amount),
            ChainUtils.chainDateToDt(_date));
        withdrawals.add(_withdrawal);
      }
      if (useSetter) setWithdrawals(withdrawals);
    }
    return withdrawals;
  }

  static Future<Receipt?> fetchReceipt({
    required Chain c,
    required String id,
    required Web3Client client,
  }) async {
    try {
      final alias = Aliases.getAlias(c);
      var paymentsContract = alias.paymentsContract(c, client);
      var thePayment = await paymentsContract.lookupPayment((id: id));
      var isPaid = thePayment[4];
      if (isPaid) {
        var _amount = thePayment[1];
        var _payer = thePayment[2];
        var _vendor = thePayment[3];
        var isRefunded = thePayment[5];
        var _date = thePayment[12];
        Receipt _receipt = Receipt(
            id: id,
            vendor: ChainUtils.hexFromEthAddress(c, _vendor),
            payer: ChainUtils.hexFromEthAddress(c, _payer),
            amount: ChainUtils.nativeUintToDecimal(c, _amount),
            isRefunded: isRefunded,
            date: ChainUtils.chainDateToDt(_date),
            transactionHash: 'transactionHash',
            blockNumber: 0);
        return _receipt;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  static Future<List<InstallmentPlan>> fetchInstallmentPlans(
      {required Chain c,
      required String walletAddress,
      required Web3Client client}) async {
    final alias = Aliases.getAlias(c);
    var paymentsContract = alias.paymentsContract(c, client);
    List<InstallmentPlan> plans = [];
    var chainPlans = await paymentsContract
        .lookupPaymentProfileInstallmentPlans(
            (profile: ChainUtils.ethAddressFromHex(c, walletAddress)));
    for (var p in chainPlans) {
      var id = p[0];
      if (!plans.any((pl) => pl.paymentID == id)) {
        var thePayment = await paymentsContract.lookupPayment((id: id));
        List<InstallmentPayment> _installmentPayments = [];
        var _installmentPeriod = thePayment[9];
        var _vendor = thePayment[3];
        var _customer = thePayment[2];
        var _fullAmount = thePayment[7];
        var _downpayment = thePayment[1];
        var _paidInstallments = thePayment[10];
        var _plan = thePayment[8];
        var _datePaid = thePayment[12];
        var nowDate = Jiffy.parseFromDateTime(DateTime.now());
        var genesisDate = ChainUtils.chainDateToDt(_datePaid);
        var installmentsDate = Jiffy.parseFromDateTime(genesisDate);
        for (var i = 1; i <= _installmentPeriod.toInt(); i++) {
          var thisInstallmentsDate =
              installmentsDate.addDuration(const Duration(days: 30)).dateTime;
          var payment = InstallmentPayment(
              amount: ChainUtils.nativeUintToDecimal(c, _plan),
              dateDue: thisInstallmentsDate,
              dateSettled: thisInstallmentsDate,
              isPaid: _paidInstallments.toInt() >= i);
          installmentsDate = Jiffy.parseFromDateTime(thisInstallmentsDate);
          _installmentPayments.add(payment);
        }
        _installmentPayments.sort((a, b) => a.dateDue.compareTo(b.dateDue));
        var paids = _installmentPayments.where((pa) => pa.isPaid).toList();
        if (paids.isNotEmpty) {
          paids.sort((a, b) => b.dateDue.compareTo(a.dateDue));
        }
        var nonPaids = _installmentPayments.where((pa) => !pa.isPaid).toList();
        if (nonPaids.isNotEmpty) {
          nonPaids.sort((a, b) => b.dateDue.compareTo(a.dateDue));
        }
        var bufferPaidAmount =
            (_plan * BigInt.from(paids.length)) + _downpayment;
        var plan = InstallmentPlan(
            paymentID: id,
            vendorAddress: ChainUtils.hexFromEthAddress(c, _vendor),
            payerAddress: ChainUtils.hexFromEthAddress(c, _customer),
            amountTotal: ChainUtils.nativeUintToDecimal(c, _fullAmount),
            amountPaid: _paidInstallments == _installmentPeriod
                ? ChainUtils.nativeUintToDecimal(c, _fullAmount)
                : ChainUtils.nativeUintToDecimal(c, bufferPaidAmount),
            plan: ChainUtils.nativeUintToDecimal(c, _plan),
            isComplete: _paidInstallments == _installmentPeriod,
            downpayment: ChainUtils.nativeUintToDecimal(c, _downpayment),
            isDue: nonPaids.any((pa) {
              var date = Jiffy.parseFromDateTime(pa.dateDue);
              return date.isBefore(nowDate);
            }),
            isOngoing: _paidInstallments < _installmentPeriod,
            installmentsQuantity: _installmentPeriod.toInt(),
            installmentsComplete: _paidInstallments.toInt(),
            installments: _installmentPayments,
            startingDate: genesisDate,
            upcomingPaymentDate: nonPaids.isNotEmpty
                ? nonPaids.first.dateDue
                : paids.first.dateDue);
        plans.add(plan);
      }
    }
    plans
        .sort((a, b) => a.upcomingPaymentDate.compareTo(b.upcomingPaymentDate));
    return plans;
  }
}
// struct Payment {
//     string id; 0
//     uint256 amount; 1
//     address customer; 2
//     address vendor; 3
//     bool isPaid; 4
//     bool isRefunded; 5
//     bool isInstallments; 6
//     uint256 fullAmount; 7
//     uint256 amountPerInstallment; 8
//     uint8 installmentPeriod; 9
//     uint8 paidInstallments; 10
//     uint8 remainingInstallments; 11
//     uint256 datePaid; 12
//     uint256 dateLastInstallmentPaid; 13
// }