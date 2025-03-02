import 'dart:convert';
import 'dart:developer';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:habitue_se/models/custom_notification.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/models/habito_notification.dart';
import 'package:habitue_se/pages/home_page/service/habito_service.dart';
import 'package:habitue_se/preferences/shared_prefs.dart';
import 'package:habitue_se/setup_routes.dart';
import 'package:habitue_se/shared/notification_events.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

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
    await resetarNotificacoes();
    _listenForEvents();
  }

  _listenForEvents() {
    GetIt.instance<EventBus>().on<NotificationEvents>().listen((event) {
      switch (event) {
        case NotificationEventHabitoCriado():
          log('NotificationEventHabitoCriado: ${event.habito.nome}');
          scheduleNotificationHabit(event.habito);
          break;
        case NotificationEventHabitoApagado():
          log('NotificationEventHabitoApagado: ${event.habito.nome}');
          removeNotificationForHabit(event.habito);
          break;
        default:
          break;
      }
    });
  }

  Future<void> _setupTimeZone() async {
    timezone.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    timezone.setLocalLocation(timezone.getLocation(timeZoneName));
  }

  Future<void> _initializeNotifications() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
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

  Future<void> scheduleNotificationsForDate(
      List<Habito> habitos, DateTime date) async {
    List<Habito> habitosDoDia = habitos
        .where((habito) => habito.habitoNotification
            .shouldTriggerNotification(currentDateTime: date))
        .toList();

    for (var habito in habitosDoDia) {
      scheduleNotificationHabit(habito);
    }
  }

  Future<void> resetarNotificacoes() async {
    await _localNotificationPlugin.cancelAll();

    List<Habito> habitos = await GetIt.instance<HabitoService>().getHabitos();

    List<Habito> habitosDoDia = GetIt.instance<HabitoService>()
        .getHabitosByData(DateTime.now(), habitos);

    await scheduleNotificationsForDate(habitosDoDia, DateTime.now());
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

  Future<void> showNotificationForListHabits(List<Habito> habitos) async {
    await Future.forEach(habitos, (habito) async {
      await showNotification(
        CustomNotification(
          id: generateNotificationId(habito.id),
          title: 'Lembre-se de ${habito.nome} hoje!',
          description:
              '${habito.nome} é um hábito que você precisa manter, não esqueça de completá-lo hoje!',
        ),
      );
    });
  }

  Future<void> scheduleNotificationHabit(Habito habito) async {
    var idsNotificacoes = [];
    if (await SharedPrefs.containsKey(habito.id)) {
      idsNotificacoes = jsonDecode(SharedPrefs.getString(habito.id)) as List;
      for (var id in idsNotificacoes) {
        _localNotificationPlugin.cancel(id);
      }
      idsNotificacoes = [];

      await SharedPrefs.remove(habito.id);
    }
    for (var time in habito.habitoNotification.horariosVariados) {
      idsNotificacoes.add(generateNotificationId(habito.id, time: time));
      await scheduleNotification(
        CustomNotification(
          id: generateNotificationId(habito.id, time: time),
          title: 'lembrete de ${habito.nome}',
          description: 'Hora de realizar seu hábito!',
          scheduleTime: time,
        ),
      );
    }
    await SharedPrefs.setString(habito.id, jsonEncode(idsNotificacoes));
    await listarNotificacoesAtivas();
  }

  removeNotificationForHabit(Habito habito) async {
    var idsNotificacoes = jsonDecode(SharedPrefs.getString(habito.id)) as List;
    for (var time in idsNotificacoes) {
      await _localNotificationPlugin.cancel(
        time as int,
      );
    }
  }

  Future<void> scheduleNotification(CustomNotification notification) async {
    _localNotificationPlugin.zonedSchedule(
        notification.id,
        notification.title,
        notification.description,
        _nextInstanceOfTime(notification.scheduleTime!),
        _notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: notification.payload ?? '/home',
        matchDateTimeComponents: DateTimeComponents.time);
  }

  // Função para calcular o próximo horário
  timezone.TZDateTime _nextInstanceOfTime(TimeOfdayHabitos time) {
    final timezone.TZDateTime now = timezone.TZDateTime.now(timezone.local);
    timezone.TZDateTime scheduledDate = timezone.TZDateTime(
      timezone.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  bool estaNoHorarioDeNotificar(List<TimeOfdayHabitos> horarios) {
    final timezone.TZDateTime now = timezone.TZDateTime.now(timezone.local);

    for (var horario in horarios) {
      if (horario.hour == now.hour) {
        return true;
      }
    }

    return false;
  }

  Future<void> checkForNotification() async {
    final details =
        await _localNotificationPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.notificationResponse!.payload);
    }
  }

  Future<void> listarNotificacoesAtivas() async {
    List<PendingNotificationRequest> pendingNotifications =
        await _localNotificationPlugin.pendingNotificationRequests();

    for (var notification in pendingNotifications) {
      log("ID: ${notification.id}, Título: ${notification.title}, Corpo: ${notification.body}");
    }
  }

  int generateNotificationId(String uuid, {TimeOfdayHabitos? time}) {
    int uuidHash = utf8.encode(uuid).reduce((a, b) => a + b);
    return uuidHash + ((time?.hour ?? 0) * 60) + (time?.minute ?? 0);
  }
}
