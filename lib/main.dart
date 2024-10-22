import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/providers/list_provider.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/caregiver_screen.dart';
import 'package:graduation_app/screens/notification.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/screens/auth/register_screen.dart';
import 'package:graduation_app/screens/task_list/add_task_screen.dart';
import 'package:graduation_app/utils/app_theme.dart';
import 'package:graduation_app/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  if (message.notification != null) {
    print("Handling a background message: ${message.messageId}");
    print(message.notification!.title);
    print(message.notification!.body);
    print(message.data);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => ListProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // in case onBackgroundMessage , if navigate to screen it must be inside material app
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('Test Click');
    //   // do anything, navigate , insert in db
    // });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('=== User is currently signed out');
      } else {
        print('=== User is signed in');
      }
    });
    super.initState();
  }

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
        CaregiverScreen.routeName: (context) => CaregiverScreen(
              body: '',
            ),
        AddTaskScreen.routeName: (context) => AddTaskScreen(),
        NotificationClass.routeName: (context) => NotificationClass()
      },
    );
  }
}
