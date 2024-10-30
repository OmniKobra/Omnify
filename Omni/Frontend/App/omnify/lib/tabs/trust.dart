import 'package:flutter/material.dart';

import '../subtabs/manage_tab.dart';
import '../subtabs/withdrawal_tab.dart';
import '../subtabs/deposit_tab.dart';
import '../widgets/trust/tabbar.dart';

class Trust extends StatefulWidget {
  const Trust({super.key});

  @override
  State<Trust> createState() => _TrustState();
}

class _TrustState extends State<Trust>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController controller;
  handleTabSelection() {
    if (controller.index != controller.previousIndex) {
      FocusScope.of(context).unfocus();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        TabController(length: 3, vsync: this, animationDuration: Duration.zero);
    controller.addListener(handleTabSelection);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(() {});
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
        animationDuration: Duration.zero,
        initialIndex: 0,
        length: 3,
        child: Stack(children: [
          Column(children: [
            Expanded(
                child: TabBarView(
                    controller: controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                  WithdrawalTab(),
                  ManageTab(isSheet: false, deposit: null),
                  DepositTab(
                      isModification: false,
                      modificationDeposit: null,
                      setsStateManage: null),
                ])),
          ]),
          MyTabBar(controller: controller)
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}
