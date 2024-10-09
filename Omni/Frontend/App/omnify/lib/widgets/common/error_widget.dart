import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils.dart';
import '../../providers/theme_provider.dart';

class MyError extends StatefulWidget {
  final void Function() handler;
  const MyError(this.handler);

  @override
  State<MyError> createState() => _MyErrorState();
}

class _MyErrorState extends State<MyError> {
  @override
  Widget build(BuildContext context) {
    final lang = Utils.language(context);
    final bool isDark = Provider.of<ThemeProvider>(context).isDark;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(20)),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.warning_amber_rounded,
              color: isDark ? Colors.white70 : Colors.black, size: 55),
          const SizedBox(height: 5),
          Center(
              child: Text(
            lang.error1,
            style: TextStyle(
                fontSize: 14, color: isDark ? Colors.white70 : Colors.grey),
          )),
          Center(
            child: TextButton(
                style: const ButtonStyle(
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    splashFactory: NoSplash.splashFactory),
                onPressed: widget.handler,
                child: Text(
                  lang.retry,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                )),
          )
        ]));
  }
}
