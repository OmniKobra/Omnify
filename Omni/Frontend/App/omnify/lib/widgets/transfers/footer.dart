// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:omnify/crypto/utils/chain_utils.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:provider/provider.dart';

import '../../languages/app_language.dart';
import '../../models/transfer.dart';
import '../../providers/theme_provider.dart';
import '../../providers/transfers_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../utils.dart';
import '../../routes.dart';
import '../../toasts.dart';

class MyFooter extends StatefulWidget {
  const MyFooter({super.key});

  @override
  State<MyFooter> createState() => _MyFooterState();
}

class _MyFooterState extends State<MyFooter> {
  Future<void> validateState({
    required Chain c,
    required Web3Client client,
    required Web3App walletClient,
    required String sessionTopic,
    required List<TransferFormModel> transfers,
    required AppLanguage lang,
    required TextDirection dir,
    required String walletAddress,
    required bool widthQuery,
    required bool isDark,
    required bool walletConnected,
  }) async {
    FocusScope.of(context).unfocus();
    for (var transfer in transfers) {
      transfer.formkey.currentState!.validate();
    }
    if (transfers.any((element) => !element.formkey.currentState!.validate())) {
    } else {
      if (!walletConnected) {
        Toasts.showInfoToast(lang.toast1, lang.toast2, isDark, dir);
      } else {
        Utils.showLoadingDialog(
            context, lang, widthQuery, false, lang.validating);
        Map<String, Decimal> _assetsToApprove = {};
        Map<String, Decimal> _assetsToBeSent = {};
        List<String> _insufficientFundAssets = [];
        String toastMsg = lang.toastMsg;
        String insufficientMessage = '';
        try {
          for (var transfer in transfers) {
            final amountInput =
                Decimal.tryParse(transfer.amount.text) ?? Decimal.parse("0.0");
            Decimal existingValue = _assetsToBeSent[transfer.asset.address] ??
                Decimal.parse(("0.0"));
            if (existingValue > Decimal.parse(("0.0"))) {
              _assetsToBeSent[transfer.asset.address] =
                  existingValue + amountInput;
            } else {
              _assetsToBeSent[transfer.asset.address] = amountInput;
            }
          }
          for (var transfer in transfers) {
            Decimal currentValue = _assetsToBeSent[transfer.asset.address]!;
            final Decimal balance = await ChainUtils.getAssetBalance(
                c, walletAddress, transfer.asset, client);
            if (balance < currentValue) {
              if (!insufficientMessage
                  .contains("\$${transfer.asset.symbol},")) {
                insufficientMessage =
                    insufficientMessage + "\$${transfer.asset.symbol}, ";
              }
              _insufficientFundAssets.add(transfer.asset.address);
            }
          }
        } catch (e) {
          Navigator.pop(context);
        }
        try {
          for (var transfer in transfers) {
            var asset = transfer.asset;
            var amount = Decimal.parse(transfer.amount.text);
            if (asset.address != Utils.zeroAddress) {
              final Decimal allowance = await ChainUtils.getErcAllowance(
                  c: c,
                  client: client,
                  owner: walletAddress,
                  asset: transfer.asset,
                  isTransfers: true,
                  isTrust: false,
                  isBridges: false,
                  isEscrow: false,
                  isDark: isDark,
                  widthQuery: widthQuery,
                  dir: dir,
                  lang: lang,
                  popDialog: () => Navigator.pop(context));
              Decimal _preexistingAmount =
                  _assetsToApprove[asset.address] ?? Decimal.parse("0.0");
              Decimal _nextAmount = _preexistingAmount + amount;
              if (allowance < amount || allowance < _nextAmount) {
                if (_preexistingAmount > Decimal.parse("0.0")) {
                  _assetsToApprove[asset.address] = amount + _preexistingAmount;
                } else {
                  _assetsToApprove[asset.address] = amount;
                  toastMsg = toastMsg + "\$${asset.symbol}, ";
                }
              }
            }
          }
        } catch (e) {
          Navigator.pop(context);
        }

        if (_insufficientFundAssets.isEmpty) {
          if (_assetsToApprove.isEmpty) {
            if (transfers.isNotEmpty && walletConnected) {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.finishTransfer);
            }
          } else {
            Toasts.showInfoToast(lang.toasts20, toastMsg, isDark, dir);
            await ChainUtils.requestApprovals(
                c: c,
                client: client,
                wcClient: walletClient,
                keys: _assetsToApprove.keys.toList(),
                allowances: _assetsToApprove,
                isTransfers: true,
                isTrust: false,
                isBridges: false,
                isEscrow: false,
                sessionTopic: sessionTopic,
                walletAddress: walletAddress,
                isDark: isDark,
                dir: dir,
                lang: lang);
            Navigator.pop(context);
          }
        } else {
          Navigator.pop(context);
          Toasts.showErrorToast(
              lang.toasts26, insufficientMessage, isDark, dir);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final transfers = Provider.of<TransfersProvider>(context);
    final transfersNo = Provider.of<TransfersProvider>(context, listen: false);
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.isDark;
    final dir = theme.textDirection;
    final client = theme.client;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lang = Utils.language(context);
    final border =
        Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200);
    final c = Provider.of<ThemeProvider>(context).startingChain;
    final walletClient = Provider.of<ThemeProvider>(context).walletClient;
    final wallet = Provider.of<WalletProvider>(context);
    final walletMethods = Provider.of<WalletProvider>(context, listen: false);
    final walletAddress = walletMethods.getAddressString(c);
    final walletConnected = wallet.isWalletConnected;
    final widthQuery = Utils.widthQuery(context);
    final sessionTopic = Provider.of<ThemeProvider>(context).stateSessionTopic;
    return Container(
      height: widthQuery ? 60 : 45,
      width: double.infinity,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(5),
        color: isDark ? Colors.grey[800] : Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          IconButton(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (transfers.transfers.length > 1) {
                transfersNo.removeTransfer();
                transfers.swiperController.previous();
                transfersNo.changeIndex(false);
              }
            },
            icon:
                Icon(Icons.remove, color: isDark ? Colors.white60 : Colors.red),
          ),
          IconButton(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              FocusScope.of(context).unfocus();
              transfers.swiperController.previous();
              transfersNo.changeIndex(false);
            },
            icon: Icon(
                dir == TextDirection.rtl
                    ? Icons.keyboard_arrow_right
                    : Icons.keyboard_arrow_left,
                color: isDark ? Colors.white60 : Colors.black),
          ),
          Text(
              dir == TextDirection.rtl
                  ? '${transfers.transfers.length}/${transfers.currentIndex + 1}'
                  : '${transfers.currentIndex + 1}/${transfers.transfers.length}',
              style: TextStyle(
                  fontSize: widthQuery ? 17 : 15,
                  color: isDark ? Colors.white60 : Colors.black,
                  fontStyle: FontStyle.italic)),
          IconButton(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              FocusScope.of(context).unfocus();
              transfers.swiperController.next();
              transfersNo.changeIndex(true);
            },
            icon: Icon(
                dir == TextDirection.rtl
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_right,
                color: isDark ? Colors.white60 : Colors.black),
          ),
          IconButton(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (transfers.transfers.length <= 9) {
                transfersNo.addTransfer(walletAddress);
                transfersNo.changeIndex(true);
                Future.delayed(
                    const Duration(milliseconds: 100),
                    () => transfers.swiperController
                        .move(transfers.transfers.length - 1));
              }
            },
            icon: Icon(Icons.add,
                color: isDark ? Colors.white60 : Colors.greenAccent[400]),
          ),
          SizedBox(width: widthQuery ? 15 : 5),
          TextButton(
              onPressed: () async {
                await validateState(
                    c: c,
                    client: client,
                    walletClient: walletClient,
                    sessionTopic: sessionTopic,
                    transfers: transfers.transfers,
                    lang: lang,
                    dir: dir,
                    walletAddress: walletAddress,
                    widthQuery: widthQuery,
                    isDark: isDark,
                    walletConnected: walletConnected);
              },
              style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                  elevation: WidgetStatePropertyAll(5),
                  overlayColor: WidgetStatePropertyAll(Colors.transparent)),
              child: Container(
                  height: widthQuery ? 40 : 30,
                  width: widthQuery ? 100 : 75,
                  // padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(widthQuery ? 10 : 7)),
                  child: Center(
                      child: Text(lang.transfer1,
                          style: TextStyle(
                              fontSize: widthQuery ? 15 : 13,
                              color: Colors.white))))),
          const Spacer()
        ],
      ),
    );
  }
}
