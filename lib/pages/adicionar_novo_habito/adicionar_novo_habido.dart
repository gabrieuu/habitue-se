import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:habitue_se/pages/adicionar_novo_habito/novo_habito_view_controller.dart';
import 'package:habitue_se/shared/status_enum.dart';
import 'package:habitue_se/shared/temas.dart';
import 'package:habitue_se/shared/widgets/emoji_picker.dart';

class AdicionarNovoHabido extends StatefulWidget {
  AdicionarNovoHabido({super.key});

  @override
  State<AdicionarNovoHabido> createState() => _AdicionarNovoHabidoState();
}

class _AdicionarNovoHabidoState extends State<AdicionarNovoHabido> {
  late final NovoHabitoViewController controller;

  @override
  void initState() {
    super.initState();
    controller = NovoHabitoViewController();
  }

  final double radiusBoxes = 10;

  final double fontTitleSize = 15;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Temas.backgroundColor,
        appBar: AppBar(
          title: const Text('Novo Habito'),
          forceMaterialTransparency: true,
          toolbarHeight: 80,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    _buildIconeEColor(context),
                    const Gap(10),
                    _buildTitle(),
                    const Gap(10),
                    _buildQuantidade(),
                    const Gap(10),
                    _buildDateInicio(title: 'Data de Inicio'),
                    const Gap(10),
                    _buildDataFim(),
                    const Gap(10),
                    _buildDescricao(),
                    const Gap(20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.createNewHabit();
                            if (controller.statusNovoHabitoAdicionado ==
                                    StatusEnum.SUCESS &&
                                mounted) {
                              context.go('/home');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Temas.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(radiusBoxes))),
                          child: (controller.statusNovoHabitoAdicionado ==
                                  StatusEnum.LOADING)
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Adicionar Habito',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Temas.backgroundColor,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuantidade() {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Objetivo'),
            Container(
              decoration: BoxDecoration(
                  color: Temas.boxColor,
                  borderRadius: BorderRadius.circular(radiusBoxes)),
              child: TextFormField(
                controller: controller.objetivo,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'ex: 10',
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    labelStyle: TextStyle(fontSize: fontTitleSize),
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide.none)),
              ),
            ),
          ],
        )),
        const Gap(20),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Unidade (Opcional)'),
            Container(
              decoration: BoxDecoration(
                  color: Temas.boxColor,
                  borderRadius: BorderRadius.circular(radiusBoxes)),
              child: TextFormField(
                controller: controller.unidade,
                decoration: InputDecoration(
                    hintText: 'ex: Km',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    labelStyle: TextStyle(fontSize: fontTitleSize),
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide.none)),
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildDataFim() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Temas.primary,
                ),
                const Gap(5),
                Text(
                  'Data Fim',
                  style: TextStyle(
                    fontSize: fontTitleSize,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            Switch(
                value: controller.dataFimHabilitada,
                activeColor: Temas.primary,
                inactiveTrackColor: Temas.boxColor,
                onChanged: controller.toggleDataFimHabilitada),
          ],
        ),
        if (controller.dataFimHabilitada)
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Selecione a Data Fim: '),
                _buildDataSelector(
                    date: controller.formatData(controller.dataFim ??
                        DateTime.now().add(const Duration(days: 60))),
                    setData: controller.setDataFim),
              ],
            ),
          )
      ],
    );
  }

  Widget _buildDateInicio({
    required String title,
  }) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: Temas.primary,
              ),
              const Gap(5),
              Text(
                title,
                style: TextStyle(
                  fontSize: fontTitleSize,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          _buildDataSelector(
              date: controller.formatData(controller.dataInicio),
              setData: controller.setDataInicio)
        ],
      ),
    );
  }

  Widget _buildDataSelector(
      {required String date, void Function(DateTime data)? setData}) {
    return GestureDetector(
      onTap: () async {
        DateTime? data = await showDialog<DateTime>(
          context: context,
          builder: (context) {
            return DatePickerDialog(
              initialEntryMode: DatePickerEntryMode.calendar,
              initialCalendarMode: DatePickerMode.day,
              initialDate: controller.dataInicio,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime(2100, 01, 0),
            );
          },
        );

        if (data != null) {
          setData?.call(data);
        }
        return;
      },
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
            color: Temas.secondary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(radiusBoxes)),
        child: Center(
            child: Text(
          date,
          style: const TextStyle(
            color: Temas.blackColor,
          ),
        )),
      ),
    );
  }

  Widget _buildDescricao() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Temas.boxColor,
          borderRadius: BorderRadius.circular(radiusBoxes)),
      child: TextFormField(
        controller: controller.descricao,
        minLines: 1,
        maxLines: 100,
        decoration: InputDecoration(
            labelText: 'Descrição (Opcional)',
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
            labelStyle: TextStyle(fontSize: fontTitleSize),
            border: const UnderlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Temas.boxColor,
          borderRadius: BorderRadius.circular(radiusBoxes)),
      child: TextFormField(
        controller: controller.habitoText,
        decoration: InputDecoration(
            labelText: 'Habito',
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            labelStyle: TextStyle(fontSize: fontTitleSize),
            border: const UnderlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _buildIconeEColor(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              emojiSelector(
                  context: context, textEditingController: controller.icone);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Temas.boxColor,
                  borderRadius: BorderRadius.circular(radiusBoxes)),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Icone',
                      style: TextStyle(fontSize: fontTitleSize),
                    ),
                    ListenableBuilder(
                        listenable: controller.icone,
                        builder: (context, __) {
                          return SizedBox(
                              width: 30,
                              child: Text(
                                controller.icone.text,
                                style: const TextStyle(fontSize: 25),
                              ));
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(20),
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Pick a color!'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: controller.cor,
                        onColorChanged: (value) {
                          controller.changeColor(value);
                          context.pop();
                        },
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Temas.boxColor,
                  borderRadius: BorderRadius.circular(radiusBoxes)),
              child: SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cor',
                      style: TextStyle(fontSize: fontTitleSize),
                    ),
                    const Gap(10),
                    Container(
                      width: 30,
                      decoration: BoxDecoration(
                          color: controller.cor,
                          borderRadius: BorderRadius.circular(10)),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
