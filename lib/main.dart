import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitue_se/database/data_service.dart';
import 'package:habitue_se/setup_modules.dart';
import 'package:habitue_se/setup_routes.dart';
import 'package:habitue_se/shared/temas.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await DataService.instance.init();
  setupModules();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Temas.primary),
        useMaterial3: true,
      ),
      routerConfig: route,
    );
  }
}
