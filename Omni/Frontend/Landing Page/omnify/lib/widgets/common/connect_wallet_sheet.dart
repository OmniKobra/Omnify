// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unnecessary_string_interpolations

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter_wc/qr_flutter_wc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../../crypto/utils/chain_data.dart';
import '../../crypto/utils/device_utils.dart';
import '../../crypto/utils/eip155.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../toasts.dart';
import '../../utils.dart';
import 'error_widget.dart';

enum ViewMode { idle, codeShown }

class ConnectWalletSheet extends StatefulWidget {
  const ConnectWalletSheet({super.key});

  @override
  State<ConnectWalletSheet> createState() => _ConnectWalletSheetState();
}

class _ConnectWalletSheetState extends State<ConnectWalletSheet> {
  ViewMode view = ViewMode.idle;
  late Future<void> future;
  late void Function() closeSheet;
  late Web3App wcClient;
  late ConnectResponse resp;
  // static final List<String> neededPlatforms = ['ios', 'android', 'web'];
  // final List<Map<String, dynamic>> _walletsInternal = [
  //   {
  //     'name': 'Rainbow Wallet',
  //     'platform': neededPlatforms,
  //     'id': '1ae92b26df02f0abca6304df07debccd18262fdf5fe82daa81593582dac9a369',
  //     'schema': 'rainbow://',
  //     'bundleId': 'com.walletconnect.sample.wallet',
  //     'universal': 'https://lab.web3modal.com/wallet',
  //     'icon': '',
  //   },
  // ];
  Map<String, RequiredNamespace> optionalNamespaces = {};
  bool sessionSet = false;
  void updateNamespaces() {
    optionalNamespaces = {};
    final evmChains = ChainData.eip155Chains;
    optionalNamespaces['eip155'] = RequiredNamespace(
        chains: evmChains.map((c) => c.chainId).toList(),
        methods: EIP155.methods.values.toList(),
        events: ['chainChanged', 'accountsChanged']);
    //TODO ADD TRON SUPPORT HERE

    // optionalNamespaces['tron'] = const RequiredNamespace(chains: [
    //   'tron:0x2b6653dc'
    // ], methods: [
    //   'tron_signTransaction',
    //   'tron_signMessage',
    //   'tron_sign',
    //   'tron_sendTransaction',
    //   'personal_sign',
    //   'tron_signTypedData'
    // ], events: [
    //   'chainChanged',
    //   'accountsChanged'
    // ]);
  }

  Future<void> initWebClient() async {
    resp = await wcClient.connect(optionalNamespaces: optionalNamespaces);
  }

  @override
  void initState() {
    super.initState();
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    closeSheet = wallet.walletSheetClose;
    wcClient = theme.walletClient;
    updateNamespaces();
    future = initWebClient();
  }

  Future<void> showQrCode(TextDirection dir, {String walletScheme = ''}) async {
    setState(() {
      view = ViewMode.codeShown;
    });
  }

