// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';
import '../languages/app_language.dart';
import '../providers/activities/bridge_activity_provider.dart';
import '../providers/activities/escrow_activity_provider.dart';
import '../providers/activities/payment_activity_provider.dart';
import '../providers/activities/transfer_activity_provider.dart';
import '../providers/activities/trust_activity_provider.dart';
import '../providers/wallet_provider.dart';
import '../providers/bridges_provider.dart';
import '../providers/discover_provider.dart';
import '../providers/escrows_provider.dart';
import '../providers/explorer_provider.dart';
import '../providers/payments_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/transactions_provider.dart';
import '../providers/transfers_provider.dart';
import '../providers/trusts_provider.dart';

class NetworkPicker extends StatefulWidget {
  final bool isExplorer;
  final bool isTransfers;
  final bool isPayments;
  final bool isTrust;
  final bool isBridgeSource;
  final bool isBridgeTarget;
  final bool isEscrow;
  final bool isTransferActivity;
  final bool isPaymentActivity;
  final bool isTrustActivity;
  final bool isBridgeActivity;
  final bool isEscrowActivity;
  final bool isTransactions;
  final bool isDiscoverTransfers;
  final bool isDiscoverPayments;
  final bool isDiscoverTrust;
  final bool isDiscoverBridges;
  final bool isDiscoverEscrow;
  const NetworkPicker(
      {required this.isExplorer,
      required this.isTransfers,
      required this.isPayments,
      required this.isTrust,
      required this.isBridgeSource,
      required this.isBridgeTarget,
      required this.isEscrow,
      required this.isTransferActivity,
      required this.isPaymentActivity,
      required this.isTrustActivity,
      required this.isBridgeActivity,
      required this.isEscrowActivity,
      required this.isTransactions,
      required this.isDiscoverTransfers,
      required this.isDiscoverPayments,
      required this.isDiscoverTrust,
      required this.isDiscoverBridges,
      required this.isDiscoverEscrow});

  @override
  State<NetworkPicker> createState() => _NetworkPickerState();
}

