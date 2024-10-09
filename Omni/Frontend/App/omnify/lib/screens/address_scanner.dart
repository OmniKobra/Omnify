// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/theme_provider.dart';
import '../utils.dart';

class AddressScanner extends StatefulWidget {
  final dynamic handler;
  const AddressScanner(this.handler);

  @override
  State<AddressScanner> createState() => _AddressScannerState();
}

class _AddressScannerState extends State<AddressScanner>
    with WidgetsBindingObserver {
  bool hasScanned = false;
  final MobileScannerController controller =
      MobileScannerController(autoStart: false, torchEnabled: false);
  StreamSubscription<Object?>? _subscription;
  void _handleBarcode(BarcodeCapture? b) {
    if (hasScanned) {
      _subscription!.pause();
      Future.delayed(const Duration(seconds: 3), () {
        _subscription!.resume();
        hasScanned = false;
      });
    }
    if (!hasScanned) {
      final scannedBarcodes = b?.barcodes ?? [];
      if (scannedBarcodes.isNotEmpty) {
        final scannedVal = scannedBarcodes.first.displayValue ?? '';
        if (scannedVal != '') {
          hasScanned = true;
          widget.handler(scannedVal);
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);
        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  Widget buildScannerToolbar(Color primary, Color secondary, bool widthQuery) =>
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 50,
              width: 100,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: primary, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          controller.toggleTorch();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: controller.torchEnabled ? secondary : primary,
                          child: Center(
                            child: Icon(Icons.flash_on_outlined,
                                size: 30,
                                color: controller.torchEnabled
                                    ? primary
                                    : secondary),
                          ),
                        )),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.switchCamera();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: primary,
                        child: Center(
                          child: Icon(Icons.flip_camera_ios_outlined,
                              size: 30, color: secondary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer()
        ],
      );
  Widget buildLogo(bool isDark, TextDirection dir) => Directionality(
        textDirection: dir,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child:InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  unawaited(_subscription?.cancel());
                  _subscription = null;
                  unawaited(controller.stop());
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios,
                    color: isDark ? Colors.white70 : Colors.black))),
          ],
        ),
      );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = controller.barcodes.listen(_handleBarcode);
    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    if (_subscription != null) {
      unawaited(_subscription?.cancel());
      _subscription = null;
    }
    super.dispose();
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final dir = Provider.of<ThemeProvider>(context).textDirection;
    final widthQuery = Utils.widthQuery(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    return WillPopScope(
        onWillPop: () async {
          unawaited(_subscription?.cancel());
          _subscription = null;
          unawaited(controller.stop());
          setState(() {});
          return true;
        },
        child: Scaffold(
            body: SafeArea(
                child: Column(children: [
          buildLogo(isDark, dir),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: MobileScanner(controller: controller)),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: buildScannerToolbar(
                        primaryColor, secondaryColor, widthQuery))
              ],
            ),
          )
        ]))));
  }
}
