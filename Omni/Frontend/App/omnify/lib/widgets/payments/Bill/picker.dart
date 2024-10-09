import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../utils.dart';
import '../chooser.dart';

class BillPicker extends StatefulWidget {
  final Widget Function(bool, bool, TextDirection, String) buildLogo;
  final void Function() scanHandler;
  final void Function() formHandler;
  const BillPicker(
      {required this.buildLogo,
      required this.scanHandler,
      required this.formHandler,
      super.key});

  @override
  State<BillPicker> createState() => _BillPickerState();
}

class _BillPickerState extends State<BillPicker> {
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final dir = Provider.of<ThemeProvider>(context).textDirection;
    final widthQuery = Utils.widthQuery(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lang = Utils.language(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      widget.buildLogo(isDark, widthQuery, dir, lang.pay5),
      // Row(children: [
      //   Container(
      //       padding: widthQuery
      //           ? const EdgeInsets.all(8)
      //           : const EdgeInsets.symmetric(horizontal: 5),
      //       decoration: BoxDecoration(
      //           border: Border.all(
      //               color: isDark
      //                   ? Colors.grey.shade700
      //                   : Colors.grey.shade200),
      //           borderRadius: BorderRadius.circular(5),
      //           color: isDark ? Colors.grey[800] : Colors.white),
      //       child: const NetworkPicker(
      //           isExplorer: false,
      //           isTransfers: false,
      //           isPayments: false,
      //           isTrust: false,
      //           isBridgeSource: false,
      //           isBridgeTarget: false,
      //           isEscrow: false,
      //           isActivity: false)),
      //   SizedBox(width: widthQuery ? 10 : 5),
      //   const WalletButton()
      // ]),
      // const SizedBox(height: 10),
      Expanded(
          child: Stack(
        children: [
          InkWell(
            onTap: widget.scanHandler,
            child: Container(
              margin: const EdgeInsets.only(left: 8, top: 0, bottom: 8),
              decoration: BoxDecoration(
                  border:
                      isDark ? Border.all(color: Colors.grey.shade700) : null,
                  color: isDark ? Colors.grey.shade800 : primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  const Spacer(flex: 4),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.qr_code_scanner_rounded,
                                size: widthQuery ? 105 : 75,
                                color: isDark ? Colors.white70 : Colors.white),
                            // const SizedBox(height: 15),
                            Text(
                              lang.pay6,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widthQuery ? 18 : 14,
                                color: isDark ? Colors.white70 : Colors.white,
                              ),
                            )
                          ],
                        ),
                        const Spacer(flex: 2)
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
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: isDark ? Colors.black : Colors.grey.shade100,
              )),
          Container(
            margin: const EdgeInsets.only(right: 8, top: 0, bottom: 8, left: 0),
            child: ClipPath(
              clipper: BezierClipper(),
              child: InkWell(
                onTap: widget.formHandler,
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: const [BoxShadow()],
                      border: Border.all(
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300),
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.format_align_center_rounded,
                                    size: widthQuery ? 105 : 75,
                                    color:
                                        isDark ? Colors.white70 : primaryColor),
                                const SizedBox(height: 5),
                                Text(lang.pay7,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: widthQuery ? 18 : 15,
                                      color: isDark
                                          ? Colors.white70
                                          : primaryColor,
                                    )),
                              ],
                            ),
                            const Spacer(flex: 6)
                          ],
                        ),
                      ),
                      const Spacer(flex: 4)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    ]);
  }
}
