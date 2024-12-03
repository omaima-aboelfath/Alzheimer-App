import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/auth/login_screen.dart';
import 'package:graduation_app/screens/location_tracker.dart';
import 'package:graduation_app/screens/task_list/add_task_screen.dart';
import 'package:graduation_app/screens/task_list/task_list_item.dart';
import 'package:graduation_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // Fetch tasks when the screen initializes
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    Provider.of<TaskProvider>(context, listen: false)
        .getAllTasksFromFireStore(userId)
        .then((_) {
      setState(() {
        _isLoading = false; // Data has been fetched
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<TaskProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    // if (listProvider.tasksList.isEmpty) {
    //   listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id);
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient, ${userProvider.currentUser!.name}',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, AddTaskScreen.routeName);
          //     },
          //     icon: const Icon(
          //       Icons.add_circle_outline_sharp,
          //       color: AppColors.white,
          //       size: 35,
          //     )),
          IconButton(
              tooltip:
                  'Log Out', // This will display "Log Out" when hovered or long-pressed.
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              icon: const Icon(
                Icons.logout,
                color: AppColors.white,
                size: 35,
              ))
        ],
      ),
      // body:
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Expanded(
      //       child: listProvider.tasksList.isEmpty
      //           ? Padding(
      //               padding: const EdgeInsets.all(100),
      //               child: Center(
      //                   child: Text(
      //                 "No Tasks Added",
      //                 style: Theme.of(context)
      //                     .textTheme
      //                     .bodySmall!
      //                     .copyWith(fontSize: 25, fontWeight: FontWeight.w600),
      //               )),
      //             )
      //           : ListView.builder(
      //               itemBuilder: (context, index) {
      //                 return TaskListItem(
      //                   // access data inside list
      //                   task: listProvider.tasksList[index],
      //                 );
      //               },
      //               itemCount: listProvider.tasksList.length,
      //             ),
      //     ),
      //   ],
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: listProvider.tasksList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(100),
                          child: Center(
                              child: Text(
                            "No Tasks Added",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                          )),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return TaskListItem(
                              // access data inside list
                              task: listProvider.tasksList[index],
                            );
                          },
                          itemCount: listProvider.tasksList.length,
                        ),
                ),
                // Add the button for GPS module
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => LocationTracker()),
                //     );
                //   },
                //   child: const Text('Open GPS Module'),
                // ),
              ],
            ),
    );
  }
}
