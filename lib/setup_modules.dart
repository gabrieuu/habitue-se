import 'package:get_it/get_it.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_controller.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';
import 'package:habitue_se/repository/abstract_tarefas_repository.dart';
import 'package:habitue_se/repository/concrete_habitos_repository.dart';
import 'package:habitue_se/repository/concrete_tarefas_repository.dart';
import 'package:habitue_se/services/firebase_messaging_service.dart';
import 'package:habitue_se/services/notification_service.dart';

setupModules() {
  _setupNotification();
  _setupModulesBottomAppBar();
  _setupModulesHomePage();
}

_setupNotification() {
  GetIt.instance.registerSingleton<NotificationService>(NotificationService());
  GetIt.instance.registerLazySingleton<FirebaseMessagingService>(
      () => FirebaseMessagingService(GetIt.instance<NotificationService>()));
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
