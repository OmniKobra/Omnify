import 'dart:async';
import 'package:decimal/decimal.dart';
import 'package:web3dart/web3dart.dart';

import '../../models/discover_events.dart';
import '../../utils.dart';
import '../contracts/transfersAbi.g.dart';
import '../contracts/paymentsAbi.g.dart';
import '../contracts/trustAbi.g.dart';
import '../contracts/bridgesAbi.g.dart' as b;
import '../contracts/escrowAbi.g.dart';
import '../utils/chain_utils.dart';
import '../utils/aliases.dart';

class DiscoverUtils {
  static StreamSubscription<AssetsReceived>? transferReceivedistener;
  static StreamSubscription<AssetsSent>? transferSentListener;
  static StreamSubscription<TransferComplete>? transferCompleteListener;

  static StreamSubscription<PaymentMade>? paymentMadeListener;
  static StreamSubscription<PaymentWithdrawalMade>? paymentWithdrawalListener;
  static StreamSubscription<PaymentInstallmentPaid>? paymentInstallmentListener;
  static StreamSubscription<PaymentRefundIssued>? paymentRefundListener;

  static StreamSubscription<TrustDeposit>? trustDepositListener;
  static StreamSubscription<TrustWithdrawal>? trustWithdrawalListener;
  static StreamSubscription<TrustModified>? trustModificationListener;
  static StreamSubscription<TrustRetraction>? trustRetractionListener;

  static StreamSubscription<b.AssetsMigrated>? bridgeMigrationListener;
  static StreamSubscription<b.AssetsReceived>? bridgeReceivedListener;

  static StreamSubscription<NewContract>? escrowNewContractListener;
  static StreamSubscription<ContractDeleted>? escrowContractDeletedListener;
  static StreamSubscription<NewBid>? escrowNewBidListener;
  static StreamSubscription<BidAccepted>? escrowBidAcceptedListener;

