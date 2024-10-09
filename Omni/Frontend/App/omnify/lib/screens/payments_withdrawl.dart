// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../languages/app_language.dart';
import '../models/transaction.dart' as otx;
import '../providers/theme_provider.dart';
import '../providers/transactions_provider.dart';
import '../providers/wallet_provider.dart';
import '../crypto/features/payment_utils.dart';
import '../toasts.dart';
import '../utils.dart';
import '../validators.dart';
import '../widgets/common/refresh_indicator.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/network_fee.dart';

class PaymentWithdrawalScreen extends StatefulWidget {
  const PaymentWithdrawalScreen({super.key});

  @override
  State<PaymentWithdrawalScreen> createState() =>
      _PaymentWithdrawalScreenState();
}

class _PaymentWithdrawalScreenState extends State<PaymentWithdrawalScreen> {
  Chain c = Chain.Avalanche;
  final TextEditingController amount = TextEditingController();
  Decimal currentBalance = Decimal.parse("0.0");
  Decimal networkFee = Decimal.parse("0.0");
  Future<void>? getBalance;
  final formKey = GlobalKey<FormState>();
  Widget buildBalance(String label, bool isDark, bool widthQuery, Chain c) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(label, isDark, widthQuery),
        const SizedBox(height: 15),
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
                Utils.removeTrailingZeros(currentBalance
                    .toStringAsFixed(Utils.nativeTokenDecimals(c))),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widthQuery ? 18 : 15))
          ],
        ),
      ],
    );
  }

  Widget buildField(bool isDark, TextEditingController controller) {
    final int decimals = Utils.nativeTokenDecimals(c);
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          validator: Validators.giveWithdrawalAmountValidator(
              context, currentBalance, decimals),
          inputFormatters: [
            DecimalTextInputFormatter(decimalRange: decimals),
            FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
          ],
          decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
              floatingLabelBehavior: FloatingLabelBehavior.never),
        ));
  }

  Widget buildLogo(
          bool isDark, bool widthQuery, TextDirection dir, String label) =>
      Directionality(
        textDirection: dir,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios,
                    color: isDark ? Colors.white70 : Colors.black)),
            SizedBox(
                height: 60,
                width: 60,
                child: ExtendedImage.network(Utils.payUrl,
                    cache: true, enableLoadState: false)),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widthQuery ? 20 : 17)),
          ],
        ),
      );
  DropdownMenuItem<Chain> buildLangButtonItem(Chain value, AppLanguage lang,
      bool widthQuery, bool isDark, Web3Client client) {
    return DropdownMenuItem<Chain>(
      value: value,
      onTap: () async {
        if (c != value) {
          final wallet = Provider.of<WalletProvider>(context, listen: false);
          final walletAddress = wallet.getAddressString(value);
          final val = await Provider.of<ThemeProvider>(context, listen: false)
              .setStartingChain(value, context, walletAddress);
          if (val) {
            amount.clear();
            currentBalance = Decimal.parse("0.0");
            final _wallet = Provider.of<WalletProvider>(context, listen: false);
            if (_wallet.isWalletConnected) {
              setState(() {
                getBalance = _getBalance(_wallet.getAddressString(value));
              });
            }
            setState(() {
              c = value;
            });
          }
        }
      },
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Utils.buildNetworkLogo(widthQuery, value, true),
            const SizedBox(width: 7.5),
            Text(value.name,
                style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black,
                    fontSize: widthQuery ? 17 : 15))
          ]),
    );
  }

  Widget buildNetworkPicker(Chain current, bool isDark, bool widthQuery,
          AppLanguage lang, List<Chain> supportedChains, Web3Client client) =>
      DropdownButton(
          dropdownColor: isDark ? Colors.grey[800] : Colors.white,
          menuMaxHeight: widthQuery ? 500 : 450,
          elevation: 8,
          onChanged: supportedChains.isEmpty ? null : (_) => setState(() {}),
          underline: Container(color: Colors.transparent),
          icon: Icon(Icons.arrow_drop_down,
              color: isDark ? Colors.white70 : Colors.black),
          value: current,
          items: supportedChains
              .map((c) =>
                  buildLangButtonItem(c, lang, widthQuery, isDark, client))
              .toList());

  Widget buildTitle(String label, bool isDark, bool widthQuery) => Text(label,
      style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black,
          fontSize: widthQuery ? 17 : 14,
          fontWeight: FontWeight.bold));

  Widget buildWithdrawButton(
      bool widthQuery,
      Color primaryColor,
      AppLanguage lang,
      bool walletConnected,
      void Function(BuildContext) connectWallet,
      TextDirection direction,
      bool isDark,
      void Function(otx.Transaction) addTransaction,
      String walletAddress) {
    return Builder(builder: (context) {
      return TextButton(
          onPressed: walletConnected
              ? () async {
                  FocusScope.of(context).unfocus();
                  if (formKey.currentState!.validate()) {
                    Utils.showLoadingDialog(context, lang, widthQuery);
                    final theme =
                        Provider.of<ThemeProvider>(context, listen: false);
                    final client = theme.client;
                    final wcClient = theme.walletClient;
                    final sessionTopic = theme.stateSessionTopic;
                    final withdrawalAmount = Decimal.parse(amount.text);
                    final txHash = await PaymentUtils.withdrawBalance(
                        c: c,
                        walletAddress: walletAddress,
                        amount: withdrawalAmount,
                        client: client,
                        wcClient: wcClient,
                        sessionTopic: sessionTopic,
                        lang: lang,
                        isDark: isDark,
                        dir: direction);
                    if (txHash != null) {
                      currentBalance -= withdrawalAmount;
                      final now = DateTime.now();
                      addTransaction(otx.Transaction(
                          c: c,
                          type: otx.TransactionType.payment,
                          id: txHash,
                          date: now,
                          status: otx.Status.omnifyReceived,
                          transactionHash: txHash,
                          blockNumber: 0,
                          secondTransactionHash: "",
                          secondBlockNumber: 0,
                          thirdTransactionHash: "",
                          thirdBlockNumber: 0));
                      Future.delayed(const Duration(seconds: 1), () {
                        Toasts.showSuccessToast(lang.transactionSent,
                            lang.transactionSent2, isDark, direction);
                      });
                      amount.clear();
                      Navigator.pop(context);
                      setState(() {});
                    } else {
                      Navigator.pop(context);
                      Toasts.showErrorToast(
                          lang.toast13, lang.toasts30, isDark, direction);
                    }
                  }
                }
              : () => connectWallet(context),
          style: const ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
              elevation: WidgetStatePropertyAll(5),
              overlayColor: WidgetStatePropertyAll(Colors.transparent)),
          child: Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(widthQuery ? 15 : 10)),
              child: Center(
                  child: walletConnected
                      ? Text(lang.trust35,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white))
                      : Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(lang.home8,
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.white))
                        ]))));
    });
  }

  Widget buildWithdrawalAddress(bool widthQuery, bool isDark, String vendor) {
    final lang = Utils.language(context);
    final container = Container(
        padding: const EdgeInsets.all(8),
        width: null,
        decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Text(
          "${lang.pay28}  $vendor",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white60 : Colors.black,
              fontSize: widthQuery ? 18 : 16),
        ));
    return container;
  }

  Future<void> _getBalance(String walletAddress) async {
    //TODO WE DELAY THE CALL HERE SO THAT THE THEME SETCHAIN CALL COMPLETES AND CHANGES THE CLIENT
    return Future.delayed(const Duration(milliseconds: 500), () {
      final client = Provider.of<ThemeProvider>(context, listen: false).client;
      return PaymentUtils.fetchBalance(c, walletAddress, client).then((d) {
        currentBalance = d;
        if (mounted) setState(() {});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    c = theme.startingChain;
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final walletConnected = walletProvider.isWalletConnected;
    final walletAddress = walletProvider.getAddressString(c);
    if (walletConnected && getBalance == null) {
      getBalance = _getBalance(walletAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final walletMethods = Provider.of<WalletProvider>(context, listen: false);
    final walletConnected = walletProvider.isWalletConnected;
    final walletAddress = walletMethods.getAddressString(c);
    if (walletConnected && getBalance == null) {
      getBalance = _getBalance(walletAddress);
    }
    if (!walletConnected && getBalance != null) {
      currentBalance = Decimal.parse("0.0");
      getBalance = null;
    }
    final connectWallet =
        Provider.of<WalletProvider>(context, listen: false).connectWallet;
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    final heightBox = SizedBox(height: widthQuery ? 10 : 5);
    const heightBox2 = SizedBox(height: 15);
    const transparent = WidgetStatePropertyAll(Colors.transparent);
    final addTransaction =
        Provider.of<TransactionsProvider>(context, listen: false)
            .addTransaction;
    final supportedChains = walletProvider.supportedChains;
    final container = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildBalance(lang.pay29, isDark, widthQuery, c),
              heightBox2,
              heightBox2,
              buildTitle(lang.pay30, isDark, widthQuery),
              heightBox2,
              Row(children: [
                Utils.buildNetworkLogo(
                    widthQuery, Utils.feeLogo(c), true, true),
                const SizedBox(width: 10),
                Expanded(child: buildField(isDark, amount)),
                const SizedBox(width: 10),
                TextButton(
                    style: const ButtonStyle(
                        overlayColor: transparent,
                        shadowColor: transparent,
                        backgroundColor: transparent),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      amount.text = currentBalance
                          .toStringAsFixed(Utils.nativeTokenDecimals(c));
                    },
                    child: Text(lang.pay31))
              ]),
              heightBox2,
              NetworkFee(
                  isInTransfers: false,
                  currentTransfer: null,
                  isSpecialCase: false,
                  isPaymentFee: false,
                  isInInstallmentFee: false,
                  isPaymentWithdrawals: true,
                  setFee: (f) {
                    setState(() {
                      networkFee = f;
                    });
                  },
                  isTrust: false,
                  isBridge: false,
                  isEscrow: false,
                  isRefuel: false,
                  isTrustCreation: false,
                  isTrustModification: false,
                  benefLength: 0,
                  ownerLength: 0,
                  setBridgeNativeGas: (_) {},
                  bridgeDestinationAsset: null,
                  setState: () => setState(() {}))
            ]));
    return SelectionArea(
      child: Scaffold(
          appBar: null,
          body: Form(
            key: formKey,
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Column(children: [
                          buildLogo(isDark, widthQuery, dir, lang.pay32),
                          Directionality(
                            textDirection: dir,
                            child: Expanded(
                                child: FutureBuilder(
                                    future: getBalance,
                                    builder: (ctx, snap) {
                                      if (snap.connectionState ==
                                          ConnectionState.waiting) {
                                        return const MyLoading();
                                      }
                                      if (snap.hasError) {
                                        return MyError(() {
                                          setState(() {
                                            getBalance =
                                                _getBalance(walletAddress);
                                          });
                                        });
                                      }
                                      return MyRefresh(
                                        onRefresh: () async {
                                          setState(() {
                                            getBalance =
                                                _getBalance(walletAddress);
                                          });
                                        },
                                        child: SingleChildScrollView(
                                            child: Column(children: [
                                          Row(
                                              mainAxisAlignment: widthQuery
                                                  ? MainAxisAlignment.center
                                                  : MainAxisAlignment.start,
                                              children: [
                                                if (widthQuery)
                                                  const Spacer(flex: 1),
                                                if (widthQuery)
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                        padding: widthQuery
                                                            ? const EdgeInsets
                                                                .all(8)
                                                            : const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5),
                                                        decoration: BoxDecoration(
                                                            border: border,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: isDark
                                                                ? Colors
                                                                    .grey[800]
                                                                : Colors.white),
                                                        child:
                                                            buildNetworkPicker(
                                                                c,
                                                                isDark,
                                                                widthQuery,
                                                                lang,
                                                                supportedChains,
                                                                theme.client)),
                                                  ),
                                                if (widthQuery)
                                                  const Spacer(flex: 1),
                                                if (!widthQuery)
                                                  Container(
                                                      padding: widthQuery
                                                          ? const EdgeInsets
                                                              .all(8)
                                                          : const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 5),
                                                      decoration: BoxDecoration(
                                                          border: border,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: isDark
                                                              ? Colors.grey[800]
                                                              : Colors.white),
                                                      child: buildNetworkPicker(
                                                          c,
                                                          isDark,
                                                          widthQuery,
                                                          lang,
                                                          supportedChains,
                                                          theme.client))
                                              ]),
                                          heightBox,
                                          if (widthQuery)
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Spacer(flex: 1),
                                                  Expanded(
                                                      flex: 2,
                                                      child: container),
                                                  const Spacer(flex: 1),
                                                ]),
                                          if (!widthQuery) container,
                                          if (walletConnected) heightBox,
                                          if (walletConnected && widthQuery)
                                            Row(
                                              children: [
                                                const Spacer(flex: 1),
                                                Expanded(
                                                    flex: 2,
                                                    child:
                                                        buildWithdrawalAddress(
                                                            widthQuery,
                                                            isDark,
                                                            walletAddress)),
                                                const Spacer(flex: 1),
                                              ],
                                            ),
                                          if (walletConnected && !widthQuery)
                                            buildWithdrawalAddress(widthQuery,
                                                isDark, walletAddress),
                                          heightBox,
                                          if (widthQuery)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Spacer(flex: 1),
                                                Expanded(
                                                  flex: 2,
                                                  child: buildWithdrawButton(
                                                      widthQuery,
                                                      primaryColor,
                                                      lang,
                                                      walletConnected,
                                                      connectWallet,
                                                      dir,
                                                      isDark,
                                                      addTransaction,
                                                      walletAddress),
                                                ),
                                                const Spacer(flex: 1),
                                              ],
                                            ),
                                          if (!widthQuery)
                                            buildWithdrawButton(
                                                widthQuery,
                                                primaryColor,
                                                lang,
                                                walletConnected,
                                                connectWallet,
                                                dir,
                                                isDark,
                                                addTransaction,
                                                walletAddress),
                                          const SizedBox(height: 8)
                                        ])),
                                      );
                                    })),
                          )
                        ])))),
          )),
    );
  }
}
