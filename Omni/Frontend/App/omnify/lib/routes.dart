import 'package:flutter/material.dart';
import 'screens/address_scanner.dart';

import 'screens/activities/bridge_activity.dart';
import 'screens/activities/escrow_activity.dart';
import 'screens/activities/payment_activity.dart';
import 'screens/activities/transfer_activity.dart';
import 'screens/activities/trust_activity.dart';
import 'screens/activities/payment_receipts.dart';
import 'screens/activities/payment_withdrawals.dart';
import 'screens/explorer_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/finish_transfer_screen.dart';
import 'screens/home_screen.dart';
import 'screens/installments_screen.dart';
import 'screens/payment_request.dart';
import 'screens/payment_screen.dart';
import 'screens/payments_withdrawl.dart';
import 'screens/settings_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/payment_gateway.dart';

class Routes {
  Routes._();
  static const splashScreen = '/splash';
  static const homeScreen = '/home';
  static const pay = '/pay';
  static const requestPay = '/request';
  static const installments = "/installments";
  static const paymentWithdrawal = '/payWithdraw';
  static const explorer = '/explorer';
  static const settingsScreen = '/settings';
  static const finishTransfer = '/finishTransfer';
  static const transferActivity = "/transferActivity";
  static const paymentActivity = "/paymentActivity";
  static const trustActivity = "/trustActivity";
  static const bridgeActivity = "/bridgeActivity";
  static const escrowActivity = "/escrowActivity";
  static const transactions = "/transactions";
  static const paymentReceipts = "/receipts";
  static const paymentWithdrawals = "/withdrawals";
  static const discover = "/discover";
  static const addressScanner = "/addressScanner";
  static const activityScreen = "/activities";
  static const paymentGateway = "/paymentGateway";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    const zero = Duration.zero;
    switch (settings.name) {
      case pay:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const PaymentScreen());
      case requestPay:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const PaymentRequestScreen());
      case installments:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const InstallmentScreen());
      case paymentWithdrawal:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const PaymentWithdrawalScreen());
      case settingsScreen:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const SettingsScreen());
      case explorer:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const ExplorerScreen());
      case finishTransfer:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const FinishTransferScreen());
      case transferActivity:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const TransferActivity());
      case paymentActivity:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const PaymentActivity());
      case trustActivity:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const TrustActivity());
      case bridgeActivity:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const BridgeActivity());
      case escrowActivity:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const EscrowActivity());
      case homeScreen:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const HomePage());
      case splashScreen:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const SplashScreen());
      case transactions:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const TransactionScreen());
      case paymentReceipts:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const PaymentReceiptScreen());
      case paymentWithdrawals:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const PaymentWithdrawalsScreen());
      case discover:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const DiscoverScreen());
      case addressScanner:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => AddressScanner(settings.arguments));
      case activityScreen:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const ActivityScreen());
      case paymentGateway:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const PaymentGateway());
      default:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const HomePage());
    }
  }
}
