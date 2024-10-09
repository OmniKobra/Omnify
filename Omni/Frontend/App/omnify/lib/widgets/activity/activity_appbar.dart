// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../utils.dart';

class ActivityAppBar extends StatelessWidget {
  final String label;
  const ActivityAppBar(this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final dir = theme.textDirection;
    final isDark = theme.isDark;
    final widthQuery = Utils.widthQuery(context);
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Directionality(
            textDirection: dir,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios,
                          color: isDark ? Colors.white70 : Colors.black)),
                  const SizedBox(width: 5),
                  Text(label,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widthQuery ? 20 : 17))
                ])));
  }
}
