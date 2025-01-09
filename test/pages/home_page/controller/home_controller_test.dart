import 'package:flutter_test/flutter_test.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';

void main() {
  HomeController controller = HomeController();
  testWidgets('deve retornar os habitos pertencentes a o dia selecionado',
      (tester) async {
    List<Habito> habitos = controller.getHabitosDoDia(DateTime(2024, 12, 26));

    double percent = controller.getTotalCompletado(habitos);
  });
}
