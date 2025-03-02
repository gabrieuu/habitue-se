import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/habito_notification.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/shared/color_extension.dart';
import 'package:habitue_se/shared/data_utils.dart';
import 'package:habitue_se/shared/dia_da_semana.dart';
import 'package:habitue_se/shared/status_enum.dart';
import 'package:habitue_se/shared/temas.dart';
import 'package:uuid/uuid.dart';

class NovoHabitoViewController extends ChangeNotifier {
  TextEditingController objetivo = TextEditingController();
  TextEditingController unidade = TextEditingController();
  TextEditingController descricao = TextEditingController();
  TextEditingController habitoText = TextEditingController();
  TextEditingController icone = TextEditingController(text: '📝');
  TextEditingController horarioDoHabito = TextEditingController();
  Color cor = Temas.primary;
  DateTime dataInicio = DateTime.now();
  DateTime? dataFim;
  bool dataFimHabilitada = false;
  StatusEnum statusNovoHabitoAdicionado = StatusEnum.EMPTY;

  Habito? habitoParaEditar;

  HomeController homeController = GetIt.instance<HomeController>();

  final List<int> days = diasSemana.keys.toList();
  List<int> selectedDays = [1, 2, 3, 4, 5, 6, 7];
  List<TimeOfdayHabitos> selectedTime = [
    TimeOfdayHabitos(hour: 8, minute: 0),
    TimeOfdayHabitos(hour: 12, minute: 0),
    TimeOfdayHabitos(hour: 18, minute: 0),
  ];

  NovoHabitoViewController({this.habitoParaEditar}) {
    if (habitoParaEditar != null) {
      objetivo.text = habitoParaEditar!.objetivoDiario.toString();
      unidade.text = habitoParaEditar!.unidadeDeMedida;
      descricao.text = habitoParaEditar!.descricao ?? '';
      habitoText.text = habitoParaEditar!.nome;
      icone.text = habitoParaEditar!.unicodeEmoji;
      cor = habitoParaEditar!.hexColor != null
          ? hexToColor(habitoParaEditar!.hexColor!)
          : cor;
      dataInicio = habitoParaEditar!.dataInicio;
      dataFim = habitoParaEditar!.dataFim;
      dataFimHabilitada = habitoParaEditar!.dataFim != null;
      selectedTime = habitoParaEditar!.habitoNotification.horariosVariados;
      selectedDays = habitoParaEditar!.habitoNotification.daysOfWeek;
      notifyListeners();
    }
  }

  void setHorarios(List<TimeOfdayHabitos> time, List<int> days) {
    selectedTime = time;
    selectedDays = days;
    notifyListeners();
  }

  Future<void> createNewHabit() async {
    if (double.tryParse(objetivo.text) == null) {
      statusNovoHabitoAdicionado = StatusEnum.ERROR;
      notifyListeners();
      return;
    }

    statusNovoHabitoAdicionado = StatusEnum.LOADING;

    notifyListeners();

    Habito habito = Habito(
      id: habitoParaEditar != null ? habitoParaEditar!.id : const Uuid().v1(),
      objetivoDiario: double.tryParse(objetivo.text)!,
      unidadeDeMedida: unidade.text,
      nome: habitoText.text,
      descricao: descricao.text,
      unicodeEmoji: icone.text,
      hexColor: cor.toHexString(),
      dataInicio: dataInicio,
      dataFim: dataFimHabilitada ? dataFim : null,
      habitoNotification: HabitoNotification(
        daysOfWeek: selectedDays,
        horariosVariados: selectedTime,
      ),
    );

    homeController.addNewHabito(habito);

    statusNovoHabitoAdicionado = StatusEnum.SUCESS;
    notifyListeners();
  }

  void setDataInicio(DateTime date) {
    dataInicio = date;
    notifyListeners();
  }

  void setDataFim(DateTime date) {
    dataFim = date;
    notifyListeners();
  }

  void changeColor(Color color) {
    cor = color;
    notifyListeners();
  }

  String formatData(DateTime date) {
    if (date.isSameDate(DateTime.now())) {
      return 'Hoje';
    }
    return date.toString().split(' ')[0].split('-').reversed.toList().join('/');
  }

  void toggleDataFimHabilitada(bool value) {
    dataFimHabilitada = value;
    notifyListeners();
  }
}
