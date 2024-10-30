import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils.dart';
import '../widgets/home/dark_button.dart';
import '../widgets/home/language_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final textDirection = Provider.of<ThemeProvider>(context).textDirection;
    final lang = Utils.language(context);
    return Directionality(
        textDirection: textDirection,
        child: SelectionArea(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                automaticallyImplyLeading: true,
                leading: IconButton(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios,
                        color: isDark ? Colors.white70 : Colors.black)),
              ),
              body: SafeArea(
                  child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isDark ? Colors.grey[800] : Colors.white),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Directionality(
                              textDirection: textDirection,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(lang.settings1,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black)),
                                    const SizedBox(width: 20),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        decoration: BoxDecoration(
                                            color: isDark
                                                ? Colors.grey[600]
                                                : Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const LanguageButton())
                                  ])),
                          const SizedBox(height: 15),
                          Directionality(
                              textDirection: textDirection,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(lang.settings2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black)),
                                    const SizedBox(width: 20),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.grey[600]
                                              : Colors.grey.shade100,
                                          shape: BoxShape.circle),
                                      child: Theme(
                                          data: ThemeData(
                                              hoverColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              splashColor: Colors.transparent),
                                          child: const DarkButton(
                                              setSize: true, size: 24)),
                                    )
                                  ])),
                        ],
                      )))),
        ));
  }
}
