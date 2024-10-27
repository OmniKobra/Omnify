import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';

class MyRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const MyRefresh({super.key, required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final walletConnected = walletProvider.isWalletConnected;
    return RefreshIndicator(
        backgroundColor: isDark ? Colors.grey.shade700 : Colors.white,
        displacement: 10,
        onRefresh: walletConnected ? onRefresh : () async {},
        child: child);
  }
}
