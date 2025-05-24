import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/infra/client_http.dart';
import 'package:habitue_se/infra/dio_client.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_controller.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/pages/home_page/service/habito_service.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';
import 'package:habitue_se/repository/abstract_tarefas_repository.dart';
import 'package:habitue_se/repository/concrete_habitos_repository.dart';
import 'package:habitue_se/repository/concrete_tarefas_repository.dart';
import 'package:habitue_se/services/notification_service.dart';

setupModules() {
  GetIt.instance.registerLazySingleton<ClientHttp>(() => DioClient());
  GetIt.instance.registerSingleton<EventBus>(EventBus());
  Modules.setupNotification();
  Modules.setupModulesBottomAppBar();
  Modules.setupModulesHomePage();
}


class Modules {
  static setupNotification() {
    GetIt.instance
        .registerSingleton<NotificationService>(NotificationService());
    // GetIt.instance.registerLazySingleton<FirebaseMessagingService>(
    //     () => FirebaseMessagingService(GetIt.instance<NotificationService>()));
  }

  static setupModulesBottomAppBar() {
    GetIt.instance.registerLazySingleton<BottomAppBarController>(
        () => BottomAppBarController());
  }

  static setupModulesHomePage() {
    GetIt.instance.registerLazySingleton<AbstractHabitosRepository>(
        () => ConcreteHabitosRepository(GetIt.I.get<ClientHttp>()));
    GetIt.instance.registerLazySingleton<AbstractTarefasRepository>(
        () => ConcreteTarefasRepository());
    GetIt.instance.registerLazySingleton(() => HabitoService(
        habitoRepository: GetIt.instance<AbstractHabitosRepository>()));
    GetIt.instance.registerLazySingleton(
        () => HomeController(GetIt.instance<HabitoService>()));
  }
}

