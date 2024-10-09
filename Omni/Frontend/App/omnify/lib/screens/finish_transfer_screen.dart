// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:omnify/crypto/features/transfer_utils.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../languages/app_language.dart';
import '../models/asset.dart';
import '../models/transaction.dart' as oTxn;
import '../models/transfer.dart';
import '../providers/fees_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/transactions_provider.dart';
import '../providers/transfers_provider.dart';
import '../providers/wallet_provider.dart';
import '../toasts.dart';
import '../utils.dart';
import '../widgets/asset_picker.dart';
import '../widgets/common/network_fee.dart';
import '../widgets/common/omnify_fee.dart';
import '../widgets/common/asset_fee.dart';

class FinishTransferScreen extends StatefulWidget {
  const FinishTransferScreen({super.key});

  @override
  State<FinishTransferScreen> createState() => _FinishTransferScreenState();
}

class _FinishTransferScreenState extends State<FinishTransferScreen> {
  Decimal totalTotal = Decimal.parse("0");
  Widget buildAssetPicker(
          bool widthQuery, bool isDark, CryptoAsset currentAsset) =>
      Container(
          padding: widthQuery
              ? const EdgeInsets.all(0)
              : const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              border: widthQuery
                  ? null
                  : Border.all(
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(5),
              color: isDark ? Colors.grey[800] : Colors.white),
          child: AssetPicker(
              isTransfers: true,
              currentAsset: currentAsset,
              changeCurrentAsset: (_) {},
              isTrust: false,
              isBridgeSource: false,
              isTransferActivity: false,
              isJustDisplaying: true));

  // buildAssetBox(String label, bool widthQuery, bool isDark,
  //         CryptoAsset currentAsset) =>
  //     SizedBox(
  //       height: 75,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           buildTitle(label, isDark, widthQuery),
  //           SizedBox(
  //               width: 150,
  //               child: buildAssetPicker(widthQuery, isDark, currentAsset))
  //         ],
  //       ),
  //     );

