import 'package:habitue_se/models/habito_notification.dart';

class CustomNotification {
  int id;
  String title;
  String description;
  String? payload;
  TimeOfdayHabitos? scheduleTime;

  CustomNotification(
      {required this.id,
      required this.title,
      required this.description,
      this.payload,
      this.scheduleTime});
}
