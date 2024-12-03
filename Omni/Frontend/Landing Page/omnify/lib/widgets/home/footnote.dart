// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../my_flutter_app_icons.dart';
import '../../providers/theme_provider.dart';
// import '../../routes.dart';
import '../../utils.dart';
import '../my_image.dart';
import 'dark_button.dart';
import 'language_button.dart';

class FootNote extends StatefulWidget {
  const FootNote();

  @override
  State<FootNote> createState() => _FootNoteState();
}

class _FootNoteState extends State<FootNote> {
  Widget buildImage(String url) => Container(
        margin: EdgeInsets.symmetric(
            vertical: 8.0, horizontal: Utils.widthQuery(context) ? 8 : 0),
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: Utils.widthQuery(context) ? 60 : 30,
              maxWidth: Utils.widthQuery(context) ? 70 : 40,
              minHeight: Utils.widthQuery(context) ? 60 : 30,
              maxHeight: Utils.widthQuery(context) ? 60 : 40,
            ),
            child: MyImage(url: url, fit: BoxFit.contain)),
      );

  Widget buildWrap() => Wrap(
        spacing: 12,
        children: [
          //TODO ADD NEXT SUPPORTED NETWORKS HERE
          buildImage(Utils.apeChainUrl),
          buildImage(Utils.blastUrl),
          buildImage(Utils.polygonUrl),
          buildImage(Utils.optimismUrl),
          buildImage(Utils.linkUrl),
          // buildImage(Utils.inchUrl),
          buildImage(Utils.fantomUrl),
          buildImage(Utils.bscUrl),
          buildImage(Utils.ethUrl),
          buildImage(Utils.layerzeroUrl),
          buildImage(Utils.avalancheUrl),
          buildImage(Utils.arbitrumUrl),
          buildImage(Utils.tronUrl),
          buildImage(Utils.baseUrl),
          buildImage(Utils.lineaUrl),
          // buildImage(Utils.cronosUrl),
          buildImage(Utils.mantleUrl),
          buildImage(Utils.gnosisUrl),
          // buildImage(Utils.kavaUrl),
          buildImage(Utils.goldrushUrl),
          buildImage(Utils.roninUrl),
          buildImage(Utils.zksyncUrl),
          buildImage(Utils.celoUrl),
          buildImage(Utils.scrollUrl),
          // buildImage(Utils.hederaUrl),
        ],
      );
  Widget buildLinkerIcon(
      IconData icon, String url, bool widthQuery, bool isDark) {
    return IconButton(
      tooltip: '',
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () {
        launchUrlString(url);
      },
      icon: Icon(icon,
          size: widthQuery ? 30 : null,
          color: isDark ? Colors.white : Colors.black),
    );
  }

  Widget buildSideTool(bool widthQuery, bool isDark) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const DarkButton(),
              const LanguageButton(),
              // TextButton(
              //     style: const ButtonStyle(
              //         foregroundColor:
              //             WidgetStatePropertyAll(Colors.transparent),
              //         backgroundColor:
              //             WidgetStatePropertyAll(Colors.transparent),
              //         splashFactory: NoSplash.splashFactory,
              //         overlayColor: WidgetStatePropertyAll(Colors.transparent)),
              //     onPressed: () {
              //       Navigator.pushNamed(context, Routes.docs);
              //     },
              //     child: Text('Docs',
              //         style: TextStyle(
              //             color: isDark ? Colors.white70 : Colors.black))),
              Wrap(children: [
                buildLinkerIcon(MyFlutterApp.x, "https://x.com/OmnifyFi",
                    widthQuery, isDark),
                buildLinkerIcon(MyFlutterApp.telegram,
                    "https://t.me/omnifyfinance", widthQuery, isDark),
                buildLinkerIcon(MyFlutterApp.github,
                    "https://github.com/OmniKobra/Omnify", widthQuery, isDark),
              ])
            ]));
  }

  @override
  Widget build(BuildContext context) {
    final widthQuery = Utils.widthQuery(context);
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: widthQuery ? 70 : 50),
        decoration:
            BoxDecoration(color: isDark ? Colors.grey[850] : Colors.grey[50]),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  flex: widthQuery ? 2 : 4,
                  child: buildSideTool(widthQuery, isDark)),
              Flexible(flex: 7, child: buildWrap()),
            ]));
  }
}
