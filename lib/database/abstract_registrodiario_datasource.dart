import 'package:habitue_se/models/registrados_do_dia.dart';

mixin AbstractRegistroDiarioDatasource {
  Future<void> saveRegistrosDiarios(RegistradosDoDia data);

  Future<List<RegistradosDoDia>> getAllRegistrosDiarios();
}
