import 'package:flutter/material.dart';
import 'package:graduation_app/providers/list_provider.dart';
import 'package:graduation_app/screens/caregiver_screen.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/screens/auth/register_screen.dart';
import 'package:graduation_app/screens/task_list/add_task_screen.dart';
import 'package:graduation_app/utils/app_theme.dart';
import 'package:graduation_app/screens/auth/login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => ListProvider(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.myTheme,
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        PatientScreen.routeName: (context) => PatientScreen(),
        CaregiverScreen.routeName: (context) => CaregiverScreen(),
        AddTaskScreen.routeName: (context) => AddTaskScreen()
      },
    );
  }
}
