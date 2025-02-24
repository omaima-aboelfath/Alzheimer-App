import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graduation_app/utils/firebase_utils.dart';
import 'package:graduation_app/model/task_data.dart';
import 'package:graduation_app/model/user_data.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:collection/collection.dart'; // For groupBy
import 'package:http/http.dart' as http;
import '../model/api_manager.dart';

class TaskProvider extends ChangeNotifier {
  // data

  List<TaskData> tasksList = [];
  List<TaskData> incompleteTasks = [];
  List<TaskData> completeTasks = [];
  List<TaskData> delayedTasks = [];
  List<TaskData> filteredTasksList = [];
  Map<String, dynamic>? data;
  // Map<String, dynamic> analysisData = {};
  Uint8List? scatterPlotImage;
  MyUser? _currentPatient;
  var selectDate = DateTime.now();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Map<String, dynamic>? _analysisData;

  // Getter for analysis data
  Map<String, dynamic>? get analysisData => _analysisData;

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

      // Categorize tasks
      incompleteTasks = tasksList.where((task) => !task.isDone).toList();
      completeTasks = tasksList.where((task) => task.isDone).toList();
      delayedTasks = tasksList.where((task) {
        // A task is delayed if completed after its scheduled time
        return task.isDone &&
            task.completedAt != null &&
            task.completedAt!.isAfter(task.dateTime);
      }).toList();

      // filter based on date
      filteredTasksList = tasksList.where(
        (task) {
          if (selectDate.day == task.dateTime.day &&
              selectDate.month == task.dateTime.month &&
              selectDate.year == task.dateTime.year) {
            return true;
          } else {
            return false;
          }
        },
      ).toList();

      // Call the Flask API to generate analysis data
      // try {
      //   await ApiManager.generateAnalysis(uId);
      //   print("Analysis data generated successfully for user: $uId");
      // } catch (e) {
      //   print('Error calling Flask API: $e');
      // }

      // Calculate analysis data
      // calculateAnalysisData();

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
  Future<void> scheduleNotification(TaskData task) async {
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
  void sendNotification(TaskData task, String title, String body) {
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

  void updateTask(TaskData updatedTask, String uId) {
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
    var groupedTasks = groupBy(incompleteTasks, (TaskData task) {
      return DateTime(
          task.dateTime.year, task.dateTime.month, task.dateTime.day);
    });

    // Convert the grouped tasks into a map with date and count of tasks per date
    return groupedTasks.map((date, tasks) => MapEntry(date, tasks.length));
  }

  Map<DateTime, int> getCompleteTaskChartData() {
    // Group complete tasks by date
    var groupedTasks = groupBy(completeTasks, (TaskData task) {
      return DateTime(
          task.dateTime.year, task.dateTime.month, task.dateTime.day);
    });

    // Convert the grouped tasks into a map with date and count of tasks per date
    return groupedTasks.map((date, tasks) => MapEntry(date, tasks.length));
  }

  // Fetch delayed tasks only
  Map<DateTime, int> getDelayedTasks() {
    // Group complete tasks by date
    var groupedTasks = groupBy(delayedTasks, (TaskData task) {
      return DateTime(
          task.dateTime.year, task.dateTime.month, task.dateTime.day);
    });

    // Convert the grouped tasks into a map with date and count of tasks per date
    return groupedTasks.map((date, tasks) => MapEntry(date, tasks.length));

    // try {
    //   final querySnapshot = await FirebaseUtils.getTasksCollection(uId)
    //       .orderBy('dateTime', descending: false)
    //       .get();
    //   tasksList = querySnapshot.docs.map((doc) => doc.data()).toList();
    //   // Filter for delayed tasks
    //   delayedTasks = tasksList.where((task) {
    //     return task.isDone && task.completedAt != null &&
    //         task.completedAt!.isAfter(task.dateTime);
    //   }).toList();
    //   notifyListeners();
    // } catch (error) {
    //   print('Error fetching delayed tasks: $error');
    // }
  }

//   Map<DateTime, int> calculateDelays() {
//   Map<DateTime, int> delayDurations = {};
//   for (Task task in completeTasks) {
//     if (task.completedAt != null) {
//       final delayDuration = task.completedAt!.difference(task.dateTime).inMinutes;
//       if (delayDuration > 0) { // Only include delayed tasks
//         delayDurations[task.dateTime] = delayDuration;
//       }
//     }
//   }
//   return delayDurations;
// }

  Map<String, int> prepareTimeSeriesData(List<TaskData> tasks) {
    final Map<String, int> timeSeriesData = {};

    for (final task in tasks) {
      if (!task.isDone) {
        final String dateKey = DateFormat('yyyy-MM-dd').format(task.dateTime);
        timeSeriesData[dateKey] = (timeSeriesData[dateKey] ?? 0) + 1;
      }
    }

    return timeSeriesData;
  }

  Future<Map<String, dynamic>> fetchTaskSummary(String userId) async {
    final url = Uri.parse('http://127.0.0.1:5000/users/$userId/tasks-summary');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Print the decoded response for debugging
        final decodedData = json.decode(response.body);
        print('Decoded Response: $decodedData');
        return Map<String, dynamic>.from(decodedData);
      } else {
        throw Exception('Failed to load task summary');
      }
    } catch (error) {
      print('Error fetching task summary: $error');
      return {}; // Return an empty map on error
    }
  }

