import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import '../../providers/explorer_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';

class Looper extends StatefulWidget {
  const Looper({super.key});

  @override
  State<Looper> createState() => _LooperState();
}

class _LooperState extends State<Looper> {
  Widget buildStat(String description, dynamic val, bool widthQuery, bool isDark,
          bool isValue) =>
      Container(
        margin: EdgeInsets.only(
            top: widthQuery ? 16 : 8,
            bottom: widthQuery ? 16 : 8,
            right: widthQuery ? 26 : 18),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: 50,
              maxWidth: widthQuery ? 200 : 150,
              minHeight: widthQuery ? 60 : 50.0,
              maxHeight: widthQuery ? 60 : 55.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(description,
                    style: TextStyle(
                        color: Colors.grey, fontSize: widthQuery ? 17 : 15)),
                const SizedBox(height: 5.0),
                Text(Utils.optimisedNumbers(val, isValue),
                    style: TextStyle(
                        fontSize: widthQuery ? 19 : 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))
              ]),
        ),
      );
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final explorer = Provider.of<ExplorerProvider>(context);
    final lang = Utils.language(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ScrollLoopAutoScroll(
        gap: 50,
        duplicateChild: 100,
        duration: const Duration(seconds: 960),
        reverseScroll: dir == TextDirection.rtl,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            buildStat(
                lang.explorer0, explorer.transfers, widthQuery, isDark, false),
            buildStat(lang.explorer1, explorer.valueTransfered, widthQuery,
                isDark, true),
            buildStat(
                lang.explorer2, explorer.deposits, widthQuery, isDark, false),
            buildStat(lang.explorer3, explorer.valueDeposited, widthQuery,
                isDark, true),
            buildStat(lang.explorer4, explorer.withdrawals, widthQuery, isDark,
                false),
            buildStat(lang.explorer5, explorer.valueWithdrawn, widthQuery,
                isDark, true),
            buildStat(
                lang.explorer6, explorer.valueLoaned, widthQuery, isDark, true),
            buildStat(lang.explorer10, explorer.valueBorrowed, widthQuery,
                isDark, true),
            buildStat(lang.explorer7, explorer.lotteryDraws, widthQuery, isDark,
                false),
            buildStat(
                lang.explorer8, explorer.winners, widthQuery, isDark, false),
            buildStat(lang.explorer9, explorer.prizesDistributed, widthQuery,
                isDark, true),
          ],
        ),
      ),
    );
  }
}
