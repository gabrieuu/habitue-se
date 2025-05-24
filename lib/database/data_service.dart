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
    // await habitoBox.clear();
    // await registroBox.clear();
  }

  

  @override
  Future<void> addAllHabito(List<Habito> habitos) {
    // TODO: implement addAllHabito
    throw UnimplementedError();
  }

  @override
  Future<void> addhabito(Habito habito) async {
    await habitoBox.put(habito.id, habito.toJson());
  }

  @override
  Future<void> deleteHabitoByData(String id, DateTime date) async {
    Habito habito = Habito.fromJson(habitoBox.get(id));
    habito.endDate = date.subtract(const Duration(days: 1));
    await habitoBox.put(habito.id, habito.toJson());
    if (registroBox.containsKey(getRegistroDiaKey(habito.id, date))) {
      await registroBox.delete(getRegistroDiaKey(habito.id, date));
    }
  }

  @override
  Future<List<Habito>> getAllHabitos() async {
    var response = habitoBox.values.toList();
    return response.map((e) => Habito.fromJson(e)).toList();
  }

  @override
  Future<void> updateHabito(Habito habito) {
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
        getRegistroDiaKey(data.habitId, DateTime.now()), data.toMap());
  }

  String getRegistroDiaKey(int idHabito, DateTime date) {
    String key =
        '$idHabito${date.toFullYear().toIso8601String().split('T')[0]}';
    return key;
  }
}
