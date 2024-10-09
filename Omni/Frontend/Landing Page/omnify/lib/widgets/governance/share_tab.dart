// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../crypto/features/gov_utils.dart';
import '../../languages/app_language.dart';
import '../../models/distribution_round.dart';
import '../../providers/governance_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../toasts.dart';
import '../../utils.dart';
import '../my_image.dart';
import '../nestedScroller.dart';
import '../network_picker.dart';
import 'show_more.dart';
import 'countdown.dart';

class SharesTab extends StatefulWidget {
  final ScrollController controller;
  const SharesTab({super.key, required this.controller});

  @override
  State<SharesTab> createState() => _SharesTabState();
}

class _SharesTabState extends State<SharesTab> {
  Widget buildDistributionRound({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required int shares,
    required DistributionRound round,
    required bool widthQuery,
    required bool isDark,
    required AppLanguage lang,
    required TextDirection direction,
  }) {
    final withdrawn = round.profitsWithdrawn / round.feesCollected;
    final withdrawnPercentage = Decimal.parse(withdrawn
            .toDecimal(scaleOnInfinitePrecision: 2)
            .floor(scale: 2)
            .toStringAsFixed(2)) *
        Decimal.parse("100");
    final remains = round.profitsRemaining / round.feesCollected;
    final remainsPercentage = Decimal.parse(remains
            .toDecimal(scaleOnInfinitePrecision: 2)
            .floor(scale: 2)
            .toStringAsFixed(2)) *
        Decimal.parse("100");
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      padding: const EdgeInsets.all(8),
      width: widthQuery ? 400 : double.infinity,
      decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("${lang.shares7} #${round.roundNumber}"),
          const SizedBox(height: 5),
          PrimerProgressBar(
            segments: [
              Segment(
                  value: withdrawnPercentage.floor().toBigInt().toInt(),
                  valueLabel:
                      Text("${withdrawnPercentage.floor().toString()}%"),
                  color: Colors.red,
                  label: Text(lang.shares8)),
              Segment(
                  value: remainsPercentage.floor().toBigInt().toInt(),
                  valueLabel: Text("${remainsPercentage.floor().toString()}%"),
                  color: Colors.green,
                  label: Text(lang.shares9)),
            ],
          ),
          buildStatChip(lang.shares10, null, c, round.feesCollected, widthQuery,
              isDark, false, true),
          buildStatChip(lang.shares11, null, c, round.profitPerShare,
              widthQuery, isDark, false, true),
          buildStatChip(lang.shares12, null, c, round.profitsWithdrawn,
              widthQuery, isDark, false, true),
          buildStatChip(lang.shares13, null, c, round.profitsRemaining,
              widthQuery, isDark, false, true),
          buildStatChip(lang.shares14, null, c, round.yourCut, widthQuery,
              isDark, false, true),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(round.roundOpen ? lang.shares15 : lang.shares16,
                style: TextStyle(
                    color: round.roundOpen ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: widthQuery ? 17 : 15)),
          ]),
          if (round.roundOpen)
            RoundCountdown(
                isInRounds: false,
                isIcoStart: false,
                isCoinDuration: false,
                isRoundEnd: true,
                roundDate: round.date),
          if ((round.roundOpen && round.hasHeldTokensEnough && shares > 0) ||
              (!round.roundOpen && round.hasWithdrawn))
            const SizedBox(height: 5),
          if ((round.roundOpen && round.hasHeldTokensEnough && shares > 0) ||
              (!round.roundOpen && round.hasWithdrawn))
            TextButton(
                onPressed: () async {
                  if (!round.hasWithdrawn &&
                      round.hasHeldTokensEnough &&
                      shares > 0) {
                    Utils.showLoadingDialog(context, lang, widthQuery);
                    final txHash = await GovUtils.withdrawProfits(
                        c: c,
                        client: client,
                        wcClient: wcClient,
                        sessionTopic: sessionTopic,
                        walletAddress: walletAddress);
                    if (txHash != null) {
                      Future.delayed(const Duration(seconds: 1), () {
                        round.withdraw();
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
                },
                style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                    elevation: WidgetStatePropertyAll(5),
                    overlayColor: WidgetStatePropertyAll(Colors.transparent)),
                child: Container(
                    height: 50,
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        border: round.hasWithdrawn
                            ? Border.all(color: Colors.red)
                            : null,
                        color: round.hasWithdrawn
                            ? Colors.transparent
                            : Colors.green,
                        shape: BoxShape.rectangle,
                        borderRadius:
                            BorderRadius.circular(widthQuery ? 15 : 10)),
                    child: Center(
                        child: Text(
                            round.hasWithdrawn ? lang.shares17 : lang.shares18,
                            style: TextStyle(
                                fontSize: 18,
                                color: round.hasWithdrawn
                                    ? Colors.red
                                    : Colors.white)))))
        ],
      ),
    );
  }

  Widget buildStatChip(
      String title,
      int? intValue,
      Chain c,
      Decimal? doubleValue,
      bool widthQuery,
      bool isDark,
      bool isShares,
      bool isInRound) {
    return Container(
      width: isInRound
          ? null
          : widthQuery
              ? 400
              : double.infinity,
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          border: isInRound
              ? null
              : Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        leading: Text(title,
            style: TextStyle(
                fontSize: widthQuery ? 16 : 14,
                color: isDark ? Colors.white60 : Colors.black)),
        horizontalTitleGap: 5,
        title: Row(
          children: [
            if (isShares)
              ConstrainedBox(
                  constraints: const BoxConstraints(
                      minHeight: 25, maxHeight: 25, minWidth: 25, maxWidth: 25),
                  child: const MyImage(url: Utils.logo, fit: null)),
            if (!isShares)
              Utils.buildNetworkLogo(true, Utils.feeLogo(c), true, true),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                  intValue != null
                      ? intValue.toString()
                      : doubleValue!.toString(),
                  style:
                      TextStyle(color: isDark ? Colors.white60 : Colors.black)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDisclaimer(String disclaimer, bool widthQuery, bool isDark) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  color: isDark ? Colors.black : Colors.white),
              child: Text(
                disclaimer,
                style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black,
                    fontSize: widthQuery ? 16 : 14),
              ),
            )),
        if (widthQuery) const Spacer(flex: 3)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dir = theme.textDirection;
    final isDark = theme.isDark;
    final client = theme.client;
    final wcClient = theme.walletClient;
    final sessionTopic = theme.stateSessionTopic;
    final walletProvider = Provider.of<WalletProvider>(context);
    final walletMethods = Provider.of<WalletProvider>(context, listen: false);
    final gov = Provider.of<GovernanceProvider>(context);
    final rounds = gov.rounds;
    final yourShares = gov.yourShares;
    final yourProfitsWithdrawn = gov.yourProfitsWithdrawn;
    final totalProfitsDistributed = gov.totalProfitsDistributed;
    final currentProfits = gov.currentProfits;
    final c = gov.currentChain;
    final isConnected = walletProvider.isWalletConnected;
    final walletAddress = walletMethods.getAddressString(c);
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    var current = currentProfits / Decimal.parse("250000");
    return Container(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        child: NestedScroller(
          controller: widget.controller,
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: NetworkPicker(
                    isExplorer: false, isGovernance: true, isIco: false),
              ),
              if (!isConnected) const SizedBox(height: 15),
              if (isConnected)
                Wrap(
                  children: [
                    buildStatChip(lang.shares, yourShares, c, null, widthQuery,
                        isDark, true, false),
                    buildStatChip(lang.shares2, null, c, yourProfitsWithdrawn,
                        widthQuery, isDark, false, false),
                    buildStatChip(lang.shares19, null, c, currentProfits,
                        widthQuery, isDark, false, false),
                    buildStatChip(
                        "${lang.profit} / OFY ≈ ",
                        null,
                        c,
                        current.toDecimal(
                            scaleOnInfinitePrecision:
                                Utils.nativeTokenDecimals(c)),
                        widthQuery,
                        isDark,
                        false,
                        false),
                    buildStatChip(
                        lang.shares3,
                        null,
                        c,
                        totalProfitsDistributed,
                        widthQuery,
                        isDark,
                        false,
                        false),
                    if (gov.yourShares > 0)
                      const RoundCountdown(
                          isInRounds: false,
                          isIcoStart: false,
                          isCoinDuration: true,
                          isRoundEnd: false,
                          roundDate: null),
                    if (rounds.isNotEmpty &&
                        currentProfits >= Decimal.parse("1.0"))
                      const RoundCountdown(
                          isInRounds: true,
                          isIcoStart: false,
                          isCoinDuration: false,
                          isRoundEnd: false,
                          roundDate: null),
                  ],
                ),
              if (isConnected)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: buildDisclaimer(
                      lang.shares4(gov.coinHoldingPeriod.inDays),
                      widthQuery,
                      isDark),
                ),
              if (isConnected) const SizedBox(height: 8),
              if (isConnected)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: buildDisclaimer(
                      lang.shares20(gov.roundInterval.inDays),
                      widthQuery,
                      isDark),
                ),
              if (isConnected) const SizedBox(height: 5),
              if (isConnected)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(lang.shares5,
                      style: TextStyle(
                          fontSize: widthQuery ? 18 : 16,
                          color: isDark ? Colors.white60 : Colors.black)),
                ),
              if (isConnected) const SizedBox(height: 5),
              if (isConnected)
                Wrap(children: [
                  ...rounds.map((r) => buildDistributionRound(
                        c: c,
                        client: client,
                        wcClient: wcClient,
                        sessionTopic: sessionTopic,
                        walletAddress: walletAddress,
                        shares: yourShares,
                        round: r,
                        widthQuery: widthQuery,
                        isDark: isDark,
                        lang: lang,
                        direction: dir,
                      )),
                  const Row(children: [
                    ShowMore(
                        isInMilestones: false,
                        isInProposals: false,
                        isInShares: true)
                  ])
                ]),
              if (!isConnected)
                Center(
                    child: Icon(Icons.wallet,
                        color: Colors.grey.shade500, size: 80)),
              if (!isConnected)
                Center(
                    child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: widthQuery ? 8 : 24.0),
                  child: Text(lang.shares6,
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: widthQuery ? 19 : 16)),
                )),
              const SizedBox(height: 15),
              const SizedBox(height: 150),
              if (isConnected) const SizedBox(height: 50)
            ],
          ),
        ));
  }
}
