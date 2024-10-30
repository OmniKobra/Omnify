import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/governance_provider.dart';
import '../../providers/ico_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';

class RoundCountdown extends StatefulWidget {
  final bool isInRounds;
  final bool isIcoStart;
  final bool isCoinDuration;
  final bool isRoundEnd;
  final DateTime? roundDate;
  const RoundCountdown(
      {super.key,
      required this.isInRounds,
      required this.isIcoStart,
      required this.isCoinDuration,
      required this.isRoundEnd,
      required this.roundDate});

  @override
  State<RoundCountdown> createState() => _RoundCountdownState();
}

class _RoundCountdownState extends State<RoundCountdown>
    with SingleTickerProviderStateMixin {
  late CustomTimerController _controller;

  @override
  void initState() {
    super.initState();
    late Duration duration;
    final gov = Provider.of<GovernanceProvider>(context, listen: false);
    final ico = Provider.of<IcoProvider>(context, listen: false);
    if (widget.isInRounds) {
      final now = DateTime.now();
      final latest = gov.rounds.first;
      final latestDate = latest.date;
      final nextDate = latestDate.add(gov.roundInterval);
      if (nextDate.isAfter(now)) {
        duration = nextDate.difference(now);
      } else {
        duration = const Duration();
      }
    } else if (widget.isIcoStart) {
      final startDate = ico.icoStart;
      final now = DateTime.now();
      if (startDate.isAfter(now)) {
        duration = startDate.difference(now);
      } else {
        duration = const Duration();
      }
    } else if (widget.isCoinDuration) {
      duration = gov.getDurationCoinHoldWait();
    } else if (widget.isRoundEnd) {
      final now = DateTime.now();
      final roundEnds = widget.roundDate!.add(gov.roundInterval);
      if (roundEnds.isAfter(now)) {
        duration = roundEnds.difference(now);
      } else {
        duration = const Duration();
      }
    } else {
      final now = DateTime.now();
      final endDate = ico.icoEnd;
      if (endDate.isAfter(now)) {
        duration = endDate.difference(now);
      } else {
        duration = const Duration();
      }
    }
    _controller = CustomTimerController(
        vsync: this,
        begin: duration,
        end: const Duration(),
        initialState: CustomTimerState.reset,
        interval: CustomTimerInterval.seconds);
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    return CustomTimer(
        controller: _controller,
        builder: (state, time) {
          return Container(
            width: widthQuery ? 400 : double.infinity,
            margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
            decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.white,
                border: Border.all(
                    color:
                        isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(5)),
            child: ListTile(
              leading: Text(
                  widget.isInRounds
                      ? lang.timer1
                      : widget.isCoinDuration
                          ? lang.timer4
                          : widget.isRoundEnd
                              ? lang.timer5
                              : widget.isIcoStart
                                  ? lang.timer2
                                  : lang.timer3,
                  style: TextStyle(
                      fontSize: widthQuery ? 16 : 14,
                      color: isDark ? Colors.white60 : Colors.black)),
              horizontalTitleGap: 5,
              title: Row(
                children: [
                  Text(
                      "${time.days}:${time.hours}:${time.minutes}:${time.seconds}",
                      style: TextStyle(
                          color: isDark ? Colors.white60 : Colors.black,
                          fontSize: widget.isInRounds ? 16 : 18)),
                ],
              ),
            ),
          );
        });
  }
}
