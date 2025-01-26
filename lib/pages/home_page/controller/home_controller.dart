import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/models/custom_notification.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/models/tarefa.dart';
import 'package:habitue_se/repository/abstract_crud_repository.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';
import 'package:habitue_se/repository/abstract_tarefas_repository.dart';
import 'package:habitue_se/services/notification_service.dart';
import 'package:habitue_se/shared/data_utils.dart';
import 'package:habitue_se/shared/status_enum.dart';
import 'package:uuid/uuid.dart';

class HomeController extends ChangeNotifier {
  List<Habito> habitos = [];
  List<Tarefa> tarefas = [];
  Set<RegistradosDoDia> registrosCalendario = {};
  Set<RegistradosDoDia> registradosDoDia = {};

  DateTime dataSelecionada = DateTime.now();

  StatusEnum statusTarefasLoading = StatusEnum.NONE;
  StatusEnum statusHabitosLoading = StatusEnum.NONE;

  AbstractHabitosRepository habitosRepository;
  AbstractTarefasRepository tarefasRepository;

  HomeController(this.habitosRepository, this.tarefasRepository) {
    init();
  }

  Future<void> init() async {
    await getAllHabitos();
    await getAllRegistradosDoDia();
    await getAllTarefas();
  }

  addNewHabito(Habito newHabito) async {
    if (habitos.contains(newHabito)) {
      var index = habitos.indexWhere((element) => element.id == newHabito.id);
      habitos[index] = newHabito;
    } else {
      habitos.add(newHabito);
    }

    notifyListeners();
    try {
      await habitosRepository.add(newHabito);
      GetIt.instance<NotificationService>().addNotificationForHabit(newHabito);
    } catch (e) {
      habitos.remove(newHabito);
      notifyListeners();
    }
  }

  deleteHabito(Habito habito) async {
    var index = habitos.indexWhere((element) => element.id == habito.id);
    habitos.remove(habito);
    notifyListeners();
    try {
      await habitosRepository.delete(habito.id);
      GetIt.instance<NotificationService>().cancelNotificationForHabit(habito);
    } catch (e) {
      habitos.insert(index, habito);
      notifyListeners();
    }
  }

  Future<void> ajustarRegistroHabitoDiario(Habito habito,
      {required double quantidade}) async {
    var data = getRegistradosByHabitoId(
      habito.id,
    );

    var comopletados = data.completadosHoje + quantidade;
    if (comopletados > habito.objetivoDiario) {
      return;
    } else if (comopletados < 0) {
      return;
    }

    registradosDoDia.remove(data);
    data.completadosHoje += quantidade;
    registradosDoDia.add(data);
    notifyListeners();

    try {
      await habitosRepository.addRegistradosDoDia(data);
    } catch (e) {
      registradosDoDia.remove(data);
      data.completadosHoje -= quantidade;
      registradosDoDia.add(data);
      notifyListeners();
    }
  }

  Future<void> getAllHabitos() async {
    try {
      statusHabitosLoading = StatusEnum.LOADING;
      notifyListeners();
      habitos = await habitosRepository.get();
      await GetIt.instance<NotificationService>()
          .sheduleNotificationForListHabits(getHabitosByData(DateTime.now()));
      log('sucessp');
      statusHabitosLoading = StatusEnum.SUCESS;
      notifyListeners();
    } catch (e) {
      statusHabitosLoading = StatusEnum.ERROR;
    } finally {
      notifyListeners();
    }
  }

  List<Habito> getHabitosByData(DateTime date) {
    if (habitos.isEmpty) {
      return [];
    }
    var list = habitos
        .where((element) =>
            isDateWithinRange(date, element.dataInicio, element.dataFim))
        .toList();
    return list;
  }

  bool isDateWithinRange(DateTime date, DateTime startDate, DateTime? endDate) {
    if (endDate == null) {
      return date.isAfter(startDate) ||
          date.toFullYear().isAtSameMomentAs(startDate.toFullYear());
    }

    return (date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
        (date.isBefore(endDate) || date.isAtSameMomentAs(endDate));
  }

  Future<void> getAllTarefas() async {
    try {
      statusTarefasLoading = StatusEnum.LOADING;
      await Future.delayed(const Duration(seconds: 3));
      notifyListeners();
      tarefas = await tarefasRepository.getTarefas();
      statusTarefasLoading = StatusEnum.SUCESS;
    } catch (e) {
      statusTarefasLoading = StatusEnum.ERROR;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getAllRegistradosDoDia({DateTime? date}) async {
    try {
      List<RegistradosDoDia> registradosDoDia =
          await habitosRepository.getRegistradosDoDia();
      this.registradosDoDia = registradosDoDia.toSet();
    } finally {
      notifyListeners();
    }
  }

  void completarTarefa(Tarefa tarefa) {
    try {
      tarefa.completado = !tarefa.completado;
      //tarefasRepository.completaTarefa(tarefa);
      notifyListeners();
    } finally {
      notifyListeners();
    }
  }

  List<RegistradosDoDia> getRegistradosDoDiaSelecionado(DateTime day) {
    if (habitos.isEmpty) {
      return [];
    }

    return registradosDoDia
        .where((element) => element.diaAtual.isSameDate(day))
        .toList();
  }

  RegistradosDoDia getRegistradosByHabitoId(String idHabito, {DateTime? day}) {
    var data = getRegistradosDoDiaSelecionado(day ?? DateTime.now())
        .firstWhere((e) => e.idHabito == idHabito, orElse: () {
      return RegistradosDoDia(
          idHabito: idHabito, diaAtual: day ?? DateTime.now().toFullYear());
    });
    return data;
  }

  double getPercentCompletado(DateTime day) {
    double totalCompletado = getTotalCompletado(day);
    double totalObjetivo = getTotalObjetivo(day);
    double percent = totalCompletado / totalObjetivo;

    if (totalObjetivo == 0) {
      return 0.0;
    }

    return percent;
  }

  double getTotalCompletado(DateTime day) {
    double totalCompletado = 0;
    List<RegistradosDoDia> registradosDoDia =
        getRegistradosDoDiaSelecionado(day);
    if (registradosDoDia.isEmpty) {
      return 0;
    }
    for (var item in registradosDoDia) {
      totalCompletado += item.completadosHoje;
    }
    return totalCompletado;
  }

  double getTotalObjetivo(DateTime date) {
    double totalObjetivo = 0;
    for (var item in habitos) {
      if (date.toFullYear().isAfter(item.dataInicio.toFullYear()) ||
          date.toFullYear().isSameDate(item.dataInicio.toFullYear())) {
        if (item.dataFim != null &&
            (date.toFullYear().isAfter(item.dataFim!.toFullYear()) ||
                date.toFullYear().isSameDate(item.dataFim!.toFullYear()))) {
          continue;
        }
        totalObjetivo += item.objetivoDiario;
      }
    }
    return totalObjetivo;
  }
}
