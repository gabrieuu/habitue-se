import 'package:habitue_se/database/data_service.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/repository/abstract_crud_repository.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';

import '../models/habito.dart';
import '../models/registrados_do_dia.dart';

class ConcreteHabitosRepository implements AbstractHabitosRepository {
  DataService _dataService = DataService.instance;

  @override
  Future<void> add(Habito object) async {
    await _dataService.addhabito(object);
  }

  @override
  Future<void> delete(String object) async {
    await _dataService.deleteHabitoHoje(object);
  }

  @override
  Future<List<Habito>> get() async {
    return await _dataService.getAllHabitos();
  }

  @override
  Future<void> update(String object) {
    throw UnimplementedError();
  }

  @override
  Future<List<RegistradosDoDia>> getRegistradosDoDia() async {
    return _dataService.getAllRegistrosDiarios();
  }

  @override
  Future<void> addRegistradosDoDia(RegistradosDoDia data) async {
    await _dataService.saveRegistrosDiarios(data);
  }
}
