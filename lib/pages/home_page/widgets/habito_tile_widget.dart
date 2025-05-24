import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/pages/home_page/pages/registrar_comportamento_page.dart';
import 'package:habitue_se/setup_routes.dart';
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
          RegistradosDoDia registradoDoDia =
              controller.getRegistradosByHabitoId(habito.id);

          return _buildTela2(registradoDoDia, context);
        });
  }

  Widget _buildTela2(RegistradosDoDia registradoDoDia, BuildContext context) {
    return CupertinoButton(
      onPressed: (controller.dataSelecionada.isSameDate(DateTime.now()))
          ? () {
              showModalBottomSheet(
                  context: Routes.rootNavigatorKey.currentContext!,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  builder: (context) {
                    return RegistrarComportamentoPage(habito: habito);
                  });
            }
          : null,
      onLongPress: () {
        _showMenu(context);
      },
      sizeStyle: CupertinoButtonSize.small,
      padding: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
            color: Temas.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: .1,
                blurRadius: 4,
                offset: const Offset(1, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(10)),
        child: IntrinsicHeight(
          child: Row(
            spacing: 20,
            children: [
              Expanded(child: _buildContent(registradoDoDia)),
              _buildIcon(context),
            ],
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(overlay.size.width / 2, overlay.size.height / 2),
        Offset(overlay.size.width / 2, overlay.size.height / 2),
      ),
      Offset.zero & overlay.size,
    );

    final selectedItem = await showMenu(
        context: context,
        position: position,
        color: Temas.backgroundColor,
        surfaceTintColor: Temas.backgroundColor,
        items: [
          PopupMenuItem(
            onTap: (controller.dataSelecionada.isSameDate(DateTime.now()))
                ? () {
                    context.push('/novo-habito', extra: habito);
                  }
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
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
                              controller.deleteHabitoByDate(habito);
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
        ]);

    if (selectedItem != null) {
      print('Opção selecionada: $selectedItem');
    }
  }

  Widget _buildContent(RegistradosDoDia registradoDoDia) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDate(),
        const Gap(2),
        _buildTitle(),
        _buildComportamentosExecutados(registradoDoDia),
      ],
    );
  }

  Widget _buildDate() {
    return Text(
      '${habito.startDate.formatDateString} - ${habito.endDate?.formatDateString ?? 'Indefinido'}',
      style: const TextStyle(color: Temas.blackColor),
    );
  }

  Widget _buildTitle() {
    return Text(
      habito.name,
      style: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 20, color: Temas.blackColor),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildComportamentosExecutados(RegistradosDoDia registradoDoDia) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(2),
        const Text(
          'Habitos Registrados:',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Temas.blackColor),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    backgroundColor: Temas.boxColor,
                    minHeight: 13,
                    color: hexToColor(habito.hexColor!),
                    value:
                        registradoDoDia.completedToday / habito.dailyGoal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Gap(15),
                Text(
                    '${(registradoDoDia.completedToday / habito.dailyGoal) * 100}%'),
              ],
            ),
            RichText(
                text: TextSpan(
                    text:
                        '${registradoDoDia.completedToday.toPrecision} de ${habito.dailyGoal.toPrecision}',
                    style: const TextStyle(fontSize: 15, color: Temas.blackColor, fontWeight: FontWeight.w600),
                    children: const [
                  TextSpan(
                      text: ' no total',
                      style: TextStyle(fontWeight: FontWeight.normal))
                ])),
          ],
        ),
      ],
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Temas.boxColor, borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Text(
        habito.unicodeEmoji,
        style: const TextStyle(fontSize: 35),
      )),
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
