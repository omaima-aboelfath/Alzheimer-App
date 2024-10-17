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
        
        ],
      ),
    );
  }
}
