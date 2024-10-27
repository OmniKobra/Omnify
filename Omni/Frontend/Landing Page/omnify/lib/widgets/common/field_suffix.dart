import 'package:flutter/material.dart';

import '../../utils.dart';

class AddressFieldSuffix extends StatefulWidget {
  final bool showScanButton;
  final void Function() copyHandler;
  final void Function(String) scannerHandler;
  const AddressFieldSuffix(
      {super.key,
      required this.showScanButton,
      required this.copyHandler,
      required this.scannerHandler});

  @override
  State<AddressFieldSuffix> createState() => _AddressFieldSuffixState();
}

class _AddressFieldSuffixState extends State<AddressFieldSuffix> {
  @override
  Widget build(BuildContext context) {
    final lang = Utils.language(context);
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  shadowColor: WidgetStatePropertyAll(Colors.transparent),
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
                  splashFactory: NoSplash.splashFactory),
              onPressed: () {
                FocusScope.of(context).unfocus();
                widget.copyHandler();
              },
              child: Text(lang.paste,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
        ]);
  }
}
