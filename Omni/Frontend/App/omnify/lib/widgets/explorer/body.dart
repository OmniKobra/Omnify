import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../utils.dart';
import 'escrow_tab.dart';
import 'bridge_tab.dart';
import 'transfers_tab.dart';
import 'trust_tab.dart';
import 'payments_tab.dart';

class ExplorerBody extends StatefulWidget {
  const ExplorerBody({super.key});

  @override
  State<ExplorerBody> createState() => _ExplorerBodyState();
}

class _ExplorerBodyState extends State<ExplorerBody> {
  Widget buildLabel(String label, bool widthQuery) {
    if (widthQuery) {
      return Text(label);
    } else {
      return SizedBox(
          width: MediaQuery.of(context).size.width / 5,
          child: Center(child: Text(label)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    return DefaultTabController(
        animationDuration: Duration.zero,
        initialIndex: 0,
        length: 5,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TabBar(
                    padding: const EdgeInsets.all(0),
                    tabAlignment: widthQuery ? null : TabAlignment.start,
                    isScrollable: !widthQuery,
                    indicatorSize: TabBarIndicatorSize.tab,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: primaryColor))),
                    labelColor: primaryColor,
                    labelPadding: const EdgeInsets.all(4),
                    unselectedLabelColor: isDark ? Colors.white70 : Colors.grey,
                    tabs: [
                      buildLabel(lang.explorer11, widthQuery),
                      buildLabel(lang.explorer15, widthQuery),
                      buildLabel(lang.explorer12, widthQuery),
                      buildLabel(lang.home4, widthQuery),
                      buildLabel(lang.home5, widthQuery),
                    ]),
              )),
          AspectRatio(
            aspectRatio: widthQuery ? 16 / 9 : 9 / 16,
            child: const TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TransfersTab(),
                  PaymentsTab(),
                  TrustTab(),
                  BridgeTab(),
                  EscrowTab()
                ]),
          ),
        ]));
  }
}
