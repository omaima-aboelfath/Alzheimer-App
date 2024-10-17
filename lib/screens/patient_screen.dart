import 'package:flutter/material.dart';
import 'package:graduation_app/screens/task_list/tasksList_screen.dart';
import 'package:graduation_app/utils/app_colors.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';

class PatientScreen extends StatefulWidget {
  static const String routeName = 'PatientScreen';

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  DateTime? _dateTime;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'patient screen',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            child: Text('Show DateTime Picker',
                style: Theme.of(context).textTheme.displaySmall),
          ),

          Text(
              _dateTime != null
                  ? DateFormat('dd-MM-yyyy hh:mm a').format(_dateTime!)
                  : 'No date selected',
              style: _dateTime != null
                  ? Theme.of(context).textTheme.bodySmall
                  : Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.red)),
          SizedBox(height: 0.1 * height),
          Text(
            'Add Task Title',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  fillColor: AppColors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          BorderSide(color: AppColors.mediumBlue, width: 1.5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          BorderSide(color: AppColors.mediumBlue, width: 1.5)),
                )),
          ),
          Text(
            'Description',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  fillColor: AppColors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          BorderSide(color: AppColors.mediumBlue, width: 1.5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          BorderSide(color: AppColors.mediumBlue, width: 1.5)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.lightBlue),
              ),
              onPressed: () {
                Navigator.pushNamed(context, TaskslistScreen.routeName);
              },
              child: Text('Submit',
                  style: Theme.of(context).textTheme.displaySmall),
            ),
          ),
          //     height: 0.2 * height,
          //     width: 0.7 * width,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         color: Colors.white,
          //         border: Border.all(color: AppColors.lightBlue)),
          //   )
        ],
      ),
    );
  }
}
