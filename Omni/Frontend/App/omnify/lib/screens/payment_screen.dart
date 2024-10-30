// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import '../toasts.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../providers/theme_provider.dart';
import '../providers/wallet_provider.dart';
import '../utils.dart';
import '../widgets/payments/Bill/picker.dart';
import '../widgets/payments/Bill/payment_details.dart';
import '../widgets/payments/Bill/payment_form.dart';

enum ViewMode { pending, manual, scanner, paying }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with WidgetsBindingObserver {
  bool hasScanned = false;
  bool toastShown = false;
  final MobileScannerController controller =
      MobileScannerController(autoStart: false, torchEnabled: false);
  StreamSubscription<Object?>? _subscription;
  ViewMode view = ViewMode.pending;
  Chain c = Chain.Avalanche;
  String vendorAddress = "";
  bool isInstallments = false;
  String paymentID = '';
  Decimal amountPerMonth = Decimal.parse("0.0");
  int installmentPeriod = 0;
  Decimal amount = Decimal.parse("0.0");
  Decimal installmentFee = Decimal.parse("0.0");
  Decimal omnifyFee = Decimal.parse("0.0");
  Decimal gasFee = Decimal.parse("0.0");
  Decimal fullAmount = Decimal.parse("0.0");
  Decimal finalMonthAmount = Decimal.parse("0.0");
  Chain stringToChain(String chainName) {
    //TODO ADD NEXT SUPPORTED NETWORKS HERE
    switch (chainName) {
      case 'Blast':
        return Chain.Blast;
      case 'Fuji':
        return Chain.Fuji;
      case 'BNBT':
        return Chain.BNBT;
      case 'Avalanche':
        return Chain.Avalanche;
      case 'Optimism':
        return Chain.Optimism;
      case 'Ethereum':
        return Chain.Ethereum;
      case 'BSC':
        return Chain.BSC;
      case 'Arbitrum':
        return Chain.Arbitrum;
      case 'Ape':
        return Chain.Ape;
      case 'Polygon':
        return Chain.Polygon;
      case 'Fantom':
        return Chain.Fantom;
      case 'Tron':
        return Chain.Tron;
      case 'Base':
        return Chain.Base;
      case 'Linea':
        return Chain.Linea;
      case 'Cronos':
        return Chain.Cronos;
      case 'Mantle':
        return Chain.Mantle;
      case 'Gnosis':
        return Chain.Gnosis;
      case 'Kava':
        return Chain.Kava;
      case 'Ronin':
        return Chain.Ronin;
      case 'Zksync':
        return Chain.Zksync;
      case 'Celo':
        return Chain.Celo;
      case 'Scroll':
        return Chain.Scroll;
      case 'Hedera':
        return Chain.Hedera;
      default:
        return Chain.Avalanche;
    }
  }

  String stripString(String str, String pattern) {
    return str.replaceAll(pattern, '');
  }

  void showErrorToast() {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final lang = Utils.language(context);
    if (!toastShown) {
      toastShown = true;
      Toasts.showErrorToast(lang.toast3, lang.toast4, isDark, dir);
      Future.delayed(const Duration(seconds: 2), () {
        toastShown = false;
      });
    }
  }

