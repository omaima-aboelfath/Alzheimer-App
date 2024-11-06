import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graduation_app/caregiver.dart';
import 'package:graduation_app/local_notification_test.dart';
import 'package:graduation_app/messaging/firebase_notification.dart';
import 'package:graduation_app/providers/patient_provider.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/caregiver_screen.dart';
import 'package:graduation_app/screens/notification.dart';
import 'package:graduation_app/screens/notification_screen.dart';
import 'package:graduation_app/screens/patient_screen.dart';
import 'package:graduation_app/screens/auth/register_screen.dart';
import 'package:graduation_app/screens/task_list/add_task_screen.dart';
import 'package:graduation_app/utils/app_theme.dart';
import 'package:graduation_app/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:graduation_app/utils/local_notification_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:graduation_app/screens/location_tracker.dart';

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

// Create a FlutterLocalNotificationsPlugin instance
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // tz.initializeTimeZones(); // Initialize timezones
  // tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
  // Initialize the notification settings
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings(
  //         '@mipmap/ic_launcher'); // replace with your app icon
  // final InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  // );
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // Create a notification channel
  // await createNotificationChannel();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseNotifications().initNotifications();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
    ),
    ChangeNotifierProvider(create: (_) => PatientProvider()),
  ], child: const MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Function to create a notification channel
// Future<void> createNotificationChannel() async {
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'your_channel_id', // Unique channel ID
//     'Your Channel Name', // User-visible channel name
//     description: 'This channel is used for important notifications.',
//     importance: Importance.high,
//     playSound: true,
//     // Add more configurations if needed
//   );

//   // Create the channel on the device
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? userId; // Variable to store the current user's ID

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
        userId = user.uid; // Store the logged-in user's ID
        final listProvider = Provider.of<TaskProvider>(context, listen: false);
        listProvider.getAllTasksFromFireStore(
            user.uid); // Fetch tasks for logged-in user
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
      navigatorKey: navigatorKey,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        PatientScreen.routeName: (context) => PatientScreen(),
        CaregiverScreen.routeName: (context) => CaregiverScreen(
              // body: '',
              uId: userId ?? '', // Pass userId or an empty string if null
            ),
        AddTaskScreen.routeName: (context) => AddTaskScreen(),
        NotificationClass.routeName: (context) => NotificationClass(),
        NotificationScreen.routeName: (context) {
          // Retrieve the message from the arguments
          final RemoteMessage message =
              ModalRoute.of(context)!.settings.arguments as RemoteMessage;
          return NotificationScreen(
              message: message); // Pass the message to NotificationScreen
        },
        LocalNotificationTest.routeName: (context) => LocalNotificationTest(),
        Caregiver.routeName: (context) => Caregiver(),
        '/locationTracker': (context) => LocationTracker()
      },
    );
  }
}
