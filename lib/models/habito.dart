import 'registrados_do_dia.dart';

class Habito {
  int id;
  String unicodeEmoji;
  String nome;
  String? descricao;
  String unidadeDeMedida;
  bool completado;
  double objetivoDiario;
  DateTime dataInicio;
  DateTime? dataFim;
  String? hexColor;
  int completadosTotal;

  Habito(
      {required this.id,
      required this.nome,
      this.descricao,
      this.unicodeEmoji = '',
      this.completado = false,
      this.completadosTotal = 0,
      required this.unidadeDeMedida,
      required this.dataInicio,
      this.dataFim,
      this.hexColor,
      required this.objetivoDiario});

  static Habito fromMap(Map<String, dynamic> map) {
    return Habito(
      id: map['id'],
      nome: map['nome'],
      unicodeEmoji: map['unicode_emoji'],
      unidadeDeMedida: map['unidade_de_medida'],
      dataInicio: DateTime.parse(map['data_inicio']),
      dataFim: map['data_fim'] != null ? DateTime.parse(map['data_fim']) : null,
      objetivoDiario: map['objetivo_diario'],
    );
  }

  void completar() {
    completado = true;
  }
}
