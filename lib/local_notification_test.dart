import 'package:flutter/material.dart';
import 'package:graduation_app/utils/local_notification_service.dart';

class LocalNotificationTest extends StatelessWidget {
  static const String routeName = '/local_notification_test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Local Notification Test'),
          // basic
          ListTile(
            onTap: () {
              LocalNotificationService.showBasicNotification();
            },
            leading: Icon(Icons.notifications),
            title: Text('Basic Notification'),
            trailing: IconButton(
              onPressed: () {
                LocalNotificationService.cancelNotification(0);
              },
              icon: Icon(Icons.cancel, color: Colors.red),
            ),
          ),

          // repeated
          ListTile(
            onTap: () {
              LocalNotificationService.showRepeatedNotification();
            },
            leading: Icon(Icons.notifications),
            title: Text('Repeated Notification'),
            trailing: IconButton(
              onPressed: () {
                LocalNotificationService.cancelNotification(1);
              },
              icon: Icon(Icons.cancel, color: Colors.red),
            ),
          ),

          // scheduled 
          ListTile(
            onTap: () {
              // LocalNotificationService.showScheduledNotification();
            },
            leading: Icon(Icons.notifications),
            title: Text('Scheduled Notification'),
            trailing: IconButton(
              onPressed: () {
                LocalNotificationService.cancelNotification(2);
              },
              icon: Icon(Icons.cancel, color: Colors.red),
            ),
          ),
          ElevatedButton(onPressed: () {
            LocalNotificationService.flutterLocalNotificationsPlugin.cancelAll();
          }, child: Text('cancel all'))
        ],
      ),
    );
  }
}
