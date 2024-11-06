import 'package:flutter/material.dart';
import 'package:graduation_app/utils/local_notification_service.dart';

class LocalNotificationTest extends StatelessWidget {
  static const String routeName = '/local_notification_test';

  const LocalNotificationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Local Notification Test'),
          // basic
          ListTile(
            onTap: () {
              LocalNotificationService.showBasicNotification();
            },
            leading: const Icon(Icons.notifications),
            title: const Text('Basic Notification'),
            trailing: IconButton(
              onPressed: () {
                LocalNotificationService.cancelNotification(0);
              },
              icon: const Icon(Icons.cancel, color: Colors.red),
            ),
          ),

          // repeated
          ListTile(
            onTap: () {
              LocalNotificationService.showRepeatedNotification();
            },
            leading: const Icon(Icons.notifications),
            title: const Text('Repeated Notification'),
            trailing: IconButton(
              onPressed: () {
                LocalNotificationService.cancelNotification(1);
              },
              icon: const Icon(Icons.cancel, color: Colors.red),
            ),
          ),

          // scheduled 
          ListTile(
            onTap: () {
              // LocalNotificationService.showScheduledNotification();
            },
            leading: const Icon(Icons.notifications),
            title: const Text('Scheduled Notification'),
            trailing: IconButton(
              onPressed: () {
                LocalNotificationService.cancelNotification(2);
              },
              icon: const Icon(Icons.cancel, color: Colors.red),
            ),
          ),
          ElevatedButton(onPressed: () {
            LocalNotificationService.flutterLocalNotificationsPlugin.cancelAll();
          }, child: const Text('cancel all'))
        ],
      ),
    );
  }
}
