// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/utils/images.dart';

import '../languages/app_language.dart';
import '../models/deposit.dart';
import '../models/transaction.dart';
import '../providers/theme_provider.dart';
import '../providers/transactions_provider.dart';
import '../providers/trusts_provider.dart';
import '../providers/wallet_provider.dart';
import '../toasts.dart';
import '../utils.dart';
import '../validators.dart';
import '../crypto/features/trust_utils.dart';
import '../widgets/common/noglow.dart';
import '../widgets/home/wallet_button.dart';
import '../widgets/network_picker.dart';
import '../widgets/asset_picker.dart';
import '../widgets/trust/search_bar.dart';

class WithdrawalTab extends StatefulWidget {
  const WithdrawalTab({super.key});

  @override
  State<WithdrawalTab> createState() => _WithdrawalTabState();
}

class _WithdrawalTabState extends State<WithdrawalTab>
    with AutomaticKeepAliveClientMixin {
  final withdrawalFormKey = GlobalKey<FormState>();
  final withdrawalAmount = TextEditingController();
  Widget buildAssetPicker(bool widthQuery, bool isDark, Deposit theDeposit) =>
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              border: widthQuery
                  ? null
                  : Border.all(
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(5),
              color: isDark ? Colors.grey[800] : Colors.white),
          child: AssetPicker(
              isTransfers: false,
              currentAsset: theDeposit.asset,
              changeCurrentAsset: (_) {},
              isTrust: false,
              isBridgeSource: false,
              isTransferActivity: false,
              isJustDisplaying: true));

  Widget buildNetworkPicker(bool widthQuery, bool isDark) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: widthQuery
              ? null
              : Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5),
          color: isDark ? Colors.grey[800] : Colors.white),
      child: const NetworkPicker(
          isExplorer: false,
          isTransfers: false,
          isPayments: false,
          isTrust: true,
          isBridgeSource: false,
          isBridgeTarget: false,
          isEscrow: false,
          isTransferActivity: false,
          isPaymentActivity: false,
          isTrustActivity: false,
          isBridgeActivity: false,
          isEscrowActivity: false,
          isTransactions: false,
          isDiscoverTransfers: false,
          isDiscoverPayments: false,
          isDiscoverTrust: false,
          isDiscoverBridges: false,
          isDiscoverEscrow: false));

  buildBox(String label, bool widthQuery, bool isDark, String textValue) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: widthQuery ? 87 : 75,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black,
                  fontSize: widthQuery ? 16 : 13,
                  fontWeight: FontWeight.bold)),
          Text(textValue)
        ],
      ),
    );
  }

  Widget buildTitle(String label, bool isDark, bool widthQuery) => Text(label,
      style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black,
          fontSize: widthQuery ? 17 : 14,
          fontWeight: FontWeight.bold));

  Widget buildID(String label, bool isDark, bool widthQuery) => Text(label,
      style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black,
          fontSize: widthQuery ? 19 : 16,
          fontWeight: FontWeight.bold));

  Widget buildWithdrawButton(
      Chain c,
      bool widthQuery,
      Color primaryColor,
      bool isDark,
      AppLanguage lang,
      TextDirection dir,
      bool walletConnected,
      void Function(BuildContext) connectWallet,
      String depositLabel,
      String? Function(String?)? amountValidator,
      TextDirection direction,
      void Function(Transaction) addTransaction,
      String walletAddress,
      Deposit _currentDeposit) {
    return Center(
      child: TextButton(
          onPressed: walletConnected
              ? () {
                  FocusScope.of(context).unfocus();
                  var myBenef = _currentDeposit.beneficiaries
                      .firstWhere((b) => b.address == walletAddress);
                  final difference = DateTime.now()
                      .difference(myBenef.dateLastWithdrawal)
                      .inMinutes;
                  final remainder = 1440 - difference;
                  final bool canWithdrawToday =
                      myBenef.isLimited ? remainder <= 0 : true;
                  if (canWithdrawToday) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.custom,
                      customAsset: AppAnim.loading,
                      barrierDismissible: true,
                      confirmBtnColor: primaryColor,
                      backgroundColor:
                          isDark ? Colors.grey.shade800 : Colors.white,
                      titleColor: isDark ? Colors.white60 : Colors.black,
                      textColor: isDark ? Colors.white60 : Colors.black,
                      title: lang.withdrawal1,
                      text: lang.withdrawal2,
                      confirmBtnText: lang.finish,
                      showConfirmBtn: true,
                      widget: Form(
                          key: withdrawalFormKey,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: TextFormField(
                                      controller: withdrawalAmount,
                                      validator: amountValidator,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        if (_currentDeposit.asset.decimals > 0)
                                          DecimalTextInputFormatter(
                                              decimalRange: _currentDeposit
                                                  .asset.decimals),
                                        if (_currentDeposit.asset.decimals > 0)
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9.]')),
                                        if (_currentDeposit.asset.decimals < 1)
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]'))
                                      ],
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: isDark
                                              ? Colors.grey.shade600
                                              : Colors.grey.shade200,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never))))),
                      onConfirmBtnTap: () async {
                        if (withdrawalFormKey.currentState!.validate()) {
                          final _amount = Decimal.parse(withdrawalAmount.text);
                          final now = DateTime.now();
                          final theme = Provider.of<ThemeProvider>(context,
                              listen: false);
                          final client = theme.client;
                          final wcClient = theme.walletClient;
                          final sessionTopic = theme.stateSessionTopic;
                          Utils.showLoadingDialog(context, lang, widthQuery);
                          final txHash = await TrustUtils.withdrawFromDeposit(
                              c: c,
                              client: client,
                              wcClient: wcClient,
                              sessionTopic: sessionTopic,
                              id: _currentDeposit.id,
                              walletAddress: walletAddress,
                              asset: _currentDeposit.asset,
                              amount: _amount);
                          if (txHash != null) {
                            addTransaction(Transaction(
                                c: c,
                                type: TransactionType.trust,
                                id: txHash,
                                date: now,
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
                              withdrawalAmount.clear();
                              _currentDeposit.withdrawAmount(_amount);
                              myBenef.setHasWithdrawn();
                              setState(() {});
                            });
                            Navigator.popUntil(context, (r) => r.isFirst);
                          } else {
                            Navigator.pop(context);
                            Toasts.showErrorToast(
                                lang.toast13, lang.toasts30, isDark, direction);
                          }
                        }
                      },
                    );
                  } else {
                    Toasts.showInfoToast(
                        lang.toasts31,
                        lang.toasts32 + remainder.toString() + lang.toasts33,
                        isDark,
                        dir);
                  }
                }
              : () => connectWallet(context),
          style: const ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
              elevation: WidgetStatePropertyAll(5),
              overlayColor: WidgetStatePropertyAll(Colors.transparent)),
          child: Container(
              height: 50,
              width: widthQuery ? 400 : double.infinity,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(widthQuery ? 15 : 10)),
              child: Center(
                  child: walletConnected
                      ? Text(depositLabel,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white))
                      : Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(lang.home8,
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.white))
                        ])))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final direction = theme.textDirection;
    final locale = theme.langCode;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final trustProvider = Provider.of<TrustsProvider>(context);
    final focus = trustProvider.withdrawalFocus;
    final currentDeposit = trustProvider.withdrawalTabDeposit;
    final wallet = Provider.of<WalletProvider>(context);
    final walletConnected = wallet.isWalletConnected;
    final walletAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(theme.startingChain);
    final c = theme.startingChain;
    final walletHandler =
        Provider.of<WalletProvider>(context, listen: false).connectWallet;
    final addTransaction =
        Provider.of<TransactionsProvider>(context, listen: false)
            .addTransaction;
    const heightBox1 = SizedBox(height: 20, width: double.infinity);
    const heightBox2 = SizedBox(height: 5);
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    final beneficiaryCondition = currentDeposit == null
        ? false
        : walletConnected &&
            currentDeposit.beneficiaries
                .any((element) => element.address == walletAddress) &&
            currentDeposit.isActive;
    super.build(context);
    return Padding(
        padding: EdgeInsets.only(
            top: kToolbarHeight - 5,
            left: 8,
            right: 8,
            bottom: widthQuery ? 8 : 70),
        child: Directionality(
            textDirection: direction,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    buildNetworkPicker(widthQuery, isDark),
                    if (widthQuery) const SizedBox(width: 5),
                    if (widthQuery) const WalletButton()
                  ]),
                  const SizedBox(height: 5),
                  const TrustSearchBar(isWithdrawal: true),
                  const SizedBox(height: 5),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: border,
                            borderRadius: BorderRadius.circular(5),
                            color: isDark ? Colors.grey[800] : Colors.white,
                          ),
                          child: focus == TrustFocus.search
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          //Icons.manage_search_rounded
                                          Icon(Icons.publish_rounded,
                                              size: widthQuery ? 120 : 70),
                                        ],
                                      ),
                                      Center(
                                        child: Text(
                                          lang.trust26,
                                          style: TextStyle(
                                              fontSize: widthQuery ? 20 : 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Noglow(
                                  child: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildID(currentDeposit!.id, isDark,
                                            widthQuery),
                                        heightBox1,
                                        buildTitle(
                                            lang.transfer6, isDark, widthQuery),
                                        heightBox2,
                                        buildAssetPicker(
                                            widthQuery, isDark, currentDeposit),
                                        heightBox1,
                                        buildTitle(
                                            lang.trust28, isDark, widthQuery),
                                        heightBox2,
                                        Text(Utils.removeTrailingZeros(
                                            currentDeposit.amountInitial
                                                .toStringAsFixed(currentDeposit
                                                    .asset.decimals))),
                                        heightBox1,
                                        buildTitle(
                                            lang.trust29, isDark, widthQuery),
                                        heightBox2,
                                        Text(Utils.removeTrailingZeros(
                                            currentDeposit.amountRemaining
                                                .toStringAsFixed(currentDeposit
                                                    .asset.decimals))),
                                        if (beneficiaryCondition) heightBox1,
                                        if (beneficiaryCondition)
                                          buildTitle(
                                              lang.trust22, isDark, widthQuery),
                                        if (beneficiaryCondition) heightBox2,
                                        if (beneficiaryCondition)
                                          Text(currentDeposit.beneficiaries
                                                  .where((b) =>
                                                      b.address ==
                                                      walletAddress)
                                                  .toList()
                                                  .first
                                                  .isLimited
                                              ? Utils.removeTrailingZeros(
                                                  currentDeposit
                                                      .beneficiaries
                                                      .where((b) =>
                                                          b.address ==
                                                          walletAddress)
                                                      .toList()
                                                      .first
                                                      .allowancePerDay
                                                      .toStringAsFixed(
                                                          currentDeposit
                                                              .asset.decimals))
                                              : lang.trust24),
                                        heightBox1,
                                        buildTitle(
                                            lang.trust30, isDark, widthQuery),
                                        heightBox2,
                                        heightBox2,
                                        Wrap(children: [
                                          buildBox(
                                              lang.trust5,
                                              widthQuery,
                                              isDark,
                                              currentDeposit.isFixed
                                                  ? lang.trust6
                                                  : lang.trust7),
                                          buildBox(
                                              lang.trust8,
                                              widthQuery,
                                              isDark,
                                              currentDeposit.isRetractable
                                                  ? lang.trust9
                                                  : lang.trust10),
                                          buildBox(
                                              lang.trust11,
                                              widthQuery,
                                              isDark,
                                              currentDeposit.isActive
                                                  ? lang.trust12
                                                  : lang.trust13),
                                          buildBox(
                                              lang.trust31,
                                              widthQuery,
                                              isDark,
                                              Utils.timeStamp(
                                                  currentDeposit.dateCreated,
                                                  locale,
                                                  context)),
                                        ]),
                                        heightBox1,
                                        buildTitle(
                                            lang.trust16, isDark, widthQuery),
                                        heightBox2,
                                        ...currentDeposit.owners.map((e) => Row(
                                                children: [
                                                  Expanded(child: Text(e))
                                                ])),
                                        heightBox1,
                                        if (!walletConnected ||
                                            walletConnected &&
                                                currentDeposit.beneficiaries.any((element) =>
                                                    element.address ==
                                                    walletAddress) &&
                                                currentDeposit.isActive)
                                          buildWithdrawButton(
                                              c,
                                              widthQuery,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              isDark,
                                              lang,
                                              direction,
                                              walletConnected,
                                              walletHandler,
                                              lang.trust35,
                                              Validators.giveTrustWithdrawalValidator(
                                                  context,
                                                  currentDeposit.beneficiaries.where((b) => b.address == walletAddress).toList().isNotEmpty
                                                      ? currentDeposit.beneficiaries
                                                          .where((b) =>
                                                              b.address ==
                                                              walletAddress)
                                                          .toList()
                                                          .first
                                                          .allowancePerDay
                                                      : Decimal.parse("0"),
                                                  currentDeposit
                                                      .amountRemaining,
                                                  currentDeposit.beneficiaries
                                                          .where((b) =>
                                                              b.address ==
                                                              walletAddress)
                                                          .toList()
                                                          .isNotEmpty
                                                      ? currentDeposit.beneficiaries
                                                          .where((b) => b.address == walletAddress)
                                                          .toList()
                                                          .first
                                                          .isLimited
                                                      : true,
                                                  currentDeposit.asset.decimals),
                                              direction,
                                              addTransaction,
                                              walletAddress,
                                              currentDeposit)
                                      ]),
                                ))))
                ])));
  }

  @override
  bool get wantKeepAlive => true;
}
