import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomAppBarController extends ChangeNotifier {
  int currentIndex = 0;
  int previousIndex = 0;

  PageController pageController = PageController();
  void changePage(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.push('/calendario');
        break;
      case 2:
        context.push('/tarefas');
        break;
      case 3:
        context.push('/habitos');
        break;
      default:
        context.go('/home');
        break;
    }
    previousIndex = currentIndex;
    currentIndex = index;
    notifyListeners();
  }
}
