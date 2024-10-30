import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/carousel_item.dart';
import '../../providers/home_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils.dart';
import 'carousel_widget.dart';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  final CarouselSliderController controller = CarouselSliderController();
  Widget buildCarousel(List<CarouselItem> items, int currentIndex,
      void Function(int) changeIndex, bool autoplay, bool widthQuery, isDark) {
    return Container(
        height: widthQuery ? 350 : 500,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.grey[50],
          // border: Border(
          // bottom: BorderSide(
          //     color: isDark ? Colors.white30 : Colors.grey.shade200)
          // )
        ),
        child: Stack(children: [
          CarouselSlider.builder(
            options: CarouselOptions(
                initialPage: currentIndex,
                pageSnapping: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  changeIndex(index);
                },
                height: widthQuery ? 350 : 450,
                autoPlay: autoplay,
                autoPlayInterval: const Duration(milliseconds: 4000),
                enableInfiniteScroll: true,
                pauseAutoPlayOnManualNavigate: true,
                pauseAutoPlayOnTouch: true,
                pauseAutoPlayInFiniteScroll: false),
            itemCount: items.length,
            itemBuilder: (ctx, ind, index) {
              final currentItem = items[ind];
              return CarouselWidget(currentItem);
            },
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: buildBar(items, currentIndex, isDark))
        ]));
  }

  Widget buildBar(List<CarouselItem> items, int currentIndex, bool isDark) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 30.0,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Spacer(),
          ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: items.map((item) {
                int index = items.indexOf(item);
                return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: currentIndex == index
                            ? Border.all(
                                color: Theme.of(context).colorScheme.secondary)
                            : null,
                        color: currentIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : isDark
                                ? Colors.white70
                                : Colors.grey.shade300));
              }).toList()),
          const Spacer(),
        ])));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final carouselItems = homeProvider.carouselItems;
    final currentIndex = homeProvider.carouselIndex;
    final autoplay = homeProvider.autoplay;
    final setIndex =
        Provider.of<HomeProvider>(context, listen: false).setCarouselIndex;
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final widthQuery = Utils.widthQuery(context);
    return buildCarousel(
        carouselItems, currentIndex, setIndex, autoplay, widthQuery, isDark);
  }
}
