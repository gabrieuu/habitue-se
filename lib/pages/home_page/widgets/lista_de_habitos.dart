import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/pages/home_page/widgets/habito_tile_widget.dart';
import 'package:habitue_se/repository/concrete_habitos_repository.dart';

class ListaDeHabitos extends StatelessWidget {
  ListaDeHabitos({super.key});
  HomeController controller = GetIt.instance<HomeController>();
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              children: List.generate(controller.habitos.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: HabitoTileWidget(
                habito: controller.habitos[index],
              ),
            );
          })),
        );
      },
    );
  }
}
