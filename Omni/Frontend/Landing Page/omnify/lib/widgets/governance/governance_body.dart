import 'package:flutter/material.dart';
import 'governance_tabbar.dart';
import 'proposals_tab.dart';
import 'milestone_tab.dart';
import 'share_tab.dart';
import '../../utils.dart';

class GovernanceBody extends StatefulWidget {
  final ScrollController controller;
  const GovernanceBody({super.key, required this.controller});

  @override
  State<GovernanceBody> createState() => _GovernanceBodyState();
}

class _GovernanceBodyState extends State<GovernanceBody> {
  @override
  Widget build(BuildContext context) {
    final widthQuery = Utils.widthQuery(context);
    return DefaultTabController(
        animationDuration: Duration.zero,
        initialIndex: 0,
        length: 3,
        child: Column(children: [
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: GovernanceTabbar()),
          AspectRatio(
            aspectRatio: widthQuery ? 16 / 9 : 9 / 16,
            child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ProposalsTab(controller: widget.controller),
                  MilestoneTab(controller: widget.controller),
                  SharesTab(controller: widget.controller)
                ]),
          )
        ]));
  }
}
