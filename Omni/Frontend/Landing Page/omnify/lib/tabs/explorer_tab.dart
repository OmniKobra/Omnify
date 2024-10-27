import 'package:flutter/material.dart';
import '../widgets/explorer/body.dart';
import '../widgets/explorer/header.dart';

class ExplorerTab extends StatefulWidget {
  const ExplorerTab({super.key});

  @override
  State<ExplorerTab> createState() => _ExplorerTabState();
}

class _ExplorerTabState extends State<ExplorerTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: const [
          ExplorerHeader(),
          SizedBox(height: 15),
          ExplorerBody()
        ]);
  }

  @override
  bool get wantKeepAlive => true;
}