  static Future<void> getLooperStats(
      {required Chain c,
      required void Function(Map<String, dynamic>) setTransferStats,
      required void Function(Map<String, dynamic>) setPaymentStats,
      required void Function(Map<String, dynamic>) setTrustStats,
      required void Function(Map<String, dynamic>) setBridgeStats,
      required void Function(Map<String, dynamic>) setEscrowStats,
      required Web3Client client}) async {
    Decimal dec(BigInt b) => ChainUtils.nativeUintToDecimal(c, b);
    final alias = Aliases.getAlias(c);
    final transferContract = alias.transfersContract(c, client);
    final paymentContract = alias.paymentsContract(c, client);
    final trustContract = alias.trustContract(c, client);
    final bridgeContract = alias.bridgesContract(c, client);
    final escrowContract = alias.escrowContract(c, client);
    var transfers = await transferContract.totalNumerOfTransfers();
    var assetsTransferred = await transferContract.totalAssetsTransferred();
    var senders = await transferContract.totalSendersUnique();
    var recipients = await transferContract.totalRecipientsUnique();
    Map<String, dynamic> _transferStats = {
      'transfers': transfers.toInt(),
      'assets transferred': dec(assetsTransferred),
      'senders': senders.toInt(),
      'recipients': recipients.toInt()
    };
    setTransferStats(_transferStats);
    var payments = await paymentContract.paymentsMade();
    var amountPaid = await paymentContract.assetsPaid();
    var installments = await paymentContract.installmentsCreated();
    var installmentsPaid = await paymentContract.installmentsPaid();
    var withdrawals = await paymentContract.withdrawalsMade();
    var amountWithdrawn = await paymentContract.amountWithdrawn();
    var paidInIstallments = await paymentContract.installmentAssetsPaid();
    var customers = await paymentContract.uniqueCustomers();
    var vendors = await paymentContract.uniqueVendors();
    var refunds = await paymentContract.refundsIssued();
    var amountRefunded = await paymentContract.refundsAmount();
    Map<String, dynamic> _paymentStats = {
      'payments': payments.toInt(),
      'amount paid': dec(amountPaid),
      'installments': installments.toInt(),
      'installments paid': installmentsPaid.toInt(),
      'withdrawals': withdrawals.toInt(),
      'amount withdrawn': dec(amountWithdrawn),
      'paid in installments': dec(paidInIstallments),
      'customers': customers.toInt(),
      'vendors': vendors.toInt(),
      'refunds': refunds.toInt(),
      'amount refunded': dec(amountRefunded),
    };
    setPaymentStats(_paymentStats);
    var amountDeposited = await trustContract.amountAssetsDeposited();
    var deposits = await trustContract.numberDeposits();
    var beneficiaries = await trustContract.numberBeneficiaries();
    var numberTrustWithdrawals = await trustContract.numberWithdrawals();
    var amountTrustAssetsWithdrawn =
        await trustContract.amountAssetsWithdrawn();
    var owners = await trustContract.numberOwners();
    Map<String, dynamic> _trustStats = {
      'amount deposited': dec(amountDeposited),
      'deposits': deposits.toInt(),
      'beneficiaries': beneficiaries.toInt(),
      'withdrawals': numberTrustWithdrawals.toInt(),
      'assets withdrawn': dec(amountTrustAssetsWithdrawn),
      'owners': owners.toInt()
    };
    setTrustStats(_trustStats);
    var assetsReceived = await bridgeContract.amountReceivedAssets();
    var assetsMigrated = await bridgeContract.amountMigratedAssets();
    var receivedTxs = await bridgeContract.numberReceivedTransactions();
    var migratedTxs = await bridgeContract.numberMigrationTransactions();
    Map<String, dynamic> _bridgeStats = {
      'assets received': dec(assetsReceived),
      'assets migrated': dec(assetsMigrated),
      'received transactions': receivedTxs.toInt(),
      'migration transactions': migratedTxs.toInt()
    };
    setBridgeStats(_bridgeStats);
    var bidsMade = await escrowContract.numberBids();
    var contracts = await escrowContract.numberContracts();
    var contractAssets = await escrowContract.amountAssetsInContracts();
    var bidAssets = await escrowContract.amountAssetsInBids();
    var completeContracts = await escrowContract.numberCompletedContracts();
    Map<String, dynamic> _escrowStats = {
      'bids made': bidsMade.toInt(),
      'contracts': contracts.toInt(),
      'contract assets': dec(contractAssets),
      'bid assets': dec(bidAssets),
      'complete contracts': completeContracts.toInt(),
    };
    setEscrowStats(_escrowStats);
  }

  static void initTransferEventListeners({
    required Chain c,
    required void Function(DiscoverTransferEvent) addEvent,
    required Web3Client client,
  }) {
    final alias = Aliases.getAlias(c);
    final transferContract = alias.transfersContract(c, client);
    if (transferReceivedistener != null) {
      transferReceivedistener!.cancel();
      transferReceivedistener = null;
    }
    transferReceivedistener =
        transferContract.assetsReceivedEvents().listen((a) async {
      final cryptoAsset =
          await ChainUtils.getCoinFromAddress(c, a.asset.hex, client);
      addEvent(DiscoverTransferEvent(
          id: a.id,
          senderAddress: ChainUtils.hexFromEthAddress(c, a.sender),
          recipientAddress: ChainUtils.hexFromEthAddress(c, a.recipient),
          amount: ChainUtils.uintToDecimal(
              c, cryptoAsset ?? Utils.generateNativeToken(c), a.amount),
          asset: ChainUtils.hexFromEthAddress(c, a.asset),
          transactionHash: "transactionHash",
          blockNumber: 0,
          type: TransferEventType.received,
          date: ChainUtils.chainDateToDt(a.date)));
    });
    if (transferSentListener != null) {
      transferSentListener!.cancel();
      transferSentListener = null;
    }
    transferSentListener =
        transferContract.assetsSentEvents().listen((a) async {
      final cryptoAsset =
          await ChainUtils.getCoinFromAddress(c, a.asset.hex, client);
      addEvent(DiscoverTransferEvent(
          id: a.id,
          senderAddress: ChainUtils.hexFromEthAddress(c, a.sender),
          recipientAddress: ChainUtils.hexFromEthAddress(c, a.recipient),
          amount: ChainUtils.uintToDecimal(
              c, cryptoAsset ?? Utils.generateNativeToken(c), a.amount),
          asset: ChainUtils.hexFromEthAddress(c, a.asset),
          transactionHash: "transactionHash",
          blockNumber: 0,
          type: TransferEventType.sent,
          date: ChainUtils.chainDateToDt(a.date)));
    });
    if (transferCompleteListener != null) {
      transferCompleteListener!.cancel();
      transferCompleteListener = null;
    }
    transferCompleteListener =
        transferContract.transferCompleteEvents().listen((a) async {
      final cryptoAsset =
          await ChainUtils.getCoinFromAddress(c, a.asset.hex, client);
      addEvent(DiscoverTransferEvent(
          id: a.id,
          senderAddress: ChainUtils.hexFromEthAddress(c, a.sender),
          recipientAddress: ChainUtils.hexFromEthAddress(c, a.recipient),
          amount: ChainUtils.uintToDecimal(
              c, cryptoAsset ?? Utils.generateNativeToken(c), a.amount),
          asset: ChainUtils.hexFromEthAddress(c, a.asset),
          transactionHash: "transactionHash",
          blockNumber: a.blockNumber.toInt(),
          type: TransferEventType.completed,
          date: ChainUtils.chainDateToDt(a.date)));
    });
  }

