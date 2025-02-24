import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/utils/date_time_utils.dart';
import 'package:graduation_app/utils/firebase_utils.dart';
import 'package:graduation_app/model/task_data.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/theming/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/dialog_utils.dart';

class TaskListItem extends StatelessWidget {
  TaskData task;
  TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<TaskProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final taskColor = task.isDone ? AppColors.greenColor : AppColors.lightBlue;
    final taskColor = (task.completedAt != null &&
            task.completedAt!
                .isAfter(task.dateTime)) //delayed & completed tasks
        ? AppColors.greenColor
        : task.isDone
            ? AppColors.greenColor
            : AppColors.darkBlue;
    // final taskDetailsColor =
    //     task.isDone ? AppColors.greenColor : AppColors.darkBlue;
    final taskDetailsColor = (task.completedAt != null &&
            task.completedAt!
                .isAfter(task.dateTime)) //delayed & completed tasks
        ? AppColors.greenColor
        : task.isDone
            ? AppColors.greenColor
            : AppColors.darkBlue;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.white,
            border: Border.all(color: AppColors.mediumBlue)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              color: taskColor,
              height: MediaQuery.of(context).size.height * 0.1,
              width: 4,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    // 'task1',
                    task.title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: taskDetailsColor,
                        )),
                Text(DateFormat('dd-MM-yyyy hh:mm a').format(task.dateTime),
                    // 'task1 date & time',
                    // task.dateTime.toString(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: taskDetailsColor,
                        )),
                if (task.completedAt !=
                    null) // Show completion time if available
                  Text(
                    'Completed At: ${DateTimeUtils.format(task.completedAt!)}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: isTaskDelayed(task)
                              ? AppColors.redColor
                              : AppColors.greenColor,
                        ),
                  ),
                // if (isTaskDelayed(task))
                //   Text(
                //     'Delayed for ${DateTimeUtils.formatDelay(task.completedAt!.difference(task.dateTime))}',
                //     style: Theme.of(context).textTheme.bodySmall!.copyWith(
                //           color: AppColors.redColor,
                //         ),
                //   ),
              ],
            )),
            // my code
            // Container(
            //   // padding: const EdgeInsets.symmetric(
            //   //   horizontal: 8,
            //   // ),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(15),
            //       color: AppColors.redColor),
            //   child: IconButton(
            //     onPressed: () {
            //       // delete task
            //       FirebaseUtils.deleteTaskFromFireStore(
            //         task,
            //         task.id,
            //         userProvider.currentUser!.id,
            //       )
            //           // online
            //           .then(
            //         (value) {
            //           print('task deleted successfully');
            //           // print list after deleting task
            //           listProvider.getAllTasksFromFireStore(userProvider
            //               .currentUser!.id); //userProvider.currentUser!.id
            //         },
            //       );
            //     },
            //     icon: const Icon(
            //       Icons.delete,
            //       color: AppColors.white,
            //       size: 35,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: 0.01 * MediaQuery.of(context).size.width,
            // ),
            // Container(
            //     // padding: const EdgeInsets.symmetric(
            //     //   horizontal: 8,
            //     // ),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(15),
            //         // color: AppColors.lightBlue
            //         color: task.isDone == true
            //             ? AppColors.greenColor
            //             : AppColors.lightBlue),
            //     child: task.isDone
            //         // ? TextButton(
            //         //     onPressed: () async {
            //         //       // Toggle isDone state
            //         //       task.isDone = !task.isDone;
            //         //       // Update task in Firestore
            //         //       await FirebaseFirestore.instance
            //         //           .collection('users')
            //         //           .doc(userProvider.currentUser!.id)
            //         //           .collection('tasks')
            //         //           .doc(task.id)
            //         //           .update({'isDone': task.isDone});
            //         //       // Notify listeners (Provider) to update UI
            //         //       Provider.of<ListProvider>(context, listen: false)
            //         //           .updateTask(
            //         //               task,
            //         //               userProvider.currentUser!
            //         //                   .id); //, userProvider.currentUser!.id
            //         //     },
            //         //     child: Text(
            //         //       "Done!",
            //         //       style: TextStyle(
            //         //         color: AppColors.greenColor,
            //         //         fontWeight: FontWeight.bold,
            //         //         fontSize: 22,
            //         //       ),
            //         //     ),
            //         //   ),
            //         ? IconButton(
            //             onPressed: () async {
            //               // Toggle isDone state
            //               task.isDone = !task.isDone;
            //               // Update task in Firestore
            //               await FirebaseFirestore.instance
            //                   .collection('users')
            //                   .doc(userProvider.currentUser!.id)
            //                   .collection('tasks')
            //                   .doc(task.id)
            //                   .update({'isDone': task.isDone});
            //               // Notify listeners (Provider) to update UI
            //               Provider.of<TaskProvider>(context, listen: false)
            //                   .updateTask(
            //                       task,
            //                       userProvider.currentUser!
            //                           .id); //, userProvider.currentUser!.id
            //             },
            //             icon: const Icon(
            //               Icons.check,
            //               color: AppColors.white,
            //               size: 35,
            //             ),
            //           )
            //         : IconButton(
            //             onPressed: () async {
            //               try {
            //                 // If isDone is true, it will become false, and vice versa.
            //                 // This ensures that clicking the button again will return the task to its initial state.
            //                 task.isDone = !task.isDone;
            //                 // Update task in Firestore
            //                 await FirebaseFirestore.instance
            //                     .collection('users')
            //                     .doc(userProvider.currentUser!.id)
            //                     .collection('tasks')
            //                     .doc(task.id)
            //                     .update({'isDone': task.isDone});
            //                 // // Fetch updated task list after Firestore update
            //                 // listProvider.getAllTasksFromFireStore(
            //                 //     userProvider.currentUser!.id);
            //                 // Notify listeners (Provider) to update UI
            //                 Provider.of<TaskProvider>(context, listen: false)
            //                     .updateTask(
            //                         task,
            //                         userProvider.currentUser!
            //                             .id); //, userProvider.currentUser!.id
            //               } catch (e) {
            //                 print('Error updating task: $e');
            //               }
            //             },
            //             icon: const Icon(
            //               Icons.check,
            //               color: AppColors.white,
            //               size: 35,
            //             ),
            //           )),
            /////***** */

            // good
            // // Delete Task Button
            // IconButton(
            //   onPressed: () async {
            //     try {
            //       await FirebaseUtils.deleteTaskFromFireStore(
            //         task,
            //         task.id,
            //         userProvider.currentUser!.id,
            //       );
            //       listProvider
            //           .getAllTasksFromFireStore(userProvider.currentUser!.id);
            //       DialogHelper.showModal(
            //           context: context,
            //           message: 'Task deleted successfully',
            //           messageColor: AppColors.redColor);
            //       print('Task deleted successfully');
            //     } catch (e) {
            //       print('Error deleting task: $e');
            //     }
            //   },
            //   icon: const Icon(Icons.delete, color: AppColors.white, size: 35),
            //   color: AppColors.redColor,
            // ),
            // const SizedBox(width: 8),
            // // Mark as Done/Undone Button
            // ElevatedButton(
            //   onPressed: () async {
            //     try {
            //       if (!task.isDone) {
            //         task.isDone = true;
            //         task.completedAt = DateTime.now();
            //         await FirebaseFirestore.instance
            //             .collection('users')
            //             .doc(userProvider.currentUser!.id)
            //             .collection('tasks')
            //             .doc(task.id)
            //             .update({
            //           'isDone': task.isDone,
            //           'completedAt': task.completedAt!.millisecondsSinceEpoch,
            //         });
            //       } else {
            //         // Undo completed state
            //         task.isDone = false;
            //         task.completedAt = null;
            //         await FirebaseFirestore.instance
            //             .collection('users')
            //             .doc(userProvider.currentUser!.id)
            //             .collection('tasks')
            //             .doc(task.id)
            //             .update({
            //           'isDone': task.isDone,
            //           'completedAt': null,
            //         });
            //       }
            //       listProvider.updateTask(task, userProvider.currentUser!.id);
            //     } catch (e) {
            //       print('Error updating task: $e');
            //     }
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: taskColor,
            //   ),
            //   child: Text(
            //     task.isDone ? 'Completed' : 'Mark as Done',
            //     style: const TextStyle(
            //       color: AppColors.white,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),

            // Delete Task Button
            // Container(
            //   // decoration: BoxDecoration(
            //   //   borderRadius: BorderRadius.circular(15),
            //   //   color: AppColors.redColor,
            //   // ),
            //   child:

            IconButton(
              onPressed: () async {
                try {
                  await FirebaseUtils.deleteTaskFromFireStore(
                    task,
                    task.id,
                    userProvider.currentUser!.id,
                  );
                  listProvider
                      .getAllTasksFromFireStore(userProvider.currentUser!.id);
                  DialogUtils.showMessage(
                    context: context,
                    title: 'Success',
                    message: 'Task deleted successfully',
                    titleColor: AppColors.greenColor,
                  );
                  print('Task deleted successfully');
                } catch (e) {
                  DialogUtils.showMessage(
                    context: context,
                    title: 'Error',
                    message: 'Error deleting task: $e',
                    titleColor: AppColors.redColor,
                  );
                  print('Error deleting task: $e');
                }
              },
              icon: const Icon(
                Icons.delete,
                // color: AppColors.white,
                color: AppColors.greyColor,
                size: 35,
              ),
            ),
            // ),
            // SizedBox(
            //   width: 0.00000001 * MediaQuery.of(context).size.width,
            // ),
            // Mark as Done/Undone Button
            // Container(
            //   // decoration: BoxDecoration(
            //   //   borderRadius: BorderRadius.circular(15),
            //   //   color: task.isDone ? AppColors.greenColor : AppColors.lightBlue,
            //   // ),
            //   child:
            IconButton(
              onPressed: () async {
                try {
                  if (!task.isDone) {
                    // Mark as done
                    task.isDone = true;
                    task.completedAt = DateTime.now();
                    // Calculate the delay
                    final delay = task.completedAt!.difference(task.dateTime);
                    task.delay = delay.isNegative
                        ? 'Completed on time'
                        : DateTimeUtils.formatDelay(delay);
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userProvider.currentUser!.id)
                        .collection('tasks')
                        .doc(task.id)
                        .update({
                      'isDone': task.isDone,
                      'completedAt': task.completedAt!.millisecondsSinceEpoch,
                      'delay': task.delay,
                    });
                  } else {
                    // Undo mark as done
                    task.isDone = false;
                    task.completedAt = null;
                    task.delay = null;

                    // Update Firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userProvider.currentUser!.id)
                        .collection('tasks')
                        .doc(task.id)
                        .update({
                      'isDone': task.isDone,
                      'completedAt': null,
                      'delay': null,
                    });
                  }
                  listProvider.updateTask(task, userProvider.currentUser!.id);
                } catch (e) {
                  print('Error updating task: $e');
                }
              },
              icon: Icon(
                task.isDone ? Icons.check_box : Icons.check_box_outlined,
                // color:AppColors.white,
                color: task.isDone ? AppColors.greenColor : AppColors.greyColor,
                size: 35,
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }

  /// Determines if the task was completed late
  bool isTaskDelayed(TaskData task) {
    if (task.completedAt != null) {
      return task.completedAt!.isAfter(task.dateTime);
    }
    return false;
  }
}
