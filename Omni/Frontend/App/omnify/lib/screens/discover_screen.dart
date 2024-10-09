import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../languages/app_language.dart';
import '../my_flutter_app_icons.dart';
import '../providers/discover_provider.dart';
import '../providers/theme_provider.dart';
import '../subtabs/discover_body.dart';
import '../utils.dart';
import '../widgets/common/error_widget.dart';
import '../widgets/common/loading_widget.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _currentIndex = 0;
  final Key _key = GlobalKey();
  final PageController pageController = PageController();
  void pageHandler(int index) {
    FocusScope.of(context).unfocus();
    _currentIndex = index;
    pageController.jumpToPage(index);
    setState(() {});
  }

  Widget buildBar(
      AppLanguage lang, bool isDark, Color primaryColor, bool widthQuery) {
    final double iconSize = widthQuery ? 33.0 : 27;
    return Theme(
      data: ThemeData(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent),
      child: BottomNavigationBar(
          selectedFontSize: 14,
          unselectedFontSize: 14,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          iconSize: 20,
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          unselectedItemColor: isDark ? Colors.white70 : Colors.grey.shade400,
          selectedItemColor: primaryColor,
          currentIndex: _currentIndex,
          onTap: pageHandler,
          items: [
            BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.transfer, size: iconSize),
                label: lang.home1,
                tooltip: ''),
            BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.infinity, size: iconSize),
                label: lang.home2,
                tooltip: ''),
            BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.safe, size: iconSize),
                label: lang.home3,
                tooltip: ''),
            BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.jigsaw, size: iconSize),
                label: lang.home4,
                tooltip: ''),
            BottomNavigationBarItem(
                icon: Icon(MyFlutterApp.hand, size: iconSize),
                label: lang.home5,
                tooltip: ''),
          ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    final c = Provider.of<ThemeProvider>(context, listen: false).startingChain;
    final client = Provider.of<ThemeProvider>(context, listen: false).client;
    Provider.of<DiscoverProvider>(context, listen: false)
        .setLooperFuture(c, false, client);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final client = theme.client;
    final discover = Provider.of<DiscoverProvider>(context);
    final direction = theme.textDirection;
    final isDark = theme.isDark;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final getLooperStats = discover.getDiscoverStats;
    return Directionality(
        textDirection: direction,
        child: SelectionArea(
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  surfaceTintColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  title: Row(children: [
                    IconButton(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios,
                            color: isDark ? Colors.white70 : Colors.black)),
                    Expanded(
                        child: buildBar(lang, isDark, primaryColor, widthQuery))
                  ]),
                ),
                body: SafeArea(
                    child: FutureBuilder(
                        future: getLooperStats,
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const MyLoading();
                          }
                          if (snapshot.hasError) {
                            return MyError(() {
                              Provider.of<DiscoverProvider>(context,
                                      listen: false)
                                  .setLooperFuture(
                                      theme.startingChain, true, client);
                            });
                          }
                          return PageView(
                              key: _key,
                              controller: pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: const [
                                DiscoverBody(
                                    isTransfers: true,
                                    isPayments: false,
                                    isTrust: false,
                                    isBridges: false,
                                    isEscrow: false),
                                DiscoverBody(
                                    isTransfers: false,
                                    isPayments: true,
                                    isTrust: false,
                                    isBridges: false,
                                    isEscrow: false),
                                DiscoverBody(
                                    isTransfers: false,
                                    isPayments: false,
                                    isTrust: true,
                                    isBridges: false,
                                    isEscrow: false),
                                DiscoverBody(
                                    isTransfers: false,
                                    isPayments: false,
                                    isTrust: false,
                                    isBridges: true,
                                    isEscrow: false),
                                DiscoverBody(
                                    isTransfers: false,
                                    isPayments: false,
                                    isTrust: false,
                                    isBridges: false,
                                    isEscrow: true),
                              ]);
                        })))));
  }
}
