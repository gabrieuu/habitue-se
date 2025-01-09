import 'package:habitue_se/models/tarefa.dart';
import 'package:habitue_se/repository/abstract_tarefas_repository.dart';

class ConcreteTarefasRepository implements AbstractTarefasRepository {
  @override
  Future<void> addTarefa(Tarefa tarefa) {
    // TODO: implement addTarefa
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTarefa(Tarefa tarefa) {
    // TODO: implement deleteTarefa
    throw UnimplementedError();
  }

  @override
  Future<List<Tarefa>> getTarefas() async {
    return tarefaMock.map((tarefa) => Tarefa.fromMap(tarefa)).toList();
  }

  @override
  Future<void> updateTarefa(Tarefa tarefa) {
    // TODO: implement updateTarefa
    throw UnimplementedError();
  }
}

const List<Map<String, dynamic>> tarefaMock = [
  {
    'titulo': 'Estudar',
    'descricao': 'blba',
    'data': '2025-1-20',
    'completado': false,
  },
  {
    'titulo': 'Correr',
    'descricao': '',
    'data': '2024-12-20',
    'completado': true,
  },
  {
    'titulo': 'Ler',
    'descricao': 'false',
    'data': '2024-12-20',
    'completado': false,
  }
];
