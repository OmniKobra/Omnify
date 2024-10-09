// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omnify/models/escrow_contract.dart';
import 'package:provider/provider.dart';

import '../../crypto/utils/chain_utils.dart';
import '../../crypto/features/escrow_utils.dart';
import '../../languages/app_language.dart';
import '../../models/asset.dart';
import '../../models/transaction.dart';
import '../../providers/theme_provider.dart';
import '../../providers/transactions_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../toasts.dart';
import '../../utils.dart';
import '../../validators.dart';
import '../asset_picker.dart';
import '../common/asset_fee.dart';
import '../common/network_fee.dart';
import '../common/omnify_fee.dart';

class NewContractSheet extends StatefulWidget {
  final bool isBid;
  final Chain contractChain;
  final EscrowContract? contract;
  const NewContractSheet(
      {super.key,
      required this.isBid,
      required this.contractChain,
      required this.contract});

  @override
  State<NewContractSheet> createState() => _NewContractSheetState();
}

class _NewContractSheetState extends State<NewContractSheet> {
  Decimal omnifyFee = Decimal.parse("0.0");
  Decimal networkFee = Decimal.parse("0.0");
  Decimal total = Decimal.parse("0.0");
  Chain c = Chain.Avalanche;
  late CryptoAsset a1;
  late CryptoAsset a2;
  final formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  DropdownMenuItem<Chain> buildLangButtonItem(
      Chain value, AppLanguage lang, bool widthQuery, bool isDark, bool isC1) {
    final walletAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(value);
    return DropdownMenuItem<Chain>(
      value: value,
      onTap: () async {
        final val = await Provider.of<ThemeProvider>(context, listen: false)
            .setStartingChain(value, context, walletAddress);
        if (val) {
          setState(() {
            if (isC1) {
              c = value;
              a1 = Utils.generateNativeToken(value);
              amountController.clear();
            } else {}
          });
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
      AppLanguage lang, bool isC1, List<Chain> supportedChains) {
    return DropdownButton(
        dropdownColor: isDark ? Colors.black : Colors.white,
        // key: UniqueKey(),
        elevation: 8,
        menuMaxHeight: widthQuery ? 500 : 450,
        onChanged: supportedChains.isEmpty ? null : (_) => setState(() {}),
        underline: Container(color: Colors.transparent),
        icon: Icon(Icons.arrow_drop_down,
            color: isDark ? Colors.white70 : Colors.black),
        value: current,
        items: supportedChains
            .map((c) => buildLangButtonItem(c, lang, widthQuery, isDark, isC1))
            .toList());
  }

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
  Widget buildTitle(String label, bool isDark, bool widthQuery) => Text(label,
      style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black,
          fontSize: widthQuery ? 17 : 14,
          fontWeight: FontWeight.bold));

  Widget buildField(bool isDark, TextEditingController controller) {
    final decimals = widget.isBid ? a2.decimals : a1.decimals;
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: TextFormField(
          onChanged: (_) {
            setState(() {});
          },
          controller: controller,
          validator: Validators.giveAmountValidator(context, decimals),
          keyboardType: TextInputType.number,
          inputFormatters: [
            if (decimals > 0) DecimalTextInputFormatter(decimalRange: decimals),
            if (decimals > 0)
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
            if (decimals < 1) FilteringTextInputFormatter.allow(RegExp('[0-9]'))
          ],
          decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
              floatingLabelBehavior: FloatingLabelBehavior.never),
        ));
  }

