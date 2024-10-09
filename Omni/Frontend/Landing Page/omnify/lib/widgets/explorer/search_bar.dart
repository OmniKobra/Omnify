// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../../crypto/features/explorer_utils.dart';
import '../../models/explorer_bridge.dart';
import '../../models/explorer_escrow.dart';
import '../../models/explorer_payment.dart';
import '../../models/explorer_transfer.dart';
import '../../models/explorer_trust.dart';
import '../../providers/explorer_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';
import '../../widgets/common/field_suffix.dart';

class MySearchBar extends StatefulWidget {
  final bool isTransfers;
  final bool isPayment;
  final bool isTrust;
  final bool isBridge;
  final bool isEscrow;
  const MySearchBar(
      {required this.isTransfers,
      required this.isPayment,
      required this.isTrust,
      required this.isBridge,
      required this.isEscrow});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  Widget buildField(String hintText, bool widthQuery, bool isDark) {
    return Flexible(
        flex: widthQuery ? 3 : 9,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              suffixIcon: AddressFieldSuffix(
                  showScanButton: false,
                  copyHandler: () async {
                    final data = await Clipboard.getData(Clipboard.kTextPlain);
                    if (data != null && data.text != null) {
                      controller.text = data.text!;
                    }
                  },
                  scannerHandler: (_) {}),
              prefixIcon: Icon(Icons.search,
                  size: 18, color: isDark ? Colors.white70 : Colors.grey),
              hintText: hintText,
              hintStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey,
                  fontSize: widthQuery ? 13 : 12),
              filled: true,
              fillColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide.none)),
        ));
  }

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> searchTransfers(
      Chain c,
      String id,
      void Function(List<ExplorerTransfer>) addTransfer,
      Web3Client client) async {
    startLoading();
    ExplorerTransfer? t = await ExplorerUtils.getTransfer(c, id, client);
    if (t != null) {
      addTransfer([t]);
      stopLoading();
    } else {
      stopLoading();
    }
  }

  Future<void> searchPayments(
      Chain c,
      String id,
      void Function(List<ExplorerPayment>) addPayment,
      Web3Client client) async {
    startLoading();
    ExplorerPayment? p = await ExplorerUtils.getPayment(c, id, client);
    if (p != null) {
      addPayment([p]);
      stopLoading();
    } else {
      stopLoading();
    }
  }

  Future<void> searchTrust(Chain c, String id,
      void Function(List<ExplorerTrust>) addTrust, Web3Client client) async {
    startLoading();
    ExplorerTrust? tr = await ExplorerUtils.getTrust(c, id, client);
    if (tr != null) {
      addTrust([tr]);
      stopLoading();
    } else {
      stopLoading();
    }
  }

  Future<void> searchBridge(Chain c, String id,
      void Function(List<ExplorerBridge>) addBridge, Web3Client client) async {
    startLoading();
    ExplorerBridge? b = await ExplorerUtils.getBridge(c, id, client);
    if (b != null) {
      addBridge([b]);
      stopLoading();
    } else {
      stopLoading();
    }
  }

  Future<void> searchEscrow(Chain c, String id,
      void Function(List<ExplorerEscrow>) addEscrow, Web3Client client) async {
    startLoading();
    ExplorerEscrow? e = await ExplorerUtils.getEscrow(c, id, client);
    if (e != null) {
      addEscrow([e]);
      stopLoading();
    } else {
      stopLoading();
    }
  }

  Widget buildSearchButton(
      Future<void> Function(String) handler, String label) {
    return TextButton(
        onPressed: () {
          if (!isLoading) {
            handler(controller.text.trim());
          }
        },
        child: isLoading
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(strokeWidth: 1))
            : Text(label,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.primary)));
  }

  Future<void> Function(String) giveHandler(Chain c, Web3Client client) {
    if (widget.isTransfers) {
      var addTransfer = Provider.of<ExplorerProvider>(context, listen: false)
          .setTransferTable;
      return (id) => searchTransfers(c, id, addTransfer, client);
    } else if (widget.isTrust) {
      var addTrust =
          Provider.of<ExplorerProvider>(context, listen: false).setTrustTable;
      return (id) => searchTrust(c, id, addTrust, client);
    } else if (widget.isBridge) {
      var addBridge =
          Provider.of<ExplorerProvider>(context, listen: false).setBridgeTable;
      return (id) => searchBridge(c, id, addBridge, client);
    } else if (widget.isEscrow) {
      var addEscrow =
          Provider.of<ExplorerProvider>(context, listen: false).setEscrowTable;
      return (id) => searchEscrow(c, id, addEscrow, client);
    } else {
      var addPayment =
          Provider.of<ExplorerProvider>(context, listen: false).setPaymentTable;
      return (id) => searchPayments(c, id, addPayment, client);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final explorer = Provider.of<ExplorerProvider>(context);
    final client = Provider.of<ThemeProvider>(context).client;
    final handler = giveHandler(explorer.currentChain, client);
    final lang = Utils.language(context);
    final transferHint = lang.explorerHint0;
    final trustHint = lang.explorerHint1;
    final bridgeHint = lang.explorerHint2;
    final escrowHint = lang.explorerHint3;
    final paymentHint = lang.explorerHint4;
    final search = lang.explorerSearch;
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    String giveHint() {
      if (widget.isTransfers) {
        return transferHint;
      } else if (widget.isTrust) {
        return trustHint;
      } else if (widget.isBridge) {
        return bridgeHint;
      } else if (widget.isEscrow) {
        return escrowHint;
      } else {
        return paymentHint;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildField(giveHint(), Utils.widthQuery(context), isDark),
        const SizedBox(width: 5),
        buildSearchButton(handler, search),
        if (Utils.widthQuery(context)) const Spacer(flex: 3),
      ],
    );
  }
}
