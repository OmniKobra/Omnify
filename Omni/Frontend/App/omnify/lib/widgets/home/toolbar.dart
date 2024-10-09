import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../routes.dart';
import '../../utils.dart';

class MyToolbar extends StatefulWidget {
  const MyToolbar({super.key});

  @override
  State<MyToolbar> createState() => _MyToolbarState();
}

class _MyToolbarState extends State<MyToolbar> {
  bool isExpanded = false;
  Widget navButton(
      String tooltip, IconData icon, String routeName, bool isDark) {
    return IconButton(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        tooltip: tooltip,
        icon: Icon(icon,
            color: isDark
                ? Colors.white60
                : Theme.of(context).colorScheme.primary),
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.pushNamed(context, routeName);
        });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final dir = Provider.of<ThemeProvider>(context).textDirection;
    final lang = Utils.language(context);
    return Container(
        margin: EdgeInsets.only(
            top: 8,
            right: dir == TextDirection.rtl ? 0 : 8,
            left: dir == TextDirection.rtl ? 8 : 0),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isExpanded)
                navButton(lang.home12, Icons.explore_outlined, Routes.discover,
                    isDark),
              if (isExpanded)
                navButton(lang.home6, Icons.search, Routes.explorer, isDark),
              if (isExpanded)
                navButton(lang.home10, Icons.hourglass_empty_rounded,
                    Routes.transactions, isDark),
              if (isExpanded)
                navButton(lang.home9, Icons.bar_chart_rounded,
                    Routes.activityScreen, isDark),
              if (isExpanded)
                navButton(lang.home7, Icons.info_outline_rounded,
                    Routes.settingsScreen, isDark),
              IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  tooltip: isExpanded ? lang.home13 : lang.home14,
                  icon: Icon(
                      !isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: isDark
                          ? Colors.white60
                          : Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    isExpanded = !isExpanded;
                    setState(() {});
                  })
            ]));
  }
}
