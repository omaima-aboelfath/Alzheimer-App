import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graduation_app/utils/dialog_utils.dart';
import 'package:graduation_app/utils/firebase_utils.dart';
import 'package:graduation_app/model/task_data.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/screens/theming/app_colors.dart';
import 'package:graduation_app/utils/local_notification_service.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  static const String routeName = 'add_task';

  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String title = '';
  String description = '';
  var formKey = GlobalKey<FormState>();
  DateTime? _dateTime;
  late TaskProvider listProvider; // global
  String selectedPriority = '';
  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task',
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.16),
                Text(
                  'Add Task Title',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'please enter task title'; // field invalid
                        }
                        return null; // field valid
                      },
                      onChanged: (text) {
                        title = text;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                        fillColor: AppColors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: AppColors.mediumBlue, width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: AppColors.mediumBlue, width: 1.5)),
                      )),
                ),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'please enter task description'; // field invalid
                        }
                        return null; // field valid
                      },
                      onChanged: (text) {
                        description = text;
                      },
                      maxLines: 3,
                      decoration: InputDecoration(
                        fillColor: AppColors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: AppColors.mediumBlue, width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: AppColors.mediumBlue, width: 1.5)),
                      )),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? dateTime =
                        await showOmniDateTimePicker(context: context);
                    // Use dateTime here
                    debugPrint('dateTime: $dateTime');
                    setState(() {
                      _dateTime = dateTime;
                    });
                  },
                  child: Text('Select the date and time',
                      style: Theme.of(context).textTheme.displaySmall),
                ),
                Text(
                    _dateTime != null
                        ? ("Date selected: ${DateFormat('dd-MM-yyyy hh:mm a').format(_dateTime!)}")
                        : 'No date selected',
                    style: _dateTime != null
                        ? Theme.of(context).textTheme.bodySmall
                        : Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.red)),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.lightBlue),
                    ),
                    onPressed: () {
                      addTask();
                    },
                    child: Text('Submit',
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //before add scheduled task
  // void addTask() {
  //   // validate() has forloop to loop on validators that i make
  //   // if we return string => invalid => validate will return false
  //   if (formKey.currentState?.validate() == true) {
  //     var userProvider = Provider.of<UserProvider>(context, listen: false);
  //     if (_dateTime == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Please select a date and time'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       return;
  //     }
  //     String formattedDateTime =
  //         DateFormat('dd-MM-yyyy hh:mm a').format(_dateTime!);
  //     Task task = Task(
  //       title: title,
  //       description: description,
  //       dateTime: _dateTime!,
  //       // formattedDateTime: formattedDateTime
  //     ); //selectDate
  //     FirebaseUtils.addTaskToFireStore(task,
  //             userProvider.currentUser!.id) //, userProvider.currentUser!.id
  //         // online
  //         .then(
  //       (value) async {
  //         await listProvider
  //             .getAllTasksFromFireStore(userProvider.currentUser!.id);
  //         // Schedule the notification after adding the task
  //         await listProvider.scheduleNotification(task);
  //         Navigator.pushReplacementNamed(context, PatientScreen.routeName);
  //         print('task added successfully');
  //         print(task.id);
  //         print(task.title + task.description);
  //         // Navigator.pop(context); // to close bottomSheet after adding task
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Task added successfully')),
  //         );
  //       },
  //     )
  //         // offline
  //         .timeout(
  //       // after one sec will print
  //       const Duration(seconds: 1),
  //       onTimeout: () {
  //         print('task added successfully');
  //         Navigator.pop(context); // to close bottomSheet after adding task
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Task added successfully')),
  //         );
  //         // print(task.id);
  //         // هيجيب الكولكشن كلها بما فيها المهمة الجديدة اللي اتضافت
  //         listProvider.getAllTasksFromFireStore(userProvider
  //             .currentUser!.id); // update list when clicking the button
  //         //getAllTasksFromFireStore(userProvider.currentUser!.id)
  //       },
  //     );
  //   }
  // }

  void addTask() {
    // validate() has forloop to loop on validators that i make
    // if we return string => invalid => validate will return false
    if (formKey.currentState?.validate() == true) {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      if (_dateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date and time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // String formattedDateTime =
      //     DateFormat('dd-MM-yyyy hh:mm a').format(_dateTime!);
      TaskData task = TaskData(
        title: title,
        description: description,
        dateTime: _dateTime!,
        priority: selectedPriority,
        // formattedDateTime: formattedDateTime
      ); //selectDate
      // FirebaseUtils.addTaskToFireStore(task, userProvider.currentUser!.id)
      FirebaseUtils.addTaskToFireStore(
              task, userProvider.currentUser!.id, userProvider.currentUser!)

          // online
          .then(
        (value) async {
          await listProvider
              .getAllTasksFromFireStore(userProvider.currentUser!.id);
          // // Schedule the notification after adding the task
          // // await listProvider.scheduleNotification(task);
          DialogUtils.showMessage(
              context: context,
              title: 'Success',
              message: 'Task Added successfully',
              titleColor: AppColors.greenColor,
              onClose: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context, PatientScreen.routeName);
              });
          // Navigator.pushReplacementNamed(context, PatientScreen.routeName);
          print('task added successfully');
          print(task.id);
          print('${task.title} ${task.description}');
          LocalNotificationService.showScheduledNotification(
              currentDate: _dateTime!);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Task added successfully'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
        },
      );
      // offline
      //     .timeout(
      //   // after one sec will print
      //   const Duration(seconds: 1),
      //   onTimeout: () {
      //     print('task added successfully');
      //     Navigator.pop(context); // to close bottomSheet after adding task
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Task added successfully')),
      //     );
      //     // print(task.id);
      //     // هيجيب الكولكشن كلها بما فيها المهمة الجديدة اللي اتضافت
      //     listProvider.getAllTasksFromFireStore(userProvider
      //         .currentUser!.id); // update list when clicking the button
      //     //getAllTasksFromFireStore(userProvider.currentUser!.id)
      //   },
      // );
    }
  }
}
