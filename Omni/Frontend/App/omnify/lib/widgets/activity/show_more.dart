import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activities/transfer_activity_provider.dart';
import '../../providers/activities/payment_activity_provider.dart';
import '../../providers/activities/bridge_activity_provider.dart';
import '../../utils.dart';

class ShowMore extends StatefulWidget {
  final bool isInTransfers;
  final bool isInPaymentReceipts;
  final bool isInPaymentWithdrawals;
  final bool isInBridgeTransactions;
  const ShowMore(
      {super.key,
      required this.isInTransfers,
      required this.isInPaymentReceipts,
      required this.isInPaymentWithdrawals,
      required this.isInBridgeTransactions});

  @override
  State<ShowMore> createState() => _ShowMoreState();
}

class _ShowMoreState extends State<ShowMore> {
  @override
  Widget build(BuildContext context) {
    final transferActivity = Provider.of<TransferActivityProvider>(context);
    final showMoreTransfers =
        Provider.of<TransferActivityProvider>(context, listen: false).showMore;
    var shownTransfers = transferActivity.transactions;
    var allTransfers = transferActivity.allTransactions;
    final paymentActivity = Provider.of<PaymentActivityProvider>(context);
    final showMoreReceipts =
        Provider.of<PaymentActivityProvider>(context, listen: false)
            .showMoreReceipts;
    final showMoreWithdrawals =
        Provider.of<PaymentActivityProvider>(context, listen: false)
            .showMoreWithdrawals;
    var shownReceipts = paymentActivity.receipts;
    var allReceipts = paymentActivity.allReceipts;
    var shownWithdrawals = paymentActivity.withdrawalList;
    var allWithdrawals = paymentActivity.allWithdrawalsList;
    final bridgeActivity = Provider.of<BridgeActivityProvider>(context);
    final showMoreBridges =
        Provider.of<BridgeActivityProvider>(context, listen: false).showMore;
    var shownBridges = bridgeActivity.transactions;
    var allBridges = bridgeActivity.allTransactions;
    final lang = Utils.language(context);
    bool hasMore() {
      if (widget.isInTransfers) {
        return allTransfers.length > shownTransfers.length;
      }
      if (widget.isInPaymentReceipts) {
        return allReceipts.length > shownReceipts.length;
      }
      if (widget.isInPaymentWithdrawals) {
        return allWithdrawals.length > shownWithdrawals.length;
      }
      if (widget.isInBridgeTransactions) {
        return allBridges.length > shownBridges.length;
      }
      return false;
    }

    void handler() {
      if (widget.isInTransfers) {
        showMoreTransfers();
      }
      if (widget.isInPaymentReceipts) {
        showMoreReceipts();
      }
      if (widget.isInPaymentWithdrawals) {
        showMoreWithdrawals();
      }
      if (widget.isInBridgeTransactions) {
        showMoreBridges();
      }
    }

    return (hasMore())
        ? Center(child: TextButton(onPressed: handler, child: Text(lang.showMore)))
        : const SizedBox.shrink();
  }
}
