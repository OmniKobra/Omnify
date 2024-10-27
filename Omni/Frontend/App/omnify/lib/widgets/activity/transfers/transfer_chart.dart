// ignore_for_file: use_key_in_widget_constructors

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:jiffy/jiffy.dart';
import 'package:omnify/providers/activities/transfer_activity_provider.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils.dart';

class TransferChart extends StatefulWidget {
  const TransferChart({super.key});

  @override
  State<StatefulWidget> createState() => TransferChartState();
}

class TransferChartState extends State<TransferChart>
    with SingleTickerProviderStateMixin {
  static const double barWidth = 22;
  static const shadowOpacity = 0.2;
  late TabController controller;
  handleTabSelection() {
    if (controller.index != controller.previousIndex) {
      FocusScope.of(context).unfocus();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        TabController(length: 3, vsync: this, animationDuration: Duration.zero);
    controller.addListener(handleTabSelection);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(() {});
    controller.dispose();
  }

  int touchedIndex = -1;

  Widget bottomTitles(double value, TitleMeta meta) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final langCode = theme.langCode;
    final widthQuery = Utils.widthQuery(context);
    final currentIndex = controller.index;
    List<String> labels = [];
    switch (currentIndex) {
      case 0:
        final now = DateTime.now();
        Duration day(int v) => Duration(days: v);
        final day_1 = now.subtract(day(1));
        final day_2 = now.subtract(day(2));
        final day_3 = now.subtract(day(3));
        final day_4 = now.subtract(day(4));
        final day_5 = now.subtract(day(5));
        final day_6 = now.subtract(day(6));
        final dayFormatter = DateFormat('EE', langCode);
        labels = [
          dayFormatter.format((day_6)),
          dayFormatter.format(day_5),
          dayFormatter.format(day_4),
          dayFormatter.format(day_3),
          dayFormatter.format(day_2),
          dayFormatter.format(day_1),
          dayFormatter.format(now)
        ];
        break;
      case 1:
        final now = Jiffy.now();
        DateTime month(int v) => now.subtract(months: v).dateTime;
        final month_1 = month(1);
        final month_2 = month(2);
        final month_3 = month(3);
        final month_4 = month(4);
        final month_5 = month(5);
        final month_6 = month(6);
        final monthFormatter = DateFormat('MMM', langCode);
        labels = [
          monthFormatter.format(month_6),
          monthFormatter.format(month_5),
          monthFormatter.format(month_4),
          monthFormatter.format(month_3),
          monthFormatter.format(month_2),
          monthFormatter.format(month_1),
          monthFormatter.format(now.dateTime)
        ];
        break;
      case 2:
        final now = Jiffy.now();
        DateTime year(int v) => now.subtract(years: v).dateTime;
        final year_1 = year(1);
        final year_2 = year(2);
        final year_3 = year(3);
        final year_4 = year(4);
        final year_5 = year(5);
        final year_6 = year(6);
        final yearFormatter = DateFormat("yy''", langCode);
        labels = [
          yearFormatter.format(year_6),
          yearFormatter.format(year_5),
          yearFormatter.format(year_4),
          yearFormatter.format(year_3),
          yearFormatter.format(year_2),
          yearFormatter.format(year_1),
          yearFormatter.format(now.dateTime),
        ];
        break;
      default:
    }
    final style = TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontSize: widthQuery ? 15 : 13);
    String text;
    switch (value.toInt()) {
      case 0:
        text = labels[0];
        break;
      case 1:
        text = labels[1];
        break;
      case 2:
        text = labels[2];
        break;
      case 3:
        text = labels[3];
        break;
      case 4:
        text = labels[4];
        break;
      case 5:
        text = labels[5];
        break;
      case 6:
        text = labels[6];
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget topTitles(double value, TitleMeta meta) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final widthQuery = Utils.widthQuery(context);
    final style = TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontSize: widthQuery ? 15 : 13);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final widthQuery = Utils.widthQuery(context);
    final style = TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontSize: widthQuery ? 14 : 12);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${value.toInt()}0k';
    }
    double degreeToRadian(double degree) {
      return degree * math.pi / 180;
    }

    return SideTitleWidget(
      angle: degreeToRadian(value < 0 ? -45 : 45),
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget rightTitles(double value, TitleMeta meta) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final widthQuery = Utils.widthQuery(context);
    final style = TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontSize: widthQuery ? 14 : 12);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${value.toInt()}0k';
    }
    double degreeToRadian(double degree) {
      return degree * math.pi / 180;
    }

    return SideTitleWidget(
      angle: degreeToRadian(90),
      axisSide: meta.axisSide,
      space: 0,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  BarChartGroupData generateGroup(
    int x,
    double value1,
    double value2,
  ) {
    final isTop = value1 > 0;
    final sum = value1 + value2;
    final isTouched = touchedIndex == x;
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: sum,
          width: barWidth,
          borderRadius: isTop
              ? const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                )
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              value1,
              const Color(0xFF3BFF49),
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
            BarChartRodStackItem(
              value1,
              value1 + value2,
              Colors.red,
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool isShadowBar(int rodIndex) => rodIndex == 1;
  Widget buildTabBar(TextDirection direction, bool widthQuery,
      double deviceWidth, bool isDark, Color primaryColor) {
    final lang = Utils.language(context);
    return Align(
        alignment: Alignment.topCenter,
        child: Directionality(
            textDirection: direction,
            child: Container(
                margin:
                    const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 5),
                height: kToolbarHeight - 16.0,
                width: widthQuery ? deviceWidth / 2 : null,
                decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TabBar(
                    controller: controller,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: primaryColor),
                    labelColor: Colors.white,
                    unselectedLabelColor: primaryColor,
                    tabs: [
                      SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Center(child: Text(lang.chart1))),
                      SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Center(child: Text(lang.chart2))),
                      SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Center(child: Text(lang.chart3)))
                    ]))));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Utils.language(context);
    final activityMethods =
        Provider.of<TransferActivityProvider>(context, listen: false);
    final getDailies = activityMethods.getCurrentAssetDailies;
    final getMonthlies = activityMethods.getCurrentAssetMonthlies;
    final getYearlies = activityMethods.getCurrentAssetYearlies;
    final isDark = theme.isDark;
    final direction = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final mainItems = controller.index == 0
        ? getDailies()
        : controller.index == 1
            ? getMonthlies()
            : getYearlies();
    double getMaxY() {
      double hightVal = 0.0;
      List<double> values = [0.0, 0.0];
      mainItems.map((k, v) {
        values.add(v[0] + v[1]);
        return const MapEntry(1, []);
      });
      values.sort((a, b) => b.compareTo(a));
      hightVal = values.first + 2;
      return hightVal;
    }

    double maxY = getMaxY();
    final chart = AspectRatio(
        aspectRatio: 0.8,
        child: Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 5),
            child: BarChart(BarChartData(
                alignment: BarChartAlignment.center,
                maxY: maxY,
                minY: 0,
                groupsSpace: widthQuery ? 24 : 45,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipColor: (_) => Colors.black,
                      getTooltipItem: (data, __, ___, ____) {
                        var received = data.barRods[0].rodStackItems[0].toY;
                        var sent =
                            data.barRods[0].rodStackItems[1].toY - received;
                        return BarTooltipItem("", const TextStyle(), children: [
                          if (received > 0)
                            TextSpan(
                                text:
                                    "${lang.transferActivity3}: ${received.toStringAsFixed(3)}",
                                style: const TextStyle(
                                  color: Color(0xFF3BFF49),
                                )),
                          if (sent > 0 && received > 0)
                            const TextSpan(
                                text: "\n",
                                style: TextStyle(
                                  color: Color(0xFF3BFF49),
                                )),
                          if (sent > 0)
                            TextSpan(
                                text:
                                    "${lang.transferActivity7}: ${sent.toStringAsFixed(3)}",
                                style: const TextStyle(color: Colors.red))
                        ]);
                      }),
                  handleBuiltInTouches: false,
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      setState(() {
                        touchedIndex = -1;
                      });
                      return;
                    }
                    final rodIndex = barTouchResponse.spot!.touchedRodDataIndex;
                    if (isShadowBar(rodIndex)) {
                      setState(() {
                        touchedIndex = -1;
                      });
                      return;
                    }
                    setState(() {
                      touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false,
                            reservedSize: 32,
                            getTitlesWidget: topTitles)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: bottomTitles,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        getTitlesWidget: leftTitles,
                        interval: 5,
                        reservedSize: 42,
                      ),
                    ),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false,
                            getTitlesWidget: rightTitles,
                            interval: 5,
                            reservedSize: 42))),
                gridData: FlGridData(
                    show: false,
                    checkToShowHorizontalLine: (value) => value % 5 == 0,
                    getDrawingHorizontalLine: (value) {
                      if (value == 0) {
                        return FlLine(
                          color: AppColors.borderColor.withOpacity(0.1),
                          strokeWidth: 3,
                        );
                      }
                      return FlLine(
                          color: AppColors.borderColor.withOpacity(0.05),
                          strokeWidth: 0.8);
                    }),
                borderData: FlBorderData(show: false),
                barGroups: mainItems.entries
                    .map(
                      (e) => generateGroup(
                        e.key,
                        e.value[0],
                        e.value[1],
                      ),
                    )
                    .toList()))));
    return DefaultTabController(
      animationDuration: Duration.zero,
      initialIndex: 0,
      length: 3,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [chart, chart, chart],
                ),
              ),
            ],
          ),
          buildTabBar(direction, widthQuery, deviceWidth, isDark, primaryColor)
        ],
      ),
    );
  }
}

class AppColors {
  static const Color borderColor = Colors.white54;
  static const Color contentColorBlue = Color(0xFF2196F3);
}
