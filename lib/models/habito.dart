import 'package:habitue_se/models/registrados_do_dia.dart';

class Habito {
  int id;
  String unicodeEmoji;
  String nome;
  String unidadeDeMedida;
  bool completado;
  int objetivoDiario;
  DateTime? dataInicio;
  DateTime? dataFim;

  List<RegistradosDoDia> registradosDoDia;
  int completadosTotal;

  Habito(
      {required this.id,
      required this.nome,
      this.unicodeEmoji = '',
      this.completado = false,
      this.completadosTotal = 0,
      required this.unidadeDeMedida,
      this.dataInicio,
      this.dataFim,
      required this.objetivoDiario,
      required this.registradosDoDia});

  static Habito fromMap(Map<String, dynamic> map) {
    return Habito(
      id: map['id'],
      nome: map['nome'],
      unicodeEmoji: map['unicode_emoji'],
      unidadeDeMedida: map['unidade_de_medida'],
      dataInicio: map['data_inicio'] != null
          ? DateTime.parse(map['data_inicio'])
          : null,
      dataFim: map['data_fim'] != null ? DateTime.parse(map['data_fim']) : null,
      objetivoDiario: map['objetivo_diario'],
      registradosDoDia: (map['registrados_do_dia'] as List)
          .map((e) => RegistradosDoDia.fromMap(e))
          .toList(),
    );
  }

  void completar() {
    completado = true;
  }
}
