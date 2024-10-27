// ignore_for_file: use_build_context_synchronously

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omnify/models/beneficiary.dart';
import 'package:provider/provider.dart';

import '../../languages/app_language.dart';
import '../../providers/theme_provider.dart';
import '../../providers/trusts_provider.dart';
import '../../toasts.dart';
import '../../utils.dart';
import '../../validators.dart';
import '../common/field_suffix.dart';

class TrustSheet extends StatefulWidget {
  final bool isBeneficiary;
  final bool isModification;
  final bool isModifyBeneficiary;
  final int decimals;
  final Beneficiary? beneficiaryToModify;
  final Function(Beneficiary) addBeneficiaryHandler;
  final Function(Beneficiary, Beneficiary) modifyModificationBeneficiary;
  const TrustSheet(
      {super.key,
      required this.isBeneficiary,
      required this.isModification,
      required this.isModifyBeneficiary,
      required this.decimals,
      required this.addBeneficiaryHandler,
      required this.beneficiaryToModify,
      required this.modifyModificationBeneficiary});

  @override
  State<TrustSheet> createState() => _TrustSheetState();
}

class _TrustSheetState extends State<TrustSheet> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  late TextEditingController? allowanceController;
  bool isLimited = false;
  bool isUnlimited = true;
  Widget buildField(AppLanguage lang, Chain c, bool isDark,
      TextEditingController controller, String? Function(String?)? validator,
      [TextInputType? keyboardType]) {
    final int decimals =
        Provider.of<TrustsProvider>(context).currentAsset.decimals;
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: [
            if (keyboardType == null)
              LengthLimitingTextInputFormatter(
                  Validators.giveChainMaxLength(c, controller.text)),
            if (keyboardType == null)
              TextInputFormatter.withFunction(
                (TextEditingValue oldValue, TextEditingValue newValue) {
                  return Validators.giveChainAddressRegexp(c, newValue.text)
                          .hasMatch(newValue.text)
                      ? newValue
                      : newValue.text == ''
                          ? const TextEditingValue(text: '')
                          : oldValue;
                },
              ),
            if (keyboardType != null && decimals > 0)
              DecimalTextInputFormatter(decimalRange: decimals),
            if (keyboardType != null && decimals > 0)
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
            if (keyboardType != null && decimals < 1)
              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
          ],
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: keyboardType == null
                  ? AddressFieldSuffix(
                      showScanButton: true,
                      copyHandler: () async {
                        final data =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (data != null && data.text != null) {
                          var validationResult = validator!(data.text);
                          if (validationResult == null) {
                            controller.text = data.text!;
                          } else {
                            Toasts.showErrorToast(
                                lang.addressValidator,
                                lang.toast10,
                                isDark,
                                Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .textDirection);
                          }
                        }
                      },
                      scannerHandler: (_) {
                        var validationResult = validator!(_);
                        if (validationResult == null) {
                          controller.text = _;
                          Navigator.pop(context);
                        } else {
                          Toasts.showErrorToast(
                              lang.addressValidator,
                              lang.toast9,
                              isDark,
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .textDirection);
                        }
                      })
                  : null,
              filled: true,
              fillColor: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
              floatingLabelBehavior: FloatingLabelBehavior.never),
        ));
  }

  Widget buildTitle(String label, bool isDark, bool widthQuery) => Text(label,
      style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black,
          fontSize: widthQuery ? 17 : 14,
          fontWeight: FontWeight.bold));

  Widget buildCheckBox(
          {required bool value,
          required String label,
          required bool isDark,
          required bool widthQuery,
          required bool paramIsLimited,
          required bool paramIsUnlimited}) =>
      ListTile(
          visualDensity: VisualDensity.comfortable,
          hoverColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          leading: Checkbox(
              value: value,
              onChanged: (val) {
                if (paramIsLimited) {
                  isLimited = val!;
                  isUnlimited = !val;
                } else {
                  isUnlimited = val!;
                  isLimited = !val;
                }

                setState(() {});
              },
              hoverColor: Colors.transparent,
              splashRadius: 0),
          horizontalTitleGap: 5,
          title: Text(label,
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black,
                fontSize: widthQuery ? 16 : 14,
              )));

  @override
  void initState() {
    super.initState();
    if (widget.isBeneficiary) {
      allowanceController = TextEditingController(
          text: widget.isModifyBeneficiary
              ? widget.beneficiaryToModify!.allowancePerDay
                  .toStringAsFixed(widget.decimals)
              : '');
      if (widget.isModifyBeneficiary) {
        addressController.text = widget.beneficiaryToModify!.address;
        isLimited = widget.beneficiaryToModify!.isLimited;
        isUnlimited = !widget.beneficiaryToModify!.isLimited;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.isBeneficiary) allowanceController!.dispose();
  }

  Widget buildButton(Color primaryColor, bool widthQuery, String doneLabel) {
    return TextButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (formKey.currentState!.validate()) {
            final b = Beneficiary(
                address: addressController.text.trim(),
                isLimited: isLimited,
                allowancePerDay: isLimited
                    ? Decimal.parse(allowanceController!.text.trim())
                    : Decimal.parse("0"),
                dateLastWithdrawal: DateTime.now());
            if (widget.isBeneficiary) {
              if (widget.isModification) {
                if (widget.isModifyBeneficiary) {
                  widget.modifyModificationBeneficiary(
                      widget.beneficiaryToModify!, b);
                } else {
                  widget.addBeneficiaryHandler(b);
                }
              } else {
                if (widget.isModifyBeneficiary) {
                  Provider.of<TrustsProvider>(context, listen: false)
                      .modifyBeneficiary(widget.beneficiaryToModify!, b);
                } else {
                  Provider.of<TrustsProvider>(context, listen: false)
                      .addBeneficiary(b);
                }
              }
              Navigator.pop(context);
            } else {
              Provider.of<TrustsProvider>(context, listen: false)
                  .addOwner(addressController.text.trim());
              Navigator.pop(context);
            }
          }
        },
        style: const ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
            elevation: WidgetStatePropertyAll(5),
            overlayColor: WidgetStatePropertyAll(Colors.transparent)),
        child: Container(
            height: 40,
            width: widthQuery ? 100 : 75,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(widthQuery ? 10 : 7)),
            child: Center(
                child: Text(doneLabel,
                    style: TextStyle(
                        fontSize: widthQuery ? 15 : 13,
                        color: Colors.white)))));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final direction = theme.textDirection;
    final isDark = theme.isDark;
    final widthQuery = Utils.widthQuery(context);
    final lang = Utils.language(context);
    const heightBox1 = SizedBox(height: 10);
    const heightBox2 = SizedBox(height: 15);
    final int decimals =
        Provider.of<TrustsProvider>(context).currentAsset.decimals;
    final Chain c = Provider.of<TrustsProvider>(context).currentChain;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formKey,
        child: Directionality(
          textDirection: direction,
          child: SelectionArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // color: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.isBeneficiary ? lang.trust19 : lang.trust20,
                          style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close,
                              color: isDark ? Colors.white60 : Colors.black))
                    ],
                  ),
                ),
                Divider(color: isDark ? Colors.white60 : Colors.grey[300]),
                Expanded(
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, bottom: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.isBeneficiary
                                ? [
                                    const SizedBox(height: 5),
                                    buildTitle(
                                        lang.trust21, isDark, widthQuery),
                                    heightBox1,
                                    buildField(
                                        lang,
                                        c,
                                        isDark,
                                        addressController,
                                        Validators.giveAddressValidator(
                                            context, c)),
                                    heightBox2,
                                    buildTitle(
                                        lang.trust22, isDark, widthQuery),
                                    heightBox1,
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: buildCheckBox(
                                                  value: isLimited,
                                                  label: lang.trust23,
                                                  isDark: isDark,
                                                  widthQuery: widthQuery,
                                                  paramIsLimited: true,
                                                  paramIsUnlimited: false)),
                                          Expanded(
                                              child: buildCheckBox(
                                                  value: isUnlimited,
                                                  label: lang.trust24,
                                                  isDark: isDark,
                                                  widthQuery: widthQuery,
                                                  paramIsLimited: false,
                                                  paramIsUnlimited: true))
                                        ]),
                                    if (isLimited) heightBox2,
                                    if (isLimited)
                                      buildTitle(
                                          lang.trust25, isDark, widthQuery),
                                    if (isLimited) heightBox1,
                                    if (isLimited)
                                      buildField(
                                          lang,
                                          c,
                                          isDark,
                                          allowanceController!,
                                          Validators.giveAmountValidator(
                                              context, decimals),
                                          TextInputType.number),
                                    heightBox2,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        buildButton(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            widthQuery,
                                            lang.trust18)
                                      ],
                                    ),
                                    SizedBox(
                                        height: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom)
                                  ]
                                : [
                                    const SizedBox(height: 5),
                                    buildTitle(
                                        lang.trust21, isDark, widthQuery),
                                    heightBox2,
                                    buildField(
                                        lang,
                                        c,
                                        isDark,
                                        addressController,
                                        Validators.giveAddressValidator(
                                            context, c)),
                                    heightBox2,
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          buildButton(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              widthQuery,
                                              lang.trust18)
                                        ]),
                                    SizedBox(
                                        height: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom)
                                  ])))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
