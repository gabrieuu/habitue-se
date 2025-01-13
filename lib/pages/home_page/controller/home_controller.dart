import 'package:flutter/material.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/models/tarefa.dart';
import 'package:habitue_se/repository/abstract_crud_repository.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';
import 'package:habitue_se/repository/abstract_tarefas_repository.dart';
import 'package:habitue_se/shared/data_utils.dart';
import 'package:habitue_se/shared/status_enum.dart';

class HomeController extends ChangeNotifier {
  List<Habito> habitos = [];
  List<Tarefa> tarefas = [];
  Set<RegistradosDoDia> registradosDoDia = {};

  StatusEnum statusTarefasLoading = StatusEnum.EMPTY;
  StatusEnum statusHabitosLoading = StatusEnum.EMPTY;

  AbstractHabitosRepository habitosRepository;
  AbstractTarefasRepository tarefasRepository;

  HomeController(this.habitosRepository, this.tarefasRepository) {
    init();
  }

  Future<void> init() async {
    getAllHabitos();
    getAllTarefas();
    getAllRegistradosDoDia();
  }

  addNewHabito(Habito newHabito) {
    habitos.add(newHabito);
    notifyListeners();
  }

  addRegistroHabitoDiario(Habito habito, {double? quantidade}) {
    var data = getRegistradosByHabitoId(habito.id);

    registradosDoDia.remove(data);

    if (data.completadosHoje + (quantidade ?? 1) > habito.objetivoDiario) {
      data.completadosHoje = habito.objetivoDiario;
    } else {
      data.completadosHoje += (quantidade ?? 1);
    }

    registradosDoDia.add(data);
    notifyListeners();
  }

  removeRegistroHabitoDiario(Habito habito, {double? quantidade}) {
    var data = getRegistradosByHabitoId(habito.id);

    registradosDoDia.remove(data);

    if (data.completadosHoje - (quantidade ?? 1) < 0) {
      data.completadosHoje = 0;
    } else {
      data.completadosHoje -= (quantidade ?? 1);
    }

    registradosDoDia.add(data);
    notifyListeners();
  }

  Future<void> getAllHabitos() async {
    try {
      statusHabitosLoading = StatusEnum.LOADING;
      await Future.delayed(const Duration(seconds: 3));
      notifyListeners();
      habitos = await habitosRepository.get();
      statusHabitosLoading = StatusEnum.SUCESS;
    } catch (e) {
      statusHabitosLoading = StatusEnum.ERROR;
    } finally {
      notifyListeners();
    }
  }

  List<Habito> getHabitosByData(DateTime date) {
    return habitos
        .where((element) =>
            date.isAfter(element.dataInicio) &&
            (element.dataFim == null || date.isBefore(element.dataFim!)))
        .toList();
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

  Future<void> getAllRegistradosDoDia() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
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

  RegistradosDoDia getRegistradosByHabitoId(int idHabito, {DateTime? day}) {
    var data = getRegistradosDoDiaSelecionado(day ?? DateTime.now())
        .firstWhere((e) => e.idHabito == idHabito, orElse: () {
      return RegistradosDoDia(
          idHabito: idHabito,
          diaAtual: day ??
              DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day));
    });
    return data;
  }

  double getPercentCompletado(DateTime day) {
    double totalCompletado = getTotalCompletado(day);
    double totalObjetivo = getTotalObjetivo(day);
    double percent = totalCompletado / totalObjetivo;
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
      if (date.isAfter(item.dataInicio) || date.isSameDate(item.dataInicio)) {
        if (item.dataFim != null && date.isAfter(item.dataFim!)) {
          continue;
        }
        totalObjetivo += item.objetivoDiario;
      }
    }
    return totalObjetivo;
  }
}