  List<ScatterSpot> getDelayedTasksScatterData(String userId) {
    List<ScatterSpot> scatterData = [];

    for (var task in delayedTasks) {
      // Convert task.dateTime to a timestamp (x-axis)
      double x = task.dateTime.millisecondsSinceEpoch.toDouble();

      // Calculate delay in minutes (y-axis)
      double y =
          task.completedAt!.difference(task.dateTime).inMinutes.toDouble();

      scatterData.add(ScatterSpot(x, y));
    }

    return scatterData;
  }

  // Function to fetch analysis data // first one i think correct
  // Map<String, dynamic> fetchAnalysisData() {
  //   // Calculate total tasks
  //   final totalTasks = tasksList.length;
  //   // Calculate completed tasks
  //   final completedTasks = tasksList.where((task) => task.isDone).length;
  //   // Calculate incomplete tasks
  //   final incompleteTasks = tasksList.where((task) => !task.isDone).length;
  //   // Calculate delayed tasks
  //   final delayedTasks = tasksList.where((task) {
  //     return task.isDone &&
  //         task.completedAt != null &&
  //         task.completedAt!.isAfter(task.dateTime);
  //   }).length;
  //   // Calculate average delay (in minutes) for delayed tasks
  //   final delayedTasksList = tasksList.where((task) {
  //     return task.isDone &&
  //         task.completedAt != null &&
  //         task.completedAt!.isAfter(task.dateTime);
  //   }).toList();
  //   final totalDelay = delayedTasksList.fold(0, (sum, task) {
  //     final delay = task.completedAt!.difference(task.dateTime).inMinutes;
  //     return sum + delay;
  //   });
  //   final averageDelay =
  //       delayedTasksList.isNotEmpty ? totalDelay / delayedTasksList.length : 0;
  //   // Return analysis data
  //   return {
  //     'totalTasks': totalTasks,
  //     'completedTasks': completedTasks,
  //     'incompleteTasks': incompleteTasks,
  //     'delayedTasks': delayedTasks,
  //     'averageDelay': averageDelay,
  //   };
  // }

