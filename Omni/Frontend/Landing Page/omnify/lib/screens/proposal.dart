// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../crypto/features/gov_utils.dart';
import '../languages/app_language.dart';
import '../providers/governance_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/wallet_provider.dart';
import '../toasts.dart';
import '../utils.dart';

class ProposalScreen extends StatefulWidget {
  const ProposalScreen({super.key});

  @override
  State<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  Chain c = Chain.Avalanche;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DropdownMenuItem<Chain> buildLangButtonItem(
          Chain value, bool widthQuery, bool isDark) =>
      DropdownMenuItem<Chain>(
        value: value,
        onTap: () {
          setState(() {
            c = value;
          });
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
                      color: isDark ? Colors.white70 : Colors.black,
                      fontSize: widthQuery ? 17 : 15))
            ]),
      );
  Widget buildNetworkPicker(Chain current, bool isDark, bool widthQuery,
      List<Chain> supportedChains) {
    return DropdownButton(
        dropdownColor: isDark ? Colors.grey[800] : Colors.white,
        // key: UniqueKey(),
        elevation: 8,
        menuMaxHeight: widthQuery ? 500 : 450,
        onChanged: (_) => setState(() {}),
        underline: Container(color: Colors.transparent),
        icon: Icon(Icons.arrow_drop_down,
            color: isDark ? Colors.white70 : Colors.black),
        value: current,
        items: supportedChains
            .map((c) => buildLangButtonItem(c, widthQuery, isDark))
            .toList());
  }

  Widget buildTitle(String label, bool isDark, bool widthQuery) => Text(label,
      style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black,
          fontSize: widthQuery ? 17 : 14,
          fontWeight: FontWeight.bold));

  Widget buildField(
      bool isDark,
      TextEditingController controller,
      String? Function(String?)? validator,
      int maxLength,
      int minLine,
      int maxLines) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: TextFormField(
          maxLength: maxLength,
          minLines: minLine,
          maxLines: maxLines,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
              floatingLabelBehavior: FloatingLabelBehavior.never),
        ));
  }

  Widget buildSubmitButton({
    required Web3Client client,
    required Web3App wcClient,
    required String sessionTopic,
    required String walletAddress,
    required bool widthQuery,
    required Color primaryColor,
    required AppLanguage lang,
    required bool isDark,
    required TextDirection direction,
  }) {
    return TextButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            Utils.showLoadingDialog(context, lang, widthQuery);
            final txHash = await GovUtils.submitProposal(
                c: c,
                client: client,
                wcClient: wcClient,
                sessionTopic: sessionTopic,
                walletAddress: walletAddress,
                title: titleController.text,
                description: descriptionController.text);
            if (txHash != null) {
              Future.delayed(const Duration(seconds: 1), () {
                Toasts.showSuccessToast(lang.transactionSent,
                    lang.transactionSent2, isDark, direction);
              });
              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              Toasts.showErrorToast(
                  lang.toast13, lang.toasts30, isDark, direction);
            }
          }
        },
        style: const ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
            elevation: WidgetStatePropertyAll(5),
            overlayColor: WidgetStatePropertyAll(Colors.transparent)),
        child: Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(widthQuery ? 15 : 10)),
            child: Center(
                child: Text(lang.proposal1,
                    style:
                        const TextStyle(fontSize: 18, color: Colors.white)))));
  }

  @override
  void initState() {
    super.initState();
    c = Provider.of<GovernanceProvider>(context, listen: false).currentChain;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final client = theme.client;
    final wcClient = theme.walletClient;
    final sessionTopic = theme.stateSessionTopic;
    final bool isDark = theme.isDark;
    final dir = theme.textDirection;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final supportedChains =
        Provider.of<WalletProvider>(context).supportedChains;
    final walletAddress =
        Provider.of<WalletProvider>(context, listen: false).getAddressString(c);
    final children = [
      const SizedBox(height: 5),
      buildNetworkPicker(c, isDark, widthQuery, supportedChains),
      const SizedBox(height: 5),
      buildTitle(lang.proposal2, isDark, widthQuery),
      const SizedBox(height: 2.5),
      buildField(isDark, titleController, (_) {
        if (_!.isEmpty || _.replaceAll(" ", "").isEmpty) {
          return '';
        }
        return null;
      }, 50, 1, 1),
      const SizedBox(height: 5),
      buildTitle(lang.proposal3, isDark, widthQuery),
      const SizedBox(height: 2.5),
      buildField(isDark, descriptionController, (_) {
        if (_!.isEmpty || _.replaceAll(" ", "").isEmpty) {
          return '';
        }
        return null;
      }, 420, 10, 20),
      const SizedBox(height: 5),
      buildSubmitButton(
        client: client,
        wcClient: wcClient,
        sessionTopic: sessionTopic,
        walletAddress: walletAddress,
        widthQuery: widthQuery,
        primaryColor: primaryColor,
        lang: lang,
        isDark: isDark,
        direction: dir,
      ),
      const SizedBox(height: 5)
    ];
    return Directionality(
      textDirection: Provider.of<ThemeProvider>(context).textDirection,
      child: SelectionArea(
        child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                leading: IconButton(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios,
                        color: isDark ? Colors.white70 : Colors.black))),
            body: SafeArea(
                child: Form(
                    key: formKey,
                    child: Directionality(
                        textDirection: dir,
                        child: SingleChildScrollView(
                            padding: const EdgeInsets.all(8),
                            child: Column(children: [
                              Row(children: [
                                if (widthQuery) const Spacer(flex: 1),
                                Expanded(
                                    flex: widthQuery ? 2 : 20,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: children)),
                                if (widthQuery) const Spacer(flex: 1),
                              ])
                            ])))))),
      ),
    );
  }
}
