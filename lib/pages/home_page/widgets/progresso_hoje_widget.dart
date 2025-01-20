import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/pages/home_page/percent_color.dart';
import 'package:habitue_se/pages/home_page/widgets/habito_tile_widget.dart';
import 'package:habitue_se/pages/home_page/widgets/percente_indicator_widget.dart';
import 'package:habitue_se/shared/temas.dart';

class ProgressoHojeWidget extends StatelessWidget {
  ProgressoHojeWidget({super.key});

  HomeController controller = GetIt.instance<HomeController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          var percent = controller.getPercentCompletado(DateTime.now());
          return Container(
            height: 60,
            width: MediaQuery.of(context).size.width * .95,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Temas.boxColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progresso hoje:',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600)),
                PercentIndicatorWidget(
                  percent: percent,
                  radius: 25,
                  progressColor: percentColor(percent),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: FittedBox(
                        child: Text('${(percent * 100).toPrecision}%')),
                  ),
                )
              ],
            ),
          );
        });
  }
}