class _NetworkPickerState extends State<NetworkPicker> {
  DropdownMenuItem<Chain> buildLangButtonItem(
      Chain value,
      dynamic setNetwork,
      AppLanguage lang,
      bool widthQuery,
      bool isDark,
      Chain current,
      Chain currentSourceChain,
      Chain currentDestinationChain,
      bool bridgeCondition) {
    final myAddresses = Provider.of<WalletProvider>(context).myAddresses;
    return DropdownMenuItem<Chain>(
      value: value,
      enabled:
          (value == Chain.Ronin && bridgeCondition) || value != Chain.Ronin,
      onTap: () async {
        if (widget.isBridgeSource || widget.isBridgeTarget) {
          if (value != current &&
              value != currentSourceChain &&
              value != currentDestinationChain) {
            final theme = Provider.of<ThemeProvider>(context, listen: false);
            if (!widget.isBridgeTarget) {
              Provider.of<ThemeProvider>(context, listen: false)
                  .setStartingChain(value, context, myAddresses[value]!)
                  .then((v) {
                if (v) {
                  setNetwork(
                      value, lang, true, theme.client, theme.walletClient);
                }
              });
            } else {
              setNetwork(value, lang, true, theme.client, theme.walletClient);
            }
          }
        } else {
          if (value != current) {
            Provider.of<ThemeProvider>(context, listen: false)
                .setStartingChain(value, context, myAddresses[value]!)
                .then((v) {
              final client =
                  Provider.of<ThemeProvider>(context, listen: false).client;
              if (v) {
                if (widget.isDiscoverTransfers ||
                    widget.isDiscoverPayments ||
                    widget.isDiscoverTrust ||
                    widget.isDiscoverBridges ||
                    widget.isDiscoverEscrow) {
                  setNetwork(value, lang, true);
                }
                if (widget.isTransferActivity ||
                    widget.isPaymentActivity ||
                    widget.isTrustActivity ||
                    widget.isBridgeActivity ||
                    widget.isEscrowActivity ||
                    widget.isEscrow) {
                  setNetwork(value, lang, client, myAddresses[value], true);
                }
              }
            });
          }
        }
      },
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Utils.buildNetworkLogo(widthQuery, value, true),
            const SizedBox(width: 7.5),
            Text(value.name,
                style: TextStyle(
                    color: widget.isExplorer
                        ? Colors.white70
                        : isDark
                            ? Colors.white70
                            : Colors.black,
                    fontSize: widthQuery ? 17 : 15))
          ]),
    );
  }

  Widget buildNetworkPicker(
      Chain current,
      bool isDark,
      bool widthQuery,
      dynamic setNetwork,
      AppLanguage lang,
      Chain currentSourceChain,
      Chain currentDestinationChain,
      List<Chain> supportedChains) {
    bool bridgecondition = !widget.isBridgeSource &&
        !widget.isBridgeTarget &&
        !widget.isDiscoverBridges &&
        !widget.isBridgeActivity;
    return DropdownButton(
        dropdownColor: widget.isExplorer
            ? Colors.black
            : isDark
                ? Colors.black
                : Colors.white,
        // key: UniqueKey(),
        elevation: 8,
        menuMaxHeight: widthQuery ? 500 : 450,
        onChanged: supportedChains.isEmpty ? null : (_) => setState(() {}),
        underline: Container(color: Colors.transparent),
        icon: Icon(Icons.arrow_drop_down,
            color: widget.isExplorer
                ? Colors.white70
                : isDark
                    ? Colors.white70
                    : Colors.black),
        value: current,
        items: widget.isBridgeTarget
            ? [
                //TODO ADD NEXT SUPPORTED NETWORKS HERE
                // TODO REMOVE CHAIN SUPPORT HERE

                // Chain.Fuji,
                // Chain.BNBT,
                Chain.Avalanche,
                Chain.Optimism,
                // Chain.Ethereum,
                Chain.BSC,
                Chain.Arbitrum,
                Chain.Ape,
                Chain.Polygon,
                Chain.Fantom,
                // Chain.Tron,
                Chain.Base,
                Chain.Linea,
                Chain.Mantle,
                Chain.Gnosis,
                // Chain.Ronin,
                Chain.Zksync,
                Chain.Celo,
                Chain.Scroll,
                Chain.Blast
              ]
                .map((c) => buildLangButtonItem(
                    c,
                    setNetwork,
                    lang,
                    widthQuery,
                    isDark,
                    current,
                    currentSourceChain,
                    currentDestinationChain,
                    bridgecondition))
                .toList()
            : supportedChains
                .map((c) => buildLangButtonItem(
                    c,
                    setNetwork,
                    lang,
                    widthQuery,
                    isDark,
                    current,
                    currentSourceChain,
                    currentDestinationChain,
                    bridgecondition))
                .toList());
  }

  dynamic getHandler(Chain c) {
    if (widget.isExplorer) {
      return Provider.of<ExplorerProvider>(context, listen: false)
          .setCurrentChain;
    }
    if (widget.isTransfers) {
      return (_, __) => Provider.of<TransfersProvider>(context, listen: false)
          .setChain(
              _,
              __,
              Provider.of<WalletProvider>(context, listen: false)
                  .getAddressString(c));
    }
    if (widget.isPayments) {
      return Provider.of<PaymentsProvider>(context, listen: false).setChain;
    }
    if (widget.isTrust) {
      return Provider.of<TrustsProvider>(context, listen: false).setChain;
    }
    if (widget.isBridgeSource) {
      return Provider.of<BridgesProvider>(context, listen: false)
          .setSourceChain;
    }
    if (widget.isBridgeTarget) {
      return Provider.of<BridgesProvider>(context, listen: false)
          .setTargetChain;
    }
    if (widget.isEscrow) {
      return Provider.of<EscrowsProvider>(context, listen: false).setChain;
    }
    if (widget.isBridgeActivity) {
      return Provider.of<BridgeActivityProvider>(context, listen: false)
          .setChain;
    }
    if (widget.isTransferActivity) {
      return Provider.of<TransferActivityProvider>(context, listen: false)
          .setChain;
    }
    if (widget.isPaymentActivity) {
      return Provider.of<PaymentActivityProvider>(context, listen: false)
          .setChain;
    }
    if (widget.isTrustActivity) {
      return Provider.of<TrustActivityProvider>(context, listen: false)
          .setChain;
    }
    if (widget.isEscrowActivity) {
      return Provider.of<EscrowActivityProvider>(context, listen: false)
          .setChain;
    }
    if (widget.isTransactions) {
      return Provider.of<TransactionsProvider>(context, listen: false).setChain;
    }
    if (widget.isDiscoverTransfers) {
      return Provider.of<DiscoverProvider>(context, listen: false)
          .setDiscoverTransferChain;
    }
    if (widget.isDiscoverPayments) {
      return Provider.of<DiscoverProvider>(context, listen: false)
          .setDiscoverPaymentChain;
    }
    if (widget.isDiscoverTrust) {
      return Provider.of<DiscoverProvider>(context, listen: false)
          .setDiscoverTrustChain;
    }
    if (widget.isDiscoverBridges) {
      return Provider.of<DiscoverProvider>(context, listen: false)
          .setDiscoverBridgeChain;
    }
    if (widget.isDiscoverEscrow) {
      return Provider.of<DiscoverProvider>(context, listen: false)
          .setDiscoverEscrowChain;
    }
    return Provider.of<ExplorerProvider>(context, listen: false)
        .setCurrentChain;
  }

  @override
  Widget build(BuildContext context) {
    final discover = Provider.of<DiscoverProvider>(context);
    final discoverTransferChain = discover.transferChain;
    final discoverPaymentChain = discover.paymentChain;
    final discoverTrustChain = discover.trustChain;
    final discoverBridgeChain = discover.bridgeChain;
    final discoverEscrowChain = discover.escrowChain;
    final explorerChain = Provider.of<ExplorerProvider>(context).currentChain;
    final transferChain = Provider.of<TransfersProvider>(context).currentChain;
    final paymentsChain = Provider.of<PaymentsProvider>(context).currentChain;
    final trustChain = Provider.of<TrustsProvider>(context).currentChain;
    final bridgeSourceChain =
        Provider.of<BridgesProvider>(context).currentSourceChain;
    final bridgeTargetChain =
        Provider.of<BridgesProvider>(context).currentTargetChain;
    final escrowChain = Provider.of<EscrowsProvider>(context).currentChain;
    final bridgeActivityChain =
        Provider.of<BridgeActivityProvider>(context).currentChain;
    final escrowActivityChain =
        Provider.of<EscrowActivityProvider>(context).currentChain;
    final paymentActivityChain =
        Provider.of<PaymentActivityProvider>(context).currentChain;
    final trustActivityChain =
        Provider.of<TrustActivityProvider>(context).currentChain;
    final transferActivityChain =
        Provider.of<TransferActivityProvider>(context).currentChain;
    final transactionsChain =
        Provider.of<TransactionsProvider>(context).currentChain;
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final supportedChains =
        Provider.of<WalletProvider>(context).supportedChains;
    Chain getChain() {
      if (widget.isExplorer) {
        return explorerChain;
      }
      if (widget.isTransfers) {
        return transferChain;
      }
      if (widget.isPayments) {
        return paymentsChain;
      }
      if (widget.isTrust) {
        return trustChain;
      }
      if (widget.isBridgeSource) {
        return bridgeSourceChain;
      }
      if (widget.isBridgeTarget) {
        return bridgeTargetChain;
      }
      if (widget.isEscrow) {
        return escrowChain;
      }
      if (widget.isTransferActivity) {
        return transferActivityChain;
      }
      if (widget.isPaymentActivity) {
        return paymentActivityChain;
      }
      if (widget.isTrustActivity) {
        return trustActivityChain;
      }
      if (widget.isBridgeActivity) {
        return bridgeActivityChain;
      }
      if (widget.isEscrowActivity) {
        return escrowActivityChain;
      }
      if (widget.isTransactions) {
        return transactionsChain;
      }
      if (widget.isDiscoverTransfers) {
        return discoverTransferChain;
      }
      if (widget.isDiscoverPayments) {
        return discoverPaymentChain;
      }
      if (widget.isDiscoverTrust) {
        return discoverTrustChain;
      }
      if (widget.isDiscoverBridges) {
        return discoverBridgeChain;
      }
      if (widget.isDiscoverEscrow) {
        return discoverEscrowChain;
      }
      return explorerChain;
    }

    return buildNetworkPicker(
        getChain(),
        isDark,
        widthQuery,
        getHandler(getChain()),
        lang,
        bridgeSourceChain,
        bridgeTargetChain,
        supportedChains);
  }
}
