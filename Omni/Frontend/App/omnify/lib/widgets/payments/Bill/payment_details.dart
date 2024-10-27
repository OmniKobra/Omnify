// ignore_for_file: use_build_context_synchronously, prefer_conditional_assignment

import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../crypto/features/payment_utils.dart';
import '../../../languages/app_language.dart';
import '../../../models/transaction.dart';
import '../../../providers/fees_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/transactions_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../toasts.dart';
import '../../../utils.dart';
import '../../common/error_widget.dart';
import '../../common/loading_widget.dart';
import '../../common/network_fee.dart';
import '../../common/omnify_fee.dart';

class PaymentDetails extends StatefulWidget {
  final Chain chain;
  final Widget Function(bool, bool, TextDirection, String)? buildLogo;
  final String vendorAddress;
  final Decimal amount;
  final Decimal amountperMonth;
  final Decimal finalInstallment;
  final String paymentID;
  final int installmentPeriod;
  final bool hasInstallments;
  final Decimal fullAmount;
  final bool isInstallments;
  final void Function()? installmentHandler;
  const PaymentDetails(
      {required this.buildLogo,
      required this.vendorAddress,
      required this.amount,
      required this.amountperMonth,
      required this.finalInstallment,
      required this.chain,
      required this.paymentID,
      required this.isInstallments,
      required this.hasInstallments,
      required this.fullAmount,
      required this.installmentPeriod,
      required this.installmentHandler,
      super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  Decimal networkFee = Decimal.parse("0.0");
  Decimal omnifyFee = Decimal.parse("0.0");
  bool paymentComplete = false;
  bool paymentAlreadyPaid = false;
  bool chainUnsupported = false;
  Timer? timer;
  Future<void>? _checkPaid;
  Widget buildFee(String label, Decimal amount, bool widthQuery, Chain c,
          bool isDark, bool isPeriod, int period) =>
      Row(
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
                  if (!isPeriod)
                    SizedBox(
                        child: Utils.buildNetworkLogo(
                            widthQuery, Utils.feeLogo(c), true, true)),
                  if (!isPeriod) const SizedBox(width: 5),
                  Text(
                      isPeriod
                          ? period.toString()
                          : Utils.removeTrailingZeros(amount
                              .toStringAsFixed(Utils.nativeTokenDecimals(c))),
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14))
                ])
          ]);

  Widget buildVendor(bool widthQuery, bool isDark, String vendor) {
    final lang = Utils.language(context);
    final container = Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Text(
          "${lang.pay17}  $vendor",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white60 : Colors.black,
              fontSize: widthQuery ? 18 : 16),
        ));
    return container;
  }

  Widget buildBillBox(bool isDark, bool widthQuery, Chain c) {
    final lang = Utils.language(context);
    final total = widget.amount + networkFee + omnifyFee;
    final bill = Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(5),
        color: isDark ? Colors.grey[800] : Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFee(lang.pay8, widget.amount, widthQuery, c, isDark, false, 0),
          if (widget.isInstallments || widget.hasInstallments)
            buildFee(lang.pay12, widget.amountperMonth, widthQuery, c, isDark,
                false, 0),
          if (widget.isInstallments || widget.hasInstallments)
            buildFee(lang.pay53, widget.finalInstallment, widthQuery, c, isDark,
                false, 0),
          if (widget.isInstallments || widget.hasInstallments)
            buildFee(
                lang.pay54, widget.fullAmount, widthQuery, c, isDark, false, 0),
          if (widget.isInstallments || widget.hasInstallments)
            buildFee(lang.pay13, Decimal.parse("3"), widthQuery, c, isDark,
                true, widget.installmentPeriod),
          NetworkFee(
              isInTransfers: false,
              currentTransfer: null,
              isSpecialCase: false,
              isPaymentFee: !widget.isInstallments,
              isInInstallmentFee: widget.isInstallments,
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
              isPaymentFee: !widget.isInstallments,
              isInInstallmentFee: widget.isInstallments,
              isTrust: false,
              isTrustModifying: false,
              isTrustCreating: false,
              isBridge: false,
              isEscrow: false,
              isRefuel: false,
              currentTransfer: null,
              newBeneficiaries: 0,
              setState: () => setState(() {}),
              setFee: (f) {
                omnifyFee = f;
              }),
          Divider(color: isDark ? Colors.grey.shade600 : Colors.grey.shade300),
          buildFee(lang.pay14, total, widthQuery, c, isDark, false, 0),
        ],
      ),
    );
    return bill;
  }

  Widget buildNetwork(Chain c, bool widthQuery, bool isDark) {
    final container = Container(
        width: widthQuery ? double.infinity : null,
        decoration: BoxDecoration(
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5),
          color: isDark ? Colors.grey[800] : Colors.white,
        ),
        child: Container(
            margin: const EdgeInsets.all(8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Utils.buildNetworkLogo(true, c, true),
              const SizedBox(width: 7.5),
              Text(c.name,
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 19))
            ])));
    return container;
  }

  Widget buildDisclaimer(bool widthQuery) {
    final lang = Utils.language(context);
    final dis = Text(lang.pay15,
        style: TextStyle(color: Colors.grey, fontSize: widthQuery ? 14 : 13));
    return dis;
  }

  Widget buildUnsupported(bool widthQuery) {
    final lang = Utils.language(context);
    final dis = Text(lang.unsupportedNetwork,
        style: TextStyle(color: Colors.grey, fontSize: widthQuery ? 14 : 13));
    return dis;
  }

  Widget buildPayButton(
      Chain c,
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
        onPressed: paymentComplete || paymentAlreadyPaid
            ? () {}
            : walletConnected
                ? () async {
                    if (!paymentComplete) {
                      FocusScope.of(context).unfocus();
                      final now = DateTime.now();
                      final theme =
                          Provider.of<ThemeProvider>(context, listen: false);
                      final client = theme.client;
                      final wcClient = theme.walletClient;
                      final sessionTopic = theme.stateSessionTopic;
                      final id = widget.paymentID;
                      if (widget.isInstallments) {
                        Utils.showLoadingDialog(context, lang, widthQuery);
                        final txHash = await PaymentUtils.payInstallment(
                            c: c,
                            client: client,
                            wcClient: wcClient,
                            sessionTopic: sessionTopic,
                            walletAddress: walletAddress,
                            id: id,
                            omnifyFee: omnifyFee,
                            paymentAmount: widget.amount,
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
                            setState(() {
                              paymentComplete = true;
                            });
                            Toasts.showSuccessToast(lang.transactionSent,
                                lang.transactionSent2, isDark, direction);
                            widget.installmentHandler!();
                          });
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          Toasts.showErrorToast(
                              lang.toast13, lang.toasts30, isDark, direction);
                        }
                      } else {
                        if (!paymentAlreadyPaid) {
                          Utils.showLoadingDialog(context, lang, widthQuery);
                          final txHash = await PaymentUtils.makePayement(
                              c: c,
                              client: client,
                              wcClient: wcClient,
                              sessionTopic: sessionTopic,
                              walletAddress: walletAddress,
                              id: id,
                              amountDue: widget.amount,
                              omnifyFee: omnifyFee,
                              vendorAddress: widget.vendorAddress,
                              isInstallments: widget.hasInstallments,
                              fullAmount: widget.fullAmount,
                              period: widget.installmentPeriod,
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
                              setState(() {
                                paymentComplete = true;
                              });
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
                color: paymentComplete || paymentAlreadyPaid
                    ? Colors.green
                    : primaryColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(widthQuery ? 15 : 10)),
            child: Center(
                child: paymentComplete || paymentAlreadyPaid
                    ? Text(lang.paymentActivity13,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white))
                    : walletConnected
                        ? Text(lang.pay16,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white))
                        : Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(lang.home8,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.white))
                          ]))));
  }

  Future<void> checkPaid(client) async {
    if (!paymentComplete && !paymentAlreadyPaid & !widget.isInstallments) {
      var isPaid =
          await PaymentUtils.checkPaid(widget.chain, widget.paymentID, client);
      paymentAlreadyPaid = isPaid;
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final fees = Provider.of<FeesProvider>(context, listen: false);
    if (!widget.isInstallments) {
      _checkPaid = checkPaid(theme.client);
      omnifyFee = fees.paymentfees.amountPerPayment;
    } else {
      omnifyFee = fees.paymentfees.amountPerInstallment;
    }
    if (wallet.isWalletConnected) {
      if (theme.startingChain != widget.chain) {
        if (wallet.supportedChains.contains(widget.chain)) {
          theme.setStartingChain(
              widget.chain, context, wallet.getAddressString(widget.chain));
        } else {
          chainUnsupported = true;
        }
      }
    } else {
      if (theme.startingChain != widget.chain) {
        if (Utils.ourChains.contains(widget.chain)) {
          theme.setStartingChain(
              widget.chain, context, wallet.getAddressString(widget.chain));
        } else {
          chainUnsupported = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lang = Utils.language(context);
    final wallet = Provider.of<WalletProvider>(context);
    final walletConnected = wallet.isWalletConnected;
    final walletAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(widget.chain);
    final connectWallet =
        Provider.of<WalletProvider>(context, listen: false).connectWallet;
    final addTransaction =
        Provider.of<TransactionsProvider>(context, listen: false)
            .addTransaction;
    if (!paymentComplete && !paymentAlreadyPaid & !widget.isInstallments) {
      if (timer == null) {
        timer = Timer.periodic(Utils.queryFeesDuration, (t) {
          checkPaid(theme.client);
        });
      }
    } else {
      if (timer != null) {
        timer!.cancel();
        timer = null;
      }
    }
    final children = [
      const SizedBox(height: 5),
      buildNetwork(widget.chain, widthQuery, isDark),
      const SizedBox(height: 5),
      buildVendor(widthQuery, isDark, widget.vendorAddress),
      const SizedBox(height: 5),
      buildBillBox(isDark, widthQuery, widget.chain),
      if (walletConnected && !chainUnsupported) const SizedBox(height: 5),
      if (walletConnected && !chainUnsupported) buildDisclaimer(widthQuery),
      const SizedBox(height: 5),
      if (!chainUnsupported)
        buildPayButton(
            widget.chain,
            widthQuery,
            primaryColor,
            lang,
            walletConnected,
            connectWallet,
            walletAddress,
            isDark,
            dir,
            addTransaction),
      if (chainUnsupported) const SizedBox(height: 5),
      if (chainUnsupported) buildUnsupported(widthQuery),
      const SizedBox(height: 8),
    ];
    final row = Row(children: [
      if (widthQuery) const Spacer(flex: 1),
      Expanded(
          flex: widthQuery ? 2 : 20,
          child: widthQuery
              ? Column(children: children)
              : ListView(children: children)),
      if (widthQuery) const Spacer(flex: 1),
    ]);
    return Directionality(
      textDirection: dir,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        if (widget.buildLogo != null)
          widget.buildLogo!(isDark, widthQuery, dir, lang.pay5),
        Expanded(
          child: FutureBuilder(
              future: _checkPaid,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const MyLoading();
                }
                if (snap.hasError) {
                  return MyError(() {
                    setState(() {
                      _checkPaid = checkPaid(theme.client);
                    });
                  });
                }
                if (widthQuery) {
                  return ListView(children: [row]);
                } else {
                  return row;
                }
              }),
        ),
      ]),
    );
  }
}
