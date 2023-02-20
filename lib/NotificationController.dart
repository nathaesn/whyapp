import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationController {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) async {
        // print("onSelectNotification");
        if (id!.isNotEmpty) {
          // print("Router Value1234 $id");
        }
      },
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "whyapp",
          "pushnotificationappchannel",
          "gdsi",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}

//Push

void pushNotificationMessage({
  required String deviceTo,
  required String content,
  required String title,
}) async {
  final data = {
    "registration_ids": [
      "ePcga9yPRFKEYG6p9rGhte:APA91bE_lu15DDE5vAh_OhRl8Z2tBGSUNjH7K5UBtSyH5eQvZic5il3R1nSAq64pNGNEnHFKOdHFOqLb4SzJhzcu2r0RV-l-0pqpmPaO8NLa31qTDKuq3bAGe9z6o0o1nb6lLR1TQx4K"
    ],
    "notification": {
      "body": content,
      "title": title,
      "android_channel_id": "whyapp",
      "sound": false
    },
    "data": {"email": "meyyqilaadikara@gmail.com"}
  };

  final headers = {
    'content-Type': 'application/json',
    'Authorization':
        'key=AAAAJuk-gsM:APA91bGrPsGRL-wJor_tZ2_saAraEtaOFqonlXk1ec3Y2zuSov1YkqE_fWHum7BVoHm2OHM7WHyQ1mflAJmKmtuDnehuhjdSz6ej6B4RaGqEuCKc4BF5Yg8EriP2KLhiZiAyaeThLY0W'
  };
  final res = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headers, body: json.encode(data));

  print("resss coyyy : " + jsonDecode(res.body)['success']);
}
