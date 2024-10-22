import 'package:flutter/material.dart';
import 'package:graduation_app/screens/notification.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/utils/app_colors.dart';

class CaregiverScreen extends StatefulWidget {
  static const String routeName = 'CaregiverScreen';
  final String body;
  const CaregiverScreen({super.key, required this.body});

  @override
  State<CaregiverScreen> createState() => _CaregiverScreenState();
}

class _CaregiverScreenState extends State<CaregiverScreen> {
  // const CaregiverScreen({super.key});
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
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, NotificationClass.routeName);
              },
              child: const Text('data')),
          Container(
            child: Text(widget.body),
          )
        ],
      ),
    );
  }
}
