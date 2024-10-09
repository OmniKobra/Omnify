import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../utils.dart';

class DarkButton extends StatelessWidget {
  final bool setSize;
  final double? size;
  const DarkButton({super.key, required this.setSize, this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final setDark = Provider.of<ThemeProvider>(context, listen: false).setDark;
    final lang = Utils.language(context);
    return Center(
        child: setSize
            ? IconButton(
                tooltip: isDark ? lang.theme1 : lang.theme2,
                onPressed: setDark,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(isDark ? Icons.brightness_5 : Icons.brightness_3,
                    size: size ?? 33,
                    color: isDark ? Colors.white : Colors.black))
            : Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                    onTap: setDark,
                    child: Icon(
                        isDark ? Icons.brightness_5 : Icons.brightness_3,
                        size: 24,
                        color: isDark ? Colors.white : Colors.black)),
              ));
  }
}
