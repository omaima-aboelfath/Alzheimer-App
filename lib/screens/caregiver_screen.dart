import 'package:flutter/material.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/utils/app_colors.dart';

class CaregiverScreen extends StatelessWidget {
  static const String routeName = 'CaregiverScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Caregiver Screen',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, PatientScreen.routeName);
              },
              label: Text(
                'go to patient',
                style: Theme.of(context).textTheme.displaySmall,
              ))
        ],
      ),
    );
  }
}
