import 'package:flutter/material.dart';
import 'package:graduation_app/utils/app_colors.dart';

class CaregiverScreen extends StatelessWidget {
  static const String routeName = 'CaregiverScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'caregiver screen',
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }
}
