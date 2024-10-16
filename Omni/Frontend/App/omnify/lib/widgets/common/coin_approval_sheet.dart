import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';

class CoinApprovalSheet extends StatefulWidget {
  final Map<String, Decimal> approvals;
  const CoinApprovalSheet({super.key, required this.approvals});

  @override
  State<CoinApprovalSheet> createState() => _CoinApprovalSheetState();
}

class _CoinApprovalSheetState extends State<CoinApprovalSheet> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