  static void disposeTransferEventListeners() {
    if (transferReceivedistener != null) {
      transferReceivedistener!.cancel();
      transferReceivedistener = null;
    }
    if (transferSentListener != null) {
      transferSentListener!.cancel();
      transferSentListener = null;
    }
    if (transferCompleteListener != null) {
      transferCompleteListener!.cancel();
      transferCompleteListener = null;
    }
  }

  static void initPaymentEventListeners({
    required Chain c,
    required void Function(DiscoverPaymentEvent) addEvent,
    required Web3Client client,
  }) {
    final alias = Aliases.getAlias(c);
    final paymentsContract = alias.paymentsContract(c, client);
    if (paymentMadeListener != null) {
      paymentMadeListener!.cancel();
      paymentMadeListener = null;
    }
    paymentMadeListener = paymentsContract.paymentMadeEvents().listen((p) {
      addEvent(DiscoverPaymentEvent(
          id: p.id,
          payerAddress: ChainUtils.hexFromEthAddress(c, p.customer),
          vendorAddress: ChainUtils.hexFromEthAddress(c, p.vendor),
          amount: ChainUtils.nativeUintToDecimal(c, p.amount),
          transactionHash: "transactionHash",
          blockNumber: p.blockNumber.toInt(),
          type: PaymentEventType.payment,
          date: ChainUtils.chainDateToDt(p.date)));
    });
    if (paymentWithdrawalListener != null) {
      paymentWithdrawalListener!.cancel();
      paymentWithdrawalListener = null;
    }
    paymentWithdrawalListener =
        paymentsContract.paymentWithdrawalMadeEvents().listen((p) {
      addEvent(DiscoverPaymentEvent(
          id: "p.id",
          payerAddress: "ChainUtils.hexFromEthAddress(c, p.customer)",
          vendorAddress: ChainUtils.hexFromEthAddress(c, p.vendor),
          amount: ChainUtils.nativeUintToDecimal(c, p.amount),
          transactionHash: "transactionHash",
          blockNumber: p.blockNumber.toInt(),
          type: PaymentEventType.withdrawal,
          date: ChainUtils.chainDateToDt(p.date)));
    });
    if (paymentInstallmentListener != null) {
      paymentInstallmentListener!.cancel();
      paymentInstallmentListener = null;
    }
    paymentInstallmentListener =
        paymentsContract.paymentInstallmentPaidEvents().listen((p) {
      addEvent(DiscoverPaymentEvent(
          id: p.id,
          payerAddress: ChainUtils.hexFromEthAddress(c, p.customer),
          vendorAddress: ChainUtils.hexFromEthAddress(c, p.vendor),
          amount: ChainUtils.nativeUintToDecimal(c, p.amount),
          transactionHash: "transactionHash",
          blockNumber: p.blockNumber.toInt(),
          type: PaymentEventType.installlmentPayment,
          date: ChainUtils.chainDateToDt(p.date)));
    });
    if (paymentRefundListener != null) {
      paymentRefundListener!.cancel();
      paymentRefundListener = null;
    }
    paymentRefundListener =
        paymentsContract.paymentRefundIssuedEvents().listen((p) {
      addEvent(DiscoverPaymentEvent(
          id: p.id,
          payerAddress: ChainUtils.hexFromEthAddress(c, p.customer),
          vendorAddress: ChainUtils.hexFromEthAddress(c, p.vendor),
          amount: ChainUtils.nativeUintToDecimal(c, p.amount),
          transactionHash: "transactionHash",
          blockNumber: p.blockNumber.toInt(),
          type: PaymentEventType.refund,
          date: ChainUtils.chainDateToDt(p.date)));
    });
  }

