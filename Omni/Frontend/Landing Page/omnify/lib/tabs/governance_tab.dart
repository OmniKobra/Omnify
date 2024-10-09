import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/governance_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/wallet_provider.dart';
import '../widgets/common/refresh_indicator.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/governance/governance_header.dart';
import '../widgets/governance/governance_body.dart';

class GovernanceTab extends StatefulWidget {
  const GovernanceTab({super.key});

  @override
  State<GovernanceTab> createState() => _GovernanceTabState();
}

class _GovernanceTabState extends State<GovernanceTab>
    with AutomaticKeepAliveClientMixin {
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    var gov = Provider.of<GovernanceProvider>(context, listen: false);
    var c = gov.currentChain;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final address = wallet.getAddressString(c);
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    if (wallet.isWalletConnected) {
      gov.setFuture(c, address, false, client);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gov = Provider.of<GovernanceProvider>(context);
    final future = gov.fetchGovernance;
    final c = gov.currentChain;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final walletProvider = Provider.of<WalletProvider>(context);
    final walletConnected = walletProvider.isWalletConnected;
    final address = wallet.getAddressString(c);
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    super.build(context);
    return FutureBuilder(
        future: future,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const MyLoading();
          }
          if (snap.hasError) {
            return MyError(() {
              Provider.of<GovernanceProvider>(context, listen: false)
                  .setFuture(c, address, true, client);
            });
          }
          return MyRefresh(
            onRefresh: walletConnected
                ? () async {
                    Provider.of<GovernanceProvider>(context, listen: false)
                        .setFuture(c, address, true, client);
                  }
                : () async {},
            child: ListView(
                controller: controller,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  const GovernanceHeader(),
                  GovernanceBody(controller: controller)
                ]),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
