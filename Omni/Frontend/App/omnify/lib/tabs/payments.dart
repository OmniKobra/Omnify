import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/theme_provider.dart';
import '../utils.dart';
import '../widgets/payments/chooser.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(
          top: 4.0,
          left: 8,
          right: 8,
          bottom: Utils.widthQuery(context) ? 8 : 70),
      child: const Column(children: [Expanded(child: PaymentChooser())]));
}
