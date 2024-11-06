import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = 'notification-screen';
  final RemoteMessage message;

  const NotificationScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Trigger the SnackBar to show the notification's message body
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // if (message.notification?.body != null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(message.notification!.body!),
    //       duration: Duration(seconds: 3),
    //     ),
    //   );
    // }
    // });
    return Scaffold(
      appBar: AppBar(
        title: Text(message.notification?.title ?? 'Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (message.notification != null) ...[
              Text(
                message.notification!.body ?? 'No message body',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20), // Add spacing between widgets
            ],
            // Text(message.notification!.body!),
            // Text("Handling a foreground message: ${message.messageId}"),
            // SnackBar(content: Text(message.notification!.body!)),
            // ScaffoldMessenger.of(context)
            //   .showSnackBar(SnackBar(content: Text(message.notification!.body!)));
            // Text(
            //   message.data.isNotEmpty
            //       ? message.data.toString()
            //       : 'No additional data',
            //   style: TextStyle(fontSize: 16),
            // ),
          ],
        ),
      ),
    );
  }
}
