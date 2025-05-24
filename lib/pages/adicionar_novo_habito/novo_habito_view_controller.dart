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
      objetivo.text = habitoParaEditar!.dailyGoal.toString();
      unidade.text = habitoParaEditar!.unitOfMeasure;
      descricao.text = habitoParaEditar!.description ?? '';
      habitoText.text = habitoParaEditar!.name;
      icone.text = habitoParaEditar!.unicodeEmoji;
      cor = hexToColor(habitoParaEditar!.hexColor);
      dataInicio = habitoParaEditar!.startDate;
      dataFim = habitoParaEditar!.endDate;
      dataFimHabilitada = habitoParaEditar!.endDate != null;
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
      id: 0,
      dailyGoal: double.tryParse(objetivo.text)!,
      unitOfMeasure: unidade.text,
      name: habitoText.text,
      description: descricao.text,
      unicodeEmoji: icone.text,
      hexColor: cor.toHexString(),
      startDate: dataInicio,
      endDate: dataFimHabilitada ? dataFim : null,
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
