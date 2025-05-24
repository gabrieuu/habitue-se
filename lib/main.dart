import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitue_se/database/data_service.dart';
import 'package:habitue_se/infra/dio_client.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/pages/home_page/service/habito_service.dart';
import 'package:habitue_se/preferences/shared_prefs.dart';
import 'package:habitue_se/repository/concrete_habitos_repository.dart';
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
  await Workmanager().registerPeriodicTask(
    'habitos',
    'notification_habitos',
    frequency: const Duration(days: 1),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    initialDelay: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.not_required),
  );

  runApp(const MyApp());
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Hive.initFlutter();
    await DataService.instance.init();
    if (task == 'notification_habitos') {
      DateTime now = DateTime.now();
      DateTime tomorrow = now.add(const Duration(days: 1));

      HabitoService habitoService =
          HabitoService(habitoRepository: ConcreteHabitosRepository(DioClient()));
      NotificationService notificationService = NotificationService();

      List<Habito> habitosDeHoje = await
          habitoService.getHabitos(DateTime.now());
      List<Habito> habitosDeAmanha = await
          habitoService.getHabitos(DateTime.now().add(Duration(days: 1)));

      await notificationService.scheduleNotificationsForDate(
          habitosDeHoje, now);
      await notificationService.scheduleNotificationsForDate(
          habitosDeAmanha, tomorrow);
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
