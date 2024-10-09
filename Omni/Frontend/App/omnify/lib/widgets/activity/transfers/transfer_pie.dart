import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../../../providers/activities/transfer_activity_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils.dart';

class TransferPieChart extends StatefulWidget {
  const TransferPieChart({super.key});

  @override
  State<TransferPieChart> createState() => _TransferPieChartState();
}

class _TransferPieChartState extends State<TransferPieChart> {
  bool showSent = true;
  bool showReceived = false;
  Widget buildCheckBox(bool value, String label, bool isDark, bool widthQuery,
          bool isSent) =>
      ListTile(
          visualDensity: VisualDensity.comfortable,
          hoverColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          leading: Checkbox(
              value: value,
              onChanged: (_) {
                if (_ == true) {
                  if (isSent) {
                    showSent = true;
                    showReceived = false;
                  } else {
                    showReceived = true;
                    showSent = false;
                  }
                } else {
                  if (isSent) {
                    showSent = false;
                    showReceived = true;
                  } else {
                    showReceived = false;
                    showSent = true;
                  }
                }
                setState(() {});
              },
              hoverColor: Colors.transparent,
              splashRadius: 0),
          horizontalTitleGap: 5,
          title: Text(label,
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black,
                fontSize: widthQuery ? 16 : 14,
              )));
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final activity =
        Provider.of<TransferActivityProvider>(context, listen: false);
    final isDark = theme.isDark;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    Map<String, double> sentDataMap = activity.getSentPieChart();
    Map<String, double> receivedDataMap = activity.getReceivedPieChart();
    return Container(
        width: widthQuery ? 300 : double.infinity,
        height: widthQuery ? 650 : null,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.transferActivity6,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: widthQuery ? 18 : 16)),
            const SizedBox(height: 5),
            PieChart(
                dataMap: showSent ? sentDataMap : receivedDataMap,
                chartRadius:
                    widthQuery ? null : MediaQuery.of(context).size.width / 2,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                centerText: "",
                legendOptions: const LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: false,
                    showChartValues: false,
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: false,
                    decimalPlaces: 9)),
            if (widthQuery) const Spacer(),
            Row(
              children: [
                Expanded(
                    child: buildCheckBox(showSent, lang.transferActivity7,
                        isDark, widthQuery, true)),
                Expanded(
                  child: buildCheckBox(showReceived, lang.transferActivity8,
                      isDark, widthQuery, false),
                ),
              ],
            ),
          ],
        ));
  }
}
