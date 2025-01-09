import 'package:habitue_se/models/habito.dart';

abstract class AbstractHabitosRepository {
  Future<List<Habito>> getHabitos();
  Future<void> addHabito(Habito habito);
  Future<void> updateHabito(Habito habito);
  Future<void> deleteHabito(Habito habito);
}