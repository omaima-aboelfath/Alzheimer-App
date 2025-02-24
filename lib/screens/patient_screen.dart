/*
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/location_tracker.dart';
import 'package:graduation_app/screens/task_list/add_task_screen.dart';
import 'package:graduation_app/screens/task_list/tasks_list.dart';
import 'package:graduation_app/utils/theming/app_colors.dart';
import 'package:provider/provider.dart';

class PatientScreen extends StatefulWidget {
  static const String routeName = 'PatientScreen';

  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  // bool _isLoading = true;
  int selectedIndex = 0;

  final List<Widget> screens = [
    TasksList(), // Screen for tasks
    AddTaskScreen(),
    LocationTracker(), // Screen for GPS functionality
    // StatisticsScreen(), // Suggestion: Display charts or stats
    // SettingsScreen(),   // Suggestion: App settings or profile
  ];

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the screen initializes
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    // Provider.of<TaskProvider>(context, listen: false).getAllTasksFromFireStore(userId).then((_) {
    //   setState(() {
    //     _isLoading = false; // Data has been fetched
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<TaskProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    // if (listProvider.tasksList.isEmpty) {
    //   listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id);
    // }
    return Scaffold(
        // without navigation bar
        // body:_isLoading
        //       ? const Center(child: CircularProgressIndicator())
        //       :
        //   Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Expanded(
        //         child: listProvider.tasksList.isEmpty
        //             ? Padding(
        //                 padding: const EdgeInsets.all(100),
        //                 child: Center(
        //                     child: Text(
        //                   "No Tasks Added",
        //                   style: Theme.of(context)
        //                       .textTheme
        //                       .bodySmall!
        //                       .copyWith(fontSize: 25, fontWeight: FontWeight.w600),
        //                 )),
        //               )
        //             : ListView.builder(
        //                 itemBuilder: (context, index) {
        //                   return TaskListItem(
        //                     // access data inside list
        //                     task: listProvider.tasksList[index],
        //                   );
        //                 },
        //                 itemCount: listProvider.tasksList.length,
        //               ),
        //       ),
        //       // Add the button for GPS module
        //       ElevatedButton(
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => LocationTracker()),
        //           );
        //         },
        //         child: const Text('Open GPS Module'),
        //       ),
        //     ],
        //   ),

        ////  labeled navigtion bar(curved)
        // body: screens[selectedIndex],
        // bottomNavigationBar: CurvedNavigationBar(
        //   backgroundColor: Colors.transparent,
        //   buttonBackgroundColor: AppColors.lightBlue,
        //   color: AppColors.lightBlue,
        //   animationCurve: Curves.easeIn,
        //   items: [
        //     CurvedNavigationBarItem(
        //       child: Icon(
        //         Icons.task_alt_rounded,
        //         color: AppColors.white,
        //       ),
        //       label: 'Tasks',
        //       labelStyle: Theme.of(context)
        //           .textTheme
        //           .bodySmall!
        //           .copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
        //     ),
        //     CurvedNavigationBarItem(
        //       child: Icon(
        //         Icons.add_circle,
        //         color: AppColors.white,
        //       ),
        //       label: 'Add Task',
        //       labelStyle: Theme.of(context)
        //           .textTheme
        //           .bodySmall!
        //           .copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
        //     ),
        //     CurvedNavigationBarItem(
        //       child: Icon(
        //         Icons.location_on,
        //         color: AppColors.white,
        //       ),
        //       label: 'Location',
        //       labelStyle: Theme.of(context)
        //           .textTheme
        //           .bodySmall!
        //           .copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
        //     ),
        //   ],
        //   onTap: (index) {
        //     setState(() {
        //       selectedIndex = index;
        //       print("Navigated to screen $index"); // Debugging
        //     });
        //   },
        // ),

        ///
        body: screens[selectedIndex],
        bottomNavigationBar: ConvexAppBar(
          height: 55,
          activeColor: AppColors.white,
          backgroundColor: AppColors.lightBlue,
          curve: Curves.easeInOutBack,
          style: TabStyle.react,
          items: [
            TabItem(
              icon: Icon(
                Icons.task_alt_rounded,
                color: AppColors.white,
              ),
              title: 'Tasks',
              isIconBlend: true,
              // labelStyle: Theme.of(context)
              //     .textTheme
              //     .bodySmall!
              //     .copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
            ),
            TabItem(
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColors.white,
                  // size: 50,
                ),
                title: 'Add Task',
                isIconBlend: true
                // labelStyle: Theme.of(context)
                //     .textTheme
                //     .bodySmall!
                //     .copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
                ),
            TabItem(
                icon: Icon(
                  Icons.location_on,
                  color: AppColors.white,
                ),
                title: 'Location',
                isIconBlend: true
                // labelStyle: Theme.of(context)
                //     .textTheme
                //     .bodySmall!
                //     .copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
                ),
          ],
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
        ));
  }
}
*/

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/location_tracker.dart';
import 'package:graduation_app/screens/task_list/add_task_screen.dart';
import 'package:graduation_app/screens/task_list/tasks_list.dart';
import 'package:provider/provider.dart';

import 'theming/app_colors.dart';

class PatientScreen extends StatefulWidget {
  static const String routeName = 'PatientScreen';

  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  int selectedIndex = 0;
  // Fetch patientId from UserProvider
  late String patientId;
  final List<Widget> screens = [];
  // final List<Widget> screens = [
  //   TasksList(), // Screen for tasks
  //   AddTaskScreen(),
  //   LocationTracker(), // Screen for GPS functionality
  //   // Additional screens can be added here
  // ];

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the screen initializes
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    // Get the patientId from UserProvider
    patientId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    // Initialize screens with the patientId passed to LocationTracker
    screens.addAll([
      TasksList(), // Screen for tasks
      AddTaskScreen(),
      LocationTracker(
          patientId: patientId), // Pass patientId to LocationTracker
    ]);
    // Fetch tasks from Firestore (uncomment if needed)
    // Provider.of<TaskProvider>(context, listen: false).getAllTasksFromFireStore(userId).then((_) {
    //   setState(() {
    //     _isLoading = false; // Data has been fetched
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<TaskProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
        body: screens[selectedIndex],
        bottomNavigationBar: ConvexAppBar(
          height: 55,
          activeColor: AppColors.white,
          backgroundColor: AppColors.lightBlue,
          curve: Curves.easeInOutBack,
          style: TabStyle.react,
          items: [
            TabItem(
              icon: Icon(
                Icons.task_alt_rounded,
                color: AppColors.white,
              ),
              title: 'Tasks',
              isIconBlend: true,
            ),
            TabItem(
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.white,
              ),
              title: 'Add Task',
              isIconBlend: true,
            ),
            TabItem(
              icon: Icon(
                Icons.location_on,
                color: AppColors.white,
              ),
              title: 'Location',
              isIconBlend: true,
            ),
          ],
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            // Navigate to the LocationTracker screen and pass patientId
            // if (index == 2) { // If the index is for the location screen
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => LocationTracker(patientId: patientId),
            //     ),
            //   );
            // }
          },
        ));
  }
}
