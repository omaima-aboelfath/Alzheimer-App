import 'package:flutter/material.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:graduation_app/screens/task_list/task_list_item.dart';
import 'package:graduation_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

class Caregiver extends StatelessWidget {
  static const String routeName = 'caregiver';

  const Caregiver({super.key});

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You will be responsible of:'),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.8,
            color: AppColors.greenColor,
            child: const Column(
              children: [ListTile()],
            ),
          )
        ],
      ),
    );
  }
}
