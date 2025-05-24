import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_controller.dart';

class DesafiosPage extends StatelessWidget {
   DesafiosPage({super.key});

  final BottomAppBarController bottomAppBarController = GetIt.instance();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        bottomAppBarController.changePage(
            context, bottomAppBarController.previousIndex);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Desafios Page'),),
        body: Center(child: Text('index'),),
      ),
    );
  }
}