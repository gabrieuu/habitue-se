import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_controller.dart';

class CalendarioPage extends StatelessWidget {
  CalendarioPage({super.key});

  BottomAppBarController bottomAppBarController =
      GetIt.instance<BottomAppBarController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        bottomAppBarController.changePage(
            context, bottomAppBarController.previousIndex);
      },
      child: Scaffold(
          appBar: AppBar(), body: Center(child: Text('Calendario Page'))),
    );
  }
}
