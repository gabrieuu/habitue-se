import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitue_se/database/data_service.dart';
import 'package:habitue_se/firebase_options.dart';
import 'package:habitue_se/init_dependencies.dart';
import 'package:habitue_se/models/custom_notification.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/preferences/shared_prefs.dart';
import 'package:habitue_se/repository/concrete_habitos_repository.dart';
import 'package:habitue_se/services/firebase_messaging_service.dart';
import 'package:habitue_se/services/notification_service.dart';
import 'package:habitue_se/setup_modules.dart';
import 'package:habitue_se/setup_routes.dart';
import 'package:habitue_se/shared/temas.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

const shouldUseFirestoreEmulator = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefs.init();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // FirebaseFirestore.instance.settings = const Settings(
  //   persistenceEnabled: true,
  // );
  // if (shouldUseFirestoreEmulator) {
  //   FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // }

  await Hive.initFlutter();
  await DataService.instance.init();
  setupModules();

  // await GetIt.instance<FirebaseMessagingService>()
  //     .initializeFirebaseMessaging();

  await Workmanager().initialize(
    callbackDispatcher,
  );
  await Workmanager().registerPeriodicTask('habitos', 'notification_habitos',
      frequency: const Duration(hours: 4),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.not_required),
      initialDelay: const Duration(hours: 1));

  runApp(const MyApp());
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Hive.initFlutter();
    await DataService.instance.init();
    if (task == 'notification_habitos') {
      HomeController controller = HomeController(ConcreteHabitosRepository());
      await controller.getAllHabitos();
      List<Habito> habitos = controller.getHabitosByData(DateTime.now());
      if (habitos.isEmpty) {
        NotificationService().showNotification(CustomNotification(
            id: 1,
            title: 'Adicione um Habito!',
            description:
                'Que tal registrar seus habitos para se manter no foco?'));
      } else {
        await NotificationService().showNotificationForListHabits(habitos);
      }
    }
    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      // showPerformanceOverlay: true,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Temas.primary),
      ),
      routerConfig: Routes.route,
    );
  }
}
