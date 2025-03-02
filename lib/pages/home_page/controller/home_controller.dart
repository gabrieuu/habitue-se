import 'package:flutter/material.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/models/tarefa.dart';
import 'package:habitue_se/pages/home_page/service/habito_service.dart';
import 'package:habitue_se/shared/data_utils.dart';
import 'package:habitue_se/shared/status_enum.dart';

class HomeController extends ChangeNotifier {
  List<Habito> habitos = [];
  List<Tarefa> tarefas = [];
  Set<RegistradosDoDia> registrosCalendario = {};
  Set<RegistradosDoDia> registradosDoDia = {};

  HabitoService habitoService;

  DateTime dataSelecionada = DateTime.now();

  StatusEnum statusTarefasLoading = StatusEnum.NONE;
  StatusEnum statusHabitosLoading = StatusEnum.NONE;

  HomeController(this.habitoService);

  Future<void> init() async {
    await getAllHabitos();
    await getAllRegistradosDoDia();
    // await getAllTarefas();
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
      await habitoService.add(newHabito);
    } catch (e) {
      habitos.remove(newHabito);
      notifyListeners();
    }
  }

  deleteHabitoByDate(Habito habito, {DateTime? date}) async {
    var index = habitos.indexWhere((element) => element.id == habito.id);
    habitos.remove(habito);
    notifyListeners();
    try {
      (date != null)
          ? await habitoService.deleteByDate(habito, date)
          : await habitoService.delete(habito);
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
      await habitoService.addRegistradosDoDia(data);
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
      habitos = await habitoService.getHabitos();
      habitos.sort((a, b) => a.id.compareTo(b.id));
      statusHabitosLoading = StatusEnum.SUCESS;
      notifyListeners();
    } catch (e) {
      statusHabitosLoading = StatusEnum.ERROR;
    } finally {
      notifyListeners();
    }
  }

  List<Habito> getHabitosByData(DateTime date) =>
      habitoService.getHabitosByData(date, habitos);

  // Future<void> getAllTarefas() async {
  //   try {
  //     statusTarefasLoading = StatusEnum.LOADING;
  //     await Future.delayed(const Duration(seconds: 3));
  //     notifyListeners();
  //     tarefas = await tarefasRepository.getTarefas();
  //     statusTarefasLoading = StatusEnum.SUCESS;
  //   } catch (e) {
  //     statusTarefasLoading = StatusEnum.ERROR;
  //   } finally {
  //     notifyListeners();
  //   }
  // }

  Future<void> getAllRegistradosDoDia({DateTime? date}) async {
    try {
      List<RegistradosDoDia> registradosDoDia =
          await habitoService.getRegistradosDoDia();
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

    return habitoService.getRegistradosDoDiaSelecionado(
        day, registradosDoDia.toList());
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

  double getTotalCompletado(DateTime day) =>
      habitoService.getTotalCompletado(day, registradosDoDia.toList());

  double getTotalObjetivo(DateTime date) =>
      habitoService.getTotalObjetivo(date, habitos);
}
