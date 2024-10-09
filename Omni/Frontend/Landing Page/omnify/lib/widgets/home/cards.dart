// ignore_for_file: use_key_in_widget_constructors

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../../models/swiper_item.dart';
import '../../my_flutter_app_icons.dart';
import '../../utils.dart';
import 'swiper_card.dart';

class Cards extends StatefulWidget {
  const Cards();

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  final controller = SwiperController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthQuery = Utils.widthQuery(context);
    final deviceWidth = widthQuery
        ? MediaQuery.of(context).size.width - 40
        : MediaQuery.of(context).size.width - 16;
    final lang = Utils.language(context);
    final List<String> transferDescription = [
      lang.transferCard1,
      lang.transferCard2,
      lang.transferCard3,
      lang.transferCard4,
      lang.transferCard5
    ];
    final List<String> paymentDescription = [
      lang.payCard1,
      lang.payCard2,
      lang.payCard3,
      lang.payCard4,
      lang.payCard5,
      lang.payCard6
    ];
    final List<String> trustDescription = [
      lang.trustCard1,
      lang.trustCard2,
      lang.trustCard3,
      lang.trustCard4,
      lang.trustCard5
    ];
    final List<String> bridgeDescription = [
      lang.bridgeCard1,
      lang.bridgeCard2,
      lang.bridgeCard3,
      lang.bridgeCard4,
      lang.bridgeCard5
    ];
    final List<String> escrowDescription = [
      lang.escrowCard1,
      lang.escrowCard2,
      lang.escrowCard3,
      lang.escrowCard4,
      lang.escrowCard5
    ];
    final List<String> refuelDescription = [lang.refuelCard1, lang.refuelCard2];
    final List<SwiperItem> cards = [
      //transfers
      SwiperItem(
          lang.fees1, transferDescription, Colors.red, MyFlutterApp.transfer),
      //refuel
      SwiperItem(
          lang.fees36, refuelDescription, Colors.cyan, Icons.local_gas_station),
      //escrow
      SwiperItem(lang.fees5, escrowDescription, Colors.pink, MyFlutterApp.hand),
      //bridge
      SwiperItem(lang.fees4, bridgeDescription, Colors.yellowAccent.shade700,
          MyFlutterApp.jigsaw),
      //trust
      SwiperItem(
          lang.fees3, trustDescription, Colors.orange, MyFlutterApp.safe),
      //payments
      SwiperItem(
          lang.fees2, paymentDescription, Colors.purple, MyFlutterApp.infinity),
    ];
    return Container(
      height: 650,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widthQuery)
            IconButton(
                onPressed: () {
                  controller.next();
                },
                icon: Icon(Icons.arrow_back_ios, size: widthQuery ? 33 : null)),
          Expanded(
              child: Swiper(
                  layout: SwiperLayout.TINDER,
                  itemWidth: deviceWidth,
                  itemHeight: 650,
                  itemCount: 6,
                  controller: controller,
                  itemBuilder: (_, i) {
                    return SwiperCard(
                        item: cards[i],
                        nextHandler: () => controller.next(),
                        previousHandler: () => controller.previous());
                  },
                  loop: true)),
          if (widthQuery)
            IconButton(
                onPressed: () {
                  controller.previous();
                },
                icon:
                    Icon(Icons.arrow_forward_ios, size: widthQuery ? 33 : null))
        ],
      ),
    );
  }
}
