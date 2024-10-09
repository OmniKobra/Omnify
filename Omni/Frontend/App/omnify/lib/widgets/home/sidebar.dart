import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../my_flutter_app_icons.dart';
import '../../providers/theme_provider.dart';
import '../../routes.dart';
import '../../utils.dart';
import '../common/noglow.dart';
import 'dark_button.dart';
import 'language_button.dart';

class MySidebar extends StatefulWidget {
  final int currentIndex;
  final void Function(int) indexHandler;

  const MySidebar(
      {super.key, required this.indexHandler, required this.currentIndex});

  @override
  State<MySidebar> createState() => _MySidebarState();
}

class _MySidebarState extends State<MySidebar> {
  int selectedIndex = 0;
  Widget buildChoice(
      {required int currentIndex,
      required int index,
      required IconData icon,
      required String label,
      required bool isDark,
      required void Function()? paramhandler,
      required Color primaryColor}) {
    void handler() {
      if (paramhandler != null) {
        paramhandler();
      } else {
        if (index != currentIndex) {
          widget.indexHandler(index);
          selectedIndex = index;
          setState(() {});
        } else {}
      }
      FocusScope.of(context).unfocus();
    }

    final iconData = Column(
      children: [
        Icon(
          icon,
          size: paramhandler != null ? 24 : 35,
          color: currentIndex == index
              ? primaryColor
              : paramhandler != null
                  ? Colors.white
                  : isDark
                      ? Colors.white70
                      : Colors.grey.shade400,
        ),
        if (paramhandler == null)
          Text(
            label,
            style: TextStyle(
                fontSize: 14,
                color: currentIndex == index
                    ? primaryColor
                    : paramhandler != null
                        ? Colors.white
                        : isDark
                            ? Colors.white70
                            : Colors.grey.shade400),
          )
      ],
    );

    return Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: paramhandler != null ? null : const EdgeInsets.all(4),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: paramhandler != null
                ? !isDark
                    ? null
                    : RadialGradient(
                        tileMode: TileMode.clamp,
                        colors: [Colors.black26, primaryColor])
                : null,
            color: paramhandler != null ? primaryColor : Colors.transparent),
        child: IconButton(
          padding: const EdgeInsets.all(0),
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          icon: iconData,
          onPressed: handler,
        ));
  }

  void push(String name) => Navigator.pushNamed(context, name);
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex;
    Future.delayed(const Duration(milliseconds: 2250), () {
      setState(() {
        selectedIndex = widget.currentIndex;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lang = Utils.language(context);
    return AnimatedContainer(
      width: 80,
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          border: Border(
              right: BorderSide(
                  color: isDark ? Colors.white24 : Colors.grey.shade300))),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 5),
            Center(
                child: SizedBox(
                    height: 60,
                    child: ExtendedImage.network(Utils.logo,
                        cache: true, enableLoadState: false))),
            Divider(
                thickness: 1,
                color: isDark ? Colors.white24 : Colors.grey.shade300),
            Expanded(
                child: Noglow(
              child: ListView(
                children: [
                  buildChoice(
                      currentIndex: selectedIndex,
                      index: 0,
                      icon: MyFlutterApp.transfer,
                      label: lang.home1,
                      isDark: isDark,
                      primaryColor: primaryColor,
                      paramhandler: null),
                  buildChoice(
                      currentIndex: selectedIndex,
                      index: 1,
                      icon: MyFlutterApp.infinity,
                      label: lang.home2,
                      isDark: isDark,
                      primaryColor: primaryColor,
                      paramhandler: null),
                  buildChoice(
                      currentIndex: selectedIndex,
                      index: 2,
                      icon: MyFlutterApp.safe,
                      label: lang.home3,
                      isDark: isDark,
                      primaryColor: primaryColor,
                      paramhandler: null),
                  buildChoice(
                      currentIndex: selectedIndex,
                      index: 3,
                      icon: MyFlutterApp.jigsaw,
                      label: lang.home4,
                      isDark: isDark,
                      primaryColor: primaryColor,
                      paramhandler: null),
                  buildChoice(
                      currentIndex: selectedIndex,
                      index: 4,
                      icon: MyFlutterApp.hand,
                      label: lang.home5,
                      isDark: isDark,
                      primaryColor: primaryColor,
                      paramhandler: null),
                  // buildChoice(
                  //     currentIndex: selectedIndex,
                  //     index: 5,
                  //     icon: Icons.local_gas_station,
                  //     label: lang.home15,
                  //     isDark: isDark,
                  //     primaryColor: primaryColor,
                  //     paramhandler: null),
                  const SizedBox(height: 5),
                  Center(
                      child: buildChoice(
                          currentIndex: selectedIndex,
                          index: 40,
                          icon: Icons.hourglass_empty_rounded,
                          label: lang.home10,
                          isDark: isDark,
                          primaryColor: primaryColor,
                          paramhandler: () {
                            Navigator.pushNamed(context, Routes.transactions);
                          })),
                  const SizedBox(height: 5),
                  Center(
                      child: buildChoice(
                          currentIndex: selectedIndex,
                          index: 40,
                          icon: Icons.explore_outlined,
                          label: lang.home12,
                          isDark: isDark,
                          primaryColor: primaryColor,
                          paramhandler: () {
                            Navigator.pushNamed(context, Routes.discover);
                          })),
                  const SizedBox(height: 5),
                  Center(
                    child: buildChoice(
                        currentIndex: selectedIndex,
                        index: 40,
                        icon: Icons.search,
                        label: lang.home6,
                        isDark: isDark,
                        primaryColor: primaryColor,
                        paramhandler: () =>
                            Navigator.pushNamed(context, Routes.explorer)),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: buildChoice(
                        currentIndex: selectedIndex,
                        index: 40,
                        icon: Icons.bar_chart_rounded,
                        label: lang.home9,
                        isDark: isDark,
                        primaryColor: primaryColor,
                        paramhandler: () => Navigator.pushNamed(
                            context, Routes.activityScreen)),
                  ),
                ],
              ),
            )),
            Divider(
                thickness: 1,
                color: isDark ? Colors.white24 : Colors.grey.shade300),
            const LanguageButton(),
            const DarkButton(setSize: true),
          ]),
    );
  }
}
