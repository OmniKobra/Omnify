import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/transfer.dart';
import '../../providers/theme_provider.dart';
import '../../providers/transfers_provider.dart';
import '../../utils.dart';

class ScheduleForm extends StatefulWidget {
  final Widget topBar;
  const ScheduleForm({required this.topBar, super.key});

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  Widget buildField(
      bool isDark, TextEditingController controller, bool isYear) {
    return SizedBox(
        width: 65,
        height: 48,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(isYear ? 4 : 2),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor:
                        isDark ? Colors.grey.shade600 : Colors.grey.shade200,
                    floatingLabelBehavior: FloatingLabelBehavior.never))));
  }

  Widget buildTitle(String label, bool isDark, bool widthQuery) => Text(label,
      style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black,
          fontSize: widthQuery ? 16 : 13,
          fontWeight: FontWeight.normal));
  Widget buildBox(String label, bool widthQuery, bool isDark,
      TextEditingController t, bool isYear) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(child: buildField(isDark, t, isYear)),
          buildTitle(label, isDark, widthQuery),
        ],
      ),
    );
  }

  Widget buildCheckBox(bool value, String label, bool isDark, bool widthQuery,
          bool isAM, TransferFormModel t) =>
      ListTile(
          visualDensity: VisualDensity.comfortable,
          hoverColor: Colors.transparent,
          leading: Checkbox(
              value: value,
              onChanged: (_) {
                if (_ == true) {
                  if (isAM) {
                    t.am = true;
                    t.pm = false;
                  } else {
                    t.pm = true;
                    t.am = false;
                  }
                } else {
                  if (isAM) {
                    t.am = false;
                    t.pm = true;
                  } else {
                    t.pm = false;
                    t.am = true;
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
  void initState() {
    super.initState();
    final now = DateTime.now();
    final transfers = Provider.of<TransfersProvider>(context, listen: false);
    final i = transfers.currentIndex;
    final list = transfers.transfers;
    final current = list[i];
    final isAm = now.hour < 12;
    final isPm = now.hour >= 12;
    final hour = now.hour > 12
        ? now.hour - 12
        : now.hour < 1
            ? now.hour + 12
            : now.hour;
    current.day.text = now.day.toString().padLeft(2, "0");
    current.month.text = now.month.toString().padLeft(2, "0");
    current.year.text = now.year.toString();
    current.hour.text = hour.toString().padLeft(2, "0");
    current.minute.text = now.minute.toString().padLeft(2, "0");
    current.am = isAm;
    current.pm = isPm;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final transfers = Provider.of<TransfersProvider>(context);
    final i = transfers.currentIndex;
    final list = transfers.transfers;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    return Expanded(
        child: ListView(
            padding: EdgeInsets.only(
                top: 0, bottom: MediaQuery.of(context).viewInsets.bottom),
            children: [
          Wrap(
            children: [
              widget.topBar,
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildBox(
                      lang.schedule1, widthQuery, isDark, list[i].day, false),
                  buildBox(
                      lang.schedule2, widthQuery, isDark, list[i].month, false),
                  buildBox(
                      lang.schedule3, widthQuery, isDark, list[i].year, true),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildBox(
                      lang.schedule4, widthQuery, isDark, list[i].hour, false),
                  buildBox(lang.schedule5, widthQuery, isDark, list[i].minute,
                      false),
                ],
              ),
              Row(
                  mainAxisAlignment: widthQuery
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widthQuery) const Spacer(),
                    Expanded(
                        child: buildCheckBox(list[i].am, lang.schedule6, isDark,
                            widthQuery, true, list[i])),
                    Expanded(
                        child: buildCheckBox(list[i].pm, lang.schedule7, isDark,
                            widthQuery, false, list[i])),
                    if (widthQuery) const Spacer(),
                  ])
            ],
          )
        ]));
  }
}
