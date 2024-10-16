// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class Validators {
  // eth style addresses: avalanche, celo, fantom, polygon, bsc, gnosis, aritrum, base, ethereum, linea, mantle, optimism, scroll, zksync, cronos
  // ronin, tron, hedera

  static int giveChainMaxLength(Chain c, String text) {
    if (c == Chain.Ronin) {
      return 46;
    } else if (c == Chain.Hedera) {
      return 9;
    } else {
      return 42;
    }
  }

  static RegExp giveChainAddressRegexp(Chain c, String text) {
    if (c == Chain.Ronin) {
      if (text.startsWith("ronin:")) {
        return RegExp(r'^[a-zA-Z0-9:]+$');
      } else {
        return RegExp(r'^[a-zA-Z0-9]+$');
      }
    } else if (c == Chain.Hedera) {
      return RegExp(r'^[a-zA-Z0-9.]+$');
    } else {
      return RegExp(r'^[a-zA-Z0-9]+$');
    }
  }

  static String? Function(String?)? giveAddressValidator(
      BuildContext context, Chain c) {
    final lang = Utils.language(context);
    var validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    String? ethAddressValidator(String? val) {
      if (val!.length > 42 ||
          val.length < 42 ||
          !val.startsWith("0x") ||
          val.isEmpty ||
          !validCharacters.hasMatch(val)) {
        return lang.addressValidator;
      }
      return null;
    }

    String? roninAddressValidator(String? val) {
      late int maxLength = 42;
      if (val!.startsWith("ronin:")) {
        maxLength = 46;
        validCharacters = RegExp(r'^[a-zA-Z0-9:]+$');
      } else if (val.startsWith("0x")) {
        maxLength = 42;
      }
      if (val.length > maxLength ||
          val.length < maxLength ||
          (!val.startsWith("0x") && !val.startsWith("ronin:")) ||
          val.isEmpty ||
          !validCharacters.hasMatch(val)) {
        return lang.addressValidator;
      }
      return null;
    }

    String? tronAddressValidator(String? val) {
      if (val!.length > 42 ||
          val.length < 42 ||
          !val.startsWith("T") ||
          val.isEmpty ||
          !validCharacters.hasMatch(val)) {
        return lang.addressValidator;
      }
      return null;
    }

    String? hederaAddressValidator(String? val) {
      validCharacters = RegExp(r'^[a-zA-Z0-9.]+$');
      if (val!.length > 9 ||
          val.length < 9 ||
          !val.startsWith("0.0.") ||
          val.isEmpty ||
          !validCharacters.hasMatch(val)) {
        return lang.addressValidator;
      }
      return null;
    }

    if (c == Chain.Ronin) {
      return roninAddressValidator;
    } else if (c == Chain.Tron) {
      return tronAddressValidator;
    } else if (c == Chain.Hedera) {
      return hederaAddressValidator;
    } else {
      return ethAddressValidator;
    }
  }

  static String? Function(String?)? giveAmountValidator(
      BuildContext context, int decimals) {
    final lang = Utils.language(context);
    final validCharacters = RegExp('[0-9.]');
    String? amountValidator(String? val) {
      if (val!.isEmpty ||
          !validCharacters.hasMatch(val) ||
          Decimal.tryParse(val)! < Decimal.parse("0.0")) {
        return lang.amountValidator1;
      }
      final splitted = val.split(".");
      if (splitted.length == 2) {
        if (splitted[1].length > decimals) {
          return lang.decimalValidator;
        }
      }
      late Decimal minAmount;
      late String minAmountString;
      if (decimals == 0) {
        minAmount = Decimal.parse("1.0");
        minAmountString = '1';
      } else if (decimals == 1) {
        minAmount = Decimal.parse("0.1");
        minAmountString = '0.1';
      } else if (decimals == 2) {
        minAmount = Decimal.parse("0.01");
        minAmountString = '0.01';
      } else if (decimals >= 3) {
        minAmountString = '0.001';
        minAmount = Decimal.parse("0.001");
      }

      if (Decimal.parse(val) < minAmount) {
        return lang.amountValidator2 + minAmountString;
      }
      return null;
    }

    return amountValidator;
  }

  static String? Function(String?)? giveWithdrawalAmountValidator(
      BuildContext context, Decimal currentBalance, int decimals) {
    final lang = Utils.language(context);
    final validCharacters = RegExp('[0-9.]');
    String? amountValidator(String? val) {
      if (val!.isEmpty ||
          !validCharacters.hasMatch(val) ||
          Decimal.tryParse(val)! < Decimal.parse("0.0")) {
        return lang.amountValidator1;
      }
      final splitted = val.split(".");
      if (splitted.length == 2) {
        if (splitted[1].length > decimals) {
          return lang.decimalValidator;
        }
      }
      late Decimal minAmount;
      late String minAmountString;
      if (decimals == 0) {
        minAmount = Decimal.parse("1.0");
        minAmountString = '1';
      } else if (decimals == 1) {
        minAmount = Decimal.parse("0.1");
        minAmountString = '0.1';
      } else if (decimals == 2) {
        minAmount = Decimal.parse("0.01");
        minAmountString = '0.01';
      } else if (decimals >= 3) {
        minAmountString = '0.001';
        minAmount = Decimal.parse("0.001");
      }

      if (Decimal.parse(val) < minAmount) {
        return lang.amountValidator2 + minAmountString;
      }
      if (currentBalance - Decimal.parse(val) < Decimal.parse("0.0")) {
        return lang.withdrawalAmountValidator;
      }
      return null;
    }

    return amountValidator;
  }

  static String? Function(String?)? giveTrustWithdrawalValidator(
      BuildContext context,
      Decimal allowance,
      Decimal available,
      bool isLimited,
      int decimals) {
    final lang = Utils.language(context);
    final validCharacters = RegExp('[0-9.]');
    String? amountValidator(String? val) {
      if (val!.isEmpty ||
          !validCharacters.hasMatch(val) ||
          Decimal.tryParse(val)! < Decimal.parse("0.0")) {
        return lang.amountValidator1;
      }
      final splitted = val.split(".");
      if (splitted.length == 2) {
        if (splitted[1].length > decimals) {
          return lang.decimalValidator;
        }
      }
      late Decimal minAmount;
      late String minAmountString;
      if (decimals == 0) {
        minAmount = Decimal.parse("1.0");
        minAmountString = '1';
      } else if (decimals == 1) {
        minAmount = Decimal.parse("0.1");
        minAmountString = '0.1';
      } else if (decimals == 2) {
        minAmount = Decimal.parse("0.01");
        minAmountString = '0.01';
      } else if (decimals >= 3) {
        minAmountString = '0.001';
        minAmount = Decimal.parse("0.001");
      }

      if (Decimal.parse(val) < minAmount) {
        return lang.amountValidator2 + minAmountString;
      }
      if (Decimal.tryParse(val)! > allowance && isLimited) {
        return lang.withdrawalValidator1;
      }
      if (Decimal.tryParse(val)! > available) {
        return lang.withdrawalValidator2;
      }
      return null;
    }

    return amountValidator;
  }

  static String? Function(String?)? giveDownpaymentValidator(
      BuildContext context, String amount, int decimals) {
    final lang = Utils.language(context);
    final validCharacters = RegExp('[0-9.]');
    var fullAmount = Decimal.tryParse(amount) ?? Decimal.parse("0.0");
    String? downPaymentValidator(String? val) {
      var downPaymentVal = Decimal.tryParse(val!) ?? Decimal.parse("0.0");
      final remaining = fullAmount - downPaymentVal;
      if (val.isEmpty ||
          !validCharacters.hasMatch(val) ||
          downPaymentVal < Decimal.parse("0") ||
          downPaymentVal > fullAmount) {
        return lang.amountValidator1;
      }
      final splitted = val.split(".");
      if (splitted.length == 2) {
        if (splitted[1].length > decimals) {
          return lang.decimalValidator;
        }
      }
      late Decimal minAmount;
      late String minAmountString;
      if (decimals == 0) {
        minAmount = Decimal.parse("1.0");
        minAmountString = '1';
      } else if (decimals == 1) {
        minAmount = Decimal.parse("0.1");
        minAmountString = '0.1';
      } else if (decimals == 2) {
        minAmount = Decimal.parse("0.01");
        minAmountString = '0.01';
      } else if (decimals >= 3) {
        minAmountString = '0.001';
        minAmount = Decimal.parse("0.001");
      }

      if (remaining < minAmount ||
          remaining < Decimal.parse("0") ||
          remaining == Decimal.parse("0")) {
        return lang.downpaymentValidator + minAmountString;
      }
      if (Decimal.parse(val) < minAmount) {
        return lang.amountValidator2 + minAmountString;
      }

      return null;
    }

    return downPaymentValidator;
  }

  static String? Function(String?)? givePeriodValidator(BuildContext context) {
    final lang = Utils.language(context);
    final validCharacters = RegExp('[0-9]');
    String? periodValidator(String? val) {
      if (val!.isEmpty ||
          !validCharacters.hasMatch(val) ||
          int.tryParse(val)! < 0) {
        return lang.periodValidator1;
      }

      if (int.parse(val) < 1) {
        return lang.periodValidator2;
      }
      if (int.parse(val) > 120) {
        return lang.periodValidator3;
      }

      return null;
    }

    return periodValidator;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;
    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      if (oldValue.text.substring(value.indexOf(".") + 1).length >
          decimalRange) {
        truncated = '';
        newSelection = const TextSelection(baseOffset: 0, extentOffset: 0);
      } else {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    } else if (value.contains(".")) {
      String tempValue = value.substring(value.indexOf(".") + 1);
      if (tempValue.contains(".")) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }
      if (value.indexOf(".") == 0) {
        truncated = "0" + truncated;
        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }
    }
    if (value.contains(" ") || value.contains("-")) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
