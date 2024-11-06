// video link
//https://youtu.be/Mctc831axv0?si=82lMNnBVSGqb_P11
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/main.dart';
import 'package:graduation_app/screens/notification_screen.dart';

class FirebaseNotifications {
//* Create instance of FBM
  final firebaseMessaging = FirebaseMessaging.instance;
//* Initialize notifications for this app or device
  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    String? token = await firebaseMessaging.getToken();
    print("token:===========> $token");
    handleBackgroundNotification();
    handleForegroundNotification();
  }

//* handle notifications when recieved
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    //else
    navigatorKey.currentState!
        .pushNamed(NotificationScreen.routeName, arguments: message);
  }

//* handle notifications in case of app is terminated or in background
  Future handleBackgroundNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

//* handle notifications in case of app is in foreground
  // Future handleForegroundNotification() async {
  //   FirebaseMessaging.onMessage.listen(handleMessage);
  // }
  // Future<void> handleForegroundNotification() async {
  //   // Handle notifications when the app is in the foreground
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Received a foreground message');
  //     handleMessage(message);
  //   });
  // }
  Future<void> handleForegroundNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Access context using navigatorKey and show Snackbar
        final context = navigatorKey.currentState?.overlay?.context;
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message.notification!.body ?? 'New Notification',
              ),
            ),
          );
        }
      }
    });
  }
}
