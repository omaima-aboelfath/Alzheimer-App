import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:alert_dialog/alert_dialog.dart';
import 'package:graduation_app/screens/caregiver_screen.dart';
import 'package:http/http.dart' as http;

// Top-level function
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }
class NotificationClass extends StatefulWidget {
  static const String routeName = 'notification';

  const NotificationClass({super.key});

  @override
  State<NotificationClass> createState() => _NotificationClassState();
}

class _NotificationClassState extends State<NotificationClass> {
  String? token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    print('token==============>$token');
  }

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // in case Terminated app
  // RemoteMessage => has all the properties of message
  getInit() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    // if(initialMessage != null && initialMessage.notification !=null) {
    // String? title = initialMessage.notification!.title;
    // String? body = initialMessage.notification!.body;
    // if(initialMessage.data['type'] == 'chat'){
    Navigator.pushNamed(context, CaregiverScreen.routeName);
    // ,arguments: { // habdaa
    //   'body':body!
    // });
    // }
    // }
  }

  @override
  void initState() {
    requestPermission();
    getToken();
    getInit();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('Test Click');
      // do anything, navigate , insert in db
      // if(message.data['type'] == 'chat'){}
      Navigator.pushNamed(context, CaregiverScreen.routeName);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("Handling a foreground message: ${message.messageId}");
        print('=======================');
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);
        print('=======================');
        // alert(
        //   context,
        //   title: Text(message.notification!.title!),
        //   content: Text(message.notification!.body!),
        // );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message.notification!.body!)));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('notification'),
      ),
    );
  }
}

sendMessage(title, message) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization': ''
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  var body = {
    "to":
        "c3dLCLKVSZ6Uxo4cDn2bUp:APA91bGJmrRm9rlNm6IxyvMhQ4ekck7uz5L2ZQ6bnysXFzX64wX46hxqi4TwkC5pkzV1Glvc5dUojTTnFeg6ewSE0mTCBwgdlC8nM9UoHDDGjNwVzLHzDewmC2BNqBe3_ksiSyH_6RKE",
    "notification": {"title": title, "body": message},
    "data": {"id": "12", "name": "omaima", "type": "alert"}
  };
  var request = http.Request('POST', url);
  request.headers.addAll(headersList);
  request.body = json.encode(body);

  var response = await request.send();
  final responseBody = await response.stream.bytesToString();

  if (response.statusCode >= 200 && response.statusCode < 300) {
    print(responseBody);
  } else {
    print(response.reasonPhrase);
  }
}
