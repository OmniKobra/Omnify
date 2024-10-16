// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../languages/app_language.dart';
import '../models/beneficiary.dart';
import '../models/deposit.dart';
import '../models/transaction.dart';
import '../providers/theme_provider.dart';
import '../providers/transactions_provider.dart';
import '../providers/trusts_provider.dart';
import '../providers/wallet_provider.dart';
import '../toasts.dart';
import '../utils.dart';
import '../validators.dart';
import '../crypto/utils/chain_utils.dart';
import '../crypto/features/trust_utils.dart';
import '../widgets/asset_picker.dart';
import '../widgets/common/asset_fee.dart';
import '../widgets/common/noglow.dart';
import '../widgets/home/wallet_button.dart';
import '../widgets/network_picker.dart';
import '../widgets/trust/trust_sheet.dart';
import '../widgets/trust/trust_table.dart';
import '../widgets/common/omnify_fee.dart';
import '../widgets/common/network_fee.dart';

class DepositTab extends StatefulWidget {
  final bool isModification;
  final Deposit? modificationDeposit;
  final void Function()? setsStateManage;
  const DepositTab(
      {super.key,
      required this.isModification,
      required this.modificationDeposit,
      required this.setsStateManage});

  @override
  State<DepositTab> createState() => _DepositTabState();
}

