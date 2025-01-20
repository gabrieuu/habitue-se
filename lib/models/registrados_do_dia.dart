class RegistradosDoDia {
  String idHabito;
  DateTime diaAtual;
  double completadosHoje;

  RegistradosDoDia(
      {required this.idHabito,
      required this.diaAtual,
      this.completadosHoje = 0});

  Map<String, dynamic> toMap() {
    return {
      'id_habito': idHabito,
      'dia_atual': diaAtual.toIso8601String(),
      'completados_hoje': completadosHoje,
    };
  }

  static RegistradosDoDia fromMap(Map<dynamic, dynamic> map) {
    return RegistradosDoDia(
      idHabito: map['id_habito'],
      diaAtual: DateTime.parse(map['dia_atual']),
      completadosHoje: map['completados_hoje'].toDouble(),
    );
  }
}