  static void disposePaymentEventListeners() {
    if (paymentMadeListener != null) {
      paymentMadeListener!.cancel();
      paymentMadeListener = null;
    }
    if (paymentWithdrawalListener != null) {
      paymentWithdrawalListener!.cancel();
      paymentWithdrawalListener = null;
    }
    if (paymentInstallmentListener != null) {
      paymentInstallmentListener!.cancel();
      paymentInstallmentListener = null;
    }
    if (paymentRefundListener != null) {
      paymentRefundListener!.cancel();
      paymentRefundListener = null;
    }
  }

  static void initTrustEventListeners({
    required Chain c,
    required void Function(DiscoverTrustEvent) addEvent,
    required Web3Client client,
  }) {
    final alias = Aliases.getAlias(c);
    final trustContract = alias.trustContract(c, client);
    if (trustDepositListener != null) {
      trustDepositListener!.cancel();
      trustDepositListener = null;
    }
    trustDepositListener = trustContract.trustDepositEvents().listen((t) async {
      final cryptoAsset =
          await ChainUtils.getCoinFromAddress(c, t.asset.hex, client);
      addEvent(DiscoverTrustEvent(
          id: t.id,
          initiatorAddress: ChainUtils.hexFromEthAddress(c, t.initiator),
          amount: ChainUtils.uintToDecimal(
              c, cryptoAsset ?? Utils.generateNativeToken(c), t.amount),
          asset: ChainUtils.hexFromEthAddress(c, t.asset),
          transactionHash: "transactionHash",
          blockNumber: t.blockNumber.toInt(),
          type: TrustEventType.deposit,
          date: ChainUtils.chainDateToDt(t.date)));
    });
    if (trustWithdrawalListener != null) {
      trustWithdrawalListener!.cancel();
      trustWithdrawalListener = null;
    }
    trustWithdrawalListener =
        trustContract.trustWithdrawalEvents().listen((t) async {
      final cryptoAsset =
          await ChainUtils.getCoinFromAddress(c, t.asset.hex, client);
      addEvent(DiscoverTrustEvent(
          id: t.id,
          initiatorAddress: ChainUtils.hexFromEthAddress(c, t.initiator),
          amount: ChainUtils.uintToDecimal(
              c, cryptoAsset ?? Utils.generateNativeToken(c), t.amount),
          asset: ChainUtils.hexFromEthAddress(c, t.asset),
          transactionHash: "transactionHash",
          blockNumber: t.blockNumber.toInt(),
          type: TrustEventType.withdrawal,
          date: ChainUtils.chainDateToDt(t.date)));
    });
    if (trustModificationListener != null) {
      trustModificationListener!.cancel();
      trustModificationListener = null;
    }
    trustModificationListener = trustContract.trustModifiedEvents().listen((t) {
      addEvent(DiscoverTrustEvent(
          id: t.id,
          blockNumber: t.blockNumber.toInt(),
          initiatorAddress: ChainUtils.hexFromEthAddress(c, t.initiator),
          amount: Decimal.parse("0.0"),
          asset: "",
          transactionHash: "transactionHash",
          type: TrustEventType.modification,
          date: ChainUtils.chainDateToDt(t.date)));
    });
    if (trustRetractionListener != null) {
      trustRetractionListener!.cancel();
      trustRetractionListener = null;
    }
    trustRetractionListener =
        trustContract.trustRetractionEvents().listen((t) async {
      final cryptoAsset =
          await ChainUtils.getCoinFromAddress(c, t.asset.hex, client);
      addEvent(DiscoverTrustEvent(
          id: t.id,
          initiatorAddress: ChainUtils.hexFromEthAddress(c, t.initiator),
          amount: ChainUtils.uintToDecimal(
              c, cryptoAsset ?? Utils.generateNativeToken(c), t.amount),
          asset: ChainUtils.hexFromEthAddress(c, t.asset),
          transactionHash: "transactionHash",
          blockNumber: t.blockNumber.toInt(),
          type: TrustEventType.retraction,
          date: ChainUtils.chainDateToDt(t.date)));
    });
  }

