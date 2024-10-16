import 'package:decimal/decimal.dart';
import 'package:provider/provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../languages/app_language.dart';
import '../main.dart';
import '../toasts.dart';
import '../utils.dart';
import '../providers/theme_provider.dart';
import '../widgets/payments/bill/payment_details.dart';

class PaymentGateway extends StatefulWidget {
  const PaymentGateway({super.key});

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
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
                  Navigator.pop(context);
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

  void showError(bool isDark, TextDirection dir, AppLanguage lang) {
    Future.delayed(const Duration(milliseconds: 200), () {
      Toasts.showErrorToast(lang.gateway1, lang.gateway2, isDark, dir);
    });
    Navigator.popUntil(context, (r) => r.isFirst);
  }

  @override
  void initState() {
    super.initState();
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final String paymentLink = MyApp.fullUrl;
    if (paymentLink != '') {
      final list = paymentLink
          .replaceAll("https://app.omnify.finance/pay/", '')
          .split("?");
      if (list.isNotEmpty && list.length == 12) {
        try {
          c = stringToChain(stripString(list[0], 'chain='));
          vendorAddress = stripString(list[1], 'vendor=');
          paymentID = stripString(list[2], 'id=');
          amount = Decimal.parse(stripString(list[3], 'amount='));
          gasFee = Decimal.parse(stripString(list[4], 'gas='));
          omnifyFee = Decimal.parse(stripString(list[5], 'omnify='));
          installmentFee =
              Decimal.parse(stripString(list[6], 'installmentFee='));
          isInstallments = bool.parse(stripString(list[7], 'isInstallments='));
          installmentPeriod = int.parse(stripString(list[8], 'period='));
          amountPerMonth =
              Decimal.parse(stripString(list[9], 'amountpermonth='));
          fullAmount = Decimal.parse(stripString(list[10], 'fullAmount='));
          finalMonthAmount =
              Decimal.parse(stripString(list[11], 'finalMonthAmount='));
        } catch (e) {
          showError(theme.isDark, theme.textDirection, theme.appLanguage);
        }
      } else {
        showError(theme.isDark, theme.textDirection, theme.appLanguage);
      }
    } else {
      showError(theme.isDark, theme.textDirection, theme.appLanguage);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: null,
      body: SafeArea(
          child: SelectionArea(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PaymentDetails(
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
                      buildLogo: buildLogo)))));
}
