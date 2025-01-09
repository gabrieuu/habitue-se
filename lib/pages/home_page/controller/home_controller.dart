import 'package:flutter/material.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/models/tarefa.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';
import 'package:habitue_se/repository/abstract_tarefas_repository.dart';
import 'package:habitue_se/shared/status_enum.dart';

class HomeController extends ChangeNotifier {
  List<Habito> habitos = [];
  List<Tarefa> tarefas = [];

  StatusEnum statusTarefasLoading = StatusEnum.EMPTY;
  StatusEnum statusHabitosLoading = StatusEnum.EMPTY;

  AbstractHabitosRepository habitosRepository;
  AbstractTarefasRepository tarefasRepository;
  HomeController(this.habitosRepository, this.tarefasRepository);

  Future<void> getAllHabitos() async {
    try {
      statusHabitosLoading = StatusEnum.LOADING;
      await Future.delayed(const Duration(seconds: 3));
      notifyListeners();
      habitos = await habitosRepository.getHabitos();
      statusHabitosLoading = StatusEnum.SUCESS;
    } catch (e) {
      statusHabitosLoading = StatusEnum.ERROR;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getAllTarefas() async {
    try {
      statusTarefasLoading = StatusEnum.LOADING;
      await Future.delayed(const Duration(seconds: 3));
      notifyListeners();
      tarefas = await tarefasRepository.getTarefas();
      statusTarefasLoading = StatusEnum.SUCESS;
    } catch (e) {
      print(e);
      statusTarefasLoading = StatusEnum.ERROR;
    } finally {
      notifyListeners();
    }
  }

  void completarTarefa(Tarefa tarefa) {
    try {
      tarefa.completado = !tarefa.completado;
      //tarefasRepository.completaTarefa(tarefa);
      notifyListeners();
    } catch (e) {
      tarefa.completado = !tarefa.completado;
    } finally {
      notifyListeners();
    }
  }

  List<RegistradosDoDia> getHabitosDoDia(DateTime day) {
    if (habitos.isEmpty) {
      debugPrint('Habitos vazios');
      return [];
    }
    List<RegistradosDoDia> registradosDoDia = [];

    for (var i = 0; i < habitos.length; i++) {
      for (var j = 0; j < habitos[i].registradosDoDia.length; j++) {
        if (isSameDate(habitos[i].registradosDoDia[j].diaAtual, day)) {
          registradosDoDia.add(habitos[i].registradosDoDia[j]);
        }
      }
    }
    return registradosDoDia;
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  String formatarNumeroDouble(double valor) {
    if (valor % 1 == 0) {
      return valor.toInt().toString();
    }
    return valor.toStringAsFixed(1);
  }

  double getTotalCompletado(List<RegistradosDoDia> registradosDoDia) {
    double totalCompletado = 0;
    int totalObjetivo = 0;

    for (var item in registradosDoDia) {
      totalCompletado += item.completadosHoje;
    }

    for (var item in registradosDoDia) {
      for (var element in habitos) {
        if (item.idHabito == element.id) {
          totalObjetivo += element.objetivoDiario;
        }
      }
    }

    if (totalObjetivo == 0) {
      return 0;
    }

    return totalCompletado;
  }

  double getTotalObjetivo(DateTime date) {
    double totalObjetivo = 0;
    for (var item in habitos) {
      if (date.isAfter(item.dataInicio!)) {
        if (item.dataFim != null && date.isAfter(item.dataFim!)) {
          break;
        }
        totalObjetivo += item.objetivoDiario;
      }
    }
    return totalObjetivo;
  }
}
