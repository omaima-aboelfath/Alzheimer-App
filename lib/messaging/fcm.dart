import 'package:firebase_messaging/firebase_messaging.dart';

class Fcm {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for notifications
  static Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
  static Future<String?> getToken() async {
    String? token = await messaging.getToken();
    print('token========>$token');
    return token;
  }
  
  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('User granted permission');
  // } else {
  //   print('User declined or has not accepted permission');
  // }

}
