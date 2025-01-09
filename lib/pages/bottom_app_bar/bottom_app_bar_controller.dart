import 'package:flutter/material.dart';

class BottomAppBarController extends ChangeNotifier {
  int currentIndex = 0;
  PageController pageController = PageController();
  void changePage(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
