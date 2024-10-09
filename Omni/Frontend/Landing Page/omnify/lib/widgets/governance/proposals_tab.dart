// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:omnify/providers/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../crypto/features/gov_utils.dart';
import '../../languages/app_language.dart';
import '../../models/proposal.dart';
import '../../providers/governance_provider.dart';
import '../../providers/theme_provider.dart';
import '../../toasts.dart';
import '../../utils.dart';
import '../my_image.dart';
import '../nestedScroller.dart';
import '../network_picker.dart';
import 'show_more.dart';

class ProposalsTab extends StatefulWidget {
  final ScrollController controller;
  const ProposalsTab({super.key, required this.controller});

  @override
  State<ProposalsTab> createState() => _ProposalsTabState();
}

class _ProposalsTabState extends State<ProposalsTab> {
  Widget buildNetworkLogo(bool widthQuery, Chain c) {
    final double constraints = widthQuery ? 35 : 25;
    return ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: constraints,
            maxHeight: constraints,
            minWidth: constraints,
            maxWidth: constraints),
        child: MyImage(url: Utils.getLogoUrl(c), fit: null));
  }

  Widget buildHeader(Proposal p) {
    final widthQuery = Utils.widthQuery(context);
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: buildNetworkLogo(widthQuery, p.network),
        title: Text(p.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        subtitle: Text(p.submitter, style: const TextStyle(fontSize: 14)));
  }

  Widget buildProposal({
    required Chain c,
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required int shares,
    required Proposal p,
    required String langCode,
    required bool widthQuery,
    required bool isDark,
    required AppLanguage lang,
    required TextDirection dir,
  }) {
    return Container(
        key: ValueKey<String>(p.proposalId),
        height: 600,
        margin: const EdgeInsets.all(10),
        width: widthQuery ? 450 : double.infinity,
        decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade300)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(p),
            Divider(
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade300),
            Padding(
                padding: const EdgeInsets.all(8),
                child:
                    Text(p.description, style: const TextStyle(fontSize: 15))),
            const Spacer(),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(Utils.timeStamp(p.dateSubmitted, langCode, context),
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey))),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                    "${lang.votingEnds} ${Utils.timeStamp(p.expiration, langCode, context)}",
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey))),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text("${lang.yes}: ${p.yay}",
                    style: const TextStyle(color: Colors.green))),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text("${lang.no}: ${p.nay}",
                    style: const TextStyle(color: Colors.redAccent))),
            if (!p.hasVoted && p.allowedToVote && shares > 0)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          Utils.showLoadingDialog(context, lang, widthQuery);
                          final txHash = await GovUtils.voteYes(
                              c: c,
                              client: client,
                              wcClient: wcClient,
                              sessionTopic: sessionTopic,
                              walletAddress: walletAddress,
                              proposalID: p.proposalId);
                          if (txHash != null) {
                            Future.delayed(const Duration(seconds: 1), () {
                              p.voteYes(shares);
                              setState(() {});
                              Toasts.showSuccessToast(lang.transactionSent,
                                  lang.transactionSent2, isDark, dir);
                            });
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            Toasts.showErrorToast(
                                lang.toast13, lang.toasts30, isDark, dir);
                          }
                        },
                        style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(0),
                            overlayColor:
                                WidgetStatePropertyAll(Colors.transparent),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15)))),
                            backgroundColor: WidgetStatePropertyAll(
                                Colors.lightGreenAccent)),
                        child: Text(lang.yes,
                            style: const TextStyle(color: Colors.white))),
                  ),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            Utils.showLoadingDialog(context, lang, widthQuery);
                            final txHash = await GovUtils.voteNo(
                                c: c,
                                client: client,
                                wcClient: wcClient,
                                sessionTopic: sessionTopic,
                                walletAddress: walletAddress,
                                proposalID: p.proposalId);
                            if (txHash != null) {
                              Future.delayed(const Duration(seconds: 1), () {
                                p.voteNo(shares);
                                setState(() {});
                                Toasts.showSuccessToast(lang.transactionSent,
                                    lang.transactionSent2, isDark, dir);
                              });
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                              Toasts.showErrorToast(
                                  lang.toast13, lang.toasts30, isDark, dir);
                            }
                          },
                          style: const ButtonStyle(
                              elevation: WidgetStatePropertyAll(0),
                              overlayColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15)))),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.redAccent)),
                          child: Text(lang.no,
                              style: const TextStyle(color: Colors.white))))
                ],
              )
          ],
        ));
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
              ? 320
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

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final walletMethods = Provider.of<WalletProvider>(context, listen: false);
    final governance = Provider.of<GovernanceProvider>(context);
    final c = governance.currentChain;
    final proposals = governance.proposals;
    final walletAddress = walletMethods.getAddressString(c);
    final isDark = theme.isDark;
    final langCode = theme.langCode;
    final client = theme.client;
    final wcClient = theme.walletClient;
    final sessionTopic = theme.stateSessionTopic;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    return Container(
      color: isDark ? Colors.grey[850] : Colors.grey[100],
      child: NestedScroller(
        controller: widget.controller,
        child: ListView(padding: const EdgeInsets.only(bottom: 200), children: [
          const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: NetworkPicker(
                  isExplorer: false, isGovernance: true, isIco: false)),
          Wrap(children: [
            buildStatChip(lang.governance4, null, governance.currentChain,
                governance.feePerProposal, widthQuery, isDark, false, false)
          ]),
          if (!widthQuery)
            ...proposals.map((p) => buildProposal(
                  c: c,
                  client: client,
                  wcClient: wcClient,
                  walletAddress: walletAddress,
                  sessionTopic: sessionTopic,
                  shares: governance.yourShares,
                  p: p,
                  langCode: langCode,
                  widthQuery: widthQuery,
                  isDark: isDark,
                  lang: lang,
                  dir: theme.textDirection,
                )),
          if (widthQuery)
            Wrap(
              children: [
                ...proposals.map((p) => buildProposal(
                      c: c,
                      client: client,
                      wcClient: wcClient,
                      walletAddress: walletAddress,
                      sessionTopic: sessionTopic,
                      shares: governance.yourShares,
                      p: p,
                      langCode: langCode,
                      widthQuery: widthQuery,
                      isDark: isDark,
                      lang: lang,
                      dir: theme.textDirection,
                    )),
              ],
            ),
          const ShowMore(
              isInMilestones: false, isInProposals: true, isInShares: false)
        ]),
      ),
    );
  }
}
