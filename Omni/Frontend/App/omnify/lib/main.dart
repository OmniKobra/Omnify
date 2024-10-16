// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'providers/activities/bridge_activity_provider.dart';
import 'providers/activities/escrow_activity_provider.dart';
import 'providers/activities/payment_activity_provider.dart';
import 'providers/activities/transfer_activity_provider.dart';
import 'providers/activities/trust_activity_provider.dart';
import 'providers/bridges_provider.dart';
import 'providers/discover_provider.dart';
import 'providers/escrows_provider.dart';
import 'providers/explorer_provider.dart';
import 'providers/fees_provider.dart';
import 'providers/payments_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/transactions_provider.dart';
import 'providers/transfers_provider.dart';
import 'providers/trusts_provider.dart';
import 'providers/wallet_provider.dart';
import 'routes.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();

  runApp(const MyApp());
}

//canva dark color: #424242
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static bool cameFromPaymentLink = false;
  static bool cameFromOtherLink = false;
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
      if (string.endsWith("/transfers") ||
          string.endsWith("/payments") ||
          string.endsWith("/trust") ||
          string.endsWith("/bridges") ||
          string.endsWith("/bridge") ||
          string.endsWith("/escrow") ||
          string.endsWith("/explorer") ||
          string.endsWith("/discover")) {
        MyApp.cameFromOtherLink = true;
        MyApp.fullUrl = string;
      } else if (string.contains("/pay")) {
        MyApp.cameFromPaymentLink = true;
        MyApp.fullUrl = string;
      }
    });
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: ExplorerProvider()),
            ChangeNotifierProvider.value(value: TransfersProvider()),
            ChangeNotifierProvider.value(value: PaymentsProvider()),
            ChangeNotifierProvider.value(value: TrustsProvider()),
            ChangeNotifierProvider.value(value: BridgesProvider()),
            ChangeNotifierProvider.value(value: EscrowsProvider()),
            ChangeNotifierProvider.value(value: WalletProvider()),
            ChangeNotifierProvider.value(value: BridgeActivityProvider()),
            ChangeNotifierProvider.value(value: EscrowActivityProvider()),
            ChangeNotifierProvider.value(value: TrustActivityProvider()),
            ChangeNotifierProvider.value(value: PaymentActivityProvider()),
            ChangeNotifierProvider.value(value: TransactionsProvider()),
            ChangeNotifierProvider.value(value: TransferActivityProvider()),
            ChangeNotifierProvider.value(value: FeesProvider()),
            ChangeNotifierProvider.value(value: DiscoverProvider()),
          ],
          child: Builder(builder: (context) {
            // Utils.testTronWalletLogic(
            //     "41a614f803b6fd780986a42c78ec9c7f77e6ded13c", true);
            // ScannerUtils.getTokenHoldings(
            //     "TSTVYwFDp7SBfZk7Hrz3tucwQVASyJdwC7", Chain.Tron
            //     "0x75D58339b11ffEc66367355E893e8Fc9b29005b6",Chain.Ethereum
            //     );
            // ScannerUtils.getAssetFromAddress(
            //     Chain.Tron, "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t"
            //     Chain.Ethereum,
            //     "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48");
            return ChangeNotifierProvider<ThemeProvider>(
                create: (_) => ThemeProvider(
                      context,
                      Provider.of<ExplorerProvider>(context, listen: false)
                          .setCurrentChain,
                    ),
                child: Consumer<ThemeProvider>(
                    builder: (ctx, theme, _) => ToastificationWrapper(
                          child: MaterialApp(
                              title: 'Omnify',
                              themeMode: theme.isDark
                                  ? ThemeMode.dark
                                  : ThemeMode.light,
                              debugShowCheckedModeBanner: false,
                              scrollBehavior: MyCustomScrollBehavior(),
                              theme: ThemeData(
                                  brightness: theme.isDark
                                      ? Brightness.dark
                                      : Brightness.light,
                                  splashColor: theme.isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200,
                                  scaffoldBackgroundColor: theme.isDark
                                      ? Colors.black
                                      : Colors.grey.shade100,
                                  colorScheme: ColorScheme.fromSeed(
                                      brightness: theme.isDark
                                          ? Brightness.dark
                                          : Brightness.light,
                                      background: theme.isDark
                                          ? Colors.black
                                          : Colors.grey.shade100,
                                      onBackground: theme.isDark
                                          ? Colors.black
                                          : Colors.white,
                                      primary: theme.isDark
                                          ? Colors.red[600]
                                          : Colors.lightBlue[600],
                                      secondary: theme.isDark
                                          ? Colors.amber[800]
                                          : Colors.amber[700],
                                      seedColor: Colors.black),
                                  useMaterial3: true),
                              onGenerateRoute: Routes.generateRoute,
                              home: const SplashScreen()),
                        )));
          }));
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
