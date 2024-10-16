import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../my_flutter_app_icons.dart';
import '../providers/theme_provider.dart';
import '../routes.dart';
import '../utils.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity>
    with AutomaticKeepAliveClientMixin {
  Widget buildChoiceSquare(String value, String label, IconData icon,
      bool isDark, bool widthQuery, Color primaryColor) {
    final heightQuery = MediaQuery.of(context).size.height > 525;
    return Container(
        margin: const EdgeInsets.all(2),
        child: InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.pushNamed(context, value);
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(5),
                    color: isDark ? Colors.grey[800] : Colors.white),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(icon,
                          size: widthQuery ? 80 : 45,
                          color: isDark ? Colors.white70 : primaryColor),
                      if (heightQuery) const SizedBox(height: 3),
                      if (heightQuery)
                        Text(label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: isDark ? Colors.white70 : primaryColor,
                                fontSize: widthQuery ? 18 : 14,
                                fontWeight: FontWeight.bold))
                    ])))));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final heightQuery = MediaQuery.of(context).size.height > 525;
    super.build(context);
    return Padding(
        padding: EdgeInsets.only(
            top: widthQuery ? 6 : 2, left: 6, right: 6, bottom: 6),
        child: Stack(children: [
          Column(children: [
            Expanded(
                child: Row(children: [
              Expanded(
                  child: buildChoiceSquare(
                      Routes.transferActivity,
                      lang.activity1,
                      MyFlutterApp.transfer,
                      isDark,
                      widthQuery,
                      primaryColor)),
              Expanded(
                  child: buildChoiceSquare(
                      Routes.paymentActivity,
                      lang.activity2,
                      MyFlutterApp.infinity,
                      isDark,
                      widthQuery,
                      primaryColor))
            ])),
            Expanded(
                child: Row(children: [
              Expanded(
                  child: buildChoiceSquare(Routes.trustActivity, lang.activity3,
                      MyFlutterApp.safe, isDark, widthQuery, primaryColor)),
              Expanded(
                  child: buildChoiceSquare(
                      Routes.bridgeActivity,
                      lang.activity4,
                      MyFlutterApp.jigsaw,
                      isDark,
                      widthQuery,
                      primaryColor))
            ]))
          ]),
          Align(
              child: InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.pushNamed(context, Routes.escrowActivity);
                  },
                  child: Container(
                      height: heightQuery ? 100 : 75,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade200),
                          color: isDark ? Colors.grey.shade800 : Colors.white),
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Icon(MyFlutterApp.hand,
                                size: 40,
                                color: isDark ? Colors.white70 : primaryColor),
                            if (heightQuery)
                              Text(lang.activity5,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold))
                          ])))))
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}
