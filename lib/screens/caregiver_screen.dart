import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/providers/patient_provider.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:graduation_app/model/user_data.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/auth/login_screen.dart';
import 'package:graduation_app/utils/app_colors.dart';
import 'package:graduation_app/utils/task_bar_chart.dart';
import 'package:provider/provider.dart';

class CaregiverScreen extends StatefulWidget {
  static const String routeName = 'caregiverScreen';

  final String uId; // Assume this is passed to the screen constructor
  CaregiverScreen({required this.uId});
  @override
  _CaregiverScreenState createState() => _CaregiverScreenState();
}

class _CaregiverScreenState extends State<CaregiverScreen> {
  MyUser? selectedPatient;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final caregiverId = ModalRoute.of(context)!.settings.arguments as String;
    Provider.of<PatientProvider>(context, listen: false)
        .fetchPatients(caregiverId);
  }

  void initState() {
    super.initState();
    // Fetch tasks when the screen initializes
    Provider.of<TaskProvider>(context, listen: false)
        .getAllTasksFromFireStore(widget.uId);
  }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Caregiver, ${userProvider.currentUser!.name}',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          IconButton(
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text('Choose Your Patient:'),
          ),
          Consumer<PatientProvider>(
            builder: (context, patientProvider, _) {
              //true
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DropdownButton<MyUser>(
                  hint: Text(
                    "Select Patient",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  value: selectedPatient,
                  iconEnabledColor: AppColors.darkBlue,
                  isExpanded: true,
                  style: Theme.of(context).textTheme.bodySmall,
                  borderRadius: BorderRadius.circular(12),
                  onChanged: (MyUser? newPatient) async {
                    if (newPatient != null) {
                      print('Selected Patient: ${newPatient.name}');
                      setState(() {
                        selectedPatient =
                            newPatient; // Set the selected patient
                      });
                      // // Fetch tasks for the selected patient *last*
                      // await taskProvider.fetchTasksForPatient(newPatient.id);
                      // await taskProvider.loadTasksForPatient(
                      //     newPatient.id); // Call the loadTasksForPatient
                      // Set current patient in TaskProvider to filter tasks
                      // taskProvider.setCurrentPatient(newPatient); ////////
                      await taskProvider
                          .getAllTasksFromFireStore(newPatient.id);
                      print(
                          'Tasks for ${newPatient.name}: , Length of incomplete tasks: ${taskProvider.incompleteTasks.length}');
                      print(
                          'Tasks IDs of Patient: ${newPatient.taskIds.length}');
                    }
                  },
                  items: patientProvider.patientsList.map((patient) {
                    return DropdownMenuItem(
                      value: patient, // Ensure patient is unique by ID
                      child: Text(patient.name),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.all(10),
            // color: const Color.fromARGB(17, 98, 255, 59),
            decoration: BoxDecoration(
              color: AppColors.white,
              // border: Border.all(
              //   color: AppColors.lightBlue,
              //   width: 1,
              // ),
            ),
            width: double.infinity,
            height: 300,
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: taskProvider.incompleteTasks.isEmpty
                    ? Text("No incomplete tasks to display")
                    : SizedBox(
                        height: 300,
                        child: TaskBarChart(
                          incompleteData:
                              taskProvider.getIncompleteTaskChartData(),
                          completeData: taskProvider.getCompleteTaskChartData(),
                        ),
                      ),
              ),
            ),
          ),
          Text('List of ${selectedPatient?.name} Tasks',
              style: Theme.of(context).textTheme.bodyMedium),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                // Use incompleteTasks getter to filter tasks
                final incompleteTasks = taskProvider.tasksList;

                return ListView.builder(
                  itemCount: incompleteTasks.length,
                  itemBuilder: (context, index) {
                    var task = incompleteTasks[index];
                    return ListTile(
                      title: Text("title: ${task.title}",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold)),
                      // Uncomment and modify if you want to display additional task info
                      subtitle: Text(
                        "date: ${task.dateTime}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: task.isDone
                          ? Icon(Icons.check, color: Colors.green)
                          : Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
