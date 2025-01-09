import 'package:get_it/get_it.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_controller.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';
import 'package:habitue_se/repository/abstract_tarefas_repository.dart';
import 'package:habitue_se/repository/concrete_habitos_repository.dart';
import 'package:habitue_se/repository/concrete_tarefas_repository.dart';

setupModules() {
  _setupModulesBottomAppBar();
  _setupModulesHomePage();
}

_setupModulesBottomAppBar() {
  GetIt.instance.registerLazySingleton<BottomAppBarController>(
      () => BottomAppBarController());
}

_setupModulesHomePage() {
  GetIt.instance.registerLazySingleton<AbstractHabitosRepository>(
      () => ConcreteHabitosRepository());
  GetIt.instance.registerLazySingleton<AbstractTarefasRepository>(
      () => ConcreteTarefasRepository());
  GetIt.instance.registerLazySingleton(() => HomeController(
      GetIt.instance<AbstractHabitosRepository>(),
      GetIt.instance<AbstractTarefasRepository>()));
}
