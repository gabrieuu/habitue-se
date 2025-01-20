import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_controller.dart';
import 'package:habitue_se/pages/home_page/pages/home_page.dart';
import 'package:habitue_se/shared/temas.dart';
import 'package:habitue_se/shared/widgets/modal_bottom_habitos.dart';

class BottomAppBarWidget extends StatefulWidget {
  BottomAppBarWidget({super.key, required this.child});
  Widget child;

  @override
  State<BottomAppBarWidget> createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  BottomAppBarController controller = GetIt.instance<BottomAppBarController>();

  // void changeTab(int index) {
  //   switch (index) {
  //     case 0:
  //       context.go('/home');
  //       break;
  //     case 1:
  //       context.push('/calendario');
  //       break;
  //     case 2:
  //       context.push('/tarefas');
  //       break;
  //     case 3:
  //       context.push('/habitos');
  //       break;
  //     default:
  //       context.go('/home');
  //       break;
  //   }
  //   controller.changePage(index);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.9,
          child: Stack(
            children: [
              Container(
                height: 90,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          spreadRadius: 0.4,
                          offset: const Offset(1, -1))
                    ],
                    color: Temas.backgroundColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _item(
                      index: 0,
                      icon: Icons.home,
                      text: 'Inicio',
                    ),
                    _item(
                      index: 1,
                      icon: Icons.calendar_month_outlined,
                      text: 'Calendario',
                    ),
                    FloatingActionButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              elevation: 2,
                              backgroundColor: Temas.backgroundColor,
                              barrierColor: Temas.blackColor.withOpacity(0.5),
                              builder: (context) {
                                return const ModalBottomHabitos();
                              });
                        },
                        child: const Icon(Icons.add)),
                    _item(
                      index: 2,
                      icon: Icons.widgets_outlined,
                      text: 'Tarefas',
                    ),
                    _item(
                      index: 3,
                      icon: Icons.coffee_outlined,
                      text: 'Hábitos',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: widget.child);
  }

  _item({
    required int index,
    required IconData icon,
    required String text,
  }) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: (controller.currentIndex != index)
              ? () {
                  controller.changePage(context, index);
                }
              : null,
          child: FittedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: controller.currentIndex == index
                      ? Temas.primary
                      : Temas.greyPrimary,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: controller.currentIndex == index
                        ? Temas.primary
                        : Temas.greyPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
