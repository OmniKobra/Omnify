import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils.dart';
import '../widgets/home/wallet_button.dart';
import '../widgets/network_picker.dart';
import '../widgets/transfers/footer.dart';
import '../widgets/transfers/body.dart';

class Transfers extends StatefulWidget {
  const Transfers({super.key});

  @override
  State<Transfers> createState() => _TransfersState();
}

class _TransfersState extends State<Transfers>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    const heightBox = SizedBox(height: 5);
    super.build(context);
    return Padding(
      padding: EdgeInsets.only(
          top: 4.0, left: 8, right: 8, bottom: widthQuery ? 8 : 70),
      child: Directionality(
        textDirection: dir,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widthQuery) const SizedBox(height: 5),
              Row(
                children: [
                  Container(
                      padding: widthQuery
                          ? const EdgeInsets.all(8)
                          : const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          border: border,
                          borderRadius: BorderRadius.circular(5),
                          color: isDark ? Colors.grey[800] : Colors.white),
                      child: const NetworkPicker(
                          isExplorer: false,
                          isTransfers: true,
                          isPayments: false,
                          isTrust: false,
                          isBridgeSource: false,
                          isBridgeTarget: false,
                          isEscrow: false,
                          isTransferActivity: false,
                          isPaymentActivity: false,
                          isTrustActivity: false,
                          isBridgeActivity: false,
                          isEscrowActivity: false,
                          isTransactions: false,
                          isDiscoverTransfers: false,
                          isDiscoverPayments: false,
                          isDiscoverTrust: false,
                          isDiscoverBridges: false,
                          isDiscoverEscrow: false)),
                  if (widthQuery) const SizedBox(width: 5),
                  if (widthQuery)
                    Container(
                        margin: EdgeInsets.only(
                            top: 8, right: 8, left: widthQuery ? 8 : 0),
                        child: const WalletButton())
                ],
              ),
              heightBox,
              const Expanded(child: TransfersBody()),
              heightBox,
              const MyFooter(),
            ]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
