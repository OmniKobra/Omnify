import 'package:flutter/material.dart';

import '../models/carousel_item.dart';

enum TabView { home, explorer, governance, fees, coins }

class HomeProvider extends ChangeNotifier {
  TabView _currentView = TabView.home;
  List<CarouselItem> _carouselItems = [];
  int _carouselIndex = 0;
  final bool _autoplay = true;
  TabView get currentView => _currentView;
  int get carouselIndex => _carouselIndex;
  List<CarouselItem> get carouselItems => _carouselItems;
  bool get autoplay => _autoplay;

  void setCarouselItems(List<CarouselItem> i) {
    _carouselItems = i;
    notifyListeners();
  }

  void setCarouselIndex(int ind) {
    if (_carouselIndex != ind) {
      _carouselIndex = ind;
    }
    notifyListeners();
  }

  void setCurrentView(TabView v, [bool? doNotNotify]) {
    if (currentView != v) {
      _currentView = v;
      if (doNotNotify == null) {
        notifyListeners();
      }
    }
  }
}
