import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/database/data_service.dart';
import 'package:habitue_se/firebase_options.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/preferences/shared_prefs.dart';
import 'package:habitue_se/services/firebase_messaging_service.dart';
import 'package:habitue_se/services/notification_service.dart';
import 'package:habitue_se/setup_modules.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

Future<void> initDependencies() async {
 
}


