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
        var habitos = controller.getHabitosByData(controller.dataSelecionada);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
              direction: Axis.horizontal,
              children: List.generate(habitos.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: (index == 0) ? 20 : 10,
                      right: 10,
                      top: 5,
                      bottom: 5),
                  child: HabitoTileWidget(
                    habito: habitos[index],
                  ),
                );
              })),
        );
      },
    );
  }
}
