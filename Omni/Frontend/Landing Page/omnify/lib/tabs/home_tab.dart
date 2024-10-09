import 'package:flutter/material.dart';

import '../widgets/home/carousel.dart';
import '../widgets/home/cards.dart';
import '../widgets/home/footnote.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: const [HomeCarousel(), Cards(), FootNote()]))
        ]);
  }

  @override
  bool get wantKeepAlive => true;
}
