import 'package:flutter/material.dart';
import 'package:graduation_app/firebase_utils.dart';
import 'package:graduation_app/model/task_data.dart';
import 'package:graduation_app/providers/list_provider.dart';
import 'package:graduation_app/screens/caregiver_screen.dart';
import 'package:graduation_app/screens/task_list/add_task_screen.dart';
import 'package:graduation_app/screens/task_list/task_list_item.dart';
import 'package:graduation_app/utils/app_colors.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PatientScreen extends StatefulWidget {
  static const String routeName = 'PatientScreen';

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  String title = '';
  String description = '';
  DateTime selectDate = DateTime.now();
  late ListProvider listProvider;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    listProvider = Provider.of<ListProvider>(context);
    if (listProvider.tasksList.isEmpty) {
      listProvider.getAllTasksFromFireStore();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Screen',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AddTaskScreen.routeName);
              },
              icon: Icon(
                Icons.add_circle_outline_sharp,
                color: AppColors.white,
                size: 35,
              )),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CaregiverScreen.routeName);
              },
              icon: Icon(
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