  Widget buildField(bool isDark, TextEditingController? controller,
      [String? id]) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Text(controller != null ? controller.text.trim() : id!));
  }

  Widget buildFieldBox(String label, bool isDark, bool widthQuery,
      TextEditingController controller) {
    return SizedBox(
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(label, isDark, widthQuery),
          SizedBox(child: buildField(isDark, controller))
        ],
      ),
    );
  }

  Widget buildTitle(String label, bool isDark, bool widthQuery) => Text(label,
      style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black,
          fontSize: widthQuery ? 17 : 14,
          fontWeight: FontWeight.bold));

  Widget buildFee(
      String label, Decimal amount, bool widthQuery, Chain c, bool isDark) {
    return widthQuery
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
            height: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white60 : Colors.grey)),
                const SizedBox(height: 7),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Utils.buildNetworkLogo(
                            widthQuery, Utils.feeLogo(c), true, true)),
                    const SizedBox(width: 10),
                    Text(
                        Utils.removeTrailingZeros(amount
                            .toStringAsFixed(Utils.nativeTokenDecimals(c))),
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17))
                  ],
                ),
              ],
            ))
        : Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 13.25,
                      color: isDark ? Colors.white60 : Colors.grey)),
              Expanded(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          child: Utils.buildNetworkLogo(
                              widthQuery, Utils.feeLogo(c), true, true)),
                      const SizedBox(width: 5),
                      Text(
                          Utils.removeTrailingZeros(amount
                              .toStringAsFixed(Utils.nativeTokenDecimals(c))),
                          style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14))
                    ]),
              )
            ],
          );
  }

  String giveDate(TransferFormModel t, AppLanguage lang) {
    String padder(String s) {
      return s.padLeft(2, "0");
    }

    String time = t.am ? lang.schedule6 : lang.schedule7;
    return "${padder(t.day.text.trim())}/${padder(t.month.text.trim())}/${padder(t.year.text.trim())} - ${padder(t.hour.text.trim())}:${padder(t.minute.text.trim())} $time";
  }

  Widget buildTransfer(
      AppLanguage lang,
      TransferFormModel currentTransfer,
      bool widthQuery,
      TextDirection direction,
      bool isDark,
      Chain chain,
      Color primaryColor,
      int ind,
      int length) {
    const heightBox = SizedBox(height: 15);
    const heightBox2 = SizedBox(height: 5);
    return Directionality(
      textDirection: direction,
      child: Container(
          height: widthQuery ? 750 : 540,
          width: widthQuery ? 420 : double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(5),
              color: isDark ? Colors.grey[800] : Colors.white),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            // borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text("$ind/$length",
                              style: const TextStyle(color: Colors.white))),
                    ]),
                buildTitle(lang.table6, isDark, widthQuery),
                heightBox2,
                buildField(isDark, null, currentTransfer.id),
                heightBox,
                buildTitle(lang.transfer6, isDark, widthQuery),
                heightBox2,
                buildAssetPicker(widthQuery, isDark, currentTransfer.asset),
                heightBox,
                buildTitle(lang.transfer7, isDark, widthQuery),
                heightBox2,
                buildField(isDark, currentTransfer.recipient),
                heightBox,
                buildTitle(lang.transfer8, isDark, widthQuery),
                heightBox2,
                buildField(isDark, currentTransfer.amount),
                heightBox,
                buildTitle(lang.transfer9, isDark, widthQuery),
                heightBox2,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        currentTransfer.isScheduled
                            ? giveDate(currentTransfer, lang)
                            : lang.transfer10,
                        style: TextStyle(
                            fontStyle: currentTransfer.isScheduled
                                ? FontStyle.italic
                                : FontStyle.normal))
                  ],
                ),
                Divider(
                    color:
                        isDark ? Colors.grey.shade600 : Colors.grey.shade300),
                if (widthQuery)
                  Wrap(children: [
                    AssetFee(
                        currentChain: chain,
                        asset: currentTransfer.asset,
                        amount: Decimal.tryParse(currentTransfer.amount.text) ??
                            Decimal.parse("0"),
                        isSpecialCase: true),
                    NetworkFee(
                      isInTransfers: true,
                      currentTransfer: currentTransfer,
                      isSpecialCase: true,
                      isPaymentFee: false,
                      isInInstallmentFee: false,
                      isPaymentWithdrawals: false,
                      isTrust: false,
                      isBridge: false,
                      isEscrow: false,
                      isRefuel: false,
                      isTrustCreation: false,
                      isTrustModification: false,
                      benefLength: 0,
                      ownerLength: 0,
                      setState: stateRecalculationLogic,
                      setFee: (_) {},
                      setBridgeNativeGas: (_) {},
                      bridgeDestinationAsset: null,
                    ),
                    OmnifyFee(
                      label: lang.transfer3,
                      isSpecialCase: true,
                      isInTransfers: true,
                      isPaymentFee: false,
                      isInInstallmentFee: false,
                      isTrust: false,
                      isTrustModifying: false,
                      isTrustCreating: false,
                      isBridge: false,
                      isEscrow: false,
                      isRefuel: false,
                      currentTransfer: currentTransfer,
                      setState: stateRecalculationLogic,
                      newBeneficiaries: 0,
                      setFee: (_) {},
                    ),
                    // buildFee(
                    //     lang.transfer4, 0.000000001, widthQuery, chain, isDark),
                    buildFee(lang.transfer5, currentTransfer.totalFee,
                        widthQuery, chain, isDark)
                  ]),
                if (!widthQuery)
                  AssetFee(
                      currentChain: chain,
                      asset: currentTransfer.asset,
                      amount: Decimal.tryParse(currentTransfer.amount.text) ??
                          Decimal.parse("0"),
                      isSpecialCase: true),
                if (!widthQuery)
                  NetworkFee(
                      isInTransfers: true,
                      currentTransfer: currentTransfer,
                      isSpecialCase: true,
                      isPaymentFee: false,
                      isInInstallmentFee: false,
                      isPaymentWithdrawals: false,
                      isTrust: false,
                      isBridge: false,
                      isEscrow: false,
                      isRefuel: false,
                      isTrustCreation: false,
                      isTrustModification: false,
                      benefLength: 0,
                      ownerLength: 0,
                      setState: stateRecalculationLogic,
                      setBridgeNativeGas: (_) {},
                      bridgeDestinationAsset: null,
                      setFee: (_) {}),
                if (!widthQuery)
                  OmnifyFee(
                    label: lang.transfer3,
                    isSpecialCase: true,
                    isInTransfers: true,
                    isPaymentFee: false,
                    isInInstallmentFee: false,
                    isTrust: false,
                    isTrustModifying: false,
                    isTrustCreating: false,
                    isBridge: false,
                    isEscrow: false,
                    isRefuel: false,
                    currentTransfer: currentTransfer,
                    setState: stateRecalculationLogic,
                    newBeneficiaries: 0,
                    setFee: (_) {},
                  ),
                // if (!widthQuery)
                // buildFee(
                //     lang.transfer4, 0.000000001, widthQuery, chain, isDark),
                if (!widthQuery)
                  buildFee(lang.transfer5, currentTransfer.totalFee, widthQuery,
                      chain, isDark),
              ])),
    );
  }

  Future<void> conductTransfers({
    required Chain c,
    required String sessionTopic,
    required Web3Client client,
    required Web3App wcClient,
    required List<TransferFormModel> transfers,
    required bool widthQuery,
    required bool isDark,
    required TextDirection direction,
    required AppLanguage lang,
    required void Function(oTxn.Transaction) addTransaction,
    required String walletAddress,
  }) async {
    try {
      Utils.showLoadingDialog(context, lang, widthQuery);
      final txn = await TransferUtils.conductTransfers(
          c, transfers, sessionTopic, wcClient, walletAddress, client);
      if (txn != null) {
        for (var t in transfers) {
          final now = DateTime.now();
          addTransaction(oTxn.Transaction(
              c: c,
              type: oTxn.TransactionType.transfer,
              id: t.id,
              date: now,
              status: oTxn.Status.pending,
              transactionHash: txn,
              blockNumber: 0,
              secondTransactionHash: "",
              secondBlockNumber: 0,
              thirdTransactionHash: "",
              thirdBlockNumber: 0));
          Future.delayed(const Duration(seconds: 1), () {
            Toasts.showSuccessToast(
                lang.transactionSent, lang.transactionSent2, isDark, direction);
          });
        }
        Navigator.popUntil(context, (route) => route.isFirst);
        Provider.of<TransfersProvider>(context, listen: false)
            .clearTransfers(walletAddress);
      } else {
        Navigator.pop(context);
        Toasts.showErrorToast(lang.toast13, lang.toasts30, isDark, direction);
      }
    } catch (e) {
      Navigator.pop(context);
      Toasts.showErrorToast(lang.toast13, lang.toasts30, isDark, direction);
    }
  }

  void stateRecalculationLogic() {
    totalTotal = Decimal.parse("0.0");
    final transferProvider =
        Provider.of<TransfersProvider>(context, listen: false);
    final transfers = transferProvider.transfers;
    for (var transfer in transfers) {
      transfer.calculateTotalFee();
      totalTotal += transfer.totalFee;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    final transferProvider =
        Provider.of<TransfersProvider>(context, listen: false);
    final transfers = transferProvider.transfers;
    final feesProvider = Provider.of<FeesProvider>(context, listen: false);
    final tier1 = feesProvider.transferFeeTier1;
    final tier2 = feesProvider.transferFeeTier2;
    final tier3 = feesProvider.transferFeeTier3;
    final tier4 = feesProvider.transferFeeTier4;
    final tiers = [tier1, tier2, tier3, tier4];
    final altcoinFee = feesProvider.altcoinTransferFee;
    for (var transfer in transfers) {
      transfer.checkTierMatch(transfer.amount.text, tiers, altcoinFee, () {});
      totalTotal += transfer.totalFee;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final theme = Provider.of<ThemeProvider>(context);
    final client = theme.client;
    final isDark = theme.isDark;
    final direction = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final transferProvider = Provider.of<TransfersProvider>(context);
    final transfers = transferProvider.transfers;
    final chain = transferProvider.currentChain;
    final walletAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(chain);
    final lang = Utils.language(context);
    final addTransaction =
        Provider.of<TransactionsProvider>(context, listen: false)
            .addTransaction;
    return Directionality(
      textDirection: direction,
      child: SelectionArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: isDark ? Colors.grey[800] : Colors.white,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: true,
              leading: IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios,
                      color: isDark ? Colors.white70 : Colors.black)),
            ),
            body: SafeArea(
                child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      if (widthQuery)
                        Directionality(
                          textDirection: direction,
                          child: Wrap(spacing: 20, runSpacing: 20, children: [
                            ...transfers.map((e) => buildTransfer(
                                lang,
                                e,
                                widthQuery,
                                direction,
                                isDark,
                                chain,
                                primaryColor,
                                transfers.indexOf(e) + 1,
                                transfers.length))
                          ]),
                        ),
                      if (!widthQuery)
                        ...transfers.map((e) => Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: buildTransfer(
                                  lang,
                                  e,
                                  widthQuery,
                                  direction,
                                  isDark,
                                  chain,
                                  primaryColor,
                                  transfers.indexOf(e) + 1,
                                  transfers.length),
                            )),
                    ],
                  ),
                ),
                Directionality(
                  textDirection: direction,
                  child: Container(
                      height: 60,
                      width: double.infinity,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(5),
                        color: isDark ? Colors.grey[800] : Colors.white,
                      ),
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      child: Utils.buildNetworkLogo(widthQuery,
                                          Utils.feeLogo(chain), true, true)),
                                  const SizedBox(width: 5),
                                  Text(
                                      Utils.removeTrailingZeros(
                                          totalTotal.toStringAsFixed(
                                              Utils.nativeTokenDecimals(
                                                  chain))),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: widthQuery ? 20 : 16))
                                ]),
                            const SizedBox(width: 10),
                            TextButton(
                                onPressed: () async {
                                  await conductTransfers(
                                      c: chain,
                                      client: client,
                                      sessionTopic: theme.stateSessionTopic,
                                      wcClient: theme.walletClient,
                                      transfers: transfers,
                                      widthQuery: widthQuery,
                                      isDark: isDark,
                                      direction: direction,
                                      lang: lang,
                                      addTransaction: addTransaction,
                                      walletAddress: walletAddress);
                                },
                                style: const ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.all(0)),
                                    elevation: WidgetStatePropertyAll(5),
                                    overlayColor: WidgetStatePropertyAll(
                                        Colors.transparent)),
                                child: Container(
                                    height: 40,
                                    width: widthQuery ? 100 : 75,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(
                                            widthQuery ? 10 : 7)),
                                    child: Center(
                                        child: Text(lang.finish,
                                            style: TextStyle(
                                                fontSize: widthQuery ? 15 : 13,
                                                color: Colors.white)))))
                          ])),
                )
              ],
            ))),
      ),
    );
  }
}
