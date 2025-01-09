import 'package:habitue_se/models/tarefa.dart';

abstract class AbstractTarefasRepository {
  Future<List<Tarefa>> getTarefas();
  Future<void> addTarefa(Tarefa tarefa);
  Future<void> updateTarefa(Tarefa tarefa);
  Future<void> deleteTarefa(Tarefa tarefa);
}
