import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/pages/home_page/widgets/percente_indicator_widget.dart';
import 'package:habitue_se/repository/concrete_habitos_repository.dart';
import 'package:habitue_se/shared/color_extension.dart';
import 'package:habitue_se/shared/data_utils.dart';
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
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              color: Temas.boxColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: .1,
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              //color: Colors.white,
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
                    ),
                    PopUpMenuWidget(
                      habito: habito,
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
                      percent: controller
                              .getRegistradosByHabitoId(habito.id)
                              .completadosHoje /
                          habito.objetivoDiario,
                      progressColor: habito.hexColor != null
                          ? hexToColor(habito.hexColor!)
                          : Temas.bluePrimary,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${controller.getRegistradosByHabitoId(habito.id).completadosHoje.toPrecision} / ${habito.objetivoDiario.toPrecision}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            if (habito.unidadeDeMedida.isNotEmpty)
                              FittedBox(
                                child: Text(
                                  habito.unidadeDeMedida,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                if (controller.dataSelecionada.isSameDate(DateTime.now()))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            controller.ajustarRegistroHabitoDiario(habito,
                                quantidade: -1);
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: hexToColor(habito.hexColor!),
                              backgroundColor:
                                  hexToColor(habito.hexColor!).withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          icon: const Icon(Icons.remove)),
                      IconButton(
                        onPressed: () {
                          controller.ajustarRegistroHabitoDiario(habito,
                              quantidade: 1);
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: hexToColor(habito.hexColor!),
                            backgroundColor:
                                hexToColor(habito.hexColor!).withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  )
              ],
            ),
          );
        });
  }
}

class PopUpMenuWidget extends StatelessWidget {
  PopUpMenuWidget({super.key, required this.habito});
  HomeController controller = GetIt.instance<HomeController>();
  Habito habito;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Temas.boxColor,
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: (controller.dataSelecionada.isSameDate(DateTime.now()))
                ? () {
                    context.push('/novo-habito', extra: habito);
                  }
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:  Text(
                            'Não é possível editar hábitos de dias anteriores')));
                  },
            child: const Text('Editar'),
          ),
          PopupMenuItem(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Temas.backgroundColor,
                      title: const Text('Excluir'),
                      content: const Text('Deseja excluir este hábito?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              controller.deleteHabito(habito);
                              Navigator.pop(context);
                            },
                            child: const Text('Sim')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Não')),
                      ],
                    );
                  });
            },
            child: const Text('Excluir'),
          ),
        ];
      },
      onSelected: (value) {
        if (value == 'editar') {
          print('editar');
        } else {
          print('excluir');
        }
      },
    );
  }
}

extension DoubleExtension on double {
  String get toPrecision {
    if (this % 1 == 0) {
      return (this).toInt().toString();
    }
    return (this).toStringAsFixed(1);
  }
}
