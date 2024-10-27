import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/carousel_item.dart';
import '../../providers/governance_provider.dart';
import '../home/carousel_widget.dart';
import '../../utils.dart';

class GovernanceHeader extends StatefulWidget {
  const GovernanceHeader({super.key});

  @override
  State<GovernanceHeader> createState() => _GovernanceHeaderState();
}

class _GovernanceHeaderState extends State<GovernanceHeader> {
  @override
  Widget build(BuildContext context) {
    final gov = Provider.of<GovernanceProvider>(context);
    final lang = Utils.language(context);
    final widthQuery = Utils.widthQuery(context);
    final item = CarouselItem(
        lang.carTitle6,
        lang.governance0(
            gov.roundInterval.inDays, gov.coinHoldingPeriod.inDays),
        Utils.governUrl);
    return SizedBox(
        height: widthQuery ? 350 : 500,
        width: double.infinity,
        child: CarouselWidget(item));
  }
}
