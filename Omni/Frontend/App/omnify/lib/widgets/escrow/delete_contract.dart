// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:omnify/widgets/common/network_fee.dart';
import 'package:provider/provider.dart';

import '../../crypto/features/escrow_utils.dart';
import '../../languages/app_language.dart';
import '../../models/escrow_contract.dart';
import '../../models/transaction.dart';
import '../../providers/theme_provider.dart';
import '../../providers/transactions_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../toasts.dart';
import '../../utils.dart';

class DeleteContract extends StatefulWidget {
  final EscrowContract contract;
  final Chain c;
  final void Function() setStatehandle;
  const DeleteContract(
      {super.key,
      required this.contract,
      required this.c,
      required this.setStatehandle});

  @override
  State<DeleteContract> createState() => _DeleteContractState();
}

class _DeleteContractState extends State<DeleteContract> {
  Decimal networkFee = Decimal.parse("0.0");
  Widget buildPropertyLabel(
          String label, Color primaryColor, bool isDark, bool widthQuery) =>
      Row(
        children: [
          Chip(
              // visualDensity: VisualDensity.compact,
              elevation: 0,
              padding: const EdgeInsets.all(0),
              labelPadding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 0,
                      color:
                          isDark ? Colors.grey.shade800 : Colors.transparent)),
              color: WidgetStatePropertyAll(
                  isDark ? Colors.grey[800] : Colors.white),
              label: Text(label,
                  style: TextStyle(
                      color: primaryColor, fontSize: widthQuery ? null : 13))),
        ],
      );

  Widget buildFee(String label, Decimal amount, bool widthQuery, Chain c,
          bool isDark) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 13.25,
                    color: isDark ? Colors.white60 : Colors.grey)),
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      child: Utils.buildNetworkLogo(
                          widthQuery, Utils.feeLogo(c), true, true)),
                  const SizedBox(width: 5),
                  Text(
                      Utils.removeTrailingZeros(
                          amount.toStringAsFixed(Utils.nativeTokenDecimals(c))),
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14))
                ])
          ],
        ),
      );

  Widget buildDeleteButton(
      bool widthQuery,
      AppLanguage lang,
      String walletAddress,
      bool isDark,
      TextDirection direction,
      void Function(Transaction) addTransaction) {
    return TextButton(
        onPressed: () async {
          setState(() {});
          Utils.showLoadingDialog(context, lang, widthQuery);
          final theme = Provider.of<ThemeProvider>(context, listen: false);
          final txHash = await EscrowUtils.deleteContract(
              c: widget.c,
              client: theme.client,
              wcClient: theme.walletClient,
              sessionTopic: theme.stateSessionTopic,
              walletAddress: walletAddress,
              id: widget.contract.escrowID);
          if (txHash != null) {
            addTransaction(Transaction(
                c: widget.c,
                type: TransactionType.escrow,
                id: txHash,
                date: DateTime.now(),
                status: Status.pending,
                transactionHash: txHash,
                blockNumber: 0,
                secondTransactionHash: "",
                secondBlockNumber: 0,
                thirdTransactionHash: "",
                thirdBlockNumber: 0));
            Future.delayed(const Duration(seconds: 1), () {
              Toasts.showSuccessToast(lang.transactionSent,
                  lang.transactionSent2, isDark, direction);
              widget.contract.deleteContract();
              widget.setStatehandle();
              setState(() {});
            });
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            Toasts.showErrorToast(
                lang.toast13, lang.toasts30, isDark, direction);
          }
        },
        style: const ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
            elevation: WidgetStatePropertyAll(5),
            overlayColor: WidgetStatePropertyAll(Colors.transparent)),
        child: Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(widthQuery ? 15 : 10)),
            child: Center(
                child: Text(lang.escrow18,
                    style:
                        const TextStyle(fontSize: 18, color: Colors.white)))));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final direction = theme.textDirection;
    final locale = theme.langCode;
    final primaryColor =
        isDark ? Colors.white70 : Theme.of(context).colorScheme.primary;
    final walletAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(theme.startingChain);
    final addTransaction =
        Provider.of<TransactionsProvider>(context, listen: false)
            .addTransaction;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    const heightBox2 = SizedBox(height: 15);
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Directionality(
            textDirection: direction,
            child: SelectionArea(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(lang.escrow19,
                              style: TextStyle(
                                  color: isDark ? Colors.white60 : Colors.black,
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close,
                                  color:
                                      isDark ? Colors.white60 : Colors.black))
                        ],
                      ),
                    ),
                    Divider(color: isDark ? Colors.white60 : Colors.grey[300]),
                    Expanded(
                        child: ListView(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, bottom: 8),
                            children: [
                          const SizedBox(height: 5),
                          Text(widget.contract.escrowID,
                              style: TextStyle(color: primaryColor)),
                          const SizedBox(height: 5),
                          Center(
                            child: SizedBox(
                                height: 120,
                                width: double.infinity,
                                child: ExtendedImage.network(
                                    widget.contract.imageUrl,
                                    cache: true,
                                    enableLoadState: false)),
                          ),
                          heightBox2,
                          Center(
                              child: Text(widget.contract.coinName,
                                  style: TextStyle(color: primaryColor))),
                          heightBox2,
                          buildPropertyLabel(
                              lang.escrow20, primaryColor, isDark, widthQuery),
                          Text(Utils.removeTrailingZeros(widget.contract.amount
                              .toStringAsFixed(widget.contract.decimals))),
                          heightBox2,
                          buildPropertyLabel(
                              lang.escrow21, primaryColor, isDark, widthQuery),
                          Text(widget.contract.ownerAddress),
                          heightBox2,
                          buildPropertyLabel(
                              lang.escrow22, primaryColor, isDark, widthQuery),
                          Text(widget.contract.assetAddress),
                          heightBox2,
                          buildPropertyLabel(
                              lang.escrow23, primaryColor, isDark, widthQuery),
                          Text(Utils.timeStamp(
                              widget.contract.dateCreated, locale, context)),
                          heightBox2,
                          buildPropertyLabel(
                              lang.escrow24, primaryColor, isDark, widthQuery),
                          ...widget.contract.bids.map((e) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Text(e.bidderAddress))),
                          heightBox2,
                          Divider(
                              color: isDark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade300),
                          NetworkFee(
                            isInTransfers: false,
                            currentTransfer: null,
                            isSpecialCase: false,
                            isPaymentFee: false,
                            isInInstallmentFee: false,
                            isPaymentWithdrawals: false,
                            setFee: (f) {
                              networkFee = f;
                              setState(() {});
                            },
                            isTrust: false,
                            isTrustCreation: false,
                            isTrustModification: false,
                            isBridge: false,
                            isEscrow: true,
                            isRefuel: false,
                            ownerLength: 0,
                            benefLength: 0,
                            setState: () {
                              setState(() {});
                            },
                            setBridgeNativeGas: (_) {},
                            bridgeDestinationAsset: null,
                            isEscrowCreation: false,
                            isEscrowDeletion: true,
                          ),
                          heightBox2,
                          Text(lang.escrow32,
                              style: TextStyle(
                                  color:
                                      isDark ? Colors.white60 : Colors.grey)),
                          const SizedBox(height: 5),
                          buildDeleteButton(widthQuery, lang, walletAddress,
                              isDark, direction, addTransaction),
                          const SizedBox(height: 8),
                          SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom)
                        ]))
                  ]),
            )));
  }
}
