import 'package:habitue_se/models/habito.dart';

mixin AbstractHabitoDatasource {
  Future<void> addAllHabito(List<Habito> habitos);
  Future<void> addhabito(Habito habito);
  Future<List<Habito>> getAllHabitos();
  Future<void> deleteHabitoByData(String id, DateTime date);
  Future<void> updateHabito(Habito habito);
}
