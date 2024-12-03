import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graduation_app/utils/firebase_utils.dart';
import 'package:graduation_app/model/task_data.dart';
import 'package:graduation_app/model/user_data.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:collection/collection.dart'; // For groupBy

class TaskProvider extends ChangeNotifier {
  // data

  List<Task> tasksList = [];
  List<Task> incompleteTasks = [];
  List<Task> completeTasks = [];

  MyUser? _currentPatient;
  var selectDate = DateTime.now();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // functions

  // new *stream*
  // Future<void> getAllTasksFromFireStore(String uId) async {
  //   FirebaseUtils.getTasksCollection(uId)
  //       // var querySnapshot = await FirebaseUtils.getTasksCollection(uId)
  //       .orderBy('dateTime', descending: false)
  //       .snapshots()
  //       .listen((querySnapshot) {
  //     tasksList = querySnapshot.docs.map((doc) {
  //       return doc.data();
  //     }).toList();
  //     print('Fetched ${tasksList.length} tasks from Firestore');
  //     print('Tasks: $tasksList'); // Debug log to see the task details
  //     // tasksList = tasksList.where((task) {
  //     //   return selectDate.day == task.dateTime.day &&
  //     //       selectDate.month == task.dateTime.month &&
  //     //       selectDate.year == task.dateTime.year;
  //     // }).toList();
  //     // Filter incomplete tasks
  //   incompleteTasks = tasksList.where((task) => !task.isDone).toList();
  //     // // Schedule notifications for each task
  //     // for (var task in tasksList) {
  //     //   // scheduleTaskNotification(task);
  //     //   scheduleNotification(task);
  //     // }
  //     // Schedule notifications for filtered tasks only
  //     tasksList.forEach(scheduleNotification);
  //     notifyListeners();
  //   });
  // }

  /// testttt ***
  Future<void> getAllTasksFromFireStore(String uId) async {
    try {
      final querySnapshot = await FirebaseUtils.getTasksCollection(uId)
          .orderBy('dateTime', descending: false)
          .get(); // Use get() instead of snapshots()
      tasksList = querySnapshot.docs.map((doc) {
        return doc.data();
      }).toList();
      // Filter tasks based on the selected date
      // tasksList = tasksList.where((task) {
      //   var taskDate = (task.dateTime ).toDate();
      //   return selectDate.day == taskDate.day &&
      //       selectDate.month == taskDate.month &&
      //       selectDate.year == taskDate.year;
      // }).toList();
      incompleteTasks = tasksList.where((task) => !task.isDone).toList();
      completeTasks = tasksList.where((task) => task.isDone).toList();
      // Update UI with new tasks
      notifyListeners();
      print('Fetched ${tasksList.length} tasks from Firestore');
    } catch (error) {
      print('Error fetching tasks: $error');
    }
  }

  //22222
// Future<void> getAllTasksFromFireStore(String uId) async {
//   try {
//     final querySnapshot = await FirebaseUtils.getTasksCollection(uId)
//         .orderBy('dateTime', descending: false)
//         .get();

//     tasksList = querySnapshot.docs.map((doc) {
//       return doc.data();
//     }).toList();

//     // Filter only the tasks of the currently selected patient
//     if (_currentPatient != null) {
//       tasksList = tasksList.where((task) => task.ownerId == _currentPatient!.id).toList();
//     }

//     incompleteTasks = tasksList.where((task) => !task.isDone).toList();
//     notifyListeners();
//     print('Fetched ${tasksList.length} tasks from Firestore');
//   } catch (error) {
//     print('Error fetching tasks: $error');
//   }
// }

