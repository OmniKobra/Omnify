import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class DocScreen extends StatefulWidget {
  const DocScreen({super.key});

  @override
  State<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDark;
    return Directionality(
        textDirection: Provider.of<ThemeProvider>(context).textDirection,
        child: SelectionArea(
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                leading: IconButton(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios,
                        color: isDark ? Colors.white70 : Colors.black)),
              ),
              body: const SafeArea(
                  child: Column(
                children: [Text('Doc')],
              ))),
        ));
  }
}
