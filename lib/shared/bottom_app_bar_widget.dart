import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_controller.dart';
import 'package:habitue_se/pages/home_page/pages/home_page.dart';
import 'package:habitue_se/shared/temas.dart';

class BottomAppBarWidget extends StatelessWidget {
  BottomAppBarWidget({super.key});

  BottomAppBarController controller = GetIt.instance<BottomAppBarController>();

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
                        showDialog(
                            context: context,
                            barrierColor: Temas.blackColor.withOpacity(0.4),
                            builder: (context) {
                              return Dialog(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Gap(10),
                                    _botao('Nova Tarefa', Temas.bluePrimary,
                                        () {}),
                                    const Gap(10),
                                    _botao('Novo Hábito', Temas.purplePrimary,
                                        () {}),
                                    const Gap(10),
                                  ],
                                ),
                              );
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
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.changePage,
        children: [
          const HomePage(),
          Container(),
          Container(),
          Container(),
        ],
      ),
    );
  }

  Widget _botao(String text, Color cor, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(15),
        backgroundColor: cor,
        foregroundColor: Temas.blackColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(text), const Icon(Icons.arrow_forward)],
      ),
    );
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
          onTap: () {
            controller.changePage(index);
            controller.pageController.jumpToPage(index);
          },
          child: FittedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: controller.currentIndex == index
                      ? Temas.blackColor
                      : Temas.greyPrimary,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: controller.currentIndex == index
                        ? Temas.blackColor
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