  void _handleBarcode(BarcodeCapture? b) {
    if (!hasScanned && view == ViewMode.scanner) {
      final scannedBarcodes = b?.barcodes ?? [];
      if (scannedBarcodes.isNotEmpty) {
        final paymentLink = scannedBarcodes.first.displayValue ?? '';
        if (paymentLink != '') {
          hasScanned = true;
          setState(() {});
          final list = paymentLink
              .replaceAll("https://app.omnify.finance/pay/", '')
              .split("?");
          if (list.isNotEmpty && list.length == 12) {
            try {
              c = stringToChain(stripString(list[0], 'chain='));
              vendorAddress = stripString(list[1], 'vendor=');
              String emptyID = '';
              String paramID = stripString(list[2], 'id=');
              paymentID = paramID == emptyID
                  ? Utils.generateID(vendorAddress, DateTime.now())
                  : paramID;
              amount = Decimal.parse(stripString(list[3], 'amount='));
              gasFee = Decimal.parse(stripString(list[4], 'gas='));
              omnifyFee = Decimal.parse(stripString(list[5], 'omnify='));
              installmentFee =
                  Decimal.parse(stripString(list[6], 'installmentFee='));
              isInstallments =
                  bool.parse(stripString(list[7], 'isInstallments='));
              installmentPeriod = int.parse(stripString(list[8], 'period='));
              amountPerMonth =
                  Decimal.parse(stripString(list[9], 'amountpermonth='));
              fullAmount = Decimal.parse(stripString(list[10], 'fullAmount='));
              finalMonthAmount =
                  Decimal.parse(stripString(list[11], 'finalMonthAmount='));
              view = ViewMode.paying;
              setState(() {});
            } catch (e) {
              showErrorToast();
            }
          } else {
            showErrorToast();
          }
        } else {
          showErrorToast();
        }
      }
    }
    if (hasScanned && view == ViewMode.scanner) {
      Future.delayed(const Duration(seconds: 1), () {
        hasScanned = false;
        setState(() {});
      });
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
        if (view == ViewMode.scanner) {
          _subscription = controller.barcodes.listen(_handleBarcode);
          unawaited(controller.start());
        }
      case AppLifecycleState.inactive:
        if (view == ViewMode.scanner) {
          unawaited(_subscription?.cancel());
          _subscription = null;
          unawaited(controller.stop());
        }
    }
  }

  Widget buildLogo(
          bool isDark, bool widthQuery, TextDirection dir, String label) =>
      Directionality(
        textDirection: dir,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  if (view == ViewMode.scanner) {
                    unawaited(_subscription?.cancel());
                    _subscription = null;
                    unawaited(controller.stop());
                  }
                  if (view == ViewMode.pending) {
                    Navigator.pop(context);
                  } else {
                    view = ViewMode.pending;
                    setState(() {});
                  }
                },
                child: Icon(Icons.arrow_back_ios,
                    color: isDark ? Colors.white70 : Colors.black)),
            SizedBox(
                height: 60,
                width: 60,
                child: ExtendedImage.network(Utils.payUrl,
                    cache: true, enableLoadState: false)),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widthQuery ? 20 : 17)),
          ],
        ),
      );
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    final walletSheetOpen =
        Provider.of<WalletProvider>(context).walletSheetOpen;
    final lang = Utils.language(context);
    return WillPopScope(
      onWillPop: () async {
        if (walletSheetOpen) {
          Provider.of<WalletProvider>(context, listen: false)
              .walletSheetClose();
          return true;
        } else {
          if (view == ViewMode.scanner) {
            unawaited(_subscription?.cancel());
            _subscription = null;
            unawaited(controller.stop());
            view = ViewMode.pending;
            setState(() {});
            return false;
          }
          if (view == ViewMode.pending) {
            return true;
          } else {
            view = ViewMode.pending;
            setState(() {});
            return false;
          }
        }
      },
      child: SelectionArea(
        child: Scaffold(
            appBar: null,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: view == ViewMode.pending
                        ? BillPicker(
                            buildLogo: buildLogo,
                            scanHandler: () {
                              _subscription =
                                  controller.barcodes.listen(_handleBarcode);
                              unawaited(controller.start());
                              view = ViewMode.scanner;
                              setState(() {});
                            },
                            formHandler: () {
                              view = ViewMode.manual;
                              setState(() {});
                            })
                        : view == ViewMode.scanner
                            ? Column(children: [
                                buildLogo(isDark, widthQuery, dir, lang.pay5),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                          child: MobileScanner(
                                              controller: controller)),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: buildScannerToolbar(
                                              primaryColor,
                                              secondaryColor,
                                              widthQuery))
                                    ],
                                  ),
                                )
                              ])
                            : view == ViewMode.manual
                                ? Column(children: [
                                    buildLogo(
                                        isDark, widthQuery, dir, lang.pay5),
                                    const PaymentForm(
                                        isRequest: false, changeViewMode: null)
                                  ])
                                : PaymentDetails(
                                    chain: c,
                                    vendorAddress: vendorAddress,
                                    isInstallments: false,
                                    paymentID: paymentID,
                                    amountperMonth: amountPerMonth,
                                    finalInstallment: finalMonthAmount,
                                    installmentPeriod: installmentPeriod,
                                    amount: amount,
                                    hasInstallments: isInstallments,
                                    fullAmount: fullAmount,
                                    installmentHandler: null,
                                    buildLogo: buildLogo)),
              ),
            )),
      ),
    );
  }
}
