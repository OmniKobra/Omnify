import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../utils.dart';

class MyTabBar extends StatefulWidget {
  final TabController controller;
  const MyTabBar({super.key, required this.controller});

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Provider.of<ThemeProvider>(context);
    final direction = theme.textDirection;
    final isDark = theme.isDark;
    final primaryColor = colorScheme.primary;
    final widthQuery = Utils.widthQuery(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final lang = Utils.language(context);
    return Align(
        alignment: Alignment.topCenter,
        child: Directionality(
            textDirection: direction,
            child: Container(
                margin:
                    const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 5),
                height: kToolbarHeight - 16.0,
                width: widthQuery ? deviceWidth / 2 : null,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade200),
                    color: isDark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TabBar(
                    controller: widget.controller,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: primaryColor),
                    labelColor: Colors.white,
                    unselectedLabelColor: primaryColor,
                    tabs: [
                      SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Center(child: Text(lang.trust2))),
                      SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Center(child: Text(lang.trust3))),
                      SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Center(child: Text(lang.trust1)))
                    ]))));
  }
}
