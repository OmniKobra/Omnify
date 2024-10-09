import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/milestone.dart';
import '../../providers/governance_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';
import '../nestedScroller.dart';
import '../network_picker.dart';
import 'show_more.dart';

class MilestoneTab extends StatefulWidget {
  final ScrollController controller;
  const MilestoneTab({super.key, required this.controller});

  @override
  State<MilestoneTab> createState() => _MilestoneTabState();
}

class _MilestoneTabState extends State<MilestoneTab> {
  Widget buildMilestone(
      Milestone m, bool isDark, bool widthQuery, String langCode) {
    final date = Utils.timeStamp(m.dateCompleted, langCode, context);
    return Card(
        color: isDark ? Colors.grey[600] : Colors.white,
        surfaceTintColor: Colors.white,
        child: ListTile(
          leading: Icon(Icons.check_circle_rounded,
              color: isDark ? Colors.black : Colors.lightGreenAccent, size: 50),
          title: Text(m.title,
              style: TextStyle(
                  fontSize: widthQuery ? 18 : 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          subtitle: Text("${m.description}\n$date",
              style: TextStyle(
                  fontSize: widthQuery ? 16 : 13, color: Colors.black)),
          isThreeLine: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final milestones = Provider.of<GovernanceProvider>(context).milestones;
    final langCode = theme.langCode;
    final isDark = theme.isDark;
    final widthQuery = Utils.widthQuery(context);
    return Container(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        child: NestedScroller(
          controller: widget.controller,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 200),
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: NetworkPicker(
                    isExplorer: false, isGovernance: true, isIco: false),
              ),
              const SizedBox(height: 10),
              ...milestones
                  .map((e) => buildMilestone(e, isDark, widthQuery, langCode)),
              const ShowMore(
                  isInMilestones: true, isInProposals: false, isInShares: false)
            ],
          ),
        ));
  }
}
