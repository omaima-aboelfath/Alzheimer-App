import 'package:flutter/material.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/utils/app_colors.dart';

class TaskslistScreen extends StatelessWidget {
  static const String routeName = 'tasks-list';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, PatientScreen.routeName),
              icon: Icon(Icons.add)),
          // Container(
          //   padding: EdgeInsets.all(14),
          //   child: Expanded(
          //     // flex: 1,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text('task1 title',
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .bodySmall!
          //                 .copyWith(fontSize: 25)),
          //         Text('description1',
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .bodySmall!
          //                 .copyWith(fontSize: 30)),
          //       ],
          //     ),
          //   ),
          //   height: 0.16 * height,
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //       color: AppColors.white,
          //       borderRadius: BorderRadius.circular(15),
          //       border: Border.all(color: AppColors.lightBlue)),
          // ),
        Container(
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
                color: 
                     AppColors.lightBlue,
                height: MediaQuery.of(context).size.height * 0.1,
                width: 4,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'task1',
                    // task.title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.darkBlue
                        // task.isDone == true
                        //     ? AppColors.greenColor
                        //     : AppColors.primaryColor
                            ),
                  ),
                  Text(
                    'task1 date & time',
                    // task.description,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color:  AppColors.darkBlue,
                        ),
                  ),
                ],
              )),
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
                          onPressed: ()  { //async
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
                        ))
            ],
          ),
        ),
        ],
      ),
    );
  }
}
