import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/models/response/habitos_registrados_percents.dart';
import 'package:habitue_se/repository/abstract_crud_repository.dart';

abstract class AbstractHabitosRepository
    with AbstractCrudRepository<Habito, int> {
  Future<void> deleteByDate(int id, DateTime date);
  Future<void> addRegistradosDoDia(RegistradosDoDia data);
  Future<List<RegistradosDoDia>> getRegistradosDoDia(int userId, String todayDate);
  Future<List<HabitosRegistradosPercents>> getPercentsByMonth(String startDate, String endDate);
}
