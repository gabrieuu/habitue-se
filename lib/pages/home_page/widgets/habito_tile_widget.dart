import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/pages/home_page/percent_color.dart';
import 'package:habitue_se/pages/home_page/widgets/percente_indicator_widget.dart';
import 'package:habitue_se/repository/concrete_habitos_repository.dart';
import 'package:habitue_se/shared/temas.dart';

class HabitoTileWidget extends StatelessWidget {
  HabitoTileWidget({super.key, required this.habito});
  final Habito habito;
  HomeController controller = GetIt.instance<HomeController>();
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              color: Temas.boxColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(2, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        habito.unicodeEmoji,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    const Gap(5),
                    Flexible(
                      child: Text(
                        habito.nome,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: PercentIndicatorWidget(
                      radius: 60,
                      lineWidth: 15,
                      percent: habito.registradosDoDia.firstWhere(
                            (element) => controller.isSameDate(
                                element.diaAtual, DateTime.now()),
                            orElse: () {
                              return RegistradosDoDia(
                                  idHabito: 0,
                                  diaAtual: DateTime.now(),
                                  completadosHoje: 0);
                            },
                          ).completadosHoje /
                          habito.objetivoDiario,
                      progressColor: Temas.purplePrimary,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${controller.formatarNumeroDouble(habito.registradosDoDia.firstWhere(
                                (element) => controller.isSameDate(
                                    element.diaAtual, DateTime.now()),
                                orElse: () {
                                  return RegistradosDoDia(
                                      idHabito: 0,
                                      diaAtual: DateTime.now(),
                                      completadosHoje: 0);
                                },
                              ).completadosHoje)} / ${habito.objetivoDiario}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            FittedBox(
                              child: Text(
                                habito.unidadeDeMedida,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Temas.backgroundColor,
                      backgroundColor: Temas.bluePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: const Text('Registrar'),
                )
              ],
            ),
          );
        });
  }
}
