import 'registrados_do_dia.dart';

class Habito {
  String id;
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
      required this.hexColor,
      required this.objetivoDiario});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'unicode_emoji': unicodeEmoji,
      'unidade_de_medida': unidadeDeMedida,
      'data_inicio': dataInicio.toIso8601String(),
      'data_fim': dataFim?.toIso8601String(),
      'hex_color': hexColor,
      'descricao': descricao,
      'objetivo_diario': objetivoDiario,
    };
  }

  static Habito fromMap(Map<dynamic, dynamic> map) {
    return Habito(
      id: map['id'] as String,
      nome: map['nome'],
      unicodeEmoji: map['unicode_emoji'],
      unidadeDeMedida: map['unidade_de_medida'],
      dataInicio: DateTime.parse(map['data_inicio']),
      hexColor: map['hex_color'],
      descricao: map['descricao'] ?? '',
      dataFim: map['data_fim'] != null ? DateTime.parse(map['data_fim']) : null,
      objetivoDiario: map['objetivo_diario'],
    );
  }

  @override
  int get hashCode => id.hashCode;

  @override
  operator ==(other) => other is Habito && other.id == id;

  void completar() {
    completado = true;
  }
}
