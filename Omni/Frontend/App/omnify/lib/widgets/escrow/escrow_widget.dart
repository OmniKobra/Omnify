import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:provider/provider.dart';

import '../../models/escrow_contract.dart';
import '../../providers/escrows_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../utils.dart';
import 'delete_contract.dart';
import 'inspect_contract.dart';
import 'new_contract.dart';
import 'view_contract.dart';

class EscrowWidget extends StatefulWidget {
  final EscrowContract contract;
  final Chain currentChain;
  final void Function() setStater;
  const EscrowWidget(
      {super.key,
      required this.contract,
      required this.currentChain,
      required this.setStater});

  @override
  State<EscrowWidget> createState() => _EscrowWidgetState();
}

class _EscrowWidgetState extends State<EscrowWidget> {
  @override
  Widget build(BuildContext context) {
    final widthQuery = Utils.widthQuery(context);
    const heightBox = SizedBox(height: 5);
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final primaryColor =
        isDark ? Colors.white60 : Theme.of(context).colorScheme.primary;
    final theme = Provider.of<ThemeProvider>(context);
    final dir = theme.textDirection;
    final lang = Utils.language(context);
    final myAddress = Provider.of<WalletProvider>(context, listen: false)
        .getAddressString(theme.startingChain);
    final walletConnected =
        Provider.of<WalletProvider>(context).isWalletConnected;
    final border = Border.all(
        width: widget.contract.bids.any((element) => element.bidAccepted) ||
                widget.contract.isDeleted
            ? 2
            : 1,
        color: widget.contract.isDeleted
            ? Colors.red
            : widget.contract.bids.any((element) => element.bidAccepted)
                ? Colors.green
                : isDark
                    ? Colors.grey.shade700
                    : Colors.grey.shade200);
    final c = Provider.of<EscrowsProvider>(context).currentChain;
    final decoration = BoxDecoration(
        border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        color: isDark ? Colors.grey[800] : Colors.white);
    final actions = [
      PieAction(
        tooltip: Text(lang.escrow5),
        onSelect: () {
          FocusScope.of(context).unfocus();
          showBottomSheet(
              context: context,
              enableDrag: false,
              backgroundColor: isDark ? Colors.grey[800] : Colors.white,
              builder: (_) {
                return Container(
                    decoration: decoration,
                    child: ContractViewer(
                      contract: widget.contract,
                      setStater: () {
                        widget.setStater();
                        setState(() {});
                      },
                    ));
              });
        },
        child: const Icon(Icons.visibility),
      ),
      if (walletConnected &&
          !widget.contract.bids.any((element) => element.bidAccepted) &&
          !widget.contract.isDeleted &&
          widget.contract.ownerAddress != myAddress &&
          !widget.contract.bids
              .any((element) => element.bidderAddress == myAddress))
        PieAction(
          tooltip: Text(lang.escrow6),
          onSelect: () {
            FocusScope.of(context).unfocus();
            showBottomSheet(
                context: context,
                enableDrag: false,
                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                builder: (_) {
                  return Container(
                      decoration: decoration,
                      child: NewContractSheet(
                          isBid: true,
                          contractChain: widget.currentChain,
                          contract: widget.contract));
                });
          },
          child: const Icon(Icons.money),
        ),
      PieAction(
        tooltip: Text(lang.escrow7),
        onSelect: () {
          FocusScope.of(context).unfocus();
          showBottomSheet(
              context: context,
              enableDrag: false,
              backgroundColor: isDark ? Colors.grey[800] : Colors.white,
              builder: (_) {
                return Container(
                    decoration: decoration,
                    child: InspectContract(contract: widget.contract));
              });
        },
        child: const Icon(Icons.manage_search),
      ),
      if (!widget.contract.bids.any((element) => element.bidAccepted) &&
          !widget.contract.isDeleted &&
          widget.contract.ownerAddress == myAddress)
        PieAction(
          buttonTheme: const PieButtonTheme(
              backgroundColor: Colors.red, iconColor: Colors.white),
          buttonThemeHovered: const PieButtonTheme(
              backgroundColor: Colors.red, iconColor: Colors.white),
          tooltip: Text(lang.escrow8),
          onSelect: () {
            FocusScope.of(context).unfocus();
            showBottomSheet(
                context: context,
                enableDrag: false,
                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                builder: (_) {
                  return Container(
                      decoration: decoration,
                      child: DeleteContract(
                          contract: widget.contract,
                          c: c,
                          setStatehandle: () {
                            widget.setStater();
                            setState(() {});
                          }));
                });
          },
          child: const Icon(Icons.delete),
        ),
    ];
    return PieMenu(
      theme: PieTheme(
          tooltipCanvasAlignment: Alignment.centerLeft,
          pointerColor: Colors.transparent,
          overlayColor: Colors.black87,
          buttonTheme: PieButtonTheme(
              backgroundColor: isDark ? Colors.grey.shade700 : primaryColor,
              iconColor: isDark ? Colors.white60 : Colors.white),
          buttonThemeHovered: PieButtonTheme(
              backgroundColor: isDark ? Colors.grey.shade700 : Colors.green,
              iconColor: isDark ? Colors.white60 : Colors.white),
          tooltipTextStyle:
              TextStyle(color: isDark ? Colors.white60 : Colors.white),
          childBounceEnabled: true,
          leftClickShowsMenu: true,
          rightClickShowsMenu: true),
      onPressed: () => {},
      actions: dir == TextDirection.ltr ? actions : actions.reversed.toList(),
      child: Container(
        width: widthQuery ? 250 : 150,
        margin: widthQuery ? const EdgeInsets.all(8) : const EdgeInsets.all(2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text("${lang.escrow30} ${widget.contract.bids.length}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: widthQuery ? 12 : 11,
                        color: isDark ? Colors.white60 : Colors.grey)),
              ],
            ),
            heightBox,
            SizedBox(
                height: widthQuery ? 75 : 60,
                width: double.infinity,
                child: ExtendedImage.network(widget.contract.imageUrl,
                    cache: true, enableLoadState: false)),
            heightBox,
            Container(
                padding: const EdgeInsets.all(4),
                child: Text(widget.contract.coinName,
                    style: TextStyle(
                        fontSize: widthQuery ? 13 : 12, color: primaryColor))),
            ListTile(
                contentPadding: const EdgeInsets.all(0),
                minVerticalPadding: 0,
                horizontalTitleGap: 5,
                dense: true,
                leading: Icon(Icons.token,
                    color: isDark ? Colors.white60 : Colors.black),
                title: Text(
                    Utils.removeTrailingZeros(widget.contract.amount
                        .toStringAsFixed(widget.contract.decimals)),
                    style: TextStyle(fontSize: widthQuery ? 12 : 11))),
            ListTile(
                contentPadding: const EdgeInsets.all(0),
                minVerticalPadding: 0,
                horizontalTitleGap: 5,
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(Icons.wallet,
                    color: isDark ? Colors.white60 : Colors.black),
                title: Text(widget.contract.ownerAddress,
                    style: TextStyle(fontSize: widthQuery ? 12 : 11))),
          ],
        ),
      ),
    );
  }
}
