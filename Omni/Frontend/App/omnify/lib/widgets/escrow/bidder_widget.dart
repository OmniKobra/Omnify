// ignore_for_file: use_build_context_synchronously

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:omnify/models/transaction.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:provider/provider.dart';

import '../../providers/transactions_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../crypto/features/escrow_utils.dart';
import '../../models/escrow_contract.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';
import '../../toasts.dart';

class BidderWidget extends StatefulWidget {
  final EscrowContract contract;
  final EscrowBid bid;
  final void Function() setStateHandle;
  const BidderWidget(
      {super.key,
      required this.contract,
      required this.bid,
      required this.setStateHandle});

  @override
  State<BidderWidget> createState() => _BidderWidgetState();
}

class _BidderWidgetState extends State<BidderWidget> {
  @override
  Widget build(BuildContext context) {
    final widthQuery = Utils.widthQuery(context);
    const heightBox = SizedBox(height: 5);
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final primaryColor =
        isDark ? Colors.white70 : Theme.of(context).colorScheme.primary;
    final dir = theme.textDirection;
    final lang = Utils.language(context);
    final myAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(theme.startingChain);
    final border = Border.all(
        width: widget.bid.bidAccepted || widget.bid.bidCancelled ? 2 : 1,
        color: widget.bid.bidAccepted
            ? Colors.green
            : widget.bid.bidCancelled
                ? Colors.red
                : isDark
                    ? Colors.black
                    : Colors.grey.shade300);
    final actions = [
      if (!widget.bid.bidCancelled &&
          !widget.bid.bidAccepted &&
          !widget.contract.bids.any((element) => element.bidAccepted) &&
          !widget.contract.isDeleted &&
          widget.contract.ownerAddress == myAddress)
        PieAction(
          tooltip: Text(lang.escrow31),
          onSelect: () async {
            setState(() {});
            Utils.showLoadingDialog(context, lang, widthQuery);
            final txHash = await EscrowUtils.acceptBid(
                c: theme.startingChain,
                client: theme.client,
                wcClient: theme.walletClient,
                sessionTopic: theme.stateSessionTopic,
                walletAddress: myAddress,
                id: widget.contract.escrowID,
                acceptedBidCount: widget.contract.bids.indexOf(widget.bid) + 1);
            if (txHash != null) {
              Provider.of<TransactionsProvider>(context, listen: false)
                  .addTransaction(Transaction(
                      c: theme.startingChain,
                      type: TransactionType.escrow,
                      id: txHash,
                      date: DateTime.now(),
                      status: Status.pending,
                      transactionHash: txHash,
                      blockNumber: 0,
                      secondTransactionHash: '',
                      secondBlockNumber: 0,
                      thirdTransactionHash: '',
                      thirdBlockNumber: 0));
              Future.delayed(const Duration(seconds: 1), () {
                Toasts.showSuccessToast(
                    lang.transactionSent, lang.transactionSent2, isDark, dir);
                widget.bid.acceptBid();
                widget.setStateHandle();
                setState(() {});
              });
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              Toasts.showErrorToast(lang.toast13, lang.toasts30, isDark, dir);
            }
          },
          buttonTheme: const PieButtonTheme(
              backgroundColor: Colors.green, iconColor: Colors.white),
          buttonThemeHovered: const PieButtonTheme(
              backgroundColor: Colors.green, iconColor: Colors.white),
          child: const Icon(Icons.check), // Can be any widget
        ),
      if (!widget.bid.bidCancelled &&
          !widget.bid.bidAccepted &&
          widget.bid.bidderAddress == myAddress)
        PieAction(
          tooltip: Text(lang.escrow36),
          onSelect: () async {
            setState(() {});
            Utils.showLoadingDialog(context, lang, widthQuery);
            final txHash = await EscrowUtils.cancelBid(
                c: theme.startingChain,
                client: theme.client,
                wcClient: theme.walletClient,
                sessionTopic: theme.stateSessionTopic,
                walletAddress: myAddress,
                id: widget.contract.escrowID,
                cancelledBidCount:
                    widget.contract.bids.indexOf(widget.bid) + 1);
            if (txHash != null) {
              Provider.of<TransactionsProvider>(context, listen: false)
                  .addTransaction(Transaction(
                      c: theme.startingChain,
                      type: TransactionType.escrow,
                      id: txHash,
                      date: DateTime.now(),
                      status: Status.pending,
                      transactionHash: txHash,
                      blockNumber: 0,
                      secondTransactionHash: '',
                      secondBlockNumber: 0,
                      thirdTransactionHash: '',
                      thirdBlockNumber: 0));
              Future.delayed(const Duration(seconds: 1), () {
                Toasts.showSuccessToast(
                    lang.transactionSent, lang.transactionSent2, isDark, dir);
                widget.bid.cancelBid();
                widget.setStateHandle();
                setState(() {});
              });
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              Toasts.showErrorToast(lang.toast13, lang.toasts30, isDark, dir);
            }
          },
          buttonTheme: const PieButtonTheme(
              backgroundColor: Colors.red, iconColor: Colors.white),
          buttonThemeHovered: const PieButtonTheme(
              backgroundColor: Colors.red, iconColor: Colors.white),
          child: const Icon(Icons.cancel), // Can be any widget
        ),
    ];
    return PieMenu(
      theme: PieTheme(
          tooltipCanvasAlignment: Alignment.centerLeft,
          pointerColor: Colors.transparent,
          overlayColor: Colors.black87,
          buttonTheme: PieButtonTheme(
              backgroundColor: isDark ? Colors.grey.shade700 : primaryColor,
              iconColor: isDark ? Colors.white60 : Colors.white),
          buttonThemeHovered: PieButtonTheme(
              backgroundColor: isDark ? Colors.grey.shade700 : Colors.green,
              iconColor: isDark ? Colors.white60 : Colors.white),
          tooltipTextStyle:
              TextStyle(color: isDark ? Colors.white60 : Colors.white),
          childBounceEnabled: true,
          leftClickShowsMenu: true,
          rightClickShowsMenu: true),
      onPressed: () => {},
      actions: dir == TextDirection.ltr ? actions : actions.reversed.toList(),
      child: Container(
        width: widthQuery ? 250 : 150,
        margin: widthQuery ? const EdgeInsets.all(8) : const EdgeInsets.all(2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[700] : Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.bid.bidAccepted)
              const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.check_circle, color: Colors.green),
              ),
            if (widget.bid.bidCancelled)
              const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.cancel, color: Colors.red),
              ),
            SizedBox(
                height: widthQuery ? 75 : 60,
                width: double.infinity,
                child: ExtendedImage.network(widget.bid.imageUrl,
                    cache: true, enableLoadState: false)),
            heightBox,
            Container(
                padding: const EdgeInsets.all(4),
                child: Text(widget.bid.coinName,
                    style: TextStyle(
                        fontSize: widthQuery ? 13 : 12, color: primaryColor))),
            ListTile(
                contentPadding: const EdgeInsets.all(0),
                minVerticalPadding: 0,
                horizontalTitleGap: 5,
                dense: true,
                leading: Icon(Icons.token,
                    color: isDark ? Colors.white60 : Colors.black),
                title: Text(
                    Utils.removeTrailingZeros(
                        widget.bid.amount.toStringAsFixed(widget.bid.decimals)),
                    style: TextStyle(fontSize: widthQuery ? 12 : 11))),
            ListTile(
                contentPadding: const EdgeInsets.all(0),
                minVerticalPadding: 0,
                horizontalTitleGap: 5,
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(Icons.wallet,
                    color: isDark ? Colors.white60 : Colors.black),
                title: Text(widget.bid.bidderAddress,
                    style: TextStyle(fontSize: widthQuery ? 12 : 11))),
            Row(
              children: [
                Chip(
                    elevation: 0,
                    padding: const EdgeInsets.all(0),
                    labelPadding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 0,
                            color: isDark
                                ? Colors.grey.shade700
                                : Colors.transparent)),
                    color: WidgetStatePropertyAll(
                        isDark ? Colors.grey[700] : Colors.white),
                    label: Text(lang.escrow22,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: widthQuery ? null : 13))),
              ],
            ),
            Text(widget.bid.assetAddress),
          ],
        ),
      ),
    );
  }
}
