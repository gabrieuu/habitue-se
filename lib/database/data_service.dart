import 'dart:convert';

import 'package:habitue_se/database/abstract_habitos_datasource.dart';
import 'package:habitue_se/database/abstract_registrodiario_datasource.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/shared/data_utils.dart';
import 'package:hive/hive.dart';

class DataService
    with AbstractHabitoDatasource, AbstractRegistroDiarioDatasource {
  static DataService? _instance;
  final String _habitosBox = 'habitos';
  final String _registroDiarioBox = 'registroDiario';
  late Box habitoBox;
  late Box registroBox;

  DataService._();

  static DataService get instance {
    _instance ??= DataService._();
    return _instance!;
  }

  Future<void> init() async {
    habitoBox = await Hive.openBox(_habitosBox);
    registroBox = await Hive.openBox(_registroDiarioBox);
    await habitoBox.clear();
    await registroBox.clear();
  }

  @override
  Future<void> addAllHabito(List<Habito> habitos) {
    // TODO: implement addAllHabito
    throw UnimplementedError();
  }

  @override
  Future<void> addhabito(Habito habito) async {
    await habitoBox.put(habito.id, habito.toMap());
  }

  @override
  Future<void> deleteHabitoHoje(String id) async {
    Habito habito = Habito.fromMap(habitoBox.get(id));
    habito.dataFim = DateTime.now().subtract(const Duration(days: 1));
    await registroBox
        .delete(registroBox.get(getRegistroDiaKey(habito.id, DateTime.now())));
    await habitoBox.put(habito.id, habito.toMap());
  }

  @override
  Future<List<Habito>> getAllHabitos() async {
    var response = habitoBox.values.toList();
    return response.map((e) => Habito.fromMap(e)).toList();
  }

  @override
  Future<void> updateHabito(String id) {
    // TODO: implement updateHabito
    throw UnimplementedError();
  }

  @override
  Future<List<RegistradosDoDia>> getAllRegistrosDiarios() async {
    var response = registroBox.values.toList();
    return response.map((e) => RegistradosDoDia.fromMap(e)).toList();
  }

  @override
  Future<void> saveRegistrosDiarios(RegistradosDoDia data) async {
    await registroBox.put(
        getRegistroDiaKey(data.idHabito, data.diaAtual), data.toMap());
  }

  String getRegistroDiaKey(String idHabito, DateTime date) {
    return '$idHabito${date.toFullYear().toIso8601String().split('T')[0]}';
  }
}