  static void disposeTrustListeners() {
    if (trustDepositListener != null) {
      trustDepositListener!.cancel();
      trustDepositListener = null;
    }
    if (trustWithdrawalListener != null) {
      trustWithdrawalListener!.cancel();
      trustWithdrawalListener = null;
    }
    if (trustModificationListener != null) {
      trustModificationListener!.cancel();
      trustModificationListener = null;
    }
    if (trustRetractionListener != null) {
      trustRetractionListener!.cancel();
      trustRetractionListener = null;
    }
  }

  static void initBridgesEventListeners({
    required Chain c,
    required void Function(DiscoverBridgeEvent) addEvent,
    required Web3Client client,
  }) {
    final alias = Aliases.getAlias(c);
    final bridgesContract = alias.bridgesContract(c, client);
    if (bridgeMigrationListener != null) {
      bridgeMigrationListener!.cancel();
      bridgeMigrationListener = null;
    }
    bridgeMigrationListener =
        bridgesContract.assetsMigratedEvents().listen((b) async {
      final cryptoAsset =
          await ChainUtils.getCoinFromAddress(c, b.asset.hex, client);
      addEvent(DiscoverBridgeEvent(
          id: b.id.toString(),
          sourceAddress: ChainUtils.hexFromEthAddress(c, b.sourceAddress),
          destinationAddress:
              ChainUtils.hexFromEthAddress(c, b.destinationAddress),
          sourceChain: Utils.lzEidToChain(b.sourceChain.toInt()),
          destinationChain: Utils.lzEidToChain(b.destinationChain.toInt()),
          asset: ChainUtils.hexFromEthAddress(c, b.asset),
          amount: ChainUtils.uintToDecimal(
              c, cryptoAsset ?? Utils.generateNativeToken(c), b.amount),
          transactionHash: "transactionHash",
          blockNumber: b.blockNumber.toInt(),
          type: BridgeEventType.migrate,
          date: ChainUtils.chainDateToDt(b.date)));
    });
    if (bridgeReceivedListener != null) {
      bridgeReceivedListener!.cancel();
      bridgeReceivedListener = null;
    }
    bridgeReceivedListener =
        bridgesContract.assetsReceivedEvents().listen((b) async {
      final cryptoAsset =
          await ChainUtils.getCoinFromAddress(c, b.asset.hex, client);
      addEvent(DiscoverBridgeEvent(
          id: b.id.toString(),
          sourceAddress: ChainUtils.hexFromEthAddress(c, b.sourceAddress),
          destinationAddress:
              ChainUtils.hexFromEthAddress(c, b.destinationAddress),
          sourceChain: Utils.lzEidToChain(b.sourceChain.toInt()),
          destinationChain: Utils.lzEidToChain(b.destinationChain.toInt()),
          asset: ChainUtils.hexFromEthAddress(c, b.asset),
          amount: ChainUtils.uintToDecimal(
              c, cryptoAsset ?? Utils.generateNativeToken(c), b.amount),
          transactionHash: "transactionHash",
          blockNumber: b.blockNumber.toInt(),
          type: BridgeEventType.receive,
          date: ChainUtils.chainDateToDt(b.date)));
    });
  }

