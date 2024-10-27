// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/carousel_item.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';
import '../my_image.dart';

class CarouselWidget extends StatefulWidget {
  final CarouselItem item;
  const CarouselWidget(this.item);

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  Widget buildImage() {
    return Expanded(child: Container());
  }

  Widget buildTextTitle(bool widthQuery, bool isDark) => Text(
        widget.item.title,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: widthQuery ? 23 : 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : Colors.black),
      );

  Widget buildTextDescription(bool widthQuery, bool isDark) =>
      Text(widget.item.description,
          softWrap: true,
          style: TextStyle(
              fontFamily: "Roboto",
              fontSize: widthQuery ? 18 : 15,
              color: isDark ? Colors.white70 : Colors.black));

  @override
  Widget build(BuildContext context) {
    final widthQuery = Utils.widthQuery(context);
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: widthQuery
          ? Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Flexible(
                    flex: 4,
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? Colors.grey[900] : Colors.white),
                        child: Center(
                            child: MyImage(
                                url: widget.item.imageUrl,
                                fit: BoxFit.scaleDown)))),
                const SizedBox(width: 15),
                Flexible(
                  flex: 7,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextTitle(widthQuery, isDark),
                      const SizedBox(height: 5),
                      buildTextDescription(widthQuery, isDark),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                Flexible(
                    flex: 4,
                    child: Center(
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? Colors.grey[900] : Colors.white),
                          child: Center(
                              child: MyImage(
                                  url: widget.item.imageUrl,
                                  fit: BoxFit.contain))),
                    )),
                const Spacer(flex: 1),
                buildTextTitle(widthQuery, isDark),
                const SizedBox(height: 5),
                buildTextDescription(widthQuery, isDark),
              ],
            ),
    );
  }
}