  Widget buildChoiceTile(
      String title,
      String subtitle,
      IconData icon,
      bool isDark,
      bool widthQuery,
      void Function() handler,
      Color primaryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              width: .5,
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200)),
      child: ListTile(
        horizontalTitleGap: 20,
        onTap: handler,
        leading: Container(
          decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(.25)
                  : primaryColor.withOpacity(.10),
              borderRadius: BorderRadius.circular(5)),
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Icon(icon,
                color: isDark ? Colors.white70 : primaryColor,
                size: widthQuery ? 30 : 24),
          ),
        ),
        title: Text(title,
            style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black,
                fontSize: widthQuery ? 16 : 14,
                fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: TextStyle(
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                fontSize: widthQuery ? 14 : 12,
                fontWeight: FontWeight.normal)),
      ),
    );
  }

  @override
  void dispose() {
    closeSheet();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = theme.isDark;
    final dir = theme.textDirection;

    return WillPopScope(
        onWillPop: () async {
          wallet.walletSheetClose();
          return true;
        },
        child: SafeArea(
          child: Directionality(
            textDirection: dir,
            child: SelectionArea(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                height: double.infinity,
                decoration: BoxDecoration(
                    border: widthQuery
                        ? Border.all(
                            color: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300)
                        : null,
                    color: isDark ? Colors.white : primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 200,
                            child: ExtendedImage.network(
                                isDark
                                    ? Utils.wcBannerDark
                                    : Utils.wcBannerLight,
                                enableLoadState: false),
                          ),
                          IconButton(
                              onPressed: () {
                                Provider.of<WalletProvider>(context,
                                        listen: false)
                                    .walletSheetClose();
                                Navigator.pop(context);
                              },
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(Icons.cancel,
                                  size: widthQuery ? 30 : 24,
                                  color: isDark ? Colors.black : Colors.white)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                          future: future,
                          builder: (ctx, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(20)),
                                      color: isDark
                                          ? Colors.grey[800]
                                          : Colors.white),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: CircularProgressIndicator(
                                                color: primaryColor))
                                      ]));
                            }
                            if (snap.hasError) {
                              return MyError(() {
                                setState(() {
                                  future = initWebClient();
                                });
                              });
                            }
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(20)),
                                  color:
                                      isDark ? Colors.grey[800] : Colors.white),
                              child: view == ViewMode.codeShown
                                  ? Directionality(
                                      textDirection: dir,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: resp.uri
                                                                .toString()));
                                                    Toasts.showInfoToast(
                                                        lang.toast5,
                                                        "",
                                                        false,
                                                        Provider.of<ThemeProvider>(
                                                                context,
                                                                listen: false)
                                                            .textDirection);
                                                  },
                                                  icon: const Icon(
                                                    Icons.copy,
                                                    color: Colors.blue,
                                                  )),
                                              const Spacer(),
                                            ],
                                          ),
                                          Expanded(
                                            child: Center(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    40.0)),
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 18.0,
                                                        ),
                                                      ),
                                                      child: QrImageView(
                                                        data:
                                                            resp.uri.toString(),
                                                        version:
                                                            QrVersions.auto,
                                                        errorCorrectionLevel:
                                                            QrErrorCorrectLevel
                                                                .Q,
                                                        eyeStyle:
                                                            const QrEyeStyle(
                                                          eyeShape:
                                                              QrEyeShape.circle,
                                                          color: Colors.black,
                                                        ),
                                                        dataModuleStyle:
                                                            const QrDataModuleStyle(
                                                          dataModuleShape:
                                                              QrDataModuleShape
                                                                  .circle,
                                                          color: Colors.black,
                                                        ),
                                                        embeddedImage:
                                                            const AssetImage(
                                                                'assets/logo_wc.png'),
                                                        embeddedImageStyle:
                                                            const QrEmbeddedImageStyle(
                                                          size:
                                                              Size(80.0, 80.0),
                                                        ),
                                                        embeddedImageEmitsError:
                                                            true,
                                                      ),
                                                    ))),
                                          ),
                                          Text(resp.uri.toString(),
                                              style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white70
                                                      : Colors.grey))
                                        ],
                                      ),
                                    )
                                  : ListView(
                                      children: [
                                        Center(
                                          child: Text(lang.wcsheet1,
                                              style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white70
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:
                                                      widthQuery ? 17 : 16)),
                                        ),
                                        const SizedBox(height: 15),
                                        buildChoiceTile(
                                            lang.wcsheet2,
                                            lang.wcsheet3,
                                            Icons.qr_code,
                                            isDark,
                                            widthQuery, () {
                                          showQrCode(dir);
                                        }, primaryColor),
                                        //metamask: chrome-extension://nkbihfbeogaeaoehlefnkodbefgpgknn
                                        //okx: chrome-extension://mcohilncbfahbmgdjkbpemcciiolgcge
                                        //trust: chrome-extension://egjidjbpglichdcondbcbdnbeeppgdph
                                        //rainbow: chrome-extension://opfgelmcmbiajamepnmloijbpoleiama
                                        //final encodedUri =
                                        // Uri.encodeComponent(
                                        //     resp.uri.toString());
                                        //wc?uri=$encodedUri
                                        if (!DeviceUtils.isPcWeb())
                                          buildChoiceTile(
                                              lang.wcsheet4,
                                              lang.wcsheet5,
                                              Icons.account_balance_wallet,
                                              isDark,
                                              widthQuery, () {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 250), () {
                                              Navigator.pop(context);
                                            });
                                            launchUrlString(resp.uri.toString(),
                                                mode: LaunchMode
                                                    .externalApplication);
                                          }, primaryColor),
                                        const SizedBox(height: 5),
                                        Center(
                                          child: SizedBox(
                                            height: 130,
                                            child: ExtendedImage.network(
                                                isDark
                                                    ? Utils.wcEmblemDark
                                                    : Utils.wcEmblemLight,
                                                enableLoadState: false),
                                          ),
                                        )
                                      ],
                                    ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
