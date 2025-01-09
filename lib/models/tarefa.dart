class Tarefa {
  String titulo;
  String descricao;
  String data;
  bool completado;

  Tarefa({
    required this.titulo,
    required this.descricao,
    required this.data,
    this.completado = false,
  });

  static Tarefa fromMap(Map<String, dynamic> map) {
    return Tarefa(
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      data: map['data'] ?? '',
      completado: map['completado'] ?? false,
    );
  }
}