class _DepositTabState extends State<DepositTab>
    with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormState>();
  bool statusActive = true;
  bool statusInactive = false;
  bool typeFixed = true;
  bool typeModifiable = false;
  bool liquidityRetractable = false;
  bool liquidityNonRetract = true;
  Decimal omnifyFee = Decimal.parse("0.0");
  Decimal networkFee = Decimal.parse("0.0");
  Decimal total = Decimal.parse("0.0");
  List<Beneficiary> oldBeneficiaries = [];
  List<Beneficiary> beneficiaries = [];
  List<Beneficiary> newBeneficiaries = [];
  Widget buildAssetPicker(bool widthQuery, bool isDark) => Container(
      padding: widthQuery
          ? const EdgeInsets.all(0)
          : const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: widthQuery
              ? null
              : Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5),
          color: isDark ? Colors.grey[800] : Colors.white),
      child: AssetPicker(
          isTransfers: false,
          currentAsset: null,
          changeCurrentAsset: (_) {},
          isTrust: true,
          isBridgeSource: false,
          isTransferActivity: false,
          isJustDisplaying: false));

  Widget buildNetworkPicker(bool widthQuery, bool isDark) =>
      const NetworkPicker(
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
          isDiscoverEscrow: false);

  buildAssetBox(String label, bool widthQuery, bool isDark) {
    return SizedBox(
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(label, isDark, widthQuery),
          SizedBox(width: 150, child: buildAssetPicker(widthQuery, isDark))
        ],
      ),
    );
  }

  Widget buildField(bool isDark, TextEditingController amountController) {
    final decimals = Provider.of<TrustsProvider>(context).currentAsset.decimals;
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: TextFormField(
          controller: amountController,
          validator: Validators.giveAmountValidator(context, decimals),
          keyboardType: TextInputType.number,
          onChanged: (_) {
            setState(() {});
          },
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

  Widget buildCheckBox(
          {required bool value,
          required String label,
          required bool isDark,
          required bool widthQuery,
          required bool paramStatusActive,
          required bool paramStatusInactive,
          required bool paramTypeFixed,
          required bool paramTypeModifiable,
          required bool paramLiquidityRetractable,
          required bool paramLiquidityNonRetract}) =>
      ListTile(
          visualDensity: VisualDensity.comfortable,
          hoverColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          leading: Checkbox(
              value: value,
              onChanged: (val) {
                if (paramStatusActive || paramStatusInactive) {
                  if (paramStatusActive) {
                    statusActive = val!;
                    statusInactive = !val;
                  } else {
                    statusInactive = val!;
                    statusActive = !val;
                  }
                } else if (paramTypeFixed || paramTypeModifiable) {
                  if (paramTypeFixed) {
                    typeFixed = val!;
                    typeModifiable = !val;
                  } else {
                    typeModifiable = val!;
                    typeFixed = !val;
                  }
                } else {
                  if (paramLiquidityRetractable) {
                    liquidityRetractable = val!;
                    liquidityNonRetract = !val;
                  } else {
                    liquidityNonRetract = val!;
                    liquidityRetractable = !val;
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

  Widget buildTitle(String label, bool isDark, bool widthQuery,
          [bool? showTooltip, String? tooltipContent]) =>
      Row(
        children: [
          Text(label,
              style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black,
                  fontSize: widthQuery ? 17 : 14,
                  fontWeight: FontWeight.bold)),
          if (showTooltip != null) const SizedBox(width: 5),
          if (showTooltip != null)
            ElTooltip(
              content: Text(tooltipContent!,
                  style: const TextStyle(color: Colors.white)),
              color: Colors.black,
              position: Provider.of<ThemeProvider>(context).textDirection ==
                      TextDirection.rtl
                  ? ElTooltipPosition.leftEnd
                  : ElTooltipPosition.rightEnd,
              showModal: false,
              showArrow: false,
              showChildAboveOverlay: false,
              timeout: const Duration(seconds: 5),
              child: Icon(Icons.info_outline,
                  size: 15, color: isDark ? Colors.white60 : Colors.black),
            )
        ],
      );

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
                        Utils.removeTrailingZeros(amount
                            .toStringAsFixed(Utils.nativeTokenDecimals(c))),
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14))
                  ])
            ],
          );
  }

  Widget buildDepositButton(
      Chain c,
      bool widthQuery,
      Color primaryColor,
      AppLanguage lang,
      bool walletConnected,
      void Function(BuildContext) connectWallet,
      String depositLabel,
      String walletAddress,
      bool isDark,
      TextDirection direction,
      void Function(Transaction) addTransaction,
      Decimal amount) {
    return TextButton(
        onPressed: walletConnected
            ? () async {
                // FocusScope.of(context).unfocus();
                setState(() {});
                if (formKey.currentState!.validate()) {
                  final now = DateTime.now();
                  final theme =
                      Provider.of<ThemeProvider>(context, listen: false);
                  final trust =
                      Provider.of<TrustsProvider>(context, listen: false);
                  final client = theme.client;
                  final wcClient = theme.walletClient;
                  final sessionTopic = theme.stateSessionTopic;
                  Utils.showLoadingDialog(context, lang, widthQuery);
                  if (widget.isModification) {
                    if (widget.isModification &&
                        !widget.modificationDeposit!.isFixed) {
                      final txHash = await TrustUtils.modifyDeposit(
                          c: c,
                          client: client,
                          wcClient: wcClient,
                          sessionTopic: sessionTopic,
                          id: widget.modificationDeposit!.id,
                          isJustActivation: false,
                          newActive: statusActive,
                          omnifyFee: omnifyFee,
                          walletAddress: walletAddress,
                          asset: widget.modificationDeposit!.asset,
                          benefs: beneficiaries);
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
                          widget.modificationDeposit!
                              .modifyDeposit(beneficiaries, statusActive);
                          widget.setsStateManage!();
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        Toasts.showErrorToast(
                            lang.toast13, lang.toasts30, isDark, direction);
                      }
                    } else {
                      final txHash = await TrustUtils.modifyDeposit(
                          c: c,
                          client: client,
                          wcClient: wcClient,
                          sessionTopic: sessionTopic,
                          id: widget.modificationDeposit!.id,
                          isJustActivation: true,
                          newActive: statusActive,
                          omnifyFee: omnifyFee,
                          walletAddress: walletAddress,
                          asset: widget.modificationDeposit!.asset,
                          benefs: widget.modificationDeposit!.beneficiaries);
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
                          widget.modificationDeposit!
                              .modifyDeposit(beneficiaries, statusActive);
                          widget.setsStateManage!();
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        Toasts.showErrorToast(
                            lang.toast13, lang.toasts30, isDark, direction);
                      }
                    }
                  } else {
                    final id = Utils.generateID(walletAddress, now);
                    Future<void> _conduct() async {
                      final txHash = await TrustUtils.createDeposit(
                          c: c,
                          client: client,
                          wcClient: wcClient,
                          sessionTopic: sessionTopic,
                          id: id,
                          amount: amount,
                          asset: trust.currentAsset,
                          isModifiable: typeModifiable,
                          isRetractable: liquidityRetractable,
                          isActive: statusActive,
                          owners: trust.owners,
                          beneficiaries: trust.beneficiaries,
                          walletAddress: walletAddress,
                          omnifyFee: omnifyFee);
                      if (txHash != null) {
                        addTransaction(Transaction(
                            c: c,
                            type: TransactionType.trust,
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
                        Navigator.popUntil(context, (r) => r.isFirst);
                      } else {
                        Navigator.pop(context);
                        Toasts.showErrorToast(
                            lang.toast13, lang.toasts30, isDark, direction);
                      }
                    }

                    if (trust.currentAsset.address == Utils.zeroAddress) {
                      final balance = await client.getBalance(
                          ChainUtils.ethAddressFromHex(c, walletAddress));
                      final balanceVal =
                          ChainUtils.nativeUintToDecimal(c, balance.getInWei);
                      if (balanceVal < amount + omnifyFee) {
                        Toasts.showErrorToast(
                            lang.toasts26,
                            lang.toasts27 + "\$${trust.currentAsset.symbol}",
                            isDark,
                            direction);
                        Navigator.pop(context);
                      } else {
                        _conduct();
                      }
                    } else {
                      final coinBalance = await ChainUtils.getAssetBalance(
                          c, walletAddress, trust.currentAsset, client);
                      if (coinBalance < amount) {
                        Toasts.showErrorToast(
                            lang.toasts26,
                            lang.toasts27 + "\$${trust.currentAsset.symbol}",
                            isDark,
                            direction);
                        Navigator.pop(context);
                      } else {
                        final contractAllowance =
                            await ChainUtils.getErcAllowance(
                                c: c,
                                client: client,
                                owner: walletAddress,
                                asset: trust.currentAsset,
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
                        if (contractAllowance < amount) {
                          Toasts.showInfoToast(
                              lang.toasts20,
                              lang.toastMsg + "\$${trust.currentAsset.symbol}",
                              isDark,
                              direction);
                          await ChainUtils.requestApprovals(
                              c: c,
                              client: client,
                              wcClient: wcClient,
                              keys: [trust.currentAsset.address],
                              allowances: {trust.currentAsset.address: amount},
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
                }
              }
            : () {
                connectWallet(context);
              },
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
                    ? Text(widget.isModification ? lang.finish : depositLabel,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white))
                    : Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(lang.home8,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white))
                      ]))));
  }

  Widget buildAddButton(
      String label, bool isBeneficiary, bool isDark, int decimals) {
    final child = Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: TrustSheet(
            isBeneficiary: isBeneficiary,
            isModification: widget.isModification,
            beneficiaryToModify: null,
            addBeneficiaryHandler: addModificationBeneficiary,
            decimals: decimals,
            isModifyBeneficiary: false,
            modifyModificationBeneficiary: modifyModificationBeneficiary));
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (widget.isModification) {
              showModalBottomSheet(
                  context: context,
                  enableDrag: false,
                  useSafeArea: true,
                  constraints: const BoxConstraints(maxHeight: double.infinity),
                  scrollControlDisabledMaxHeightRatio: 1,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  // isScrollControlled: false,
                  builder: (_) {
                    return child;
                  });
            } else {
              showBottomSheet(
                  context: context,
                  enableDrag: false,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  // isScrollControlled: false,
                  builder: (_) {
                    return child;
                  });
            }
          },
          style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
                  const EdgeInsets.all(0))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.add),
              const SizedBox(width: 3),
              Text(label,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ],
          )),
    );
  }

  void addModificationBeneficiary(Beneficiary b) {
    if (!beneficiaries.contains(b)) {
      beneficiaries.add(b);
      if (!oldBeneficiaries.any((be) => be.address == b.address)) {
        newBeneficiaries.add(b);
      }
      setState(() {});
    }
  }

  void removeModificationBeneficiary(Beneficiary b) {
    if (beneficiaries.contains(b)) {
      beneficiaries.remove(b);
      if (!oldBeneficiaries.any((be) => be.address == b.address)) {
        newBeneficiaries.removeWhere((be) => be.address == b.address);
      }
      setState(() {});
    }
  }

  void modifyModificationBeneficiary(Beneficiary current, Beneficiary b) {
    if (beneficiaries.contains(current)) {
      final i = beneficiaries.indexOf(current);
      beneficiaries[i] = b;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isModification) {
      statusActive = widget.modificationDeposit!.isActive;
      statusInactive = !widget.modificationDeposit!.isActive;
      beneficiaries = [...widget.modificationDeposit!.beneficiaries];
      oldBeneficiaries = [...beneficiaries];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final direction = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final trustsProvider = Provider.of<TrustsProvider>(context);
    final wallet = Provider.of<WalletProvider>(context);
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    final decimals = trustsProvider.currentAsset.decimals;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final walletConnected = wallet.isWalletConnected;
    final chain = trustsProvider.currentChain;
    final walletAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(chain);
    final amountController = trustsProvider.amountController;
    final addTransaction =
        Provider.of<TransactionsProvider>(context, listen: false)
            .addTransaction;
    final handler1 =
        Provider.of<WalletProvider>(context, listen: false).connectWallet;
    const heightBox1 = SizedBox(height: 30, width: double.infinity);
    const heightBox2 = SizedBox(height: 10, width: double.infinity);
    const heightBox3 = SizedBox(height: 20, width: double.infinity);
    const heightBox4 = SizedBox(height: 5);
    const heightBox5 = SizedBox(height: 15);
    void handler(BuildContext ctx) {
      handler1(ctx);
    }

    void calculateTotal() {
      total = Decimal.parse("0.0");
      if (trustsProvider.currentAsset.address == Utils.zeroAddress &&
          !widget.isModification) {
        var am =
            Decimal.tryParse(amountController.text) ?? Decimal.parse("0.0");
        total += am;
      }
      total += omnifyFee;
      total += networkFee;
    }

    if (walletConnected && !trustsProvider.owners.contains(walletAddress)) {
      Provider.of<TrustsProvider>(context, listen: false)
          .addOwner(walletAddress, true);
    }
    calculateTotal();
    super.build(context);
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.isModification ? 8 : kToolbarHeight - 5,
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
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: border,
                      borderRadius: BorderRadius.circular(5),
                      color: isDark ? Colors.grey[800] : Colors.white,
                    ),
                    child: Noglow(
                        child: SingleChildScrollView(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widthQuery
                                    ? [
                                        if (!widget.isModification)
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                    height: 75,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          buildTitle(
                                                              lang.bridge4,
                                                              isDark,
                                                              widthQuery),
                                                          buildNetworkPicker(
                                                              widthQuery,
                                                              isDark),
                                                        ])),
                                                if (widthQuery)
                                                  const SizedBox(width: 5),
                                                if (widthQuery)
                                                  const WalletButton()
                                              ]),
                                        if (!widget.isModification)
                                          const SizedBox(height: 10),
                                        Wrap(children: [
                                          if (!widget.isModification)
                                            Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  buildAssetBox(lang.transfer6,
                                                      widthQuery, isDark),
                                                  const Spacer(flex: 2),
                                                  Expanded(
                                                    flex: 4,
                                                    child: buildFieldBox(
                                                        lang.transfer8,
                                                        isDark,
                                                        widthQuery,
                                                        amountController),
                                                  ),
                                                  const Spacer(flex: 2),
                                                ]),
                                          if (!widget.isModification)
                                            heightBox1,
                                          if (!widget.isModification)
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  buildTitle(
                                                      lang.trust5,
                                                      isDark,
                                                      widthQuery,
                                                      true,
                                                      lang.tooltip1),
                                                  const SizedBox(width: 61),
                                                  Expanded(
                                                      child: buildCheckBox(
                                                          value: typeFixed,
                                                          label: lang.trust6,
                                                          isDark: isDark,
                                                          widthQuery:
                                                              widthQuery,
                                                          paramStatusActive:
                                                              false,
                                                          paramStatusInactive:
                                                              false,
                                                          paramTypeFixed: true,
                                                          paramTypeModifiable:
                                                              false,
                                                          paramLiquidityRetractable:
                                                              false,
                                                          paramLiquidityNonRetract:
                                                              false)),
                                                  Expanded(
                                                      child: buildCheckBox(
                                                          value: typeModifiable,
                                                          label: lang.trust7,
                                                          isDark: isDark,
                                                          widthQuery:
                                                              widthQuery,
                                                          paramStatusActive:
                                                              false,
                                                          paramStatusInactive:
                                                              false,
                                                          paramTypeFixed: false,
                                                          paramTypeModifiable:
                                                              true,
                                                          paramLiquidityRetractable:
                                                              false,
                                                          paramLiquidityNonRetract:
                                                              false)),
                                                  const Spacer(),
                                                ]),
                                          if (!widget.isModification)
                                            heightBox3,
                                          if (!widget.isModification)
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  buildTitle(
                                                      lang.trust8,
                                                      isDark,
                                                      widthQuery,
                                                      true,
                                                      lang.tooltip2),
                                                  const SizedBox(width: 29),
                                                  Expanded(
                                                      child: buildCheckBox(
                                                          value:
                                                              liquidityRetractable,
                                                          label: lang.trust9,
                                                          isDark: isDark,
                                                          widthQuery:
                                                              widthQuery,
                                                          paramStatusActive:
                                                              false,
                                                          paramStatusInactive:
                                                              false,
                                                          paramTypeFixed: false,
                                                          paramTypeModifiable:
                                                              false,
                                                          paramLiquidityRetractable:
                                                              true,
                                                          paramLiquidityNonRetract:
                                                              false)),
                                                  Expanded(
                                                      child: buildCheckBox(
                                                          value:
                                                              liquidityNonRetract,
                                                          label: lang.trust10,
                                                          isDark: isDark,
                                                          widthQuery:
                                                              widthQuery,
                                                          paramStatusActive:
                                                              false,
                                                          paramStatusInactive:
                                                              false,
                                                          paramTypeFixed: false,
                                                          paramTypeModifiable:
                                                              false,
                                                          paramLiquidityRetractable:
                                                              false,
                                                          paramLiquidityNonRetract:
                                                              true)),
                                                  const Spacer(),
                                                ]),
                                          if (!widget.isModification)
                                            heightBox3,
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                buildTitle(
                                                    lang.trust11,
                                                    isDark,
                                                    widthQuery,
                                                    true,
                                                    lang.tooltip3),
                                                const SizedBox(width: 51),
                                                Expanded(
                                                    child: buildCheckBox(
                                                        value: statusActive,
                                                        label: lang.trust12,
                                                        isDark: isDark,
                                                        widthQuery: widthQuery,
                                                        paramStatusActive: true,
                                                        paramStatusInactive:
                                                            false,
                                                        paramTypeFixed: false,
                                                        paramTypeModifiable:
                                                            false,
                                                        paramLiquidityRetractable:
                                                            false,
                                                        paramLiquidityNonRetract:
                                                            false)),
                                                Expanded(
                                                    child: buildCheckBox(
                                                        value: statusInactive,
                                                        label: lang.trust13,
                                                        isDark: isDark,
                                                        widthQuery: widthQuery,
                                                        paramStatusActive:
                                                            false,
                                                        paramStatusInactive:
                                                            true,
                                                        paramTypeFixed: false,
                                                        paramTypeModifiable:
                                                            false,
                                                        paramLiquidityRetractable:
                                                            false,
                                                        paramLiquidityNonRetract:
                                                            false)),
                                                const Spacer(),
                                              ]),
                                          heightBox1,
                                          if ((widget.isModification &&
                                                  !widget.modificationDeposit!
                                                      .isFixed) ||
                                              !widget.isModification)
                                            buildTitle(lang.trust14, isDark,
                                                widthQuery),
                                          if ((widget.isModification &&
                                                  !widget.modificationDeposit!
                                                      .isFixed) ||
                                              !widget.isModification)
                                            heightBox2,
                                          if ((widget.isModification &&
                                                  !widget.modificationDeposit!
                                                      .isFixed) ||
                                              !widget.isModification)
                                            TrustTable(
                                                isOwners: false,
                                                isModification:
                                                    widget.isModification,
                                                beneficiaries: beneficiaries,
                                                decimals: decimals,
                                                modifyBeneficiaryHandler:
                                                    modifyModificationBeneficiary,
                                                removeBeneficiaryHandler:
                                                    removeModificationBeneficiary),
                                          if ((widget.isModification &&
                                                  !widget.modificationDeposit!
                                                      .isFixed) ||
                                              !widget.isModification)
                                            buildAddButton(lang.trust15, true,
                                                isDark, decimals),
                                          if (!widget.isModification)
                                            heightBox1,
                                          if (!widget.isModification)
                                            buildTitle(lang.trust16, isDark,
                                                widthQuery),
                                          if (!widget.isModification)
                                            heightBox2,
                                          if (!widget.isModification)
                                            TrustTable(
                                                isOwners: true,
                                                decimals: decimals,
                                                beneficiaries: const [],
                                                removeBeneficiaryHandler: null,
                                                modifyBeneficiaryHandler: null,
                                                isModification: false),
                                          if (!widget.isModification)
                                            buildAddButton(lang.trust17, false,
                                                isDark, decimals),
                                          heightBox1,
                                          Divider(
                                              color: isDark
                                                  ? Colors.grey.shade600
                                                  : Colors.grey.shade300),
                                          if (!widget.isModification)
                                            AssetFee(
                                                currentChain: chain,
                                                asset:
                                                    trustsProvider.currentAsset,
                                                amount: Decimal.tryParse(
                                                        amountController
                                                            .text) ??
                                                    Decimal.parse("0"),
                                                isSpecialCase: true),
                                          if (!widget.isModification ||
                                              (widget.isModification &&
                                                  !widget.modificationDeposit!
                                                      .isFixed))
                                            OmnifyFee(
                                                label: lang.transfer3,
                                                isSpecialCase: true,
                                                isInTransfers: false,
                                                isPaymentFee: false,
                                                isInInstallmentFee: false,
                                                isTrust: true,
                                                isTrustModifying:
                                                    widget.isModification,
                                                isTrustCreating:
                                                    !widget.isModification,
                                                isBridge: false,
                                                isEscrow: false,
                                                isRefuel: false,
                                                currentTransfer: null,
                                                newBeneficiaries: widget
                                                        .isModification
                                                    ? newBeneficiaries.length
                                                    : trustsProvider
                                                        .beneficiaries.length,
                                                setState: () {
                                                  setState(() {});
                                                },
                                                setFee: (f) {
                                                  omnifyFee = f;
                                                  calculateTotal();
                                                }),
                                          NetworkFee(
                                              isInTransfers: false,
                                              currentTransfer: null,
                                              isSpecialCase: true,
                                              isPaymentFee: false,
                                              isInInstallmentFee: false,
                                              isPaymentWithdrawals: false,
                                              isTrust: true,
                                              isTrustCreation:
                                                  !widget.isModification,
                                              isTrustModification:
                                                  widget.isModification,
                                              isBridge: false,
                                              isEscrow: false,
                                              isRefuel: false,
                                              ownerLength: widget.isModification
                                                  ? 0
                                                  : trustsProvider
                                                      .owners.length,
                                              benefLength: widget.isModification
                                                  ? !widget.modificationDeposit!
                                                          .isFixed
                                                      ? beneficiaries.length
                                                      : 0
                                                  : trustsProvider
                                                      .beneficiaries.length,
                                              setBridgeNativeGas: (_) {},
                                              bridgeDestinationAsset: null,
                                              setFee: (t) {
                                                networkFee = t;
                                                calculateTotal();
                                              },
                                              setState: () {
                                                setState(() {});
                                              }),
                                          buildFee(lang.transfer5, total,
                                              widthQuery, chain, isDark),
                                          heightBox1,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              buildDepositButton(
                                                  chain,
                                                  widthQuery,
                                                  primaryColor,
                                                  lang,
                                                  walletConnected,
                                                  handler,
                                                  lang.trust4,
                                                  walletAddress,
                                                  isDark,
                                                  direction,
                                                  addTransaction,
                                                  Decimal.tryParse(
                                                          amountController
                                                              .text) ??
                                                      Decimal.parse("0.0"))
                                            ],
                                          )
                                        ]),
                                      ]
                                    : [
                                        if (!widget.isModification)
                                          buildTitle(
                                              lang.bridge4, isDark, widthQuery),
                                        if (!widget.isModification)
                                          Row(children: [
                                            buildNetworkPicker(
                                                widthQuery, isDark),
                                            if (widthQuery)
                                              const SizedBox(width: 5),
                                            if (widthQuery) const WalletButton()
                                          ]),
                                        if (!widget.isModification)
                                          const SizedBox(height: 5),
                                        if (!widget.isModification)
                                          buildTitle(lang.transfer6, isDark,
                                              widthQuery),
                                        if (!widget.isModification) heightBox4,
                                        if (!widget.isModification)
                                          buildAssetPicker(widthQuery, isDark),
                                        if (!widget.isModification) heightBox5,
                                        if (!widget.isModification)
                                          buildTitle(lang.transfer8, isDark,
                                              widthQuery),
                                        if (!widget.isModification) heightBox4,
                                        if (!widget.isModification)
                                          buildField(isDark, amountController),
                                        if (!widget.isModification) heightBox5,
                                        if (!widget.isModification)
                                          buildTitle(
                                              lang.trust5, isDark, widthQuery),
                                        if (!widget.isModification) heightBox4,
                                        if (!widget.isModification)
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    child: buildCheckBox(
                                                        value: typeFixed,
                                                        label: lang.trust6,
                                                        isDark: isDark,
                                                        widthQuery: widthQuery,
                                                        paramStatusActive:
                                                            false,
                                                        paramStatusInactive:
                                                            false,
                                                        paramTypeFixed: true,
                                                        paramTypeModifiable:
                                                            false,
                                                        paramLiquidityRetractable:
                                                            false,
                                                        paramLiquidityNonRetract:
                                                            false)),
                                                Expanded(
                                                    child: buildCheckBox(
                                                        value: typeModifiable,
                                                        label: lang.trust7,
                                                        isDark: isDark,
                                                        widthQuery: widthQuery,
                                                        paramStatusActive:
                                                            false,
                                                        paramStatusInactive:
                                                            false,
                                                        paramTypeFixed: false,
                                                        paramTypeModifiable:
                                                            true,
                                                        paramLiquidityRetractable:
                                                            false,
                                                        paramLiquidityNonRetract:
                                                            false)),
                                              ]),
                                        if (!widget.isModification) heightBox5,
                                        if (!widget.isModification)
                                          buildTitle(
                                              lang.trust8, isDark, widthQuery),
                                        if (!widget.isModification) heightBox4,
                                        if (!widget.isModification)
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    child: buildCheckBox(
                                                        value:
                                                            liquidityRetractable,
                                                        label: lang.trust9,
                                                        isDark: isDark,
                                                        widthQuery: widthQuery,
                                                        paramStatusActive:
                                                            false,
                                                        paramStatusInactive:
                                                            false,
                                                        paramTypeFixed: false,
                                                        paramTypeModifiable:
                                                            false,
                                                        paramLiquidityRetractable:
                                                            true,
                                                        paramLiquidityNonRetract:
                                                            false)),
                                                Expanded(
                                                    child: buildCheckBox(
                                                        value:
                                                            liquidityNonRetract,
                                                        label: lang.trust10,
                                                        isDark: isDark,
                                                        widthQuery: widthQuery,
                                                        paramStatusActive:
                                                            false,
                                                        paramStatusInactive:
                                                            false,
                                                        paramTypeFixed: false,
                                                        paramTypeModifiable:
                                                            false,
                                                        paramLiquidityRetractable:
                                                            false,
                                                        paramLiquidityNonRetract:
                                                            true)),
                                              ]),
                                        if (!widget.isModification) heightBox5,
                                        buildTitle(
                                            lang.trust11, isDark, widthQuery),
                                        heightBox4,
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: buildCheckBox(
                                                      value: statusActive,
                                                      label: lang.trust12,
                                                      isDark: isDark,
                                                      widthQuery: widthQuery,
                                                      paramStatusActive: true,
                                                      paramStatusInactive:
                                                          false,
                                                      paramTypeFixed: false,
                                                      paramTypeModifiable:
                                                          false,
                                                      paramLiquidityRetractable:
                                                          false,
                                                      paramLiquidityNonRetract:
                                                          false)),
                                              Expanded(
                                                  child: buildCheckBox(
                                                      value: statusInactive,
                                                      label: lang.trust13,
                                                      isDark: isDark,
                                                      widthQuery: widthQuery,
                                                      paramStatusActive: false,
                                                      paramStatusInactive: true,
                                                      paramTypeFixed: false,
                                                      paramTypeModifiable:
                                                          false,
                                                      paramLiquidityRetractable:
                                                          false,
                                                      paramLiquidityNonRetract:
                                                          false)),
                                            ]),
                                        heightBox5,
                                        if ((widget.isModification &&
                                                !widget.modificationDeposit!
                                                    .isFixed) ||
                                            !widget.isModification)
                                          buildTitle(
                                              lang.trust14, isDark, widthQuery),
                                        if ((widget.isModification &&
                                                !widget.modificationDeposit!
                                                    .isFixed) ||
                                            !widget.isModification)
                                          heightBox4,
                                        if ((widget.isModification &&
                                                !widget.modificationDeposit!
                                                    .isFixed) ||
                                            !widget.isModification)
                                          TrustTable(
                                              isOwners: false,
                                              isModification:
                                                  widget.isModification,
                                              decimals: decimals,
                                              beneficiaries: beneficiaries,
                                              modifyBeneficiaryHandler:
                                                  modifyModificationBeneficiary,
                                              removeBeneficiaryHandler:
                                                  removeModificationBeneficiary),
                                        if ((widget.isModification &&
                                                !widget.modificationDeposit!
                                                    .isFixed) ||
                                            !widget.isModification)
                                          buildAddButton(lang.trust15, true,
                                              isDark, decimals),
                                        if (!widget.isModification) heightBox5,
                                        if (!widget.isModification)
                                          buildTitle(
                                              lang.trust16, isDark, widthQuery),
                                        if (!widget.isModification) heightBox4,
                                        if (!widget.isModification)
                                          TrustTable(
                                              isOwners: true,
                                              beneficiaries: const [],
                                              decimals: decimals,
                                              removeBeneficiaryHandler: null,
                                              modifyBeneficiaryHandler: null,
                                              isModification: false),
                                        if (!widget.isModification)
                                          buildAddButton(lang.trust17, false,
                                              isDark, decimals),
                                        heightBox5,
                                        Divider(
                                            color: isDark
                                                ? Colors.grey.shade600
                                                : Colors.grey.shade300),
                                        if (!widget.isModification)
                                          AssetFee(
                                              currentChain: chain,
                                              asset:
                                                  trustsProvider.currentAsset,
                                              amount: Decimal.tryParse(
                                                      amountController.text) ??
                                                  Decimal.parse("0"),
                                              isSpecialCase: true),
                                        if (!widget.isModification ||
                                            (widget.isModification &&
                                                !widget.modificationDeposit!
                                                    .isFixed))
                                          OmnifyFee(
                                              label: lang.transfer3,
                                              isSpecialCase: true,
                                              isInTransfers: false,
                                              isPaymentFee: false,
                                              isInInstallmentFee: false,
                                              isTrust: true,
                                              isTrustModifying:
                                                  widget.isModification,
                                              isTrustCreating:
                                                  !widget.isModification,
                                              isBridge: false,
                                              isEscrow: false,
                                              isRefuel: false,
                                              currentTransfer: null,
                                              newBeneficiaries:
                                                  widget.isModification
                                                      ? newBeneficiaries.length
                                                      : trustsProvider
                                                          .beneficiaries.length,
                                              setState: () {
                                                setState(() {});
                                              },
                                              setFee: (f) {
                                                omnifyFee = f;
                                                calculateTotal();
                                              }),
                                        NetworkFee(
                                            isInTransfers: false,
                                            currentTransfer: null,
                                            isSpecialCase: true,
                                            isPaymentFee: false,
                                            isInInstallmentFee: false,
                                            isPaymentWithdrawals: false,
                                            isTrust: true,
                                            isTrustCreation:
                                                !widget.isModification,
                                            isTrustModification:
                                                widget.isModification,
                                            isBridge: false,
                                            isEscrow: false,
                                            isRefuel: false,
                                            ownerLength: widget.isModification
                                                ? 0
                                                : trustsProvider.owners.length,
                                            benefLength: widget.isModification
                                                ? !widget.modificationDeposit!
                                                        .isFixed
                                                    ? beneficiaries.length
                                                    : 0
                                                : trustsProvider
                                                    .beneficiaries.length,
                                            setBridgeNativeGas: (_) {},
                                            bridgeDestinationAsset: null,
                                            setFee: (t) {
                                              networkFee = t;
                                              calculateTotal();
                                            },
                                            setState: () {
                                              setState(() {});
                                            }),
                                        buildFee(lang.transfer5, total,
                                            widthQuery, chain, isDark),
                                        heightBox5,
                                        buildDepositButton(
                                            chain,
                                            widthQuery,
                                            primaryColor,
                                            lang,
                                            walletConnected,
                                            handler,
                                            lang.trust4,
                                            walletAddress,
                                            isDark,
                                            direction,
                                            addTransaction,
                                            Decimal.tryParse(
                                                    amountController.text) ??
                                                Decimal.parse("0.0")),
                                      ]))),
                  ))
                ])),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
