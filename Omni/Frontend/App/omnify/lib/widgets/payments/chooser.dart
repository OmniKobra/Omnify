import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../routes.dart';
import '../../utils.dart';

class PaymentChooser extends StatefulWidget {
  const PaymentChooser({super.key});

  @override
  State<PaymentChooser> createState() => _PaymentChooserState();
}

class _PaymentChooserState extends State<PaymentChooser> {
  Widget buildImage(bool widthQuery, bool isDark, Color primaryColor) => Center(
      child: Container(
          height: widthQuery ? 75 : 50,
          width: widthQuery ? 75 : 50,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
              color: isDark ? Colors.grey.shade800 : Colors.white),
          child: ExtendedImage.network(Utils.payUrl,
              cache: true, enableLoadState: false)));

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final widthQuery = Utils.widthQuery(context);
    final heightQuery = MediaQuery.of(context).size.height > 525;
    final lang = Utils.language(context);
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.requestPay);
          },
          child: Container(
            decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : primaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.payments_rounded,
                              size: widthQuery ? 95 : 75,
                              color: isDark ? Colors.white70 : Colors.white),
                          // const SizedBox(height: 15),
                          if (heightQuery)
                            Text(
                              lang.pay1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widthQuery ? 18 : 14,
                                color: isDark ? Colors.white70 : Colors.white,
                              ),
                            )
                        ],
                      ),
                      if (!heightQuery && widthQuery) const SizedBox(width: 5),
                      if (!heightQuery && widthQuery)
                        Text(
                          lang.pay1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: widthQuery ? 18 : 14,
                            color: isDark ? Colors.white70 : Colors.white,
                          ),
                        ),
                      const Spacer(flex: 1)
                    ],
                  ),
                ),
                const Spacer(flex: 2)
              ],
            ),
          ),
        ),
        ClipPath(
            clipper: BezierClipper(),
            child:
                Container(color: isDark ? Colors.black : Colors.grey.shade100)),
        ClipPath(
          clipper: BezierClipper(),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.pay);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 1),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.mobile_friendly_rounded,
                                size: widthQuery ? 95 : 75,
                                color: isDark ? Colors.white70 : Colors.white),
                            if (heightQuery) const SizedBox(height: 5),
                            if (heightQuery)
                              Text(lang.pay2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: widthQuery ? 18 : 15,
                                    color:
                                        isDark ? Colors.white70 : Colors.white,
                                  )),
                          ],
                        ),
                        if (!heightQuery && widthQuery)
                          const SizedBox(width: 5),
                        if (!heightQuery && widthQuery)
                          Text(lang.pay2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widthQuery ? 18 : 15,
                                color: isDark ? Colors.white70 : Colors.white,
                              )),
                        const Spacer(flex: 10)
                      ],
                    ),
                  ),
                  const Spacer(flex: 2)
                ],
              ),
            ),
          ),
        ),
        ClipPath(
            clipper: BezierClipper2(),
            child:
                Container(color: isDark ? Colors.black : Colors.grey.shade100)),
        ClipPath(
            clipper: BezierClipper3(),
            child:
                Container(color: isDark ? Colors.black : Colors.grey.shade100)),
        ClipPath(
          clipper: BezierClipper2(),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.installments);
            },
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    if (!isDark) const BoxShadow(),
                    if (isDark) BoxShadow(color: Colors.grey.shade100)
                  ],
                  border: Border.all(
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  color: isDark ? Colors.grey.shade800 : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Spacer(flex: 6),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.calendar_month_rounded,
                                size: widthQuery ? 95 : 75,
                                color: isDark ? Colors.white70 : primaryColor),
                            if (heightQuery) const SizedBox(height: 5),
                            if (heightQuery)
                              Text(lang.pay3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: widthQuery ? 18 : 15,
                                    color:
                                        isDark ? Colors.white70 : primaryColor,
                                  )),
                          ],
                        ),
                        if (!heightQuery && widthQuery)
                          const SizedBox(width: 5),
                        if (!heightQuery && widthQuery)
                          Text(lang.pay3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widthQuery ? 18 : 15,
                                color: isDark ? Colors.white70 : primaryColor,
                              )),
                        const Spacer(flex: 6)
                      ],
                    ),
                  ),
                  const Spacer(flex: 8)
                ],
              ),
            ),
          ),
        ),
        ClipPath(
          clipper: BezierClipper3(),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.paymentWithdrawal);
            },
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    if (!isDark) const BoxShadow(),
                    if (isDark) BoxShadow(color: Colors.grey.shade100)
                  ],
                  border: Border.all(
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  color: isDark ? Colors.grey.shade800 : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  const Spacer(flex: 8),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Spacer(flex: 6),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.exit_to_app_rounded,
                                size: widthQuery ? 95 : 75,
                                color: isDark ? Colors.white70 : primaryColor),
                            if (heightQuery) const SizedBox(height: 5),
                            if (heightQuery)
                              Text(lang.pay4,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: widthQuery ? 18 : 15,
                                    color:
                                        isDark ? Colors.white70 : primaryColor,
                                  )),
                          ],
                        ),
                        if (!heightQuery && widthQuery)
                          const SizedBox(width: 5),
                        if (!heightQuery && widthQuery)
                          Text(lang.pay4,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widthQuery ? 18 : 15,
                                color: isDark ? Colors.white70 : primaryColor,
                              )),
                        const Spacer(flex: 6)
                      ],
                    ),
                  ),
                  const Spacer(flex: 1)
                ],
              ),
            ),
          ),
        ),
        buildImage(widthQuery, isDark, primaryColor)
      ],
    );
  }
}

class BezierClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        0, size.height * 0.5, size.width * 0, size.height * 1 + 16);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BezierClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      0,
      0,
      size.width * 0.5,
      size.height * 0.5 + 16,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BezierClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width / 2, 0);
    path.moveTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