  // Schedule a notification for a task
  ///1
  // Future<void> scheduleTaskNotification(Task task) async {
  //   final now = DateTime.now();
  //   if (!task.isDone) {
  //     if (task.dateTime.isBefore(now)) {
  //       // Task missed, send notification
  //       sendNotification(
  //           task, 'Task missed', 'You missed the task "${task.title}"');
  //     } else if (task.dateTime.isBefore(now.add(Duration(minutes: 10)))) {
  //       // Task due soon, send notification
  //       sendNotification(task, 'Task due soon',
  //           'The task "${task.title}" is due in less than 10 minutes');
  //     } else {
  //       // Convert DateTime to TZDateTime for scheduling notifications
  //       tz.TZDateTime scheduledDate = tz.TZDateTime.from(
  //           task.dateTime.subtract(Duration(minutes: 10)), tz.local);
  //       // Schedule notification for 10 minutes before the task
  //       await flutterLocalNotificationsPlugin.zonedSchedule(
  //         task.id.hashCode, // Use task ID as a unique identifier
  //         'Task Reminder',
  //         'The task "${task.title}" is due in 10 minutes',
  //         scheduledDate,
  //         const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //               'your_channel_id', 'your_channel_name'),
  //         ),
  //         androidScheduleMode:
  //             AndroidScheduleMode.exactAllowWhileIdle, // Updated parameter
  //         uiLocalNotificationDateInterpretation:
  //             UILocalNotificationDateInterpretation.absoluteTime,
  //       );
  //     }
  //   }
  // }
  ///2
  // Future<void> scheduleNotification(Task task) async {
  //   // final scheduledDate = task.dateTime.subtract(Duration(minutes: 10)); // Schedule 10 minutes before the task time
  //   tz.TZDateTime scheduledDate = tz.TZDateTime.from(
  //       task.dateTime.subtract(Duration(minutes: 10)), tz.local);
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     task.id.hashCode, // Unique ID for the notification
  //     'Task Reminder', // Notification title
  //     'The task "${task.title}" is due in 10 minutes', // Notification body
  //     scheduledDate,
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'your_channel_id', // Use your channel ID
  //         'Your Channel Name', // Channel name (optional)
  //         channelDescription:
  //             'This channel is used for important notifications.', // Optional description
  //         importance: Importance.high,
  //         playSound: true,
  //       ),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode
  //         .exactAllowWhileIdle, // Use this to allow the notification to trigger while idle
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }
  ///3
  // Future<void> scheduleNotification(Task task) async {
  //   // Request permission for exact alarms
  //   print("Requesting permissions==========");
  //   var status = await Permission.ignoreBatteryOptimizations.request();
  //   print("Permission status: $status");
  //   if (status.isDenied || status.isPermanentlyDenied) {
  //     // If permission is denied, show an explanation
  //     print('Exact alarms permission is denied.');
  //     return; // Exit if permission is not granted
  //   }
  //   // If permission is granted, schedule the notification
  //   // Define the notification details
  //   var androidDetails = AndroidNotificationDetails(
  //     'your_channel_id', // Replace with your channel ID
  //     'Your Channel Name', // Replace with your channel name
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: true,
  //   );
  //   var notificationDetails = NotificationDetails(android: androidDetails);
  //   // Schedule the notification (replace with your date)
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     task.id as int, // Unique ID for the notification
  //     'Task Reminder', // Notification title
  //     'You have a task: ${task.title}', // Notification body
  //     tz.TZDateTime.from(task.dateTime, tz.local), // Schedule time
  //     notificationDetails,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents: DateTimeComponents.dateAndTime,
  //   );
  // }

  //4
  Future<void> scheduleNotification(Task task) async {
    var status = await Permission.ignoreBatteryOptimizations.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      print('Exact alarms permission is denied.');
      return;
    }

    var androidDetails = const AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id.hashCode,
      'Task Reminder',
      'You have a task: ${task.title}',
      tz.TZDateTime.from(
          task.dateTime.subtract(const Duration(minutes: 10)), tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  // Send an immediate notification
  void sendNotification(Task task, String title, String body) {
    flutterLocalNotificationsPlugin.show(
      task.id.hashCode,
      title,
      body,
      const NotificationDetails(
        android:
            AndroidNotificationDetails('your_channel_id', 'your_channel_name'),
      ),
    );
  }

  void changeSelectDate(DateTime newDate, String uId) {
    selectDate = newDate; // change the date to the selected date by user
    // we want when clicking on newDate calling getAllTasksFromFireStore because there we filtering based on selectedDates
    // we call it also after adding new task on bottom sheet to update list
    getAllTasksFromFireStore(uId);
    // notifyListeners();
  }

  void updateTask(Task updatedTask, String uId) {
    for (int i = 0; i < tasksList.length; i++) {
      if (tasksList[i].id == updatedTask.id) {
        tasksList[i] = updatedTask;
        notifyListeners();
        break; // Exit the loop once the task is found and updated
      }
    }
    // getAllTasksFromFireStore(uId);
  }

  // Setter for the current patient
  void setCurrentPatient(MyUser patient) {
    _currentPatient = patient;
    notifyListeners(); // Notify listeners to refresh the UI
  }

// Generate chart data using the Task model directly
  Map<DateTime, int> getIncompleteTaskChartData() {
    // Group incomplete tasks by date
    var groupedTasks = groupBy(incompleteTasks, (Task task) {
      return DateTime(
          task.dateTime.year, task.dateTime.month, task.dateTime.day);
    });

    // Convert the grouped tasks into a map with date and count of tasks per date
    return groupedTasks.map((date, tasks) => MapEntry(date, tasks.length));
  }

  Map<DateTime, int> getCompleteTaskChartData() {
    // Group complete tasks by date
    var groupedTasks = groupBy(completeTasks, (Task task) {
      return DateTime(
          task.dateTime.year, task.dateTime.month, task.dateTime.day);
    });

    // Convert the grouped tasks into a map with date and count of tasks per date
    return groupedTasks.map((date, tasks) => MapEntry(date, tasks.length));
  }
}
