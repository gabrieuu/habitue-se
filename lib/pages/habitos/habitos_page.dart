import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_controller.dart';

class HabitosPage extends StatelessWidget {
  HabitosPage({super.key});

  final BottomAppBarController bottomAppBarController =
      GetIt.instance<BottomAppBarController>();
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
        child: const Center(child: Text('Habitos Page')));
  }
}
