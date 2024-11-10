// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'providers/explorer_provider.dart';
import 'providers/fees_provider.dart';
import 'providers/governance_provider.dart';
import 'providers/home_provider.dart';
import 'providers/ico_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/wallet_provider.dart';
import 'routes.dart';
import 'screens/splash_screen.dart';

//flutter run -d chrome --web-renderer html --release
void main() {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static bool cameFromLink = false;
  static String fullUrl = "";
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      var string = uri.toString();
      if (string.endsWith("/home") ||
          string.endsWith("/explorer") ||
          string.endsWith("/governance") ||
          string.endsWith("/fees") ||
          string.endsWith("/coins")) {
        MyApp.cameFromLink = true;
        MyApp.fullUrl = string;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: HomeProvider()),
          ChangeNotifierProvider.value(value: ExplorerProvider()),
          ChangeNotifierProvider.value(value: GovernanceProvider()),
          ChangeNotifierProvider.value(value: WalletProvider()),
          ChangeNotifierProvider.value(value: FeesProvider()),
          ChangeNotifierProvider.value(value: IcoProvider()),
        ],
        child: Builder(builder: (context) {
          return ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(
                  context,
                  Provider.of<HomeProvider>(context, listen: false)
                      .setCarouselItems,
                  Provider.of<ExplorerProvider>(context, listen: false)
                      .setCurrentChain),
              child: Consumer<ThemeProvider>(
                  builder: (ctx, theme, _) => ToastificationWrapper(
                          child: MaterialApp(
                        title: 'Omnify | DeFi Hub',
                        themeMode:
                            theme.isDark ? ThemeMode.dark : ThemeMode.light,
                        debugShowCheckedModeBanner: false,
                        scrollBehavior: MyCustomScrollBehavior(),
                        theme: ThemeData(
                            brightness: theme.isDark
                                ? Brightness.dark
                                : Brightness.light,
                            splashColor: theme.isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                            scaffoldBackgroundColor:
                                theme.isDark ? Colors.black : Colors.white,
                            colorScheme: ColorScheme.fromSeed(
                                brightness: theme.isDark
                                    ? Brightness.dark
                                    : Brightness.light,
                                background:
                                    theme.isDark ? Colors.black : Colors.white,
                                onBackground:
                                    theme.isDark ? Colors.black : Colors.white,
                                primary: theme.isDark
                                    ? Colors.red[800]
                                    : Colors.redAccent[400],
                                secondary: theme.isDark
                                    ? Colors.amber[800]
                                    : Colors.amber[700],
                                seedColor: Colors.black),
                            useMaterial3: true),
                        onGenerateRoute: Routes.generateRoute,
                        home: const SplashScreen(),
                      ))));
        }));
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
