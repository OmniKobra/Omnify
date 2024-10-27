import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/swiper_item.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';

class SwiperCard extends StatefulWidget {
  final SwiperItem item;
  final void Function() nextHandler;
  final void Function() previousHandler;
  const SwiperCard(
      {super.key,
      required this.item,
      required this.nextHandler,
      required this.previousHandler});

  @override
  State<SwiperCard> createState() => _SwiperCardState();
}

class _SwiperCardState extends State<SwiperCard> {
  Widget buildListTile(
      String description, Color c, bool isDark, bool widthQuery) {
    return SizedBox(
      width: widthQuery ? 400 : null,
      child: ListTile(
          leading: Icon(Icons.arrow_forward_ios_rounded,
              color: isDark ? Colors.grey[600] : c),
          title: Text(
            description,
            style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black,
                fontSize: widthQuery ? 16 : 14),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final dir = Provider.of<ThemeProvider>(context).textDirection;
    return Stack(
      children: [
        Container(
            height: 650,
            decoration: BoxDecoration(
                border: Border.all(
                    color: isDark ? Colors.grey.shade600 : widget.item.color),
                color: isDark ? Colors.grey[850] : Colors.grey[50],
                borderRadius: BorderRadius.circular(12)),
            child: Container(
                margin: EdgeInsets.only(
                    top: widthQuery ? 150 : 140, left: 8, right: 8, bottom: 8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment:
                        widget.item.icon == Icons.local_gas_station
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.spaceBetween,
                    children: [
                      if (!widthQuery)
                        ...widget.item.features.map((e) => buildListTile(
                            e, widget.item.color, isDark, widthQuery)),
                      if (widthQuery)
                        Expanded(
                          child: Wrap(spacing: 10, children: [
                            ...widget.item.features.map((e) => buildListTile(
                                e, widget.item.color, isDark, widthQuery))
                          ]),
                        ),
                      if (!widthQuery) const Spacer(),
                      if (!widthQuery)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  style: const ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                      backgroundColor: WidgetStatePropertyAll(
                                          Colors.transparent)),
                                  onPressed: widget.nextHandler,
                                  child: Text(lang.previous,
                                      style: TextStyle(
                                          color: isDark
                                              ? Colors.white70
                                              : widget.item.color))),
                              TextButton(
                                  onPressed: widget.previousHandler,
                                  child: Text(lang.next,
                                      style: TextStyle(
                                          color: isDark
                                              ? Colors.white70
                                              : widget.item.color)))
                            ])
                    ]))),
        ClipPath(
            clipper: MyClipper(),
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade600 : widget.item.color,
                  borderRadius: BorderRadius.circular(12)),
            )),
        Container(
          margin: const EdgeInsets.only(top: 50, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (dir == TextDirection.rtl) const SizedBox(width: 10),
              Icon(widget.item.icon,
                  color: isDark ? Colors.white70 : Colors.white,
                  size: widthQuery ? 45 : 35),
              const SizedBox(width: 10),
              Text(
                widget.item.title,
                style: TextStyle(
                    fontSize: widthQuery ? 27 : 24,
                    color: isDark ? Colors.white70 : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 4.25);
    var firstControlPoint = Offset(size.width / 4, size.height / 3);
    var firstEndPoint = Offset(size.width / 2, size.height / 3 - 60);
    var secondControlPoint =
        Offset(size.width - (size.width / 4), size.height / 4 - 65);
    var secondEndPoint = Offset(size.width, size.height / 3 - 40);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
}
