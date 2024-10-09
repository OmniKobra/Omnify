// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../crypto/features/ico_utils.dart';
import '../languages/app_language.dart';
import '../providers/wallet_provider.dart';
import '../toasts.dart';
import '../widgets/common/refresh_indicator.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/my_image.dart';
import '../widgets/common/error_widget.dart';
import '../providers/ico_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/governance/countdown.dart';
import '../widgets/network_picker.dart';
import '../utils.dart';

class CoinSeller extends StatefulWidget {
  const CoinSeller({super.key});

  @override
  State<CoinSeller> createState() => _CoinSellerState();
}

class _CoinSellerState extends State<CoinSeller>
    with AutomaticKeepAliveClientMixin {
  Decimal total = Decimal.parse("0.0");
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildStatChip(
      String title,
      int? intValue,
      Chain c,
      Decimal? doubleValue,
      bool widthQuery,
      bool isDark,
      bool isShares,
      bool isInRound,
      [bool? isInfo]) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          border: isInRound
              ? null
              : Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        leading: isInfo == null
            ? Text(title,
                style: TextStyle(
                    fontSize: widthQuery ? 16 : 14,
                    color: isDark ? Colors.white60 : Colors.black))
            : null,
        horizontalTitleGap: 5,
        title: Row(
          children: [
            if (isShares && isInfo == null)
              ConstrainedBox(
                  constraints: const BoxConstraints(
                      minHeight: 25, maxHeight: 25, minWidth: 25, maxWidth: 25),
                  child: const MyImage(url: Utils.logo, fit: null)),
            if (!isShares && isInfo == null)
              Utils.buildNetworkLogo(true, Utils.feeLogo(c), true, true),
            const SizedBox(width: 5),
            if (isInfo == null)
              Expanded(
                  child: Text(
                      intValue != null
                          ? intValue.toString()
                          : doubleValue!.toString(),
                      style: TextStyle(
                          color: isDark ? Colors.white60 : Colors.black))),
            if (isInfo != null)
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontSize: widthQuery ? 16 : 14,
                        color: isDark ? Colors.white60 : Colors.black)),
              )
          ],
        ),
      ),
    );
  }

  Widget buildFee(Chain c, String label, Decimal amount, bool widthQuery,
      bool isDark, int decimals) {
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
              SizedBox(
                  child: Utils.buildNetworkLogo(
                      widthQuery, Utils.feeLogo(c), true, true)),
              const SizedBox(width: 5),
              Text(Utils.removeTrailingZeros(amount.toStringAsFixed(decimals)),
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14))
            ])
      ],
    );
  }

  Widget buildPayButton({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required bool widthQuery,
    required Color primaryColor,
    required AppLanguage lang,
    required bool walletConnected,
    required void Function(BuildContext) connectWallet,
    required bool isDark,
    required TextDirection direction,
    required void Function(int) buyCoins,
  }) {
    return TextButton(
        onPressed: walletConnected
            ? () async {
                if (formKey.currentState!.validate()) {
                  Utils.showLoadingDialog(context, lang, widthQuery);
                  var _wantAmmount = int.parse(controller.text);
                  final txHash = await IcoUtils.buyCoins(
                      c: c,
                      client: client,
                      wcClient: wcClient,
                      sessionTopic: sessionTopic,
                      walletAddress: walletAddress,
                      want: _wantAmmount);
                  if (txHash != null) {
                    Future.delayed(const Duration(seconds: 1), () {
                      buyCoins(_wantAmmount);
                      controller.clear();
                      setState(() {});
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
                    ? Text(lang.coinseller6,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white))
                    : Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(lang.home6,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white))
                      ]))));
  }

  @override
  void initState() {
    super.initState();
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final ico = Provider.of<IcoProvider>(context, listen: false);
    final c = ico.currentChain;
    ico.setFuture(c, theme.client, false);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void calculateTotal(int amount, Decimal pricePerCoin) {
    total = Decimal.parse("0.0");
    Decimal amountDecimal = Decimal.fromInt(amount);
    total = amountDecimal * pricePerCoin;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final wallet = Provider.of<WalletProvider>(context);
    final walletMethods = Provider.of<WalletProvider>(context, listen: false);
    final connectWallet = walletMethods.connectWallet;
    final isDark = theme.isDark;
    final now = DateTime.now();
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    var wantAmount = int.tryParse(controller.text) ?? 0;
    super.build(context);
    return Form(
      key: formKey,
      child: Container(
          color: isDark ? Colors.black : Colors.grey[50],
          child: FutureBuilder(
              future: Provider.of<IcoProvider>(context).initializeIco,
              builder: (_, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const MyLoading();
                }
                if (snap.hasError) {
                  return MyError(() {
                    final c = Provider.of<IcoProvider>(context, listen: false)
                        .currentChain;
                    Provider.of<IcoProvider>(context, listen: false)
                        .setFuture(c, theme.client, true);
                  });
                }
                return Builder(builder: (ctx) {
                  final ico = Provider.of<IcoProvider>(ctx);
                  calculateTotal(wantAmount, ico.startingPrice);
                  final c = ico.currentChain;
                  final isIcoStart = ico.icoStart.isAfter(now);
                  final icoEnd = ico.icoEnd;
                  final isOngoing =
                      icoEnd.isAfter(now) && ico.icoStart.isBefore(now);
                  final children = [
                    const Row(
                      children: [
                        NetworkPicker(
                            isExplorer: false,
                            isGovernance: false,
                            isIco: true),
                      ],
                    ),
                    if (isIcoStart || isOngoing) const SizedBox(height: 8),
                    if (isIcoStart || isOngoing)
                      RoundCountdown(
                          isInRounds: false,
                          isIcoStart: isIcoStart,
                          isCoinDuration: false,
                          isRoundEnd: false,
                          roundDate: null),
                    const SizedBox(height: 8),
                    Wrap(
                      children: [
                        buildStatChip(
                            lang.coinseller1,
                            ico.totalSupply,
                            c,
                            Decimal.parse("0.0"),
                            widthQuery,
                            isDark,
                            true,
                            false),
                        buildStatChip(
                            lang.coinseller2,
                            ico.soldCoins,
                            c,
                            Decimal.parse("0.0"),
                            widthQuery,
                            isDark,
                            true,
                            false),
                        buildStatChip(
                            lang.coinseller3,
                            ico.remainingCoins,
                            c,
                            Decimal.parse("0.0"),
                            widthQuery,
                            isDark,
                            true,
                            false),
                        buildStatChip(
                            lang.coinseller4,
                            null,
                            c,
                            ico.startingPrice,
                            widthQuery,
                            isDark,
                            false,
                            false),
                        buildStatChip(
                            "${lang.coinseller7}: ${ico.omnicoinAddress}",
                            0,
                            c,
                            Decimal.parse("0.0"),
                            widthQuery,
                            isDark,
                            false,
                            false,
                            true),
                        buildStatChip(
                            "${lang.coinseller8}: Omnify Coin",
                            0,
                            c,
                            Decimal.parse("0.0"),
                            widthQuery,
                            isDark,
                            false,
                            false,
                            true),
                        buildStatChip(
                            "${lang.coinseller9}: OFY",
                            0,
                            c,
                            Decimal.parse("0.0"),
                            widthQuery,
                            isDark,
                            false,
                            false,
                            true),
                        buildStatChip(
                            "${lang.coinseller10}: 0",
                            0,
                            c,
                            Decimal.parse("0.0"),
                            widthQuery,
                            isDark,
                            false,
                            false,
                            true),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      ConstrainedBox(
                          constraints: const BoxConstraints(
                              minHeight: 25,
                              maxHeight: 25,
                              minWidth: 25,
                              maxWidth: 25),
                          child: const MyImage(url: Utils.logo, fit: null)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: TextFormField(
                                  controller: controller,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) {
                                    setState(() {});
                                  },
                                  validator: (v) {
                                    var _amount = int.tryParse(v!) ?? 0;
                                    if (v.isEmpty ||
                                        v.replaceAll(" ", "").isEmpty ||
                                        _amount > ico.remainingCoins ||
                                        _amount < 1) {
                                      return '';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
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
                                          FloatingLabelBehavior.never))))
                    ]),
                    const SizedBox(height: 8),
                    buildFee(c, lang.coinseller5, total, widthQuery, isDark,
                        Utils.nativeTokenDecimals(c)),
                    if (isOngoing) const SizedBox(height: 8),
                    if (isOngoing)
                      buildPayButton(
                        c: c,
                        client: theme.client,
                        wcClient: theme.walletClient,
                        sessionTopic: theme.stateSessionTopic,
                        walletAddress: walletMethods.getAddressString(c),
                        widthQuery: widthQuery,
                        primaryColor: primaryColor,
                        lang: lang,
                        walletConnected: wallet.isWalletConnected,
                        connectWallet: connectWallet,
                        isDark: isDark,
                        direction: theme.textDirection,
                        buyCoins: Provider.of<IcoProvider>(ctx, listen: false)
                            .buyCoins,
                      ),
                    if (isOngoing) const SizedBox(height: 8),
                    const SizedBox(height: 450),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ];
                  final row = Row(children: [
                    if (widthQuery) const Spacer(flex: 1),
                    Expanded(
                        flex: widthQuery ? 2 : 20,
                        child: widthQuery
                            ? Column(children: children)
                            : MyRefresh(
                                onRefresh: () async {
                                  final c = Provider.of<IcoProvider>(context,
                                          listen: false)
                                      .currentChain;
                                  Provider.of<IcoProvider>(context,
                                          listen: false)
                                      .setFuture(c, theme.client, true);
                                },
                                child: ListView(
                                    padding: const EdgeInsets.all(8.0),
                                    children: children),
                              )),
                    if (widthQuery) const Spacer(flex: 1),
                  ]);
                  if (widthQuery) {
                    return MyRefresh(
                      onRefresh: () async {
                        final c =
                            Provider.of<IcoProvider>(context, listen: false)
                                .currentChain;
                        Provider.of<IcoProvider>(context, listen: false)
                            .setFuture(c, theme.client, true);
                      },
                      child: ListView(
                          padding: const EdgeInsets.all(8.0), children: [row]),
                    );
                  } else {
                    return row;
                  }
                });
              })),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
