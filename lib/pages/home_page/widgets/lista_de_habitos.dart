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
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20),
            scrollDirection: Axis.horizontal,
            itemCount: controller.habitos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: HabitoTileWidget(
                  habito: controller.habitos[index],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
