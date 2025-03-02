import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/pages/home_page/widgets/habito_tile_widget.dart';
import 'package:habitue_se/shared/temas.dart';

class RegistrarComportamentoPage extends StatefulWidget {
  const RegistrarComportamentoPage({super.key, required this.habito});
  final Habito habito;

  @override
  State<RegistrarComportamentoPage> createState() =>
      _RegistrarComportamentoPageState();
}

class _RegistrarComportamentoPageState
    extends State<RegistrarComportamentoPage> {
  late RegistradosDoDia registradosDoDia;
  HomeController controller = GetIt.instance.get<HomeController>();
  Timer? _timer;
  double value = 0;

  @override
  void initState() {
    registradosDoDia = controller.getRegistradosByHabitoId(widget.habito.id,
        day: controller.dataSelecionada);
    value = registradosDoDia.completadosHoje;
    super.initState();
  }

  onLongPressButton(int value) {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (data) {
      changeValue(value);
    });
  }

  onLongPressStop() {
    _timer?.cancel();
  }

  void changeValue(int value) {
    this.value += value;
    if (this.value >= widget.habito.objetivoDiario) {
      this.value = widget.habito.objetivoDiario;
    } else if (this.value < 0) {
      this.value = 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.habito.nome,
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.tabularFigures()]),
          ),
          if (widget.habito.descricao != null &&
              widget.habito.descricao!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Gap(2),
                  Text(widget.habito.descricao!,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFeatures: [FontFeature.tabularFigures()])),
                ],
              ),
            ),
          const Gap(2),
          Text(
            '${value.ceil()} / ${widget.habito.objetivoDiario.toPrecision}',
            style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.tabularFigures()]),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: GestureDetector(
                    onTap: () {
                      changeValue(-1);
                    },
                    onLongPressStart: (details) {
                      onLongPressButton(-1);
                    },
                    onLongPressEnd: (details) {
                      onLongPressStop();
                    },
                    child: Card(
                        color: Temas.primary,
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ))),
              ),
              Expanded(
                child: SliderTheme(
                  data: const SliderThemeData(
                    trackHeight: 25,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
                  ),
                  child: Slider.adaptive(
                      value: value,
                      max: widget.habito.objetivoDiario,
                      min: 0,
                      activeColor: Temas.primary,
                      inactiveColor: Temas.boxColor,
                      allowedInteraction: SliderInteraction.tapAndSlide,
                      onChanged: (value) {
                        setState(() {
                          this.value = value.ceil().toDouble();
                        });
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: GestureDetector(
                    onTap: () {
                      changeValue(1);
                    },
                    onLongPressStart: (data) {
                      onLongPressButton(1);
                    },
                    onLongPressEnd: (data) {
                      onLongPressStop();
                    },
                    onLongPress: () {},
                    child: const Card(
                        color: Colors.white,
                        child: Icon(
                          Icons.add,
                          color: Temas.primary,
                        ))),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              controller.ajustarRegistroHabitoDiario(widget.habito,
                  quantidade: value);
              if (mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromWidth(200),
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('Registrar'),
          )
        ],
      ),
    );
  }
}
