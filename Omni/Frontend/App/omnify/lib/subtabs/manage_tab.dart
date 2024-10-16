// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:omnify/providers/fees_provider.dart';
import 'package:omnify/subtabs/deposit_tab.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../crypto/utils/chain_utils.dart';
import '../languages/app_language.dart';
import '../models/deposit.dart';
import '../models/transaction.dart';
import '../providers/transactions_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/trusts_provider.dart';
import '../providers/wallet_provider.dart';
import '../utils.dart';
import '../validators.dart';
import '../toasts.dart';
import '../crypto/features/trust_utils.dart';
import '../widgets/common/noglow.dart';
import '../widgets/home/wallet_button.dart';
import '../widgets/network_picker.dart';
import '../widgets/asset_picker.dart';
import '../widgets/trust/search_bar.dart';
import '../widgets/common/omnify_fee.dart';

class ManageTab extends StatefulWidget {
  final bool isSheet;
  final Deposit? deposit;
  const ManageTab({super.key, required this.isSheet, required this.deposit});

  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController depositAmount = TextEditingController();
  final GlobalKey<FormState> depositFormKey = GlobalKey<FormState>();
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

  Widget buildAssetPicker(bool widthQuery, bool isDark, Deposit theDeposit) =>
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
              isTransfers: false,
              currentAsset: theDeposit.asset,
              changeCurrentAsset: (_) {},
              isTrust: false,
              isBridgeSource: false,
              isTransferActivity: false,
              isJustDisplaying: true));

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

  Widget buildButton(
      Chain c,
      bool widthQuery,
      Color primaryColor,
      bool isDark,
      AppLanguage lang,
      bool walletConnected,
      void Function(BuildContext) connectWallet,
      String depositLabel,
      bool isModify,
      bool isDeposit,
      bool isRetract,
      Deposit? deposit,
      String? Function(String?)? amountValidator,
      String walletAddress,
      TextDirection direction,
      void Function(Transaction) addTransaction) {
    return Center(
      child: TextButton(
          onPressed: walletConnected
              ? () {
                  if (isModify) {
                    showModalBottomSheet(
                        context: context,
                        enableDrag: false,
                        useSafeArea: true,
                        constraints:
                            const BoxConstraints(maxHeight: double.infinity),
                        scrollControlDisabledMaxHeightRatio: 1,
                        backgroundColor:
                            isDark ? Colors.grey[800] : Colors.white,
                        // isScrollControlled: false,
                        builder: (_) {
                          return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: isDark
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade300),
                                  color:
                                      isDark ? Colors.grey[800] : Colors.white),
                              child: Column(children: [
                                Directionality(
                                    textDirection:
                                        Provider.of<ThemeProvider>(context)
                                            .textDirection,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 0),
                                              child: Text(lang.trust32,
                                                  style: TextStyle(
                                                      color: isDark
                                                          ? Colors.white60
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          const Spacer(),
                                          IconButton(
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(Icons.close,
                                                  color: isDark
                                                      ? Colors.white60
                                                      : Colors.black))
                                        ])),
                                Expanded(
                                    child: DepositTab(
                                        isModification: true,
                                        modificationDeposit: deposit,
                                        setsStateManage: () {
                                          setState(() {});
                                        }))
                              ]));
                        });
                  }
                  if (isDeposit) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.custom,
                      barrierDismissible: true,
                      confirmBtnColor: Colors.green,
                      backgroundColor:
                          isDark ? Colors.grey.shade800 : Colors.white,
                      titleColor: isDark ? Colors.white60 : Colors.black,
                      textColor: isDark ? Colors.white60 : Colors.black,
                      title: lang.manage1,
                      text: lang.manage2,
                      confirmBtnText: lang.finish,
                      customAsset: 'assets/omnitrust.png',
                      widget: Form(
                        key: depositFormKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: TextFormField(
                                    controller: depositAmount,
                                    validator: amountValidator,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      if (deposit!.asset.decimals > 0)
                                        DecimalTextInputFormatter(
                                            decimalRange:
                                                deposit.asset.decimals),
                                      if (deposit.asset.decimals > 0)
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9.]')),
                                      if (deposit.asset.decimals < 1)
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
                                            FloatingLabelBehavior.never),
                                  )),
                              const SizedBox(height: 5),
                              OmnifyFee(
                                  label: lang.transfer3,
                                  isSpecialCase: false,
                                  isInTransfers: false,
                                  isPaymentFee: false,
                                  isInInstallmentFee: false,
                                  isTrust: true,
                                  isTrustModifying: false,
                                  isTrustCreating: false,
                                  isBridge: false,
                                  isEscrow: false,
                                  isRefuel: false,
                                  currentTransfer: null,
                                  newBeneficiaries: 0,
                                  setState: () {},
                                  setFee: (_) {})
                            ],
                          ),
                        ),
                      ),
                      onConfirmBtnTap: () async {
                        if (depositFormKey.currentState!.validate()) {
                          setState(() {});
                          final now = DateTime.now();
                          final theme = Provider.of<ThemeProvider>(context,
                              listen: false);
                          final client = theme.client;
                          final wcClient = theme.walletClient;
                          final sessionTopic = theme.stateSessionTopic;
                          final _amount = Decimal.parse(depositAmount.text);
                          Utils.showLoadingDialog(context, lang, widthQuery);
                          final depositFee =
                              Provider.of<FeesProvider>(context, listen: false)
                                  .trustFees
                                  .amountPerDeposit;
                          Future<void> _conduct() async {
                            final txHash = await TrustUtils.depositIntoExisting(
                              c: c,
                              client: client,
                              wcClient: wcClient,
                              sessionTopic: sessionTopic,
                              omnifyFee: depositFee,
                              amount: _amount,
                              asset: deposit.asset,
                              id: deposit.id,
                              walletAddress: walletAddress,
                            );
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
                              Future.delayed(const Duration(seconds: 2), () {
                                Toasts.showSuccessToast(lang.transactionSent,
                                    lang.transactionSent2, isDark, direction);
                                depositAmount.clear();
                                deposit.depositAmount(_amount);
                                setState(() {});
                              });
                              if (!widget.isSheet) {
                                Navigator.popUntil(context, (r) => r.isFirst);
                              } else {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            } else {
                              Navigator.pop(context);
                              Toasts.showErrorToast(lang.toast13, lang.toasts30,
                                  isDark, direction);
                            }
                          }

                          if (deposit.asset.address == Utils.zeroAddress) {
                            final balance = await client.getBalance(
                                ChainUtils.ethAddressFromHex(c, walletAddress));
                            final balanceVal = ChainUtils.nativeUintToDecimal(
                                c, balance.getInWei);
                            if (balanceVal < _amount + depositFee) {
                              Toasts.showErrorToast(
                                  lang.toasts26,
                                  lang.toasts27 + "\$${deposit.asset.symbol}",
                                  isDark,
                                  direction);
                              Navigator.pop(context);
                            } else {
                              _conduct();
                            }
                          } else {
                            final coinBalance =
                                await ChainUtils.getAssetBalance(
                                    c, walletAddress, deposit.asset, client);
                            if (coinBalance < _amount) {
                              Toasts.showErrorToast(
                                  lang.toasts26,
                                  lang.toasts27 + "\$${deposit.asset.symbol}",
                                  isDark,
                                  direction);
                              Navigator.pop(context);
                            } else {
                              final contractAllowance =
                                  await ChainUtils.getErcAllowance(
                                      c: c,
                                      client: client,
                                      owner: walletAddress,
                                      asset: deposit.asset,
                                      isTransfers: false,
                                      isTrust: true,
                                      isBridges: false,
                                      isEscrow: false,
                                      isDark: isDark,
                                      widthQuery: widthQuery,
                                      dir: direction,
                                      lang: lang,
                                      popDialog: () {
                                        Navigator.pop(context);
                                      });
                              if (contractAllowance < _amount) {
                                Toasts.showInfoToast(
                                    lang.toasts20,
                                    lang.toastMsg + "\$${deposit.asset.symbol}",
                                    isDark,
                                    direction);
                                await ChainUtils.requestApprovals(
                                    c: c,
                                    client: client,
                                    wcClient: wcClient,
                                    keys: [deposit.asset.address],
                                    allowances: {
                                      deposit.asset.address: _amount
                                    },
                                    isTransfers: false,
                                    isTrust: true,
                                    isBridges: false,
                                    isEscrow: false,
                                    sessionTopic: sessionTopic,
                                    walletAddress: walletAddress,
                                    isDark: isDark,
                                    dir: direction,
                                    lang: lang);
                                Navigator.pop(context);
                              } else {
                                _conduct();
                              }
                            }
                          }
                        }
                      },
                    );
                  }

                  if (isRetract) {
                    QuickAlert.show(
                      context: context,
                      title: lang.manage3,
                      showCancelBtn: true,
                      type: QuickAlertType.error,
                      headerBackgroundColor: Colors.red,
                      backgroundColor:
                          isDark ? Colors.grey.shade800 : Colors.white,
                      titleColor: isDark ? Colors.white60 : Colors.black,
                      textColor: isDark ? Colors.white60 : Colors.black,
                      confirmBtnText: lang.manage4,
                      onConfirmBtnTap: () async {
                        setState(() {});
                        final now = DateTime.now();
                        final theme =
                            Provider.of<ThemeProvider>(context, listen: false);
                        final client = theme.client;
                        final wcClient = theme.walletClient;
                        final sessionTopic = theme.stateSessionTopic;
                        Utils.showLoadingDialog(context, lang, widthQuery);
                        final txHash = await TrustUtils.retractDeposit(
                            c: c,
                            client: client,
                            wcClient: wcClient,
                            sessionTopic: sessionTopic,
                            id: deposit!.id,
                            walletAddress: walletAddress);
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
                          Future.delayed(const Duration(seconds: 2), () {
                            Toasts.showSuccessToast(lang.transactionSent,
                                lang.transactionSent2, isDark, direction);
                            deposit.retractDeposit();
                            setState(() {});
                          });
                          if (!widget.isSheet) {
                            Navigator.popUntil(context, (r) => r.isFirst);
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        } else {
                          Navigator.pop(context);
                          Toasts.showErrorToast(
                              lang.toast13, lang.toasts30, isDark, direction);
                        }
                      },
                      confirmBtnColor: Colors.red,
                      cancelBtnText: lang.manage5,
                      text: lang.manage6,
                    );
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
  void dispose() {
    super.dispose();
    depositAmount.dispose();
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
    final focus = trustProvider.manageFocus;
    final currentDeposit =
        widget.isSheet ? widget.deposit : trustProvider.manageTabDeposit;
    final wallet = Provider.of<WalletProvider>(context);
    final walletConnected = wallet.isWalletConnected;
    final myAddress = Provider.of<WalletProvider>(context, listen: false)
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
    final isOwner = currentDeposit != null &&
        currentDeposit.owners.any((element) => element == myAddress);
    final modifyCondition =
        currentDeposit != null && walletConnected && isOwner;
    final depositCondition =
        currentDeposit != null && walletConnected && !currentDeposit.isFixed;
    final retractCondition = currentDeposit != null &&
        walletConnected &&
        currentDeposit.isRetractable &&
        isOwner &&
        currentDeposit.amountRemaining > Decimal.parse("0.0");
    super.build(context);
    return Padding(
        padding: EdgeInsets.only(
            top: widget.isSheet ? 8 : kToolbarHeight - 5,
            left: 8,
            right: 8,
            bottom: widget.isSheet
                ? 8
                : widthQuery
                    ? 8
                    : 70),
        child: Directionality(
            textDirection: direction,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isSheet)
                    Row(children: [
                      buildNetworkPicker(widthQuery, isDark),
                      if (widthQuery) const SizedBox(width: 5),
                      if (widthQuery) const WalletButton()
                    ]),
                  if (!widget.isSheet) const SizedBox(height: 5),
                  if (!widget.isSheet)
                    const TrustSearchBar(isWithdrawal: false),
                  if (widget.isSheet)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                  const SizedBox(height: 5),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: widget.isSheet ? null : border,
                            borderRadius: BorderRadius.circular(5),
                            color: isDark ? Colors.grey[800] : Colors.white,
                          ),
                          child: focus == TrustFocus.search && !widget.isSheet
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
                                          Icon(Icons.stream_rounded,
                                              size: widthQuery ? 120 : 70),
                                        ],
                                      ),
                                      Center(
                                        child: Text(
                                          lang.trust27,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildID(
                                        currentDeposit!.id, isDark, widthQuery),
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
                                        children: [Expanded(child: Text(e))])),
                                    heightBox1,
                                    if (!walletConnected)
                                      buildButton(
                                          c,
                                          widthQuery,
                                          Theme.of(context).colorScheme.primary,
                                          isDark,
                                          lang,
                                          walletConnected,
                                          walletHandler,
                                          "",
                                          false,
                                          false,
                                          false,
                                          null,
                                          Validators.giveAmountValidator(
                                              context,
                                              currentDeposit.asset.decimals),
                                          myAddress,
                                          direction,
                                          addTransaction),
                                    if (modifyCondition)
                                      buildButton(
                                          c,
                                          widthQuery,
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          isDark,
                                          lang,
                                          walletConnected,
                                          walletHandler,
                                          lang.trust32,
                                          true,
                                          false,
                                          false,
                                          currentDeposit,
                                          Validators.giveAmountValidator(
                                              context,
                                              currentDeposit.asset.decimals),
                                          myAddress,
                                          direction,
                                          addTransaction),
                                    if (depositCondition) heightBox2,
                                    if (depositCondition)
                                      buildButton(
                                          c,
                                          widthQuery,
                                          Colors.green,
                                          isDark,
                                          lang,
                                          walletConnected,
                                          walletHandler,
                                          lang.trust33,
                                          false,
                                          true,
                                          false,
                                          currentDeposit,
                                          Validators.giveAmountValidator(
                                              context,
                                              currentDeposit.asset.decimals),
                                          myAddress,
                                          direction,
                                          addTransaction),
                                    if (retractCondition) heightBox2,
                                    if (retractCondition)
                                      buildButton(
                                          c,
                                          widthQuery,
                                          Colors.red,
                                          isDark,
                                          lang,
                                          walletConnected,
                                          walletHandler,
                                          lang.trust34,
                                          false,
                                          false,
                                          true,
                                          currentDeposit,
                                          Validators.giveAmountValidator(
                                              context,
                                              currentDeposit.asset.decimals),
                                          myAddress,
                                          direction,
                                          addTransaction),
                                  ],
                                )))))
                ])));
  }

  @override
  bool get wantKeepAlive => true;
}
