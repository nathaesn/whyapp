import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  // final datanya = await FirebaseFirestore.instance
  //     .collection("user")
  //     .doc("qilaadikara@gmail.com")
  //     .collection("tokenDevice")
  //     .get();
  // final List myList = datanya.docs.toList();
  // print("Haloo KYAAA :  " + myList[0]["token"]);
  // print(myList.length);
  int index = 0;
  final data = {
    "registration_ids": [deviceTo],
    "notification": {
      "body": content,
      "title": title,
      "android_channel_id": "whyapp",
      "sound": false
    },
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
