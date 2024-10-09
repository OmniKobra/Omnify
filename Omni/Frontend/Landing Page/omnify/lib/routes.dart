import 'package:flutter/material.dart';

import 'screens/docs.dart';
import 'screens/home.dart';
import 'screens/proposal.dart';

class Routes {
  Routes._();
  static const home = '/home';
  static const proposal = '/proposal';
  static const docs = '/docs';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    const zero = Duration.zero;
    switch (settings.name) {
      case home:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const MyHomePage());
      case proposal:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const ProposalScreen());
      case docs:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const DocScreen());
      default:
        return PageRouteBuilder(
            transitionDuration: zero,
            pageBuilder: (ctx, dbl, _) => const MyHomePage());
    }
  }
}
