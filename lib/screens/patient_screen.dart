import 'package:flutter/material.dart';
import 'package:graduation_app/providers/list_provider.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/caregiver_screen.dart';
import 'package:graduation_app/screens/task_list/add_task_screen.dart';
import 'package:graduation_app/screens/task_list/task_list_item.dart';
import 'package:graduation_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

class PatientScreen extends StatefulWidget {
  static const String routeName = 'PatientScreen';

  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  // late ListProvider listProvider;
  @override
  Widget build(BuildContext context) {

    var listProvider = Provider.of<ListProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    if (listProvider.tasksList.isEmpty) {
      listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient, ${userProvider.currentUser!.name}',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AddTaskScreen.routeName);
              },
              icon: const Icon(
                Icons.add_circle_outline_sharp,
                color: AppColors.white,
                size: 35,
              )),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CaregiverScreen.routeName);
              },
              icon: const Icon(
                Icons.logout,
                color: AppColors.white,
                size: 35,
              ))
        ],
      ),
      body: Column(
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
                          .copyWith(fontSize: 25, fontWeight: FontWeight.w600),
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
        ],
      ),
    );
  }
}
