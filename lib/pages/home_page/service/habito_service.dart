import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/preferences/shared_prefs.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';
import 'package:habitue_se/services/notification_service.dart';
import 'package:habitue_se/shared/data_utils.dart';
import 'package:habitue_se/shared/notification_events.dart';

class HabitoService {
  HabitoService({required this.habitoRepository});

  final AbstractHabitosRepository habitoRepository;

  Future<List<Habito>> getHabitos() async {
    List<Habito> habitos = await habitoRepository.get();
    for (var habito in habitos) {
      if (!await SharedPrefs.containsKey(habito.id)) {
        await _saveIdsNotificacoesInSharedPrefs(habito);
      }
      var data = SharedPrefs.getString(habito.id);
    }
    return habitos;
  }

  Future<void> add(Habito habito) async {
    GetIt.instance<EventBus>().fire(NotificationEventHabitoCriado(habito));
    _saveIdsNotificacoesInSharedPrefs(habito);
    await habitoRepository.add(habito);
  }

  Future<void> _saveIdsNotificacoesInSharedPrefs(Habito habito) async {
    List<int> idsNotificacoes = [];
    print('teste');
    for (var time in habito.habitoNotification.horariosVariados) {
      idsNotificacoes.add(GetIt.instance<NotificationService>()
          .generateNotificationId(habito.id, time: time));
    }
    if (idsNotificacoes.isNotEmpty) {
      if (await SharedPrefs.containsKey(habito.id)) {
        var data = jsonDecode(SharedPrefs.getString(habito.id)) as List;

        for (var id in data) {
          if (!idsNotificacoes.contains(id)) {
            idsNotificacoes.add(id);
          }
        }
      }
      await SharedPrefs.setString(habito.id, jsonEncode(idsNotificacoes));
    }
  }

  deleteByDate(Habito habito, DateTime date) async {
    GetIt.instance<EventBus>().fire(NotificationEventHabitoApagado(habito));
    await habitoRepository.deleteByDate(habito.id, date);
  }

  delete(Habito habito) async {
    GetIt.instance<EventBus>().fire(NotificationEventHabitoApagado(habito));
    await habitoRepository.delete(habito.id);
  }

  Future<void> addRegistradosDoDia(RegistradosDoDia registradosDoDia) async {
    await habitoRepository.addRegistradosDoDia(registradosDoDia);
  }

  Future<List<RegistradosDoDia>> getRegistradosDoDia() async {
    return await habitoRepository.getRegistradosDoDia();
  }

  List<Habito> getHabitosByData(DateTime date, List<Habito> habitos) {
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

  double getTotalObjetivo(DateTime date, List<Habito> habitos) {
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

  List<RegistradosDoDia> getRegistradosDoDiaSelecionado(
      DateTime day, List<RegistradosDoDia> registradosDoDia) {
    return registradosDoDia
        .where((element) => element.diaAtual.isSameDate(day))
        .toList();
  }

  double getTotalCompletado(
      DateTime day, List<RegistradosDoDia> registradosDoDiaGeral) {
    double totalCompletado = 0;
    List<RegistradosDoDia> registradosDoDia =
        getRegistradosDoDiaSelecionado(day, registradosDoDiaGeral);
    if (registradosDoDia.isEmpty) {
      return 0;
    }
    for (var item in registradosDoDia) {
      totalCompletado += item.completadosHoje;
    }
    return totalCompletado;
  }
}
