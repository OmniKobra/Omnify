import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/governance_provider.dart';
import '../../utils.dart';

class ShowMore extends StatefulWidget {
  final bool isInMilestones;
  final bool isInProposals;
  final bool isInShares;
  const ShowMore({
    super.key,
    required this.isInMilestones,
    required this.isInProposals,
    required this.isInShares,
  });

  @override
  State<ShowMore> createState() => _ShowMoreState();
}

class _ShowMoreState extends State<ShowMore> {
  @override
  Widget build(BuildContext context) {
    final gov = Provider.of<GovernanceProvider>(context);
    final govMethods = Provider.of<GovernanceProvider>(context, listen: false);
    final showMoreMilestones = govMethods.showMoreMilestones;
    final showMoreProposals = govMethods.showMoreProposals;
    final showMoreRounds = govMethods.showMoreRounds;
    var shownMilestones = gov.milestones;
    var allMilestones = gov.allMilestones;
    var shownProposals = gov.proposals;
    var allProposals = gov.allProposals;
    var shownRounds = gov.rounds;
    var allRounds = gov.allRounds;
    
    final lang = Utils.language(context);
    bool hasMore() {
      if (widget.isInMilestones) {
        return allMilestones.length > shownMilestones.length;
      }
      if (widget.isInProposals) {
        return allProposals.length > shownProposals.length;
      }
      if (widget.isInShares) {
        return allRounds.length > shownRounds.length;
      }
      return false;
    }

    void handler() {
      if (widget.isInMilestones) {
        showMoreMilestones();
      }
      if (widget.isInProposals) {
        showMoreProposals();
      }
      if (widget.isInShares) {
        showMoreRounds();
      }
    }

    return (hasMore())
        ? Center(
            child: TextButton(onPressed: handler, child: Text(lang.showMore)))
        : const SizedBox.shrink();
  }
}
