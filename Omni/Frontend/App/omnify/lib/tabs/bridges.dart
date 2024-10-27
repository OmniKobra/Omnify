// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../crypto/features/bridge_utils.dart';
import '../crypto/utils/chain_utils.dart';
import '../languages/app_language.dart';
import '../models/transaction.dart';
import '../providers/bridges_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/transactions_provider.dart';
import '../providers/wallet_provider.dart';
import '../toasts.dart';
import '../utils.dart';
import '../validators.dart';
import '../widgets/asset_picker.dart';
import '../widgets/common/asset_fee.dart';
import '../widgets/common/field_suffix.dart';
import '../widgets/common/network_fee.dart';
import '../widgets/common/omnify_fee.dart';
import '../widgets/network_picker.dart';

class Bridges extends StatefulWidget {
  const Bridges({super.key});

  @override
  State<Bridges> createState() => _BridgesState();
}

class _BridgesState extends State<Bridges> with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormState>();
  Decimal omnifyFee = Decimal.parse("0.0");
  Decimal networkFee = Decimal.parse("0.0");
  Decimal nativeGas = Decimal.parse("0.0");
  Decimal total = Decimal.parse("0.0");
  late void Function() disposeAmountController;
  late void Function() disposeAddressController;

  Widget buildTitle(String label, bool isDark, bool widthQuery) => Text(label,
      style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black,
          fontSize: widthQuery ? 17 : 14,
          fontWeight: FontWeight.bold));

  Widget buildAssetPicker(bool widthQuery, bool isDark) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5),
          color: isDark ? Colors.grey[800] : Colors.white),
      child: AssetPicker(
          isTransfers: false,
          currentAsset: null,
          changeCurrentAsset: (_) {},
          isTrust: false,
          isBridgeSource: true,
          isTransferActivity: false,
          isJustDisplaying: false));

  Widget buildNetworkPicker(bool widthQuery, bool isDark, bool isBridgeSource,
          bool isBridgeTarget) =>
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(5),
              color: isDark ? Colors.grey[800] : Colors.white),
          child: NetworkPicker(
              isExplorer: false,
              isTransfers: false,
              isPayments: false,
              isTrust: false,
              isBridgeSource: isBridgeSource,
              isBridgeTarget: isBridgeTarget,
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

  Widget buildField(AppLanguage lang, Chain? c, bool isDark,
      TextEditingController controller, String? Function(String?)? validator,
      [TextInputType? keyboardType]) {
    final decimals =
        Provider.of<BridgesProvider>(context).currentSourceAsset.decimals;
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          onChanged: (_) {
            setState(() {});
          },
          inputFormatters: [
            if (keyboardType == null)
              LengthLimitingTextInputFormatter(
                  Validators.giveChainMaxLength(c!, controller.text)),
            if (keyboardType == null)
              TextInputFormatter.withFunction(
                (TextEditingValue oldValue, TextEditingValue newValue) {
                  return Validators.giveChainAddressRegexp(c!, newValue.text)
                          .hasMatch(newValue.text)
                      ? newValue
                      : newValue.text == ''
                          ? const TextEditingValue(text: '')
                          : oldValue;
                },
              ),
            if (keyboardType != null && decimals > 0)
              DecimalTextInputFormatter(decimalRange: decimals),
            if (keyboardType != null && decimals > 0)
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
            if (keyboardType != null && decimals < 1)
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
                            setState(() {});
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

  Widget buildFee(
      String label, bool widthQuery, Chain c, bool isDark, Decimal amount,
      [bool? isConfirmations]) {
    return Padding(
        padding: isConfirmations == null
            ? EdgeInsets.symmetric(horizontal: 8, vertical: widthQuery ? 4 : 0)
            : EdgeInsets.symmetric(
                horizontal: widthQuery ? 0 : 8, vertical: widthQuery ? 4 : 0),
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
                  if (isConfirmations == null)
                    SizedBox(
                        child: Utils.buildNetworkLogo(
                            widthQuery, Utils.feeLogo(c), true, true)),
                  if (isConfirmations == null) const SizedBox(width: 5),
                  Text(
                      isConfirmations == null
                          ? Utils.removeTrailingZeros(amount
                              .toStringAsFixed(Utils.nativeTokenDecimals(c)))
                          : "> ${Utils.chainToConfirmations(c).toString()}",
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14))
                ])
          ],
        ));
  }

  Widget buildTip(bool isDark, bool widthQuery, AppLanguage lang) {
    var bridges = Provider.of<BridgesProvider>(context, listen: false);
    var destinationAsset = bridges.currentDestinationAsset;
    bool isMaidenBridge = destinationAsset == null;
    bool isReturning = bridges.isReturningBridgedAsset;
    bool hasEquivalent = !isReturning && !isMaidenBridge;
    Chain sourceChain = bridges.currentSourceChain;
    Chain destinationChain = bridges.currentTargetChain;
    var decor = BoxDecoration(
        border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(5),
        color: isDark ? Colors.grey[800] : Colors.white);
    var padding = const EdgeInsets.all(8);
    if (isMaidenBridge) {
      return Container(
          height: null,
          decoration: decor,
          padding: padding,
          child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: Icon(Icons.warning_amber,
                  color: isDark ? Colors.white70 : Colors.amber),
              title: Text(lang.bridge7,
                  style:
                      TextStyle(color: isDark ? Colors.white70 : Colors.black)),
              subtitle: Text(
                  '${lang.bridge8} ${sourceChain.name} ${lang.bridge9} ${destinationChain.name} ${lang.bridge10} ${destinationChain.name}',
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black))));
    }
    if (isReturning) {
      return Container(
          decoration: decor,
          padding: padding,
          height: null,
          child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: Icon(Icons.info_outline,
                  color: isDark ? Colors.white70 : Colors.blue),
              title: Text(lang.bridge11,
                  style:
                      TextStyle(color: isDark ? Colors.white70 : Colors.black)),
              subtitle: Text('${lang.bridge12} ${destinationChain.name}',
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black))));
    }
    if (hasEquivalent) {
      return Container(
          decoration: decor,
          padding: padding,
          height: null,
          child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: Icon(Icons.check_circle,
                  color: isDark ? Colors.white70 : Colors.green),
              title: Text(lang.bridge13,
                  style:
                      TextStyle(color: isDark ? Colors.white70 : Colors.black)),
              subtitle: Text(
                  '${lang.bridge14} ${sourceChain.name} ${lang.bridge9} ${destinationChain.name}',
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black))));
    }
    return Container();
  }

  Widget buildDestinationAssetDetails(
      bool isSource, bool isDark, bool widthQuery, AppLanguage lang) {
    var bridges = Provider.of<BridgesProvider>(context, listen: false);
    var destinationAsset =
        isSource ? bridges.currentSourceAsset : bridges.currentDestinationAsset;
    var decor = BoxDecoration(
        border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(5),
        color: isDark ? Colors.grey[800] : Colors.white);
    var padding = const EdgeInsets.all(8);
    const heightbox = SizedBox(height: 5);
    if (destinationAsset != null) {
      return Container(
        padding: padding,
        decoration: decor,
        height: null,
        width: widthQuery ? null : double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isSource ? lang.bridge15 : lang.bridge16,
                style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black,
                    fontWeight: FontWeight.bold)),
            heightbox,
            Text("${lang.bridge17} ${destinationAsset.address}",
                style:
                    TextStyle(color: isDark ? Colors.white60 : Colors.black)),
            heightbox,
            Text("${lang.bridge18} ${destinationAsset.symbol}",
                style:
                    TextStyle(color: isDark ? Colors.white60 : Colors.black)),
            heightbox,
            Text("${lang.bridge19} ${destinationAsset.decimals.toString()}",
                style:
                    TextStyle(color: isDark ? Colors.white60 : Colors.black)),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildSourceWidget(
      bool isDark, bool widthQuery, Chain c, AppLanguage lang) {
    const heightBox = SizedBox(height: 10);
    const heightBox2 = SizedBox(height: 5);
    var bridges = Provider.of<BridgesProvider>(context);
    final decimals = bridges.currentSourceAsset.decimals;
    final amountController =
        Provider.of<BridgesProvider>(context, listen: false).amountController;
    final asset = bridges.currentSourceAsset;
    final destinationAsset = bridges.currentDestinationAsset;
    final sourceAsset = bridges.currentSourceAsset;
    var amount = Decimal.tryParse(amountController.text) ?? Decimal.parse("0");
    return Container(
        height: widthQuery ? null : 455,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Text(lang.bridge1,
                        style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: widthQuery ? 17 : 16))
                  ],
                ),
              ),
              Divider(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              if (widthQuery)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitle(lang.bridge4, isDark, widthQuery),
                        heightBox2,
                        buildNetworkPicker(widthQuery, isDark, true, false),
                        heightBox,
                        buildTitle(lang.transfer6, isDark, widthQuery),
                        heightBox2,
                        buildAssetPicker(widthQuery, isDark),
                        heightBox,
                        buildTitle(lang.transfer8, isDark, widthQuery),
                        heightBox2,
                        buildField(
                            lang,
                            null,
                            isDark,
                            amountController,
                            Validators.giveAmountValidator(context, decimals),
                            TextInputType.number),
                        heightBox,
                        buildFee(lang.confirmations, widthQuery, c, isDark,
                            amount, true),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: AssetFee(
                                currentChain: c,
                                asset: asset,
                                amount: amount,
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
                          isBridge: true,
                          isEscrow: false,
                          isRefuel: false,
                          ownerLength: 0,
                          benefLength: 0,
                          setState: () {
                            calculateTotal();
                            setState(() {});
                          },
                          setBridgeNativeGas: (f) {
                            nativeGas = f;
                            calculateTotal();
                          },
                          bridgeDestinationAsset: destinationAsset,
                          asset: sourceAsset,
                          amount: amount,
                          omnifyFee: omnifyFee,
                          recipient: bridges.addressController.text,
                        ),
                        OmnifyFee(
                            label: lang.transfer3,
                            isSpecialCase: false,
                            isInTransfers: false,
                            isPaymentFee: false,
                            isInInstallmentFee: false,
                            isTrust: false,
                            isTrustModifying: false,
                            isTrustCreating: false,
                            isBridge: true,
                            isEscrow: false,
                            isRefuel: false,
                            currentTransfer: null,
                            newBeneficiaries: 0,
                            setState: () {
                              calculateTotal();
                              setState(() {});
                            },
                            setFee: (f) {
                              omnifyFee = f;
                              calculateTotal();
                            }),
                      ],
                    )),
              if (!widthQuery)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitle(lang.bridge4, isDark, widthQuery),
                        heightBox2,
                        buildNetworkPicker(widthQuery, isDark, true, false),
                        heightBox,
                        buildTitle(lang.transfer6, isDark, widthQuery),
                        heightBox2,
                        buildAssetPicker(widthQuery, isDark),
                        heightBox,
                        buildTitle(lang.transfer8, isDark, widthQuery),
                        heightBox2,
                        buildField(
                            lang,
                            null,
                            isDark,
                            amountController,
                            Validators.giveAmountValidator(context, decimals),
                            TextInputType.number),
                      ],
                    )),
              if (!widthQuery) const Spacer(),
              if (!widthQuery)
                buildFee(
                    lang.confirmations, widthQuery, c, isDark, amount, true),
              if (!widthQuery)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AssetFee(
                        currentChain: c,
                        asset: asset,
                        amount: Decimal.tryParse(amountController.text) ??
                            Decimal.parse("0"),
                        isSpecialCase: false)),
              if (!widthQuery)
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8, vertical: widthQuery ? 4 : 0),
                    child: NetworkFee(
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
                      isBridge: true,
                      isEscrow: false,
                      isRefuel: false,
                      ownerLength: 0,
                      benefLength: 0,
                      setState: () {
                        calculateTotal();
                        setState(() {});
                      },
                      setBridgeNativeGas: (f) {
                        nativeGas = f;
                        calculateTotal();
                      },
                      bridgeDestinationAsset: destinationAsset,
                      asset: sourceAsset,
                      amount: amount,
                      omnifyFee: omnifyFee,
                      recipient: bridges.addressController.text,
                    )),
              if (!widthQuery)
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8, vertical: widthQuery ? 4 : 0),
                    child: OmnifyFee(
                        label: lang.transfer3,
                        isSpecialCase: false,
                        isInTransfers: false,
                        isPaymentFee: false,
                        isInInstallmentFee: false,
                        isTrust: false,
                        isTrustModifying: false,
                        isTrustCreating: false,
                        isBridge: true,
                        isEscrow: false,
                        isRefuel: false,
                        currentTransfer: null,
                        newBeneficiaries: 0,
                        setState: () {
                          calculateTotal();
                          setState(() {});
                        },
                        setFee: (f) {
                          omnifyFee = f;
                          calculateTotal();
                        })),
              Divider(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: buildFee(lang.transfer5, widthQuery, c, isDark, total),
              )
            ]));
  }

  Widget buildDestinationWidget(
      bool isDark, bool widthQuery, Chain c, AppLanguage lang) {
    const heightBox = SizedBox(height: 20);
    const heightBox2 = SizedBox(height: 10);
    final bridges = Provider.of<BridgesProvider>(context, listen: false);
    final addressController = bridges.addressController;
    final amountController = bridges.amountController;
    final asset = bridges.currentDestinationAsset ?? bridges.currentSourceAsset;
    return Container(
        height: widthQuery ? null : 355,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Text(lang.bridge2,
                        style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: widthQuery ? 17 : 16))
                  ],
                ),
              ),
              Divider(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              if (widthQuery)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle(lang.bridge4, isDark, widthQuery),
                          heightBox2,
                          buildNetworkPicker(widthQuery, isDark, false, true),
                          heightBox,
                          buildTitle(lang.bridge3, isDark, widthQuery),
                          heightBox2,
                          buildField(lang, c, isDark, addressController,
                              Validators.giveAddressValidator(context, c)),
                          heightBox
                        ])),
              if (!widthQuery)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitle(lang.bridge4, isDark, widthQuery),
                        heightBox2,
                        buildNetworkPicker(widthQuery, isDark, false, true),
                        heightBox,
                        buildTitle(lang.bridge3, isDark, widthQuery),
                        heightBox2,
                        buildField(lang, c, isDark, addressController,
                            Validators.giveAddressValidator(context, c)),
                      ],
                    )),
              if (!widthQuery) const Spacer(),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthQuery ? 8 : 0),
                  child: buildFee(lang.confirmations, widthQuery, c, isDark,
                      Decimal.parse("0.0"), true)),
              Divider(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AssetFee(
                      currentChain: c,
                      asset: asset,
                      amount: Decimal.tryParse(amountController.text) ??
                          Decimal.parse("0"),
                      isSpecialCase: false,
                      isBridgeTarget: true)),
            ]));
  }

  Widget buildArrowButton(bool widthQuery, bool isDark, Color primaryColor,
          TextDirection dir) =>
      Container(
          height: 50,
          width: 50,
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              color: isDark ? Colors.grey[800] : Colors.white),
          child: Center(
              child: Icon(
                  widthQuery
                      ? dir == TextDirection.rtl
                          ? Icons.keyboard_double_arrow_left_rounded
                          : Icons.keyboard_double_arrow_right_rounded
                      : Icons.keyboard_double_arrow_down_rounded,
                  size: widthQuery ? 40 : 33,
                  color: primaryColor)));

  Widget buildBridgeButton(
      bool widthQuery,
      Color primaryColor,
      AppLanguage lang,
      bool walletConnected,
      void Function(BuildContext) connectWallet,
      String walletAddress,
      bool isDark,
      TextDirection direction,
      void Function(Transaction) addTransaction,
      Chain sourceChain,
      Chain destinationChain) {
    return TextButton(
        onPressed: walletConnected
            ? () async {
                FocusScope.of(context).unfocus();
                if (sourceChain == destinationChain) {
                  Toasts.showInfoToast(
                      lang.toast7, lang.toast8, isDark, direction);
                } else {
                  if (formKey.currentState!.validate()) {
                    setState(() {});
                    final now = DateTime.now();
                    final theme =
                        Provider.of<ThemeProvider>(context, listen: false);
                    final bridges =
                        Provider.of<BridgesProvider>(context, listen: false);
                    final amountController = bridges.amountController;
                    final recipient = bridges.addressController.text;
                    final client = theme.client;
                    final wcClient = theme.walletClient;
                    final sessionTopic = theme.stateSessionTopic;
                    final _amount = Decimal.tryParse(amountController.text) ??
                        Decimal.parse("0");
                    Utils.showLoadingDialog(context, lang, widthQuery);
                    Future<void> _conduct() async {
                      final txHash = await BridgeUtils.migrateAssets(
                          c: bridges.currentSourceChain,
                          targetChain: bridges.currentTargetChain,
                          client: client,
                          wcClient: wcClient,
                          sessionTopic: sessionTopic,
                          // nativeGas: nativeGas,
                          omnifyFee: omnifyFee,
                          amount: _amount,
                          asset: bridges.currentSourceAsset,
                          recipient: recipient,
                          walletAddress: walletAddress);
                      if (txHash != null) {
                        addTransaction(Transaction(
                            c: sourceChain,
                            type: TransactionType.bridge,
                            destinationChain: destinationChain,
                            id: txHash[1],
                            date: now,
                            status: Status.pending,
                            transactionHash: txHash[0],
                            blockNumber: 0,
                            secondTransactionHash: "",
                            secondBlockNumber: 0,
                            thirdTransactionHash: "",
                            thirdBlockNumber: 0));
                        Future.delayed(const Duration(seconds: 1), () {
                          Toasts.showSuccessToast(lang.transactionSent,
                              lang.transactionSent2, isDark, direction);
                        });
                        Navigator.popUntil(context, (r) => r.isFirst);
                      } else {
                        Navigator.pop(context);
                        Toasts.showErrorToast(
                            lang.toast13, lang.toasts30, isDark, direction);
                      }
                    }

                    final coinBalance = await ChainUtils.getAssetBalance(
                        bridges.currentSourceChain,
                        walletAddress,
                        bridges.currentSourceAsset,
                        client);
                    if (coinBalance < _amount) {
                      Toasts.showErrorToast(
                          lang.toasts26,
                          lang.toasts27 +
                              "\$${bridges.currentSourceAsset.symbol}",
                          isDark,
                          direction);
                      Navigator.pop(context);
                    } else {
                      final contractAllowance =
                          await ChainUtils.getErcAllowance(
                              c: bridges.currentSourceChain,
                              client: client,
                              owner: walletAddress,
                              asset: bridges.currentSourceAsset,
                              isTransfers: false,
                              isTrust: false,
                              isBridges: true,
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
                            lang.toastMsg +
                                "\$${bridges.currentSourceAsset.symbol}",
                            isDark,
                            direction);
                        await ChainUtils.requestApprovals(
                            c: bridges.currentSourceChain,
                            client: client,
                            wcClient: wcClient,
                            keys: [bridges.currentSourceAsset.address],
                            allowances: {
                              bridges.currentSourceAsset.address: _amount
                            },
                            isTransfers: false,
                            isTrust: false,
                            isBridges: true,
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
                    ? Text(lang.finish,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white))
                    : Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(lang.home8,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white))
                      ]))));
  }

  void calculateTotal() {
    total = Decimal.parse("0.0");
    total = omnifyFee + networkFee + nativeGas;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    var bridges = Provider.of<BridgesProvider>(context, listen: false);
    var theme = Provider.of<ThemeProvider>(context, listen: false);
    bridges.initControllers();
    disposeAmountController = bridges.disposeAmountController;
    disposeAddressController = bridges.disposeAddressController;
    var currentSourceChain = bridges.currentSourceChain;
    var currentDestinationChain = bridges.currentTargetChain;
    bridges.setSourceChain(currentSourceChain, theme.appLanguage, false,
        theme.client, theme.walletClient);
    bridges.setTargetChain(currentDestinationChain, theme.appLanguage, false,
        theme.client, theme.walletClient);
  }

  @override
  void dispose() {
    super.dispose();
    // disposeAmountController();
    // disposeAddressController();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final walletMethods = Provider.of<WalletProvider>(context, listen: false);
    final walletConnected = walletProvider.isWalletConnected;
    final connectWallet =
        Provider.of<WalletProvider>(context, listen: false).connectWallet;
    final bridgeProvider = Provider.of<BridgesProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
    final direction = theme.textDirection;
    final isDark = theme.isDark;
    final widthQuery = Utils.widthQuery(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final heightBox = SizedBox(height: widthQuery ? 10 : 5);
    final sourceChain = bridgeProvider.currentSourceChain;
    final walletAddress = walletMethods.getAddressString(sourceChain);
    final destinationChain = bridgeProvider.currentTargetChain;
    final addTransaction =
        Provider.of<TransactionsProvider>(context, listen: false)
            .addTransaction;
    final lang = Utils.language(context);
    super.build(context);
    return Form(
      key: formKey,
      child: Directionality(
        textDirection: direction,
        child: Padding(
          padding: EdgeInsets.only(
              top: 4.0, left: 8, right: 8, bottom: widthQuery ? 8 : 70),
          child: widthQuery
              ? SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            flex: 14,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Spacer(flex: 1),
                                Expanded(
                                    flex: 14,
                                    child: buildSourceWidget(
                                        isDark, widthQuery, sourceChain, lang)),
                                buildArrowButton(widthQuery, isDark,
                                    primaryColor, direction),
                                Expanded(
                                    flex: 14,
                                    child: buildDestinationWidget(isDark,
                                        widthQuery, destinationChain, lang)),
                                const Spacer(flex: 1),
                              ],
                            ),
                          ),
                        ],
                      ),
                      heightBox,
                      Row(children: [
                        const Spacer(flex: 1),
                        Expanded(
                            flex: 2,
                            child: buildDestinationAssetDetails(
                                true, isDark, widthQuery, lang)),
                        const Spacer(flex: 1),
                      ]),
                      heightBox,
                      Row(children: [
                        const Spacer(flex: 1),
                        Expanded(
                            flex: 2, child: buildTip(isDark, widthQuery, lang)),
                        const Spacer(flex: 1),
                      ]),
                      heightBox,
                      Row(children: [
                        const Spacer(flex: 1),
                        Expanded(
                            flex: 2,
                            child: buildDestinationAssetDetails(
                                false, isDark, widthQuery, lang)),
                        const Spacer(flex: 1),
                      ]),
                      heightBox,
                      Row(children: [
                        const Spacer(flex: 1),
                        Expanded(
                          flex: 2,
                          child: buildBridgeButton(
                              widthQuery,
                              primaryColor,
                              lang,
                              walletConnected,
                              connectWallet,
                              walletAddress,
                              isDark,
                              direction,
                              addTransaction,
                              sourceChain,
                              destinationChain),
                        ),
                        const Spacer(flex: 1)
                      ])
                    ],
                  ))
              : SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      buildSourceWidget(isDark, widthQuery, sourceChain, lang),
                      heightBox,
                      buildTip(isDark, widthQuery, lang),
                      heightBox,
                      buildDestinationAssetDetails(
                          true, isDark, widthQuery, lang),
                      heightBox,
                      buildArrowButton(
                          widthQuery, isDark, primaryColor, direction),
                      heightBox,
                      buildDestinationAssetDetails(
                          false, isDark, widthQuery, lang),
                      heightBox,
                      buildDestinationWidget(
                          isDark, widthQuery, destinationChain, lang),
                      heightBox,
                      buildBridgeButton(
                          widthQuery,
                          primaryColor,
                          lang,
                          walletConnected,
                          connectWallet,
                          walletAddress,
                          isDark,
                          direction,
                          addTransaction,
                          sourceChain,
                          destinationChain)
                    ],
                  )),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
