import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';

class ConcreteHabitosRepository implements AbstractHabitosRepository {
  @override
  Future<void> addHabito(Habito habito) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteHabito(Habito habito) {
    throw UnimplementedError();
  }

  @override
  Future<List<Habito>> getHabitos() async {
    return habitoMock.map((habito) => Habito.fromMap(habito)).toList();
  }

  @override
  Future<void> updateHabito(Habito habito) {
    throw UnimplementedError();
  }
}

const List<Map<String, dynamic>> habitoMock = [
  {
    'id': 1,
    'nome': 'Correr',
    'unicode_emoji': '\u{1F3C3}\u{200D}\u{2642}\u{FE0F}',
    'unidade_de_medida': 'Km',
    'data_inicio': '2024-12-08',
    'data_fim': null,
    'objetivo_diario': 5,
    'registrados_do_dia': [
      {
        'id_habito': 1,
        'dia_atual': '2025-01-09',
        'completados_hoje': 1,
      },
      {
        'id_habito': 1,
        'dia_atual': '2025-01-08',
        'completados_hoje': 5,
      },
      {
        'id_habito': 1,
        'dia_atual': '2024-12-10',
        'completados_hoje': 2,
      },
      {
        'id_habito': 1,
        'dia_atual': '2024-12-20',
        'completados_hoje': 2,
      },
    ],
  },
  {
    'id': 1,
    'nome': 'Treinar',
    'unicode_emoji': '\u{1F3C3}\u{200D}\u{2642}\u{FE0F}',
    'unidade_de_medida': 'Horas',
    'data_inicio': '2024-12-08',
    'data_fim': '2025-01-09',
    'objetivo_diario': 3,
    'registrados_do_dia': [
      {
        'id_habito': 1,
        'dia_atual': '2025-01-09',
        'completados_hoje': 2,
      },
    ],
  }
];
