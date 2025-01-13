import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/repository/abstract_crud_repository.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';

import '../models/habito.dart';
import '../models/registrados_do_dia.dart';

class ConcreteHabitosRepository implements AbstractHabitosRepository {
  @override
  Future<void> add(Habito object) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> delete(int object) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Habito>> get() async {
    return [];
  }

  @override
  Future<void> update(int object) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<List<RegistradosDoDia>> getRegistradosDoDia() async {
    return [];
  }
}
