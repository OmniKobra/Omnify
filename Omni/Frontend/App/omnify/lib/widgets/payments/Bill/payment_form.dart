// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../crypto/features/payment_utils.dart';
import '../../../languages/app_language.dart';
import '../../../models/transaction.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/transactions_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../toasts.dart';
import '../../../utils.dart';
import '../../../validators.dart';
import '../../common/field_suffix.dart';
import '../../common/network_fee.dart';
import '../../common/omnify_fee.dart';

class PaymentForm extends StatefulWidget {
  final bool isRequest;
  final void Function(Decimal, Decimal, Decimal, Decimal, Decimal, int, Chain,
      bool, String, Decimal, Decimal)? changeViewMode;
  const PaymentForm(
      {required this.isRequest, required this.changeViewMode, super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final formKey = GlobalKey<FormState>();
  bool isFullPayment = true;
  bool isInstallments = false;
  Decimal amountPerMonth = Decimal.parse('0.0');
  Decimal finalMonthAmount = Decimal.parse('0.0');
  Decimal networkFee = Decimal.parse('0.0');
  Decimal installmentFee = Decimal.parse('0.0');
  Decimal omnifyFee = Decimal.parse('0.0');
  Chain c = Chain.Avalanche;
  final TextEditingController vendor = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController downpayment = TextEditingController();
  final TextEditingController period = TextEditingController();
  void clearForm() {
    vendor.clear();
    amount.clear();
    if (isInstallments) {
      period.clear();
      downpayment.clear();
      isInstallments = false;
      isFullPayment = true;
      amountPerMonth = Decimal.parse('0.0');
      finalMonthAmount = Decimal.parse('0.0');
    }
    setState(() {});
  }

  DropdownMenuItem<Chain> buildLangButtonItem(
      Chain value, AppLanguage lang, bool widthQuery, bool isDark) {
    final walletAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(value);
    return DropdownMenuItem<Chain>(
      value: value,
      onTap: () async {
        if (c != value) {
          final val = await Provider.of<ThemeProvider>(context, listen: false)
              .setStartingChain(value, context, walletAddress);
          if (val) {
            clearForm();
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
      AppLanguage lang, List<Chain> supportedChains) {
    return DropdownButton(
        dropdownColor: isDark ? Colors.grey[800] : Colors.white,
        // key: UniqueKey(),
        elevation: 8,
        menuMaxHeight: widthQuery ? 500 : 450,
        onChanged: supportedChains.isEmpty ? null : (_) => setState(() {}),
        underline: Container(color: Colors.transparent),
        icon: Icon(Icons.arrow_drop_down,
            color: isDark ? Colors.white70 : Colors.black),
        value: current,
        items: supportedChains
            .map((c) => buildLangButtonItem(c, lang, widthQuery, isDark))
            .toList());
  }

  Widget buildTitle(String label, bool isDark, bool widthQuery) => Text(label,
      style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black,
          fontSize: widthQuery ? 17 : 14,
          fontWeight: FontWeight.bold));

  Widget buildField(
      AppLanguage lang,
      bool isDark,
      TextEditingController controller,
      String? Function(String?)? validator,
      bool isPeriod,
      [TextInputType? keyboardType]) {
    final decimals = Utils.nativeTokenDecimals(c);
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          onChanged: keyboardType != null ? (_) => setState(() {}) : null,
          inputFormatters: [
            if (keyboardType == null)
              LengthLimitingTextInputFormatter(
                  Validators.giveChainMaxLength(c, controller.text)),
            if (keyboardType == null)
              TextInputFormatter.withFunction(
                (TextEditingValue oldValue, TextEditingValue newValue) {
                  return Validators.giveChainAddressRegexp(c, newValue.text)
                          .hasMatch(newValue.text)
                      ? newValue
                      : newValue.text == ''
                          ? const TextEditingValue(text: '')
                          : oldValue;
                },
              ),
            if (keyboardType != null && !isPeriod)
              DecimalTextInputFormatter(decimalRange: decimals),
            if (keyboardType != null && !isPeriod)
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
            if (keyboardType != null && isPeriod)
              LengthLimitingTextInputFormatter(3),
            if (keyboardType != null && isPeriod)
              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
          ],
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: keyboardType == null
                  ? AddressFieldSuffix(
                      showScanButton: true,
                      copyHandler: () async {
                        final data =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (data != null && data.text != null) {
                          var validationResult = validator!(data.text);
                          if (validationResult == null) {
                            controller.text = data.text!;
                          } else {
                            Toasts.showErrorToast(
                                lang.addressValidator,
                                lang.toast10,
                                isDark,
                                Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .textDirection);
                          }
                        }
                      },
                      scannerHandler: (_) {
                        var validationResult = validator!(_);
                        if (validationResult == null) {
                          controller.text = _;
                          Navigator.pop(context);
                        } else {
                          Toasts.showErrorToast(
                              lang.addressValidator,
                              lang.toast9,
                              isDark,
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .textDirection);
                        }
                      })
                  : null,
              filled: true,
              fillColor: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
              floatingLabelBehavior: FloatingLabelBehavior.never),
        ));
  }

  Widget buildCheckBox(bool value, String label, bool isDark, bool widthQuery,
          bool isInstallment) =>
      ListTile(
          visualDensity: VisualDensity.comfortable,
          hoverColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          leading: Checkbox(
              value: value,
              onChanged: (_) {
                if (_ == true) {
                  if (isInstallment) {
                    isFullPayment = false;
                    isInstallments = _!;
                  } else {
                    isInstallments = false;
                    isFullPayment = _!;
                  }
                } else {
                  if (isInstallment) {
                    isFullPayment = true;
                    isInstallments = _!;
                  } else {
                    isInstallments = true;
                    isFullPayment = _!;
                  }
                }
                setState(() {});
              },
              hoverColor: Colors.transparent,
              splashRadius: 0),
          horizontalTitleGap: 5,
          title: Text(label,
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black,
                fontSize: widthQuery ? 16 : 14,
              )));

  Widget buildFee(String label, Decimal amount, bool widthQuery, bool isDark,
      bool isPeriod, int period, int decimals) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13.25, color: isDark ? Colors.white60 : Colors.grey)),
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isPeriod)
                SizedBox(
                    child: Utils.buildNetworkLogo(
                        widthQuery, Utils.feeLogo(c), true, true)),
              if (!isPeriod) const SizedBox(width: 5),
              Text(
                  isPeriod
                      ? period.toString()
                      : Utils.removeTrailingZeros(
                          amount.toStringAsFixed(decimals)),
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14))
            ])
      ],
    );
  }

  Widget buildPayButton(
      bool widthQuery,
      Color primaryColor,
      AppLanguage lang,
      bool walletConnected,
      void Function(BuildContext) connectWallet,
      String walletAddress,
      bool isDark,
      TextDirection direction,
      void Function(Transaction) addTransaction) {
    return TextButton(
        onPressed: walletConnected
            ? () async {
                FocusScope.of(context).unfocus();
                if (formKey.currentState!.validate()) {
                  if (widget.isRequest) {
                    final amountParam = isInstallments
                        ? Decimal.parse(downpayment.text)
                        : Decimal.parse(amount.text);
                    final id = Utils.generateID(walletAddress, DateTime.now());
                    widget.changeViewMode!(
                        amountParam,
                        amountPerMonth,
                        installmentFee,
                        networkFee,
                        omnifyFee,
                        int.tryParse(period.text) ?? 0,
                        c,
                        isInstallments,
                        id,
                        Decimal.parse(amount.text),
                        finalMonthAmount);
                  } else {
                    Utils.showLoadingDialog(context, lang, widthQuery);
                    final now = DateTime.now();
                    final id = Utils.generateID(walletAddress, now);
                    final paymentAmount = isInstallments
                        ? Decimal.parse(downpayment.text)
                        : Decimal.parse(amount.text);
                    final theme =
                        Provider.of<ThemeProvider>(context, listen: false);
                    final client = theme.client;
                    final wcClient = theme.walletClient;
                    final sessionTopic = theme.stateSessionTopic;
                    final txHash = await PaymentUtils.makePayement(
                        c: c,
                        client: client,
                        wcClient: wcClient,
                        sessionTopic: sessionTopic,
                        walletAddress: walletAddress,
                        id: id,
                        amountDue: paymentAmount,
                        omnifyFee: omnifyFee,
                        vendorAddress: vendor.text,
                        isInstallments: isInstallments,
                        fullAmount: Decimal.parse(amount.text),
                        period: int.tryParse(period.text) ?? 0,
                        lang: lang,
                        dir: direction,
                        isDark: isDark);
                    if (txHash != null) {
                      addTransaction(Transaction(
                          c: c,
                          type: TransactionType.payment,
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
                        clearForm();
                      });
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Toasts.showErrorToast(
                          lang.toast13, lang.toasts30, isDark, direction);
                    }
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
                    ? Text(widget.isRequest ? lang.pay19 : lang.pay16,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white))
                    : Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(lang.home8,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white))
                      ]))));
  }

  Widget buildDisclaimer(bool widthQuery) {
    final lang = Utils.language(context);
    final dis = Text(lang.pay15,
        style: TextStyle(color: Colors.grey, fontSize: widthQuery ? 14 : 13));
    return widthQuery
        ? Row(
            children: [const Spacer(), dis, const Spacer()],
          )
        : dis;
  }

  @override
  void initState() {
    super.initState();
    c = Provider.of<ThemeProvider>(context, listen: false).startingChain;
  }

  @override
  void dispose() {
    super.dispose();
    vendor.dispose();
    amount.dispose();
    downpayment.dispose();
    period.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final wallet = Provider.of<WalletProvider>(context);
    final walletConnected = wallet.isWalletConnected;
    final supportedChains = wallet.supportedChains;
    final walletAddress =
        Provider.of<WalletProvider>(context, listen: false).getAddressString(c);
    final connectWallet =
        Provider.of<WalletProvider>(context, listen: false).connectWallet;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    final heightBox = SizedBox(height: widthQuery ? 10 : 5);
    const heightBox2 = SizedBox(height: 5);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    final addTransaction =
        Provider.of<TransactionsProvider>(context, listen: false)
            .addTransaction;
    final decimals = Utils.nativeTokenDecimals(c);
    if (isInstallments) {
      final _amount = Decimal.tryParse(amount.text) ?? Decimal.parse('0.0');
      final _downpayment =
          Decimal.tryParse(downpayment.text) ?? Decimal.parse('0.0');
      final _period = int.tryParse(period.text) ?? 0;
      final _remaining = _amount - _downpayment;
      if (_period > 0) {
        var buffer = _remaining / Decimal.fromInt(_period);
        amountPerMonth = buffer
            .toDecimal(scaleOnInfinitePrecision: decimals)
            .floor(scale: decimals);
        String stringAmount = amountPerMonth.toStringAsFixed(decimals);
        amountPerMonth = Decimal.parse(stringAmount);
        if (_period > 1) {
          final numberOfIncompleteInstallments = _period - 1;
          var _paidAfterInstallments =
              amountPerMonth * Decimal.parse("$numberOfIncompleteInstallments");
          var _remainsAfterInstallments =
              _amount - _downpayment - _paidAfterInstallments;
          finalMonthAmount = _remainsAfterInstallments;
        }
      } else {
        amountPerMonth = _remaining;
        finalMonthAmount = Decimal.parse("0");
      }
    }
    final Decimal _paymentDue = isInstallments
        ? Decimal.tryParse(downpayment.text) ?? Decimal.parse('0.0')
        : Decimal.tryParse(amount.text) ?? Decimal.parse('0.0');
    final Decimal total = _paymentDue + networkFee + omnifyFee;
    return Form(
      key: formKey,
      child: Expanded(
          child: Directionality(
              textDirection: dir,
              child: SingleChildScrollView(
                  child: Column(
                      children: widthQuery
                          ? [
                              Row(
                                  mainAxisAlignment: widthQuery
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  children: [
                                    if (widthQuery) const Spacer(flex: 1),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                          padding: widthQuery
                                              ? const EdgeInsets.all(8)
                                              : const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                          decoration: BoxDecoration(
                                              border: border,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: isDark
                                                  ? Colors.grey[800]
                                                  : Colors.white),
                                          child: buildNetworkPicker(
                                              c,
                                              isDark,
                                              widthQuery,
                                              lang,
                                              supportedChains)),
                                    ),
                                    if (widthQuery) const Spacer(flex: 1)
                                  ]),
                              heightBox,
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (isInstallments) const Spacer(flex: 2),
                                    if (!isInstallments) const Spacer(flex: 1),
                                    Expanded(
                                        flex: isInstallments ? 14 : 2,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              border: border,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: isDark
                                                  ? Colors.grey[800]
                                                  : Colors.white),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (!widget.isRequest)
                                                  buildTitle(lang.pay20, isDark,
                                                      widthQuery),
                                                if (!widget.isRequest)
                                                  heightBox2,
                                                if (!widget.isRequest)
                                                  buildField(
                                                      lang,
                                                      isDark,
                                                      vendor,
                                                      Validators
                                                          .giveAddressValidator(
                                                              context, c),
                                                      false),
                                                if (!widget.isRequest)
                                                  heightBox,
                                                buildTitle(lang.pay21, isDark,
                                                    widthQuery),
                                                heightBox2,
                                                Row(children: [
                                                  Utils.buildNetworkLogo(
                                                      widthQuery,
                                                      Utils.feeLogo(c),
                                                      true,
                                                      true),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                      child: buildField(
                                                          lang,
                                                          isDark,
                                                          amount,
                                                          Validators
                                                              .giveAmountValidator(
                                                                  context,
                                                                  decimals),
                                                          false,
                                                          TextInputType.number))
                                                ]),
                                                heightBox,
                                                buildTitle(lang.pay22, isDark,
                                                    widthQuery),
                                                buildCheckBox(
                                                    isFullPayment,
                                                    lang.pay23,
                                                    isDark,
                                                    widthQuery,
                                                    false),
                                                buildCheckBox(
                                                    isInstallments,
                                                    lang.pay24,
                                                    isDark,
                                                    widthQuery,
                                                    true),
                                              ]),
                                        )),
                                    if (isInstallments) const Spacer(flex: 2),
                                    if (isInstallments)
                                      Expanded(
                                        flex: 14,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              border: border,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: isDark
                                                  ? Colors.grey[800]
                                                  : Colors.white),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8),
                                                    child: Row(children: [
                                                      Text(lang.pay25,
                                                          style: TextStyle(
                                                              color: isDark
                                                                  ? Colors
                                                                      .white60
                                                                  : Colors
                                                                      .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  widthQuery
                                                                      ? 17
                                                                      : 16))
                                                    ])),
                                                Divider(
                                                    color: isDark
                                                        ? Colors.grey.shade700
                                                        : Colors.grey.shade200),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        buildTitle(lang.pay26,
                                                            isDark, widthQuery),
                                                        heightBox2,
                                                        Row(children: [
                                                          Utils
                                                              .buildNetworkLogo(
                                                                  widthQuery,
                                                                  Utils.feeLogo(
                                                                      c),
                                                                  true,
                                                                  true),
                                                          const SizedBox(
                                                              width: 10),
                                                          Expanded(
                                                              child: buildField(
                                                                  lang,
                                                                  isDark,
                                                                  downpayment,
                                                                  Validators.giveDownpaymentValidator(
                                                                      context,
                                                                      amount
                                                                          .text,
                                                                      decimals),
                                                                  false,
                                                                  TextInputType
                                                                      .number))
                                                        ]),
                                                        heightBox,
                                                        buildTitle(lang.pay27,
                                                            isDark, widthQuery),
                                                        heightBox2,
                                                        buildField(
                                                            lang,
                                                            isDark,
                                                            period,
                                                            Validators
                                                                .givePeriodValidator(
                                                                    context),
                                                            true,
                                                            TextInputType
                                                                .number),
                                                      ]),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    if (isInstallments) const Spacer(flex: 2),
                                    if (!isInstallments) const Spacer(flex: 1),
                                  ]),
                              heightBox,
                              Row(
                                children: [
                                  const Spacer(flex: 1),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: border,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: isDark
                                              ? Colors.grey[800]
                                              : Colors.white),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildFee(
                                                lang.pay8,
                                                _paymentDue,
                                                widthQuery,
                                                isDark,
                                                false,
                                                0,
                                                decimals),

                                            // if (isInstallments)
                                            //   OmnifyFee(
                                            //       label: lang.pay11,
                                            //       isSpecialCase: false,
                                            //       isInTransfers: false,
                                            //       isPaymentFee: false,
                                            //       isInInstallmentFee: true,
                                            //       isTrust: false,
                                            //       isBridge: false,
                                            //       isEscrow: false,
                                            //       isRefuel: false,
                                            //       currentTransfer: null,
                                            //       setState: () =>
                                            //           setState(() {}),
                                            //       setFee: (f) {
                                            //         installmentFee = f;
                                            //       }),
                                            if (isInstallments)
                                              buildFee(
                                                  lang.pay12,
                                                  amountPerMonth,
                                                  widthQuery,
                                                  isDark,
                                                  false,
                                                  0,
                                                  decimals),
                                            if (isInstallments)
                                              buildFee(
                                                  lang.pay53,
                                                  finalMonthAmount,
                                                  widthQuery,
                                                  isDark,
                                                  false,
                                                  0,
                                                  decimals),
                                            if (isInstallments)
                                              buildFee(
                                                  lang.pay13,
                                                  Decimal.parse('3'),
                                                  widthQuery,
                                                  isDark,
                                                  true,
                                                  int.tryParse(period.text) ??
                                                      0,
                                                  decimals),
                                            NetworkFee(
                                                isInTransfers: false,
                                                currentTransfer: null,
                                                isSpecialCase: false,
                                                isPaymentFee: true,
                                                isInInstallmentFee: false,
                                                isPaymentWithdrawals: false,
                                                setFee: (f) {
                                                  networkFee = f;
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
                                                setState: () =>
                                                    setState(() {})),
                                            OmnifyFee(
                                                label: lang.pay10,
                                                isSpecialCase: false,
                                                isInTransfers: false,
                                                isPaymentFee: true,
                                                isInInstallmentFee: false,
                                                isTrust: false,
                                                isTrustModifying: false,
                                                isTrustCreating: false,
                                                isBridge: false,
                                                isEscrow: false,
                                                isRefuel: false,
                                                newBeneficiaries: 0,
                                                currentTransfer: null,
                                                setState: () => setState(() {}),
                                                setFee: (f) {
                                                  omnifyFee = f;
                                                }),
                                            Divider(
                                                color: isDark
                                                    ? Colors.grey.shade600
                                                    : Colors.grey.shade300),
                                            buildFee(
                                                lang.pay14,
                                                total,
                                                widthQuery,
                                                isDark,
                                                false,
                                                0,
                                                decimals),
                                          ]),
                                    ),
                                  ),
                                  const Spacer(flex: 1),
                                ],
                              ),
                              if (walletConnected && !widget.isRequest)
                                heightBox,
                              if (walletConnected && !widget.isRequest)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(flex: 1),
                                    Expanded(
                                        flex: 2,
                                        child: Text(lang.pay15,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                    widthQuery ? 14 : 13))),
                                    const Spacer(flex: 1),
                                  ],
                                ),
                              heightBox,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(flex: 1),
                                  Expanded(
                                    flex: 2,
                                    child: buildPayButton(
                                        widthQuery,
                                        primaryColor,
                                        lang,
                                        walletConnected,
                                        connectWallet,
                                        walletAddress,
                                        isDark,
                                        dir,
                                        addTransaction),
                                  ),
                                  const Spacer(flex: 1),
                                ],
                              ),
                              const SizedBox(height: 8)
                            ]
                          : [
                              Row(
                                children: [
                                  Container(
                                      padding: widthQuery
                                          ? const EdgeInsets.all(8)
                                          : const EdgeInsets.symmetric(
                                              horizontal: 5),
                                      decoration: BoxDecoration(
                                          border: border,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: isDark
                                              ? Colors.grey[800]
                                              : Colors.white),
                                      child: buildNetworkPicker(c, isDark,
                                          widthQuery, lang, supportedChains)),
                                ],
                              ),
                              heightBox,
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: border,
                                      borderRadius: BorderRadius.circular(5),
                                      color: isDark
                                          ? Colors.grey[800]
                                          : Colors.white),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (!widget.isRequest)
                                          buildTitle(
                                              lang.pay20, isDark, widthQuery),
                                        if (!widget.isRequest) heightBox2,
                                        if (!widget.isRequest)
                                          buildField(
                                              lang,
                                              isDark,
                                              vendor,
                                              Validators.giveAddressValidator(
                                                  context, c),
                                              false),
                                        if (!widget.isRequest) heightBox,
                                        buildTitle(
                                            lang.pay21, isDark, widthQuery),
                                        heightBox2,
                                        Row(children: [
                                          Utils.buildNetworkLogo(widthQuery,
                                              Utils.feeLogo(c), true, true),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: buildField(
                                                  lang,
                                                  isDark,
                                                  amount,
                                                  Validators
                                                      .giveAmountValidator(
                                                          context, decimals),
                                                  false,
                                                  TextInputType.number))
                                        ]),
                                        heightBox,
                                        buildTitle(
                                            lang.pay22, isDark, widthQuery),
                                        buildCheckBox(isFullPayment, lang.pay23,
                                            isDark, widthQuery, false),
                                        buildCheckBox(
                                            isInstallments,
                                            lang.pay24,
                                            isDark,
                                            widthQuery,
                                            true),
                                      ])),
                              if (isInstallments) heightBox,
                              if (isInstallments)
                                Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                        border: border,
                                        borderRadius: BorderRadius.circular(5),
                                        color: isDark
                                            ? Colors.grey[800]
                                            : Colors.white),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Row(
                                              children: [
                                                Text(lang.pay25,
                                                    style: TextStyle(
                                                        color: isDark
                                                            ? Colors.white60
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: widthQuery
                                                            ? 17
                                                            : 16))
                                              ],
                                            ),
                                          ),
                                          Divider(
                                              color: isDark
                                                  ? Colors.grey.shade700
                                                  : Colors.grey.shade200),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  buildTitle(lang.pay26, isDark,
                                                      widthQuery),
                                                  heightBox2,
                                                  Row(children: [
                                                    Utils.buildNetworkLogo(
                                                        widthQuery,
                                                        Utils.feeLogo(c),
                                                        true,
                                                        true),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                        child: buildField(
                                                            lang,
                                                            isDark,
                                                            downpayment,
                                                            Validators
                                                                .giveDownpaymentValidator(
                                                                    context,
                                                                    amount.text,
                                                                    decimals),
                                                            false,
                                                            TextInputType
                                                                .number))
                                                  ]),
                                                  heightBox,
                                                  buildTitle(lang.pay27, isDark,
                                                      widthQuery),
                                                  heightBox2,
                                                  buildField(
                                                      lang,
                                                      isDark,
                                                      period,
                                                      Validators
                                                          .givePeriodValidator(
                                                              context),
                                                      true,
                                                      TextInputType.number),
                                                ]),
                                          ),
                                        ])),
                              heightBox,
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: border,
                                      borderRadius: BorderRadius.circular(5),
                                      color: isDark
                                          ? Colors.grey[800]
                                          : Colors.white),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildFee(
                                            lang.pay8,
                                            _paymentDue,
                                            widthQuery,
                                            isDark,
                                            false,
                                            0,
                                            decimals),

                                        // if (isInstallments)
                                        //   OmnifyFee(
                                        //       label: lang.pay11,
                                        //       isSpecialCase: false,
                                        //       isInTransfers: false,
                                        //       isPaymentFee: false,
                                        //       isInInstallmentFee: true,
                                        //       isTrust: false,
                                        //       isBridge: false,
                                        //       isEscrow: false,
                                        //       isRefuel: false,
                                        //       currentTransfer: null,
                                        //       setState: () =>
                                        //           setState(() {}),
                                        //       setFee: (f) {
                                        //         installmentFee = f;
                                        //       }),
                                        if (isInstallments)
                                          buildFee(
                                              lang.pay12,
                                              amountPerMonth,
                                              widthQuery,
                                              isDark,
                                              false,
                                              0,
                                              decimals),
                                        if (isInstallments)
                                          buildFee(
                                              lang.pay53,
                                              finalMonthAmount,
                                              widthQuery,
                                              isDark,
                                              false,
                                              0,
                                              decimals),
                                        if (isInstallments)
                                          buildFee(
                                              lang.pay13,
                                              Decimal.parse('3'),
                                              widthQuery,
                                              isDark,
                                              true,
                                              int.tryParse(period.text) ?? 0,
                                              decimals),
                                        NetworkFee(
                                            isInTransfers: false,
                                            currentTransfer: null,
                                            isSpecialCase: false,
                                            isPaymentFee: true,
                                            isInInstallmentFee: false,
                                            isPaymentWithdrawals: false,
                                            setFee: (f) {
                                              networkFee = f;
                                            },
                                            isTrust: false,
                                            isBridge: false,
                                            isEscrow: false,
                                            isRefuel: false,
                                            isTrustCreation: false,
                                            isTrustModification: false,
                                            setBridgeNativeGas: (_) {},
                                            bridgeDestinationAsset: null,
                                            benefLength: 0,
                                            ownerLength: 0,
                                            setState: () => setState(() {})),
                                        OmnifyFee(
                                            label: lang.pay10,
                                            isSpecialCase: false,
                                            isInTransfers: false,
                                            isPaymentFee: true,
                                            isInInstallmentFee: false,
                                            isTrust: false,
                                            isTrustModifying: false,
                                            isTrustCreating: false,
                                            isBridge: false,
                                            isEscrow: false,
                                            isRefuel: false,
                                            newBeneficiaries: 0,
                                            currentTransfer: null,
                                            setState: () => setState(() {}),
                                            setFee: (f) {
                                              omnifyFee = f;
                                            }),
                                        Divider(
                                            color: isDark
                                                ? Colors.grey.shade600
                                                : Colors.grey.shade300),
                                        buildFee(lang.pay14, total, widthQuery,
                                            isDark, false, 0, decimals),
                                      ])),
                              if (walletConnected && !widget.isRequest)
                                heightBox,
                              if (walletConnected && !widget.isRequest)
                                buildDisclaimer(widthQuery),
                              heightBox,
                              buildPayButton(
                                  widthQuery,
                                  primaryColor,
                                  lang,
                                  walletConnected,
                                  connectWallet,
                                  walletAddress,
                                  isDark,
                                  dir,
                                  addTransaction),
                              const SizedBox(height: 8),
                            ])))),
    );
  }
}
