import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/repository/abstract_crud_repository.dart';

abstract class AbstractHabitosRepository
    with AbstractCrudRepository<Habito, int> {
  Future<List<RegistradosDoDia>> getRegistradosDoDia();
}
