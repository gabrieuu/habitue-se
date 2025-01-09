class RegistradosDoDia {
  int idHabito;
  DateTime diaAtual;
  double completadosHoje;

  RegistradosDoDia(
      {required this.idHabito,
      required this.diaAtual,
      this.completadosHoje = 0});

  static RegistradosDoDia fromMap(Map<String, dynamic> map) {
    return RegistradosDoDia(
      idHabito: map['id_habito'],
      diaAtual: DateTime.parse(map['dia_atual']),
      completadosHoje: map['completados_hoje'].toDouble(),
    );
  }
}
