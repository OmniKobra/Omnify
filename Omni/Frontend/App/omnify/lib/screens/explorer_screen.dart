import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../widgets/explorer/body.dart';
import '../widgets/explorer/header.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Provider.of<ThemeProvider>(context).textDirection,
      child: SelectionArea(
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.arrow_back_ios, color: Colors.white70))),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: const [
                      ExplorerHeader(),
                      SizedBox(height: 15),
                      ExplorerBody()
                    ]),
              ),
            )),
      ),
    );
  }
}
