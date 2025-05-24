import 'package:flutter/material.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/models/response/habitos_registrados_percents.dart';
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
    // // var data = getRegistradosByHabitoId(
    // //   habito.id,
    // // );

    // var comopletados = data.completadosHoje + quantidade;
    // if (comopletados > habito.objetivoDiario) {
    //   return;
    // } else if (comopletados < 0) {
    //   return;
    // }

    // registradosDoDia.remove(data);
    // data.completadosHoje += quantidade;
    // registradosDoDia.add(data);
    // notifyListeners();

    // try {
    //   await habitoService.addRegistradosDoDia(data);
    // } catch (e) {
    //   registradosDoDia.remove(data);
    //   data.completadosHoje -= quantidade;
    //   registradosDoDia.add(data);
    //   notifyListeners();
    // }
  }

  Future<void> getAllHabitos({DateTime? date}) async {
    try {
      statusHabitosLoading = StatusEnum.LOADING;
      notifyListeners();
      habitos = await habitoService.getHabitos(date ?? dataSelecionada);
      statusHabitosLoading = StatusEnum.SUCESS;
      notifyListeners();
    } catch (e) {
      statusHabitosLoading = StatusEnum.ERROR;
    } finally {
      notifyListeners();
    }
  }

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

  RegistradosDoDia getRegistradosByHabitoId(int habitoId){
    RegistradosDoDia a = registradosDoDia.firstWhere((e) => e.habitId == habitoId, orElse: () {
      return RegistradosDoDia(id: 0, habitId: habitoId, actualDay: dataSelecionada, completedToday: 0);
    },);

    return a;
  }

  Future<void> getAllRegistradosDoDia({DateTime? date}) async {
    try {
      List<RegistradosDoDia> registradosDoDia =
          await habitoService.getRegistradosDoDia(1, dataSelecionada);
      this.registradosDoDia = registradosDoDia.toSet();
    } finally {
      notifyListeners();
    }
  }

  Future<List<HabitosRegistradosPercents>> getRegistradosByMonth() async{
    return habitoService.getPercentsByMonth(DateTime(DateTime.now().year, DateTime.now().month, 1), DateTime(DateTime.now().year, DateTime.now().month + 1, 0));
  }

}
