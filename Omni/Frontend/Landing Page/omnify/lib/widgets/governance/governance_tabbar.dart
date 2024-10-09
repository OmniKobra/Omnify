import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../utils.dart';

class GovernanceTabbar extends StatefulWidget {
  const GovernanceTabbar({super.key});

  @override
  State<GovernanceTabbar> createState() => _GovernanceTabbarState();
}

class _GovernanceTabbarState extends State<GovernanceTabbar> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final primaryColor = colorScheme.primary;
    final accentColor = colorScheme.secondary;
    final widthQuery = Utils.widthQuery(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final lang = Utils.language(context);
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            margin: const EdgeInsets.all(10),
            height: kToolbarHeight - 16.0,
            width: widthQuery ? deviceWidth / 2 : null,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(20.0)),
            child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: accentColor),
                labelColor: isDark ? Colors.white70 : Colors.white,
                unselectedLabelColor: isDark ? Colors.white70 : Colors.white,
                tabs: [
                  Text(lang.governance1),
                  Text(lang.governance2),
                  Text(lang.governance3)
                ])));
  }
}
