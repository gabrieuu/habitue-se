import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:habitue_se/models/custom_notification.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/setup_routes.dart';
import 'package:timezone/timezone.dart' as timezone;
import 'package:timezone/data/latest_all.dart' as timezone;

class NotificationService {
  late FlutterLocalNotificationsPlugin _localNotificationPlugin;
  late AndroidNotificationDetails _androidNotificationDetails;

  NotificationService() {
    _localNotificationPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupTimeZone();
    await _initializeNotifications();
  }

  Future<void> _setupTimeZone() async {
    timezone.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    timezone.setLocalLocation(timezone.getLocation(timeZoneName));
  }

  Future<void> _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _localNotificationPlugin.initialize(
      const InitializationSettings(android: android),
      onDidReceiveNotificationResponse: _onReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );
  }

  @pragma('vm:entry-point')
  static void _notificationTapBackground(
      NotificationResponse notificationResponse) {
    // ignore: avoid_print
    debugPrint('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      debugPrint(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

  Future<void> _onReceiveNotificationResponse(
      NotificationResponse response) async {
    switch (response.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        _onSelectNotification(response.payload);
        break;
      default:
        break;
    }
  }

  _onSelectNotification(String? payload) {
    if (payload != null) {
      Routes.rootNavigatorKey.currentContext!.pushReplacementNamed(payload);
    }
  }

  NotificationDetails get _notificationDetails {
    _androidNotificationDetails = const AndroidNotificationDetails(
      'lembretes_notification_1',
      'Lembretes',
      groupKey: 'habitos_group',
      channelDescription: 'Esta é a Notificação de lembretes',
      importance: Importance.max,
      priority: Priority.max,
      category: AndroidNotificationCategory.alarm,
      enableVibration: true,
    );

    return NotificationDetails(android: _androidNotificationDetails);
  }

  Future<void> showNotification(CustomNotification notification) async {
    _localNotificationPlugin.show(
      notification.id,
      notification.title,
      notification.description,
      _notificationDetails,
      payload: notification.payload,
    );
  }

  Future<void> sheduleNotificationForListHabits(List<Habito> habitos) async {
    await Future.forEach(habitos, (habito) async {
      await cancelNotificationForHabit(habito);
      await showNotificationSchedule(
        CustomNotification(
          id: habito.id.hashCode.abs(),
          title: 'Lembre-se de ${habito.nome} hoje!',
          description:
              '${habito.nome} é um hábito que você precisa manter, não esqueça de completá-lo hoje!',
        ),
      );
    });
  }

  Future<void> cancelNotificationForHabit(Habito habito) async {
    await _localNotificationPlugin.cancel(habito.id.hashCode.abs());
  }

  addNotificationForHabit(Habito habito, {String? title, String? description}) {
    showNotificationSchedule(
      CustomNotification(
        id: habito.id.hashCode.abs(),
        title: title ?? 'Lembre-se de ${habito.nome} hoje!',
        description: description ??
            '${habito.nome} é um hábito que você precisa manter, não esqueça de completá-lo hoje!',
      ),
    );
  }

  Future<void> showNotificationSchedule(CustomNotification notification,
      {Time? time}) async {
    _localNotificationPlugin.zonedSchedule(
        notification.id,
        notification.title,
        notification.description,
        _nextInstanceOfTime(time ?? Time(hour: 8, minute: 0)),
        _notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: notification.payload,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  // Função para calcular o próximo horário
  timezone.TZDateTime _nextInstanceOfTime(Time time) {
    final timezone.TZDateTime now = timezone.TZDateTime.now(timezone.local);
    timezone.TZDateTime scheduledDate = timezone.TZDateTime(
      timezone.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Se o horário já passou hoje, agende para amanhã
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> checkForNotification() async {
    final details =
        await _localNotificationPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.notificationResponse!.payload);
    }
  }
}

class Time {
  final int hour;
  final int minute;

  Time({required this.hour, required this.minute});
}