  void calculateAnalysisData() {
    // Calculate total tasks
    final totalTasks = tasksList.length;

    // Calculate completed tasks
    final completedTasks = tasksList.where((task) => task.isDone).length;

    // Calculate incomplete tasks
    final incompleteTasks = tasksList.where((task) => !task.isDone).length;

    // Calculate delayed tasks
    final delayedTasksList = tasksList.where((task) {
      return task.isDone &&
          task.completedAt != null &&
          task.completedAt!.isAfter(task.dateTime);
    }).toList();

    // Calculate total delay
    final totalDelay =
        delayedTasksList.fold<Duration>(Duration.zero, (sum, task) {
      final delay = task.completedAt!.difference(task.dateTime);
      return sum + delay;
    });

    // Calculate average delay
    final averageDelay = delayedTasksList.isNotEmpty
        ? totalDelay ~/ delayedTasksList.length
        : Duration.zero;

    // Calculate most delayed tasks (sorted in increasing order of delay)
    final mostDelayedTasks =
        delayedTasksList.fold<Map<String, Duration>>({}, (map, task) {
      final taskTitle = task.title;
      final delay = task.completedAt!.difference(task.dateTime);
      map[taskTitle] = delay;
      return map;
    });

    // Sort most delayed tasks by delay (ascending order)
    final sortedMostDelayedTasks = Map.fromEntries(
      mostDelayedTasks.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value)),
    );

    // Calculate time of day delays (in 12-hour format)
    final timeOfDayDelays =
        delayedTasksList.fold<Map<int, int>>({}, (map, task) {
      final hour = task.dateTime.hour % 12; // Convert to 12-hour format
      map[hour] = (map[hour] ?? 0) + 1;
      return map;
    });

    // // Store analysis data
    // _analysisData = {
    //   'totalTasks': totalTasks,
    //   'completedTasks': completedTasks,
    //   'incompleteTasks': incompleteTasks,
    //   'delayedTasks': delayedTasksList.length,
    //   'averageDelay': averageDelay.inMinutes, // Store delay in minutes
    //   'mostDelayedTasks': sortedMostDelayedTasks.map((key, value) =>
    //       MapEntry(key, value.inMinutes)), // Convert delays to minutes
    //   'timeOfDayDelays': timeOfDayDelays,
    //   'timestamp': DateTime.now().toIso8601String(), // Add timestamp
    // };
    _analysisData = {
      'totalTasks': totalTasks.toString(), // Convert to String
      'completedTasks': completedTasks.toString(), // Convert to String
      'incompleteTasks': incompleteTasks.toString(), // Convert to String
      'delayedTasks': delayedTasksList.length.toString(), // Convert to String
      'averageDelay': averageDelay.inMinutes.toString(), // Convert to String
      'mostDelayedTasks': sortedMostDelayedTasks.map((key, value) =>
          MapEntry(key, value.inMinutes.toString())), // Convert to String
      'timeOfDayDelays': timeOfDayDelays.map((key, value) =>
          MapEntry(key.toString(), value.toString())), // Convert to String
      'timestamp': DateTime.now().toIso8601String(),
    };
    // Print analysis data for verification
    print('Analysis Data:');
    print('Total Tasks: $totalTasks');
    print('Completed Tasks: $completedTasks');
    print('Incomplete Tasks: $incompleteTasks');
    print('Delayed Tasks: ${delayedTasksList.length}');
    print('Average Delay: ${averageDelay.inMinutes} minutes');
    print('Most Delayed Tasks:');
    sortedMostDelayedTasks.forEach((task, delay) {
      print('$task: ${delay.inMinutes} minutes');
    });
    print('Time of Day Delays:');
    timeOfDayDelays.forEach((hour, count) {
      print('${hour % 12} ${hour < 12 ? 'AM' : 'PM'}: $count delays');
    });

    // Notify listeners to update the UI
    notifyListeners();
  }

  // Future<void> saveAnalysisDataToFirestore(String userId) async {
  //   if (_analysisData == null) {
  //     print('No analysis data to save.');
  //     return;
  //   }
  //   try {
  //     final analysisRef = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .collection('analysis')
  //         .doc(userId);
  //     await analysisRef.set(_analysisData!, SetOptions(merge: true));
  //     print('Analysis data saved to Firestore.');
  //   } catch (e) {
  //     print('Error saving analysis data to Firestore: $e');
  //   }
  // }

  Future<void> saveAnalysisDataToFirestore(String userId) async {
    if (_analysisData == null) {
      print('No analysis data to save.');
      return;
    }

    try {
      final analysisRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('analysis')
          .doc(); // Auto-generate a unique document ID

      await analysisRef.set(_analysisData!);
      print(
          'Analysis data saved to Firestore with document ID: ${analysisRef.id}');
    } catch (e) {
      print('Error saving analysis data to Firestore: $e');
    }
  }

  Future<void> calculateAndSaveAnalysisData(String userId) async {
    calculateAnalysisData(); // Calculate the analysis data
    // print("analysis data calculated");
    await saveAnalysisDataToFirestore(userId); // Save the data to Firestore
    // print("analysis data saved");
  }

  // Fetch analysis data from Firestore
  //correct
  // Future<void> fetchAnalysisData(String userId) async {
  //   try {
  //     final doc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .collection('analysis')
  //         .doc()
  //         .get();
  //     if (doc.exists) {
  //       _analysisData = doc.data();
  //       notifyListeners(); // Notify listeners that the data has been updated
  //     } else {
  //       _analysisData = null;
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print('Error fetching analysis data: $e');
  //     _analysisData = null;
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchAnalysisData(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('analysis')
          .orderBy('timestamp', descending: true) // Fetch the latest document
          .limit(1) // Limit to the most recent document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        _analysisData = doc.data();
        notifyListeners(); // Notify listeners to update the UI
        print('Analysis data fetched: $_analysisData');
      } else {
        _analysisData = null;
        notifyListeners();
        print('No analysis data found in Firestore.');
      }
    } catch (e) {
      print('Error fetching analysis data: $e');
      _analysisData = null;
      notifyListeners();
    }
  }

  // Clear analysis data
  void clearAnalysisData() {
    _analysisData = null;
    notifyListeners();
  }

  // Function to calculate and store analysis data
  // correct but the formatt
  // void calculateAnalysisData() {
  //   // Calculate total tasks
  //   final totalTasks = tasksList.length;
  //   // Calculate completed tasks
  //   final completedTasks = tasksList.where((task) => task.isDone).length;
  //   // Calculate incomplete tasks
  //   final incompleteTasks = tasksList.where((task) => !task.isDone).length;
  //   // Calculate delayed tasks
  //   final delayedTasks = tasksList.where((task) {
  //     return task.isDone &&
  //         task.completedAt != null &&
  //         task.completedAt!.isAfter(task.dateTime);
  //   }).length;
  //   // Calculate average delay (in minutes) for delayed tasks
  //   final delayedTasksList = tasksList.where((task) {
  //     return task.isDone &&
  //         task.completedAt != null &&
  //         task.completedAt!.isAfter(task.dateTime);
  //   }).toList();
  //   final totalDelay = delayedTasksList.fold(0, (sum, task) {
  //     final delay = task.completedAt!.difference(task.dateTime).inMinutes;
  //     return sum + delay;
  //   });
  //   final averageDelay = delayedTasksList.isNotEmpty
  //       ? totalDelay / delayedTasksList.length
  //       : 0;
  //   // Calculate most delayed tasks
  //   final mostDelayedTasks = delayedTasksList.fold<Map<String, double>>({}, (map, task) {
  //     final taskTitle = task.title;
  //     final delay = task.completedAt!.difference(task.dateTime).inMinutes.toDouble();
  //     map[taskTitle] = (map[taskTitle] ?? 0) + delay;
  //     return map;
  //   });
  //   // Calculate time of day delays
  //   final timeOfDayDelays = delayedTasksList.fold<Map<int, int>>({}, (map, task) {
  //     final hour = task.dateTime.hour;
  //     map[hour] = (map[hour] ?? 0) + 1;
  //     return map;
  //   });

  //   // Store analysis data
  //   analysisData = {
  //     'totalTasks': totalTasks,
  //     'completedTasks': completedTasks,
  //     'incompleteTasks': incompleteTasks,
  //     'delayedTasks': delayedTasks,
  //     'averageDelay': averageDelay,
  //     'mostDelayedTasks': mostDelayedTasks,
  //     'timeOfDayDelays': timeOfDayDelays,
  //   };

  //   // Print analysis data for verification
  //   print('Analysis Data:');
  //   print('Total Tasks: $totalTasks');
  //   print('Completed Tasks: $completedTasks');
  //   print('Incomplete Tasks: $incompleteTasks');
  //   print('Delayed Tasks: $delayedTasks');
  //   print('Average Delay: $averageDelay minutes');
  //   print('Most Delayed Tasks: $mostDelayedTasks');
  //   print('Time of Day Delays: $timeOfDayDelays');
  // }

  //correct without scatter
  // void calculateAnalysisData() {
  //   // Calculate total tasks
  //   final totalTasks = tasksList.length;

  //   // Calculate completed tasks
  //   final completedTasks = tasksList.where((task) => task.isDone).length;

  //   // Calculate incomplete tasks
  //   final incompleteTasks = tasksList.where((task) => !task.isDone).length;

  //   // Calculate delayed tasks
  //   final delayedTasksList = tasksList.where((task) {
  //     return task.isDone &&
  //         task.completedAt != null &&
  //         task.completedAt!.isAfter(task.dateTime);
  //   }).toList();

  //   // Calculate total delay
  //   final totalDelay =
  //       delayedTasksList.fold<Duration>(Duration.zero, (sum, task) {
  //     final delay = task.completedAt!.difference(task.dateTime);
  //     return sum + delay;
  //   });

  //   // Calculate average delay
  //   final averageDelay = delayedTasksList.isNotEmpty
  //       ? totalDelay ~/ delayedTasksList.length
  //       : Duration.zero;

  //   // Calculate most delayed tasks (sorted in increasing order of delay)
  //   final mostDelayedTasks =
  //       delayedTasksList.fold<Map<String, Duration>>({}, (map, task) {
  //     final taskTitle = task.title;
  //     final delay = task.completedAt!.difference(task.dateTime);
  //     map[taskTitle] = delay;
  //     return map;
  //   });

  //   // Sort most delayed tasks by delay (ascending order)
  //   final sortedMostDelayedTasks = Map.fromEntries(
  //     mostDelayedTasks.entries.toList()
  //       ..sort((a, b) => a.value.compareTo(b.value)),
  //   );

  //   // Calculate time of day delays (in 12-hour format)
  //   final timeOfDayDelays =
  //       delayedTasksList.fold<Map<int, int>>({}, (map, task) {
  //     final hour = task.dateTime.hour % 12; // Convert to 12-hour format
  //     map[hour] = (map[hour] ?? 0) + 1;
  //     return map;
  //   });

  //   // Store analysis data
  //   analysisData = {
  //     'totalTasks': totalTasks,
  //     'completedTasks': completedTasks,
  //     'incompleteTasks': incompleteTasks,
  //     'delayedTasks': delayedTasksList.length,
  //     'averageDelay': averageDelay,
  //     'mostDelayedTasks': sortedMostDelayedTasks,
  //     'timeOfDayDelays': timeOfDayDelays,
  //   };

  //   // Print analysis data for verification
  //   print('Analysis Data:');
  //   print('Total Tasks: $totalTasks');
  //   print('Completed Tasks: $completedTasks');
  //   print('Incomplete Tasks: $incompleteTasks');
  //   print('Delayed Tasks: ${delayedTasksList.length}');
  //   print('Average Delay: ${DateTimeUtils.formatDelay(averageDelay)}');
  //   print('Most Delayed Tasks:');
  //   sortedMostDelayedTasks.forEach((task, delay) {
  //     print('$task: ${DateTimeUtils.formatDelay(delay)}');
  //   });
  //   print('Time of Day Delays:');
  //   timeOfDayDelays.forEach((hour, count) {
  //     print('${hour % 12} ${hour < 12 ? 'AM' : 'PM'}: $count delays');
  //   });
  // }

  // Cache analysis data
  // Future<void> cacheAnalysisData(String userId, Map<String, dynamic> data) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('analysisData_$userId', json.encode(data));
  //   _cachedAnalysisData = data;
  //   notifyListeners(); // Notify listeners that the data has been updated
  // }

  // // Get cached analysis data
  // Future<Map<String, dynamic>?> getCachedAnalysisData(String userId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final data = prefs.getString('analysisData_$userId');
  //   if (data != null) {
  //     _cachedAnalysisData = json.decode(data);
  //     notifyListeners(); // Notify listeners that the data has been updated
  //   }
  //   return _cachedAnalysisData;
  // }

  // // Clear cached analysis data
  // Future<void> clearCachedAnalysisData(String userId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('analysisData_$userId');
  //   _cachedAnalysisData = null;
  //   notifyListeners(); // Notify listeners that the data has been cleared
  // }

  // Future<void> calculateAnalysisData() async {
  //   // Calculate total tasks
  //   final totalTasks = tasksList.length;

  //   // Calculate completed tasks
  //   final completedTasks = tasksList.where((task) => task.isDone).length;

  //   // Calculate incomplete tasks
  //   final incompleteTasks = tasksList.where((task) => !task.isDone).length;

  //   // Calculate delayed tasks
  //   final delayedTasksList = tasksList.where((task) {
  //     return task.isDone &&
  //         task.completedAt != null &&
  //         task.completedAt!.isAfter(task.dateTime);
  //   }).toList();

  //   // Calculate total delay
  //   final totalDelay =
  //       delayedTasksList.fold<Duration>(Duration.zero, (sum, task) {
  //     final delay = task.completedAt!.difference(task.dateTime);
  //     return sum + delay;
  //   });

  //   // Calculate average delay
  //   final averageDelay = delayedTasksList.isNotEmpty
  //       ? totalDelay ~/ delayedTasksList.length
  //       : Duration.zero;

  //   // Calculate most delayed tasks (sorted in increasing order of delay)
  //   final mostDelayedTasks =
  //       delayedTasksList.fold<Map<String, Duration>>({}, (map, task) {
  //     final taskTitle = task.title;
  //     final delay = task.completedAt!.difference(task.dateTime);
  //     map[taskTitle] = delay;
  //     return map;
  //   });

  //   // Sort most delayed tasks by delay (ascending order)
  //   final sortedMostDelayedTasks = Map.fromEntries(
  //     mostDelayedTasks.entries.toList()
  //       ..sort((a, b) => a.value.compareTo(b.value)),
  //   );

  //   // Calculate time of day delays (in 12-hour format)
  //   final timeOfDayDelays =
  //       delayedTasksList.fold<Map<int, int>>({}, (map, task) {
  //     final hour = task.dateTime.hour % 12; // Convert to 12-hour format
  //     map[hour] = (map[hour] ?? 0) + 1;
  //     return map;
  //   });

  //   // Fetch scatter plot image
  //   final scatterPlotPath = data?['scatter_plot_path'];
  //   Uint8List? scatterPlotImage;

  //   if (scatterPlotPath is String) {
  //     // Ensure scatterPlotPath is a String
  //     final file = File(scatterPlotPath);
  //     if (await file.exists()) {
  //       scatterPlotImage = await file.readAsBytes();
  //     } else {
  //       print('Scatter plot file does not exist at path: $scatterPlotPath');
  //     }
  //   } else {
  //     print('Invalid scatter plot path type: ${scatterPlotPath.runtimeType}');
  //   }

  //   // Store analysis data
  //   analysisData = {
  //     'totalTasks': totalTasks,
  //     'completedTasks': completedTasks,
  //     'incompleteTasks': incompleteTasks,
  //     'delayedTasks': delayedTasksList.length,
  //     'averageDelay': averageDelay,
  //     'mostDelayedTasks': sortedMostDelayedTasks,
  //     'timeOfDayDelays': timeOfDayDelays,
  //     'scatterPlotImage': scatterPlotImage, // Include scatter plot image
  //   };

  //   // Print analysis data for verification
  //   print('Analysis Data:');
  //   print('Total Tasks: $totalTasks');
  //   print('Completed Tasks: $completedTasks');
  //   print('Incomplete Tasks: $incompleteTasks');
  //   print('Delayed Tasks: ${delayedTasksList.length}');
  //   print('Average Delay: ${DateTimeUtils.formatDelay(averageDelay)}');
  //   print('Most Delayed Tasks:');
  //   sortedMostDelayedTasks.forEach((task, delay) {
  //     print('$task: ${DateTimeUtils.formatDelay(delay)}');
  //   });
  //   print('Time of Day Delays:');
  //   timeOfDayDelays.forEach((hour, count) {
  //     print('${hour % 12} ${hour < 12 ? 'AM' : 'PM'}: $count delays');
  //   });
  //   print(
  //       'Scatter Plot Image: ${scatterPlotImage != null ? "Available" : "Not Available"}');
  // }

// Future<void> fetchData() async {
  //   final response = await http.get(
  //     Uri.parse('http://127.0.0.1:5000/analyze'),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //   if (response.statusCode == 200) {
  //     data = response.body;
  //     notifyListeners(); // Notify listeners to rebuild UI
  //   } else {
  //     throw Exception('Failed to fetch data');
  //   }
  // }

// Future<void> fetchAnalysisData(List<Task> tasks) async {
//   final url = Uri.parse('http://127.0.0.1:5000/analyze');
//   final jsonTasks = tasks.map((task) => task.toFirestore()).toList();
//   try {
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(jsonTasks),
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final dates = data['dates'];
//       final counts = data['counts'];
//       // Use dates and counts to visualize the time series
//     } else {
//       print('Error: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Exception: $e');
//   }
// }
}
