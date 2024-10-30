// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/explorer_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';
import '../network_picker.dart';

class ExplorerHeader extends StatefulWidget {
  const ExplorerHeader();

  @override
  State<ExplorerHeader> createState() => _ExplorerHeaderState();
}

class _ExplorerHeaderState extends State<ExplorerHeader> {
  Widget buildNetworkDescription(
      String description, bool isDark, bool widthQuery) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(description,
          softWrap: true,
          style:
              TextStyle(color: Colors.white70, fontSize: widthQuery ? 17 : 15)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final explorer = Provider.of<ExplorerProvider>(context);
    final description = explorer.description;
    final isDark = theme.isDark;
    final widthQuery = Utils.widthQuery(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widthQuery)
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: ListTile(
                          isThreeLine: true,
                          title: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: NetworkPicker(
                                  isExplorer: true,
                                  isGovernance: false,
                                  isIco: false)),
                          subtitle: buildNetworkDescription(
                              description, isDark, widthQuery)))
                ]),
          if (!widthQuery)
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: NetworkPicker(
                          isExplorer: true, isGovernance: false, isIco: false)),
                  buildNetworkDescription(description, isDark, widthQuery)
                ]),
          // if (!widthQuery) const SizedBox(height: 20),
          // const Looper(),
        ],
      ),
    );
  }
}
