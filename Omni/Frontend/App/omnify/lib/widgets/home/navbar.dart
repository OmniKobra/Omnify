import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../my_flutter_app_icons.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';

class Navbar extends StatefulWidget {
  final void Function(int) indexHandler;
  final int currentIndex;
  const Navbar(
      {super.key, required this.indexHandler, required this.currentIndex});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;
  void buttonHandler(int i) {
    if (selectedIndex == i) {
    } else {
      widget.indexHandler(i);
      selectedIndex = i;
      setState(() {});
    }
    FocusScope.of(context).unfocus();
  }

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
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final dir = Provider.of<ThemeProvider>(context).textDirection;
    final primaryColor = Theme.of(context).colorScheme.primary;
    const double iconSize = 29.0;
    final lang = Utils.language(context);
    return Align(
        alignment: Alignment.bottomCenter,
        child: Directionality(
          textDirection: dir,
          child: Container(
              height: 65,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color:
                              isDark ? Colors.white24 : Colors.grey.shade300))),
              child: Theme(
                data: ThemeData(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent),
                child: BottomNavigationBar(
                    selectedFontSize: 14,
                    unselectedFontSize: 14,
                    showUnselectedLabels: true,
                    showSelectedLabels: true,
                    iconSize: 20,
                    backgroundColor: isDark ? Colors.black : Colors.white,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    unselectedItemColor:
                        isDark ? Colors.white70 : Colors.grey.shade400,
                    selectedItemColor: primaryColor,
                    currentIndex: selectedIndex,
                    onTap: buttonHandler,
                    items: [
                      BottomNavigationBarItem(
                          icon:
                              const Icon(MyFlutterApp.transfer, size: iconSize),
                          label: lang.home1,
                          tooltip: ''),
                      BottomNavigationBarItem(
                          icon:
                              const Icon(MyFlutterApp.infinity, size: iconSize),
                          label: lang.home2,
                          tooltip: ''),
                      BottomNavigationBarItem(
                          icon: const Icon(MyFlutterApp.safe, size: iconSize),
                          label: lang.home3,
                          tooltip: ''),
                      BottomNavigationBarItem(
                          icon: const Icon(MyFlutterApp.jigsaw, size: iconSize),
                          label: lang.home4,
                          tooltip: ''),
                      BottomNavigationBarItem(
                          icon: const Icon(MyFlutterApp.hand, size: iconSize),
                          label: lang.home5,
                          tooltip: ''),
                      // BottomNavigationBarItem(
                      //     icon: const Icon(Icons.local_gas_station,
                      //         size: iconSize),
                      //     label: lang.home15,
                      //     tooltip: ''),
                    ]),
              )),
        ));
  }
}
