// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:graduation_app/providers/task_provider.dart';
// import 'package:graduation_app/providers/user_provider.dart';
// import 'package:graduation_app/screens/auth/login_screen.dart';
// import 'package:graduation_app/screens/task_list/task_list_item.dart';
// import 'package:graduation_app/screens/theming/app_colors.dart';
// import 'package:provider/provider.dart';
// import '../../utils/dialog_utils.dart';

// class TasksList extends StatefulWidget {
//   const TasksList({super.key});

//   @override
//   State<TasksList> createState() => _TasksListState();
// }

// class _TasksListState extends State<TasksList> {
//   bool _isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     // Fetch tasks when the screen initializes
//     final userId =
//         Provider.of<UserProvider>(context, listen: false).currentUser!.id;
//     Provider.of<TaskProvider>(context, listen: false)
//         .getAllTasksFromFireStore(userId)
//         .then((_) {
//       setState(() {
//         _isLoading = false; // Data has been fetched
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var listProvider = Provider.of<TaskProvider>(context);
//     var userProvider = Provider.of<UserProvider>(context);
//     // if (listProvider.tasksList.isEmpty) {
//     //   listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id);
//     // }
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false, // Disable the implicit leading icon
//         title: Text(
//           'Patient, ${userProvider.currentUser!.name}',
//           style: Theme.of(context).textTheme.displayMedium,
//         ),
//         actions: [
//           // IconButton(
//           //     tooltip:
//           //         'Log Out', // This will display "Log Out" when hovered or long-pressed.
//           //     onPressed: () async {
//           //       await FirebaseAuth.instance.signOut();
//           //       Navigator.pushReplacementNamed(context, LoginScreen.routeName);
//           //     },
//           //     icon: const Icon(
//           //       Icons.logout,
//           //       color: AppColors.white,
//           //       size: 35,
//           //     ))

//           // Menu icon to open the drawer
//           // Use a Builder to get the correct context for opening the drawer
//           Builder(
//             builder: (context) {
//               return IconButton(
//                 tooltip: 'Menu', // Tooltip for the menu icon
//                 onPressed: () {
//                   Scaffold.of(context).openEndDrawer(); // Open the drawer
//                 },
//                 icon: const Icon(
//                   Icons.menu, // Hamburger menu icon
//                   color: AppColors.white,
//                   size: 35,
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       // Right Navigation Drawer
//       endDrawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: AppColors.lightBlue,
//               ),
//               child: Text(
//                 "Settings",
//                 style: TextStyle(
//                   color: AppColors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.location_on, color: AppColors.darkBlue),
//               title: Text("Update Home Location",
//                   style: TextStyle(color: AppColors.darkBlue)),
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer
//                 DialogUtils.showHomeLocationDialog(
//                   context: context,
//                   onComplete: () {
//                     // Handle completion if needed
//                   },
//                   patientId: userProvider.currentUser!.id,
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout, color: AppColors.darkBlue),
//               title:
//                   Text("Logout", style: TextStyle(color: AppColors.darkBlue)),
//               onTap: () async {
//                 Navigator.pop(context); // Close the drawer
//                 await FirebaseAuth.instance.signOut();
//                 Navigator.pushReplacementNamed(context, LoginScreen.routeName);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // ElevatedButton(
//                 //     onPressed: () {
//                 //       DialogUtils.showHomeLocationDialog(
//                 //           context: context,
//                 //           onComplete: () {},
//                 //           patientId: userProvider.currentUser!.id);
//                 //     },
//                 //     child: Text('tab to save home location')),
//                 Expanded(
//                   child: listProvider.tasksList.isEmpty
//                       ? Padding(
//                           padding: const EdgeInsets.all(100),
//                           child: Center(
//                               child: Text(
//                             "No Tasks Added",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall!
//                                 .copyWith(
//                                     fontSize: 25, fontWeight: FontWeight.w600),
//                           )),
//                         )
//                       : ListView.builder(
//                           itemBuilder: (context, index) {
//                             return TaskListItem(
//                               // access data inside list
//                               task: listProvider.tasksList[index],
//                             );
//                           },
//                           itemCount: listProvider.tasksList.length,
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/auth/login_screen.dart';
import 'package:graduation_app/screens/task_list/task_list_item.dart';
import 'package:graduation_app/screens/theming/app_colors.dart';
import 'package:provider/provider.dart';
import '../../utils/dialog_utils.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() async {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    await Provider.of<TaskProvider>(context, listen: false)
        .getAllTasksFromFireStore(userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<TaskProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Patient, ${userProvider.currentUser!.name}',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                tooltip: 'Menu',
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: AppColors.white,
                  size: 35,
                ),
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
              ),
              child: Text(
                "Settings",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: AppColors.darkBlue),
              title: Text("Update Home Location",
                  style: TextStyle(color: AppColors.darkBlue)),
              onTap: () {
                Navigator.pop(context);
                DialogUtils.showHomeLocationDialog(
                  context: context,
                  onComplete: () {},
                  patientId: userProvider.currentUser!.id,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.darkBlue),
              title:
                  Text("Logout", style: TextStyle(color: AppColors.darkBlue)),
              onTap: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                EasyDateTimeLine(
                  initialDate: DateTime.now(),
                  onDateChange: (selectedDate) {
                    setState(() {
                      listProvider.changeSelectDate(
                          selectedDate, userProvider.currentUser!.id);
                      _selectedDate = selectedDate;
                    });
                  },
                  headerProps: EasyHeaderProps(
                    monthStyle:
                        Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.darkBlue,
                            ),
                    monthPickerType: MonthPickerType.dropDown,
                    dateFormatter: DateFormatter.fullDateDMY(),
                    selectedDateStyle: TextStyle(
                      color: AppColors.darkBlue,
                    ),
                  ),
                  dayProps: EasyDayProps(
                    dayStructure: DayStructure.dayStrDayNum,
                    inactiveDayStyle: DayStyle(
                      dayNumStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.lightBlue,
                              ),
                      dayStrStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.lightBlue,
                              ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: AppColors.white,
                      ),
                    ),
                    activeDayStyle: DayStyle(
                      dayNumStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.darkBlue),
                      dayStrStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.darkBlue),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.darkBlue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: listProvider.filteredTasksList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(100),
                          child: Center(
                            child: Text(
                              "No Tasks Added",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return TaskListItem(
                              task: listProvider.filteredTasksList[index],
                            );
                          },
                          itemCount: listProvider.filteredTasksList.length,
                        ),
                ),
              ],
            ),
    );
  }
}
