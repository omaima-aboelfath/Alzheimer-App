
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  // initialization of notifications
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static onTap(NotificationResponse notificationResponse) {}
  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings());
    flutterLocalNotificationsPlugin.initialize(
      settings,
      // the functions that will be called when a notification is clicked
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  // basic notification
  static void showBasicNotification() async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        'id 1',
        'basic notification',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.show(
        0, 'Basic Notification', 'body of notification', details,
        payload: 'Payload data (when open notification)');
  }

  // repeated notification
  static void showRepeatedNotification() async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails(
        'id 2',
        'repeated notification',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
        1,
        'Repeated Notification',
        'body of repeated notification',
        RepeatInterval.everyMinute,
        details,
        payload: 'Payload data (when open notification)');
  }

  // scheduled notification
  /// before merge with tasks
  // static void showScheduledNotification() async {
  //   const AndroidNotificationDetails android = AndroidNotificationDetails(
  //     'id 3',
  //     'scheduled notification',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   NotificationDetails details = const NotificationDetails(android: android);
  //   tz.initializeTimeZones();
  //   final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  //   tz.setLocalLocation(tz.getLocation(currentTimeZone));
  //   print("Time Zone Name: ${tz.local.name}");
  //   print("Current Year: ${tz.TZDateTime.now(tz.local).year}");
  //   print("Current Month: ${tz.TZDateTime.now(tz.local).month}");
  //   print("Current Day: ${tz.TZDateTime.now(tz.local).day}");
  //   print("Current Hour: ${tz.TZDateTime.now(tz.local).hour}");
  //   print("Current Minute: ${tz.TZDateTime.now(tz.local).minute}");
  //   tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, 2024, 10, 30, 0, 37);
  //   // Ensure the date is still in the future before scheduling
  //   if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
  //     print("Scheduled time is in the past. Please adjust accordingly.");
  //     return;
  //   }
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       2,
  //       'Scheduled Notification',
  //       'body of scheduled notification',
  //       // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)), //after 10 seconds from click
  //       scheduledDate,
  //       details,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       payload: 'Payload data (when open notification)');
  // }
 
 static void showScheduledNotification({required DateTime currentDate}) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'id 3',
      'scheduled notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = const NotificationDetails(android: android);
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    print("Time Zone Name: ${tz.local.name}");
    print("Current Year: ${tz.TZDateTime.now(tz.local).year}");
    print("Current Month: ${tz.TZDateTime.now(tz.local).month}");
    print("Current Day: ${tz.TZDateTime.now(tz.local).day}");
    print("Current Hour: ${tz.TZDateTime.now(tz.local).hour}");
    print("Current Minute: ${tz.TZDateTime.now(tz.local).minute}");
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local, 
      currentDate.year, 
      currentDate.month, 
      currentDate.day, 
      0, 37);
    // Ensure the date is still in the future before scheduling
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      print("Scheduled time is in the past. Please adjust accordingly.");
      return;
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        'Scheduled Notification',
        'body of scheduled notification',
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)), //after 10 seconds from click
        scheduledDate,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'Payload data (when open notification)');
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

//1- setup
   /// add dependencies ....
 //2- basic notification
 //3- reapeted notification
 //4- scheduled notification