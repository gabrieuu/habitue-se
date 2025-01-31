import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    widget.habito.objetivoDiario = 100;
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
                      label: '$value',
                      divisions: widget.habito.objetivoDiario.toInt(),
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
          ElevatedButton(onPressed: () {}, child: const Text('Registrar'))
        ],
      ),
    );
  }
}
