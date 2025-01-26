import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:habitue_se/models/custom_notification.dart';
import 'package:habitue_se/preferences/shared_prefs.dart';
import 'package:habitue_se/services/notification_service.dart';

class FirebaseMessagingService {
  final NotificationService _notificationService;

  FirebaseMessagingService(this._notificationService);

  Future<void> initializeFirebaseMessaging() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _listenTokenUpdate();
    _getDeviceFirebaseToken();
    _onMessage();
  }

  _listenTokenUpdate() {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      var data = await FirebaseFirestore.instance
          .collection('notifications')
          .doc(SharedPrefs.getString(KeysSharedPreferences.NOTIFICATION_TOKEN))
          .get();

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(SharedPrefs.getString(KeysSharedPreferences.NOTIFICATION_TOKEN))
          .delete();

      await SharedPrefs.setString(
          KeysSharedPreferences.NOTIFICATION_TOKEN, token);

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(SharedPrefs.getString(KeysSharedPreferences.NOTIFICATION_TOKEN))
          .set({
        'deviceToken': token,
        'startTime': data['startTime'],
        'intervalHours': data['intervalHours'],
        'enabled': data['enabled'],
      });
    });
  }

  _getDeviceFirebaseToken() async {
    String tokenSalvo =
        SharedPrefs.getString(KeysSharedPreferences.NOTIFICATION_TOKEN);

    if (tokenSalvo.isNotEmpty) return;

    String? token = await FirebaseMessaging.instance.getToken();
    await SharedPrefs.setString(
        KeysSharedPreferences.NOTIFICATION_TOKEN, token ?? '');

    debugPrint('============================');
    debugPrint('Firebase Token: $token');
    debugPrint('============================');
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notificationService.showNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title ?? '',
            description: notification.body ?? '',
            payload: message.data['payload'] ?? '/home',
          ),
        );
      }
    });
  }
}
