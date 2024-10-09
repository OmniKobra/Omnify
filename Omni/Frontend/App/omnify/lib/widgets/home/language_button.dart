// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../utils.dart';

class LanguageButton extends StatefulWidget {
  const LanguageButton();

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  DropdownMenuItem<String> buildLangButtonItem({
    required String value,
    required String description,
    required void Function(String) setLang,
    required bool widthQuery,
    required bool isDark,
  }) =>
      DropdownMenuItem<String>(
        value: value,
        onTap: () => setLang(value),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(description,
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black,
                        fontSize: 14)),
              )
            ]),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final lang = theme.langCode;
    final handler =
        Provider.of<ThemeProvider>(context, listen: false).setLanguage;
    final widthQuery = Utils.widthQuery(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: DropdownButton(
          dropdownColor: isDark ? Colors.grey[800] : Colors.grey[50],
          // key: UniqueKey(),
          // borderRadius: BorderRadius.circular(25.0),
          elevation: 8,
          onChanged: (_) => setState(() {}),
          underline: Container(color: Colors.transparent),
          icon: Icon(Icons.arrow_drop_down,
              color: isDark ? Colors.white70 : Colors.black, size: 15),
          value: lang,
          items: [
            buildLangButtonItem(
                value: 'en',
                description: 'English',
                widthQuery: widthQuery,
                setLang: handler,
                isDark: isDark),
            buildLangButtonItem(
                value: 'ar',
                description: 'العربية',
                widthQuery: widthQuery,
                setLang: handler,
                isDark: isDark),
            buildLangButtonItem(
                value: 'tr',
                description: 'Türkçe',
                widthQuery: widthQuery,
                setLang: handler,
                isDark: isDark),
            buildLangButtonItem(
                value: 'fr',
                description: 'Français',
                widthQuery: widthQuery,
                setLang: handler,
                isDark: isDark),
          ]),
    );
  }
}