  Widget buildButton(
      Color primaryColor,
      bool widthQuery,
      String doneLabel,
      AppLanguage lang,
      String walletAddress,
      bool isDark,
      TextDirection direction,
      void Function(Transaction) addTransaction) {
    return TextButton(
        onPressed: () async {
          setState(() {});
          if (formKey.currentState!.validate()) {
            final theme = Provider.of<ThemeProvider>(context, listen: false);
            final client = theme.client;
            final wcClient = theme.walletClient;
            final sessionTopic = theme.stateSessionTopic;
            Decimal amount = Decimal.parse(amountController.text);
            Utils.showLoadingDialog(context, lang, widthQuery);
            late CryptoAsset asset;
            if (widget.isBid) {
              asset = a2;
              Future<void> _conduct() async {
                final txHash = await EscrowUtils.submitBid(
                    c: c,
                    client: client,
                    wcClient: wcClient,
                    sessionTopic: sessionTopic,
                    walletAddress: walletAddress,
                    id: widget.contract!.escrowID,
                    asset: asset,
                    amount: amount);
                if (txHash != null) {
                  addTransaction(Transaction(
                      c: c,
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
                  });
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Toasts.showErrorToast(
                      lang.toast13, lang.toasts30, isDark, direction);
                }
              }

              final coinBalance = await ChainUtils.getAssetBalance(
                  c, walletAddress, asset, client);
              if (coinBalance < amount) {
                Toasts.showErrorToast(lang.toasts26,
                    lang.toasts27 + "\$${asset.symbol}", isDark, direction);
                Navigator.pop(context);
              } else {
                if (asset.address == Utils.zeroAddress) {
                  _conduct();
                } else {
                  final contractAllowance = await ChainUtils.getErcAllowance(
                      c: c,
                      client: client,
                      owner: walletAddress,
                      asset: asset,
                      isTransfers: false,
                      isTrust: false,
                      isBridges: false,
                      isEscrow: true,
                      isDark: isDark,
                      widthQuery: widthQuery,
                      dir: direction,
                      lang: lang,
                      popDialog: () {
                        Navigator.pop(context);
                      });
                  if (contractAllowance < amount) {
                    Toasts.showInfoToast(lang.toasts20,
                        lang.toastMsg + "\$${asset.symbol}", isDark, direction);
                    await ChainUtils.requestApprovals(
                        c: c,
                        client: client,
                        wcClient: wcClient,
                        keys: [asset.address],
                        allowances: {asset.address: amount},
                        isTransfers: false,
                        isTrust: false,
                        isBridges: false,
                        isEscrow: true,
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
            } else {
              asset = a1;
              Future<void> _conduct() async {
                final now = DateTime.now();
                final id = Utils.generateID(walletAddress, now);
                final txHash = await EscrowUtils.createEscrowContract(
                    c: c,
                    client: client,
                    wcClient: wcClient,
                    sessionTopic: sessionTopic,
                    walletAddress: walletAddress,
                    id: id,
                    asset: asset,
                    amount: amount,
                    omnifyFee: omnifyFee);
                if (txHash != null) {
                  addTransaction(Transaction(
                      c: c,
                      type: TransactionType.escrow,
                      id: id,
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
                  });
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Toasts.showErrorToast(
                      lang.toast13, lang.toasts30, isDark, direction);
                }
              }

              final coinBalance = await ChainUtils.getAssetBalance(
                  c, walletAddress, asset, client);
              if (coinBalance < amount) {
                Toasts.showErrorToast(lang.toasts26,
                    lang.toasts27 + "\$${asset.symbol}", isDark, direction);
                Navigator.pop(context);
              } else {
                if (asset.address == Utils.zeroAddress) {
                  _conduct();
                } else {
                  final contractAllowance = await ChainUtils.getErcAllowance(
                      c: c,
                      client: client,
                      owner: walletAddress,
                      asset: asset,
                      isTransfers: false,
                      isTrust: false,
                      isBridges: false,
                      isEscrow: true,
                      isDark: isDark,
                      widthQuery: widthQuery,
                      dir: direction,
                      lang: lang,
                      popDialog: () {
                        Navigator.pop(context);
                      });
                  if (contractAllowance < amount) {
                    Toasts.showInfoToast(lang.toasts20,
                        lang.toastMsg + "\$${asset.symbol}", isDark, direction);
                    await ChainUtils.requestApprovals(
                        c: c,
                        client: client,
                        wcClient: wcClient,
                        keys: [asset.address],
                        allowances: {asset.address: amount},
                        isTransfers: false,
                        isTrust: false,
                        isBridges: false,
                        isEscrow: true,
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
          }
        },
        style: const ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
            elevation: WidgetStatePropertyAll(5),
            overlayColor: WidgetStatePropertyAll(Colors.transparent)),
        child: Container(
            height: 40,
            width: widthQuery ? 100 : 75,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(widthQuery ? 10 : 7)),
            child: Center(
                child: Text(doneLabel,
                    style: TextStyle(
                        fontSize: widthQuery ? 15 : 13,
                        color: Colors.white)))));
  }

  @override
  void initState() {
    super.initState();
    c = Provider.of<ThemeProvider>(context, listen: false).startingChain;
    a1 = Utils.generateNativeToken(c);
    a2 = Utils.generateNativeToken(widget.contractChain);
  }

  void calculateTotal() {
    total = Decimal.parse("0.0");
    var amount = Decimal.tryParse(amountController.text) ?? Decimal.parse("0");
    if (!widget.isBid) {
      total += omnifyFee;
      if (a1.address == Utils.zeroAddress) {
        total += amount;
      }
    } else {
      if (a2.address == Utils.zeroAddress) {
        total += amount;
      }
    }
    total += networkFee;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final direction = theme.textDirection;
    final walletAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(theme.startingChain);
    final supportedChains =
        Provider.of<WalletProvider>(context).supportedChains;
    final addTransaction =
        Provider.of<TransactionsProvider>(context, listen: false)
            .addTransaction;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    const heightBox1 = SizedBox(height: 10);
    const heightBox2 = SizedBox(height: 15);
    calculateTotal();
    return Form(
      key: formKey,
      child: GestureDetector(
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
                            Text(widget.isBid ? lang.escrow9 : lang.escrow10,
                                style: TextStyle(
                                    color:
                                        isDark ? Colors.white60 : Colors.black,
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
                      Divider(
                          color: isDark ? Colors.white60 : Colors.grey[300]),
                      Expanded(
                          child: SingleChildScrollView(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, bottom: 8),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    if (!widget.isBid)
                                      buildTitle(
                                          lang.escrow11, isDark, widthQuery),
                                    if (!widget.isBid) heightBox1,
                                    if (!widget.isBid)
                                      buildNetworkPicker(c, isDark, widthQuery,
                                          lang, true, supportedChains),
                                    if (!widget.isBid) heightBox2,
                                    buildTitle(
                                        lang.escrow12, isDark, widthQuery),
                                    heightBox1,
                                    AssetPicker(
                                        isTransfers: false,
                                        currentAsset: widget.isBid ? a2 : a1,
                                        changeCurrentAsset: widget.isBid
                                            ? (a) {
                                                setState(() {
                                                  a2 = a;
                                                });
                                              }
                                            : (a) {
                                                setState(() {
                                                  a1 = a;
                                                });
                                              },
                                        isTrust: false,
                                        isBridgeSource: false,
                                        isTransferActivity: false,
                                        isJustDisplaying: false),
                                    heightBox2,
                                    buildTitle(
                                        lang.escrow13, isDark, widthQuery),
                                    heightBox1,
                                    buildField(isDark, amountController),
                                    heightBox2,
                                    Divider(
                                        color: isDark
                                            ? Colors.grey.shade600
                                            : Colors.grey.shade300),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: AssetFee(
                                            currentChain: c,
                                            asset: widget.isBid ? a2 : a1,
                                            amount: Decimal.tryParse(
                                                    amountController.text) ??
                                                Decimal.parse("0"),
                                            isSpecialCase: false)),
                                    NetworkFee(
                                        isInTransfers: false,
                                        currentTransfer: null,
                                        isSpecialCase: false,
                                        isPaymentFee: false,
                                        isInInstallmentFee: false,
                                        isPaymentWithdrawals: false,
                                        setFee: (f) {
                                          networkFee = f;
                                          calculateTotal();
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
                                        isEscrowCreation: !widget.isBid,
                                        isEscrowDeletion: false),
                                    if (!widget.isBid)
                                      OmnifyFee(
                                          label: lang.escrow15,
                                          isSpecialCase: false,
                                          isInTransfers: false,
                                          isPaymentFee: false,
                                          isInInstallmentFee: false,
                                          isTrust: false,
                                          isTrustModifying: false,
                                          isTrustCreating: false,
                                          isBridge: false,
                                          isEscrow: true,
                                          isRefuel: false,
                                          currentTransfer: null,
                                          newBeneficiaries: 0,
                                          setState: () {
                                            setState(() {});
                                          },
                                          setFee: (f) {
                                            omnifyFee = f;
                                            calculateTotal();
                                          }),
                                    buildFee(lang.escrow16, total, widthQuery,
                                        c, isDark),
                                    heightBox2,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        buildButton(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            widthQuery,
                                            lang.escrow17,
                                            lang,
                                            walletAddress,
                                            isDark,
                                            direction,
                                            addTransaction)
                                      ],
                                    ),
                                    SizedBox(
                                        height: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom)
                                  ])))
                    ]),
              ))),
    );
  }
}
