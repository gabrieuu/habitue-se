import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_controller.dart';
import 'package:habitue_se/pages/home_page/widgets/calendario_de_registos.dart';
import 'package:habitue_se/shared/temas.dart';
import 'package:habitue_se/shared/widgets/timeline_calendar.dart';

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
          backgroundColor: Temas.backgroundColor,
          body: Column(
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    color: Temas.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.3,
                        blurRadius: 4,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Text(
                          'Calendário',
                          style: TextStyle(
                              color: Temas.blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ),
                      const Gap(20),
                      CalendarioDeRegistros(),
                    ],
                  )))
            ],
          )),
    );
  }
}
