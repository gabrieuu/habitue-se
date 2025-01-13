import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitue_se/pages/home_page/pages/home_page.dart';
import 'package:habitue_se/setup_modules.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_widget.dart';
import 'package:habitue_se/setup_routes.dart';
import 'package:habitue_se/shared/temas.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupModules();
  initializeDateFormatting().then((_) {
    return runApp(const MyApp());
  });
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
