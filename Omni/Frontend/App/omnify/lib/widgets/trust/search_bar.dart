// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omnify/crypto/features/trust_utils.dart';
import 'package:provider/provider.dart';

import '../../models/deposit.dart';
import '../../providers/theme_provider.dart';
import '../../providers/trusts_provider.dart';
import '../../utils.dart';
import '../common/field_suffix.dart';

class TrustSearchBar extends StatefulWidget {
  final bool isWithdrawal;
  const TrustSearchBar({required this.isWithdrawal});

  @override
  State<TrustSearchBar> createState() => _TrustSearchBarState();
}

class _TrustSearchBarState extends State<TrustSearchBar> {
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  Widget buildField(String hintText, bool widthQuery, bool isDark) => Flexible(
      flex: widthQuery ? 2 : 5,
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
            hoverColor: Colors.transparent,
            prefixIcon: Icon(Icons.search,
                size: 18, color: isDark ? Colors.white70 : Colors.grey),
            hintText: hintText,
            hintStyle: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey,
                fontSize: widthQuery ? 13 : 12),
            filled: true,
            fillColor: isDark ? Colors.grey.shade700 : Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide.none)),
      ));

  Widget buildSearchButton({
    required Future<void> Function(
            {required String id,
            required void Function() setWithdrawalFocus,
            required void Function(Deposit) setWithdrawalDeposit,
            required void Function() setManageFocus,
            required void Function(Deposit) setManageDeposit})
        handler,
    required void Function() paramSetWithdrawalFocus,
    required void Function(Deposit) paramSetWithdrawalDeposit,
    required void Function() paramSetManageFocus,
    required void Function(Deposit) paramSetManageDeposit,
    required String label,
  }) =>
      TextButton(
          onPressed: () async {
            if (!isLoading) {
              FocusScope.of(context).unfocus();
              if (controller.text.isNotEmpty) {
                handler(
                  id: controller.text.trim(),
                  setWithdrawalFocus: paramSetWithdrawalFocus,
                  setWithdrawalDeposit: paramSetWithdrawalDeposit,
                  setManageFocus: paramSetManageFocus,
                  setManageDeposit: paramSetManageDeposit,
                );
              }
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

  Future<void> searchDeposits(
      {required String id,
      required void Function() setWithdrawalFocus,
      required void Function(Deposit) setWithdrawalDeposit,
      required void Function() setManageFocus,
      required void Function(Deposit) setManageDeposit}) async {
    startLoading();
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final c = theme.startingChain;
    final client = theme.client;
    Deposit? theDeposit =
        await TrustUtils.fetchDeposit(c: c, client: client, id: id);
    if (theDeposit != null) {
      if (widget.isWithdrawal) {
        setWithdrawalFocus();
        setWithdrawalDeposit(theDeposit);
      } else {
        setManageFocus();
        setManageDeposit(theDeposit);
      }
      stopLoading();
    } else {
      stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    final trustProvider = Provider.of<TrustsProvider>(context, listen: false);
    final setWithdrawalFocus = trustProvider.setWithdrawalFocus;
    final setWithdrawalDeposit = trustProvider.setWithdrawalDeposit;
    final setManageFocus = trustProvider.setManageFocus;
    final setManageDeposit = trustProvider.setManageDeposit;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildField(lang.trust36, Utils.widthQuery(context), isDark),
        const SizedBox(width: 5),
        buildSearchButton(
            handler: searchDeposits,
            paramSetWithdrawalFocus: setWithdrawalFocus,
            paramSetWithdrawalDeposit: setWithdrawalDeposit,
            paramSetManageFocus: setManageFocus,
            paramSetManageDeposit: setManageDeposit,
            label: lang.trust37),
        if (widthQuery) const Spacer(flex: 1),
      ],
    );
  }
}
