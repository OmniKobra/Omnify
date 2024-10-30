import 'package:flutter/material.dart';

class Noglow extends StatelessWidget {
  final Widget child;
  const Noglow({super.key, required this.child});

  @override
  Widget build(BuildContext context) =>
      NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: child);
}
