import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class MyRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const MyRefresh({super.key, required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    return RefreshIndicator(
        backgroundColor: isDark ? Colors.grey.shade700 : Colors.white,
        displacement: 10,
        onRefresh: onRefresh,
        child: child);
  }
}