  static void disposeBridgeListeners() {
    if (bridgeMigrationListener != null) {
      bridgeMigrationListener!.cancel();
      bridgeMigrationListener = null;
    }
    if (bridgeReceivedListener != null) {
      bridgeReceivedListener!.cancel();
      bridgeReceivedListener = null;
    }
  }

  static void initEscrowEventListeners({
    required Chain c,
    required void Function(DiscoverEscrowEvent) addEvent,
    required Web3Client client,
  }) {
    final alias = Aliases.getAlias(c);
    final escrowContract = alias.escrowContract(c, client);
    if (escrowNewContractListener != null) {
      escrowNewContractListener!.cancel();
      escrowNewContractListener = null;
    }
    escrowNewContractListener =
        escrowContract.newContractEvents().listen((contract) {
      addEvent(DiscoverEscrowEvent(
          id: contract.id,
          ownerAddress: ChainUtils.hexFromEthAddress(c, contract.owner),
          contractID: contract.id,
          transactionHash: "transactionHash",
          blockNumber: contract.blockNumber.toInt(),
          type: EscrowEventType.newContract,
          date: ChainUtils.chainDateToDt(contract.date)));
    });
    if (escrowContractDeletedListener != null) {
      escrowContractDeletedListener!.cancel();
      escrowContractDeletedListener = null;
    }
    escrowContractDeletedListener =
        escrowContract.contractDeletedEvents().listen((contract) {
      addEvent(DiscoverEscrowEvent(
          id: contract.id,
          contractID: contract.id,
          ownerAddress: ChainUtils.hexFromEthAddress(c, contract.owner),
          transactionHash: "transactionHash",
          blockNumber: contract.blockNumber.toInt(),
          type: EscrowEventType.deleteContract,
          date: ChainUtils.chainDateToDt(contract.date)));
    });
    if (escrowNewBidListener != null) {
      escrowNewBidListener!.cancel();
      escrowNewBidListener = null;
    }
    escrowNewBidListener = escrowContract.newBidEvents().listen((contract) {
      addEvent(DiscoverEscrowEvent(
          id: contract.id,
          contractID: contract.id,
          ownerAddress: ChainUtils.hexFromEthAddress(c, contract.owner),
          transactionHash: "transactionHash",
          blockNumber: contract.blockNumber.toInt(),
          type: EscrowEventType.newBid,
          date: ChainUtils.chainDateToDt(contract.date)));
    });

    if (escrowBidAcceptedListener != null) {
      escrowBidAcceptedListener!.cancel();
      escrowBidAcceptedListener = null;
    }
    escrowBidAcceptedListener =
        escrowContract.bidAcceptedEvents().listen((contract) {
      addEvent(DiscoverEscrowEvent(
          id: contract.id,
          contractID: contract.id,
          ownerAddress: ChainUtils.hexFromEthAddress(c, contract.owner),
          transactionHash: "transactionHash",
          blockNumber: contract.blockNumber.toInt(),
          type: EscrowEventType.bidAccepted,
          date: ChainUtils.chainDateToDt(contract.date)));
    });
  }

  static void disposeEscrowEventListeners() {
    if (escrowNewContractListener != null) {
      escrowNewContractListener!.cancel();
      escrowNewContractListener = null;
    }
    if (escrowContractDeletedListener != null) {
      escrowContractDeletedListener!.cancel();
      escrowContractDeletedListener = null;
    }
    if (escrowNewBidListener != null) {
      escrowNewBidListener!.cancel();
      escrowNewBidListener = null;
    }
    if (escrowBidAcceptedListener != null) {
      escrowBidAcceptedListener!.cancel();
      escrowBidAcceptedListener = null;
    }
  }
}
