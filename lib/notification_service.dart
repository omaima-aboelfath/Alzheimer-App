// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> requestPermissions() async {
//     PermissionStatus status = await Permission.scheduleExactAlarm.request();
    
//     if (status.isGranted) {
//       print("Permission granted!");
//     } else if (status.isDenied) {
//       print("Permission denied. Please enable it in settings.");
//     } else if (status.isPermanentlyDenied) {
//       await openAppSettings();
//     }
//   }

//   Future<void> scheduleNotification() async {
//     PermissionStatus status = await Permission.scheduleExactAlarm.status;

//     if (status.isGranted) {
//       // Schedule your notification here
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'Task Reminder',
//         'Time to complete your task!',
//         // Use timezone to schedule the notification
//         scheduledTime, // replace with your DateTime
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'your channel id',
//             'your channel name',
//             channelDescription: 
//             'your channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//         ),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
//       );
//     } else {
//       await requestPermissions(); // Re-attempt requesting permission
//     }
//   }
// }
