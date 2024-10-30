import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../providers/fees_provider.dart';
import 'asset.dart';
import '../utils.dart';

enum Vision { transfer, date }

class TransferFormModel {
  CryptoAsset asset;
  String id;
  TextEditingController amount;
  TextEditingController recipient;
  TextEditingController day;
  TextEditingController month;
  TextEditingController year;
  TextEditingController hour;
  TextEditingController minute;
  GlobalKey<FormState> formkey;
  bool isScheduled;
  bool isInstant;
  bool am;
  bool pm;
  Vision vision;
  Decimal gasFee;
  Decimal omnifyFee;
  Decimal totalFee;

  void changeAsset(CryptoAsset a, String val, List<FeeTier> tiers,
      Decimal altcoinFee, void Function() setstate) {
    asset = a;
    checkTierMatch(val, tiers, altcoinFee, setstate);
    // setstate();
  }

  void checkTierMatch(String val, List<FeeTier> tiers, Decimal altcoinFee,
      void Function() setState) {
    final amount = val.isEmpty ? Decimal.parse("0") : Decimal.parse(val);
    for (var tier in tiers) {
      if (amount == Decimal.parse("0")) {
        setOmnifyFee(Decimal.parse("0.0"));
      }
      if (asset.address == Utils.zeroAddress) {
        if (tier.highThreshold != null) {
          if (amount >= tier.lowThreshold && amount <= tier.highThreshold!) {
            setOmnifyFee(tier.fee);
          }
        } else {
          if (amount >= tier.lowThreshold) {
            setOmnifyFee(tier.fee);
          }
        }
      } else {
        setOmnifyFee(altcoinFee);
      }
      calculateTotalFee();
      setState();
    }
  }

  void setGasFee(Decimal f, void Function()setState) {
    gasFee = f;
    calculateTotalFee();
    setState();
  }

  void setOmnifyFee(Decimal f) {
    omnifyFee = f;
  }

  void calculateTotalFee() {
    Decimal totl = Decimal.parse("0.0");
    if (asset.address == Utils.zeroAddress) {
      Decimal parse = Decimal.tryParse(amount.text) ?? Decimal.parse("0.0");
      totl += parse;
    }
    totl += omnifyFee;
    totl += gasFee;
    totalFee = totl;
  }

  TransferFormModel(
      {required this.asset,
      required this.id,
      required this.amount,
      required this.recipient,
      required this.day,
      required this.month,
      required this.year,
      required this.hour,
      required this.minute,
      required this.formkey,
      required this.isScheduled,
      required this.isInstant,
      required this.am,
      required this.pm,
      required this.vision,
      required this.gasFee,
      required this.omnifyFee,
      required this.totalFee});
}
