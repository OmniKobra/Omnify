import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../tabs/activity.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return SelectionArea(
        child: Scaffold(
            body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                    child: Column(children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back_ios,
                                color: isDark ? Colors.white70 : Colors.black)),
                      ),
                      const Spacer()
                    ],
                  ),
                  const Expanded(child: Activity())
                ])))));
  }
}
