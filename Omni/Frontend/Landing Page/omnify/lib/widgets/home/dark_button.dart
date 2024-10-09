import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../utils.dart';

class DarkButton extends StatelessWidget {
  const DarkButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final setDark = Provider.of<ThemeProvider>(context, listen: false).setDark;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    return Center(
        child: IconButton(
            tooltip: isDark ? lang.theme0 : lang.theme1,
            onPressed: setDark,
            icon: Icon(isDark ? Icons.brightness_5 : Icons.brightness_3,
                size: widthQuery ? 33 : null,
                color: isDark ? Colors.white : Colors.black)));
  }
}
