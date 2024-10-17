import 'package:flutter/material.dart';
import 'package:graduation_app/firebase_utils.dart';
import 'package:graduation_app/model/task_data.dart';
import 'package:graduation_app/providers/list_provider.dart';
import 'package:graduation_app/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskListItem extends StatelessWidget {
  Task task;
  TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              color: AppColors.lightBlue,
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
                    style: Theme.of(context).textTheme.bodyMedium
                    // task.isDone == true
                    //     ? AppColors.greenColor
                    //     : AppColors.primaryColor

                    ),
                Text(DateFormat('dd-MM-yyyy hh:mm a').format(task.dateTime),
                    // 'task1 date & time',
                    // task.dateTime.toString(),
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            )),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.redColor
                  ),
              child:
                  //  task.isDone
                  //     ?
                  //  TextButton(
                  //     onPressed: ()  { //async
                  //       // // Toggle isDone state
                  //       // task.isDone = !task.isDone;
                  //       // // Update task in Firestore
                  //       // await FirebaseFirestore.instance
                  //       //     .collection('tasks')
                  //       //     .doc(task.id)
                  //       //     .update({'isDone': task.isDone});
                  //       // // Notify listeners (Provider) to update UI
                  //       // Provider.of<ListProvider>(context, listen: false)
                  //       //     .updateTask(task, userProvider.currentUser!.id);
                  //     },
                  //     child: Text(
                  //       "Done!",
                  //       style: TextStyle(
                  //         color: AppColors.greenColor,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 24,
                  //       ),
                  //     ),
                  //   )
                  // :
                  IconButton(
                onPressed: () {
                  // delete task
                  FirebaseUtils.deleteTaskFromFireStore(
                    task,
                    task.id,
                  ) // userProvider.currentUser!.id
                      // online
                      .then(
                    (value) {
                      print('task deleted successfully');
                      // print list after deleting task
                      listProvider
                          .getAllTasksFromFireStore(); //userProvider.currentUser!.id
                    },
                  );

                  //async
                  // If isDone is true, it will become false, and vice versa.
                  // This ensures that clicking the button again will return the task to its initial state.
                  // task.isDone = !task.isDone;
                  // // Update task in Firestore
                  // await FirebaseFirestore.instance
                  //     .collection('tasks')
                  //     .doc(task.id)
                  //     .update({'isDone': task.isDone});
                  // // Notify listeners (Provider) to update UI
                  // Provider.of<ListProvider>(context, listen: false)
                  //     .updateTask(task, userProvider.currentUser!.id);
                },
                icon: Icon(
                  Icons.delete,
                  color: AppColors.white,
                  size: 35,
                ),
              ),
            ),
            SizedBox(
              width: 0.01 * MediaQuery.of(context).size.width,
            ),
            Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.lightBlue
                    // color: task.isDone == true
                    //     ? AppColors.whiteColor
                    //     : AppColors.primaryColor
                    ),
                child:
                    //  task.isDone
                    //     ?
                    //  TextButton(
                    //     onPressed: ()  { //async
                    //       // // Toggle isDone state
                    //       // task.isDone = !task.isDone;
                    //       // // Update task in Firestore
                    //       // await FirebaseFirestore.instance
                    //       //     .collection('tasks')
                    //       //     .doc(task.id)
                    //       //     .update({'isDone': task.isDone});
                    //       // // Notify listeners (Provider) to update UI
                    //       // Provider.of<ListProvider>(context, listen: false)
                    //       //     .updateTask(task, userProvider.currentUser!.id);
                    //     },
                    //     child: Text(
                    //       "Done!",
                    //       style: TextStyle(
                    //         color: AppColors.greenColor,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 24,
                    //       ),
                    //     ),
                    //   )
                    // :
                    IconButton(
                  onPressed: () {
                    //async
                    // If isDone is true, it will become false, and vice versa.
                    // This ensures that clicking the button again will return the task to its initial state.
                    // task.isDone = !task.isDone;
                    // // Update task in Firestore
                    // await FirebaseFirestore.instance
                    //     .collection('tasks')
                    //     .doc(task.id)
                    //     .update({'isDone': task.isDone});
                    // // Notify listeners (Provider) to update UI
                    // Provider.of<ListProvider>(context, listen: false)
                    //     .updateTask(task, userProvider.currentUser!.id);
                  },
                  icon: Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: 35,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
