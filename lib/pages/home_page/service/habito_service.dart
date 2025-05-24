import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/models/response/habitos_registrados_percents.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';
import 'package:habitue_se/shared/data_utils.dart';
import 'package:habitue_se/shared/notification_events.dart';

class HabitoService {
  HabitoService({required this.habitoRepository});

  final AbstractHabitosRepository habitoRepository;

  Future<List<Habito>> getHabitos(DateTime date) async {
    List<Habito> habitos = await habitoRepository.get(data: date);
    return habitos;
  }

  Future<void> add(Habito habito) async {
    GetIt.instance<EventBus>().fire(NotificationEventHabitoCriado(habito));
    await habitoRepository.add(habito);
  }

  deleteByDate(Habito habito, DateTime date) async {
    GetIt.instance<EventBus>().fire(NotificationEventHabitoApagado(habito));
    await habitoRepository.deleteByDate(habito.id!, date);
  }

  delete(Habito habito) async {
    GetIt.instance<EventBus>().fire(NotificationEventHabitoApagado(habito));
    await habitoRepository.delete(habito.id);
  }

  Future<void> addRegistradosDoDia(RegistradosDoDia registradosDoDia) async {
    await habitoRepository.addRegistradosDoDia(registradosDoDia);
  }

  Future<List<RegistradosDoDia>> getRegistradosDoDia(int userId, DateTime dataAtual) async {
    String date = dataAtual.toIso8601String().split('T')[0];
    return await habitoRepository.getRegistradosDoDia(userId, date);
  }

  Future<List<HabitosRegistradosPercents>> getPercentsByMonth(DateTime startDate, DateTime endDate) async{
    String startDateString = startDate.toIso8601String().split('T')[0];
    String endDateString = endDate.toIso8601String().split('T')[0];
    return await habitoRepository.getPercentsByMonth(startDateString, endDateString);
  }

  bool isDateWithinRange(DateTime date, DateTime startDate, DateTime? endDate) {
    if (endDate == null) {
      return date.isAfter(startDate) ||
          date.toFullYear().isAtSameMomentAs(startDate.toFullYear());
    }

    return (date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
        (date.isBefore(endDate) || date.isAtSameMomentAs(endDate));
  }

}
