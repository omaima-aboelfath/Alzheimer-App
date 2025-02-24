// data class

import 'package:graduation_app/utils/date_time_utils.dart';

class TaskData {
  static const String collectionName = 'tasks';
  String id; // to get each task, not required to use auto-id
  String title;
  String description;
  DateTime dateTime;
  bool isDone;
  String priority; // "High", "Medium", "Low"
  String? taskType; // "Appoitment", "Reminder(medication)", "Event"
  DateTime? completedAt; // Nullable, only set when task is completed
  String? delay; // Nullable, stores delay as a human-readable string


  // String formattedDateTime;
  TaskData({
    this.id = '',
    required this.title,
    required this.description,
    required this.dateTime,
    this.isDone = false,
    this.priority = 'Low',
    this.completedAt,
    this.delay,
    this.taskType
    // required this.formattedDateTime
  });

  // Calculate the delay when marking a task as completed
  void calculateAndSetDelay() {
    if (completedAt != null) {
      final duration = completedAt!.difference(dateTime);
      delay = duration.isNegative
          ? 'Completed on time'
          : DateTimeUtils.formatDelay(duration);
    } else {
      delay = null;
    }
  }

  // take data from firebase : json => object
  // send data to firebase : object => json

  // json to object
  TaskData
.fromFireStore(Map<String, dynamic> map)
      : this(
          id: map['id'] as String, // casting 'optional'
          title: map['title'],
          description: map['description'],
          dateTime: DateTime.fromMillisecondsSinceEpoch(
              map['dateTime']), // to convert int to DateTime
          isDone: map['isDone'],
          priority: map['priority'] ?? 'Low',
          completedAt: map['completedAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'])
              : null,
          delay: map['delay'], // Retrieve delay from Firestore   
          taskType: map['taskType'], 
          // formattedDateTime: map['formattedDateTime']
        );

  // object => json = map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch, // to convert DateTime to int
      'isDone': isDone,
      'priority': priority,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'delay': delay, // Save delay to Firestore
      'taskType': taskType,
      // 'formattedDateTime': formattedDateTime
    };
  }
}
