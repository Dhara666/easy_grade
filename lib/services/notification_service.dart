import 'dart:developer';
import 'package:easy_grade/pages/intro_page/intro_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../pages/dashboard_page/dashboard_page.dart';
import '../utills/app_logs.dart';

class NotificationService {

  FirebaseMessaging? firebaseMessaging;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log('Background message Id : ${message.messageId}');
    log('Background message Time : ${message.sentTime}');
  }

  Future<void> initializeNotification() async {
    await Firebase.initializeApp();
    await initializeLocalNotification();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken();
    log('FCM Token --> $fcmToken');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification != null) {
        await getStoreUserInfo();
        if(userInfo!= null) {
          navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (context) => const DashBoardPage(selectedIndex: 2)));
        }
        else{
          navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (context) => const IntroPage()));
        }
      }
    });

    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(announcement: true);

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
        log('Message data: ${remoteMessage.data}');
        log('Message title: ${remoteMessage.notification!.title}, body: ${remoteMessage.notification!.body}');

        AndroidNotificationDetails androidNotificationDetails =
            const AndroidNotificationDetails(
          'CHANNEL ID',
          'CHANNEL NAME',
          channelDescription: 'CHANNEL DESCRIPTION',
          importance: Importance.max,
          priority: Priority.max,
        );
        IOSNotificationDetails iosNotificationDetails =
            const IOSNotificationDetails (
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
        NotificationDetails notificationDetails = NotificationDetails(
            android: androidNotificationDetails, iOS: iosNotificationDetails);

        await flutterLocalNotificationsPlugin.show(
          0,
          remoteMessage.notification!.title!,
          remoteMessage.notification!.body!,
          notificationDetails, payload: remoteMessage.notification!.title!
        );
      });
   }
  }

   initializeLocalNotification() {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    IOSInitializationSettings ios = const IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    InitializationSettings platform =
        InitializationSettings(android: android, iOS: ios);
      flutterLocalNotificationsPlugin.initialize(platform,
        onSelectNotification: onSelectNotification
    );
  }
}

Future<dynamic> onSelectNotification(payload) async {
  await getStoreUserInfo();
   if(userInfo!= null) {
     navigatorKey.currentState?.push(MaterialPageRoute(
         builder: (context) => const DashBoardPage(selectedIndex: 2)));
   }
   else{
     navigatorKey.currentState?.push(MaterialPageRoute(
         builder: (context) => const IntroPage()));
   }
}