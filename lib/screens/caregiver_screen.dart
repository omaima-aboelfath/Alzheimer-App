/* my cooode
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/providers/patient_provider.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:graduation_app/model/user_data.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/auth/login_screen.dart';
import 'package:graduation_app/utils/theming/app_colors.dart';
import 'package:graduation_app/utils/theming/date_time_utils.dart';
// import 'package:graduatiaon_app/utils/visualization/task_bar_chart.dart';
import 'package:graduation_app/utils/visualization/task_line_chart.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/visualization/task_bar_chart.dart';

class CaregiverScreen extends StatefulWidget {
  static const String routeName = 'caregiverScreen';

  // final String uId; // Assume this is passed to the screen constructor
  // const CaregiverScreen({super.key, required this.uId});
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

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the screen initializes
    // Provider.of<TaskProvider>(context, listen: false)
    //     .getAllTasksFromFireStore(widget.uId);
    // Provider.of<TaskProvider>(context, listen: false)
    //     .getAllTasksFromFireStore(selectedPatient?.id??'');
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
          const Padding(
            padding: EdgeInsets.all(15),
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
            decoration: const BoxDecoration(
              color: AppColors.white,
              // border: Border.all(
              //   color: AppColors.lightBlue,
              //   width: 1,
              // ),
            ),
            // width: double.infinity,
            height: 300,
            child: Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: taskProvider.incompleteTasks.isEmpty
                  ? Center(child: const Text("No tasks to display"))
                  : SizedBox(
                      height: 300,
                      child: TaskBarChart(
                        incompleteData:
                            taskProvider.getIncompleteTaskChartData(),
                        completeData: taskProvider.getCompleteTaskChartData(),
                        delayedData: taskProvider.getDelayedTasks(),
                      ),
                    ),
              // : TaskLineChart(
              //     completedData:
              //         taskProvider.getCompleteTaskChartData(),
              //     incompleteData:
              //         taskProvider.getIncompleteTaskChartData())
            )),
          ),
          // Text('List of ${selectedPatient?.name} Tasks',
          //     style: Theme.of(context).textTheme.bodyMedium),
          // Expanded(
          //   child: Consumer<TaskProvider>(
          //     builder: (context, taskProvider, child) {
          //       // Use incompleteTasks getter to filter tasks
          //       final incompleteTasks = taskProvider.tasksList;
          //       return ListView.builder(
          //         itemCount: incompleteTasks.length,
          //         itemBuilder: (context, index) {
          //           var task = incompleteTasks[index];
          //           return ListTile(
          //             // title: Text("title: ${task.title}",
          //             //     style: Theme.of(context)
          //             //         .textTheme
          //             //         .bodySmall!
          //             //         .copyWith(fontWeight: FontWeight.bold)),
          //             title:
          //                 task.isDone && task.completedAt != null
          //                     ? Text(
          //                         "Completed at: ${DateTimeUtils.format(task.completedAt!)}",
          //                         style: Theme.of(context).textTheme.bodySmall,
          //                       )
          //                     : Text(
          //                         'Uncompleted',
          //                         style: Theme.of(context).textTheme.bodySmall,
          //                       ),
          //             // Uncomment and modify if you want to display additional task info
          //             subtitle: Text(
          //               "date: ${DateTimeUtils.format(task.dateTime)}",
          //               style: Theme.of(context).textTheme.bodySmall,
          //             ),
          //             trailing: task.isDone
          //                 ? const Icon(Icons.check, color: Colors.green)
          //                 : const Icon(
          //                     Icons.close,
          //                     color: Colors.red,
          //                   ),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
*/

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_app/providers/patient_provider.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:graduation_app/model/user_data.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/screens/auth/login_screen.dart';
import 'package:graduation_app/screens/caregiver_location_tracker.dart';
import 'package:graduation_app/screens/home_location.dart';
import 'package:graduation_app/screens/pdf_preview_screen.dart';
import 'package:graduation_app/screens/visualization/tasks_delay.dart';
import 'package:graduation_app/utils/firebase_utils.dart';
import 'package:graduation_app/utils/pdf_utils.dart';
import 'package:graduation_app/screens/theming/app_colors.dart';
import 'package:graduation_app/screens/visualization/task_bar_chart.dart';
import 'package:provider/provider.dart';
import '../model/api_manager.dart';
import '../utils/dialog_utils.dart';
import 'visualization/delay_forecast.dart';

class CaregiverScreen extends StatefulWidget {
  static const String routeName = 'caregiverScreen';
  final String uId;
  const CaregiverScreen({super.key, required this.uId});

  @override
  _CaregiverScreenState createState() => _CaregiverScreenState();
}

class _CaregiverScreenState extends State<CaregiverScreen> {
  MyUser? selectedPatient;
  String? chartUrl;
  bool isLoadingChart = true;
  String? errorMessageChart;
  GoogleMapController? _mapController;
  double? latitude;
  double? longitude;
  DateTime? timestamp;
  File? pdfFile; // To store the generated PDF file
  bool isGeneratingReport = false; // To track if the report is being generated

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      final caregiverId = arguments as String;
      Provider.of<PatientProvider>(context, listen: false)
          .fetchPatients(caregiverId);
    } else {
      // Handle the case where arguments are null
      print('Error: No arguments provided to CaregiverScreen');
      // Optionally, show an error message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No arguments provided to CaregiverScreen'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the screen initializes
    // Fetch task summary chart when the patient is selected
    Provider.of<TaskProvider>(context, listen: false)
        .getAllTasksFromFireStore(widget.uId);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _fetchLocation() async {
    if (selectedPatient != null) {
      print("Fetch location button pressed"); // Debugging
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(selectedPatient!.id)
          .get();
      var data = doc.data() as Map<String, dynamic>;

      setState(() {
        latitude = data['latitude'];
        longitude = data['longitude'];
        timestamp = (data['timestamp'] as Timestamp).toDate();
      });

      print("Location data: $latitude, $longitude at $timestamp"); // Debugging

      if (_mapController != null && latitude != null && longitude != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(latitude!, longitude!),
          ),
        );
      }
    } else {
      print("No patient selected yet!");
    }
  }

  // Function to request location permission
  void _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _startLocationUpdates();
    } else {
      print('Location permission denied');
    }
  }

  // Start listening to location updates and move the camera to the updated location
  void _startLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      // Update location in Firestore
      _updateLocationInFirebase(position.latitude, position.longitude);

      // Move the camera to the current location if map controller is initialized
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
        print('Current Location: ${position.latitude}, ${position.longitude}');
      }
    });
  }

  // Update location in Firebase Firestore
  void _updateLocationInFirebase(double lat, double lon) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(selectedPatient!.id)
        .set({
      'latitude': lat,
      'longitude': lon,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)).then((value) {
      print('Location updated successfully');
    }).catchError((error) {
      print('Error updating location: $error');
    });
  }

  // Future<void> fetchTaskSummaryChart() async {
  //   if (selectedPatient != null) {
  //     final url =
  //         'http://10.0.2.2:5000/users/${selectedPatient!.id}/tasks-summary-chart';
  //     try {
  //       final response = await http.get(Uri.parse(url));
  //       if (response.statusCode == 200) {
  //         final data = json.decode(response.body);
  //         setState(() {
  //           chartUrl = data['chart_url'];
  //           isLoadingChart = false;
  //         });
  //       } else {
  //         setState(() {
  //           errorMessageChart =
  //               'Failed to load chart: ${response.reasonPhrase}';
  //           isLoadingChart = false;
  //         });
  //       }
  //     } catch (e) {
  //       setState(() {
  //         errorMessageChart = 'Error: $e';
  //         isLoadingChart = false;
  //       });
  //     }
  //   }
  // }

  ///last one
  // Future<void> fetchTaskSummaryChart() async {
  //   if (selectedPatient != null) {
  //     try {
  //       final url = await ApiManager.fetchTaskSummaryChart(selectedPatient!.id);
  //       setState(() {
  //         chartUrl = url;
  //         isLoadingChart = false;
  //       });
  //     } catch (e) {
  //       setState(() {
  //         errorMessageChart = 'Error loading chart: $e';
  //         isLoadingChart = false;
  //       });
  //     }
  //   }
  // }

  // Future<void> fetchDelayVisualizationChart() async {
  //   if (selectedPatient != null) {
  //     try {
  //       final url =
  //           await ApiManager.fetchDelayVisualizationChart(selectedPatient!.id);
  //       setState(() {
  //         chartUrl = url;
  //         isLoadingChart = false;
  //       });
  //     } catch (e) {
  //       setState(() {
  //         errorMessageChart = 'Error loading chart: $e';
  //         isLoadingChart = false;
  //       });
  //     }
  //   }
  // }

  // Display home location on Google Maps
  void showPatientHomeLocation(String patientId) async {
    final homeLocation = await FirebaseUtils.fetchHomeLocation(patientId);
    if (homeLocation != null) {
      final double latitude = homeLocation['latitude'];
      final double longitude = homeLocation['longitude'];
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latitude, longitude),
        ),
      );
      print('Patient Home Location: $latitude, $longitude');
    } else {
      print('Home location not available.');
    }
  }

  //my code
  // Future<void> generateReport() async {
  //   if (selectedPatient == null) return;
  //   setState(() {
  //     isGeneratingReport = true;
  //   });
  //   try {
  //     // Fetch data from Firestore
  //     final reportData =
  //         await FirebaseUtils.fetchReportData(selectedPatient!.id);
  //     // Generate PDF
  //     final pdf = await PdfUtils.generatePdfReport({
  //       'patientName': selectedPatient!.name,
  //       'totalTasks': reportData['totalTasks'],
  //       'completedTasks': reportData['completedTasks'],
  //       'incompleteTasks': reportData['incompleteTasks'],
  //       'forecastData': reportData['analysis'],
  //       'recommendations': reportData['recommendations'],
  //     });
  //     // Save PDF to file
  //     // pdfFile = await PdfUtils.savePdfToFile(pdf);
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(content: Text('Report generated successfully!')),
  //     // );
  //     // Navigate to the PDF Preview Screen
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PdfPreviewScreen(pdfFile: pdfFile!),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error generating report: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       isGeneratingReport = false;
  //     });
  //   }
  // }

  //2
//   Future<void> generateReport() async {
//   if (selectedPatient == null) return;
//   setState(() {
//     isGeneratingReport = true;
//   });
//   try {
//     // Fetch data from Firestore
//     final reportData = await FirebaseUtils.fetchReportData(selectedPatient!.id);
//     // Generate PDF
//     final pdf = await PdfUtils.generatePdfReport({
//       'patientName': selectedPatient!.name,
//       'totalTasks': reportData['totalTasks'],
//       'completedTasks': reportData['completedTasks'],
//       'incompleteTasks': reportData['incompleteTasks'],
//       'forecastData': reportData['analysis'],
//       'recommendations': reportData['recommendations'],
//       'scatter_plot_path': reportData['scatter_plot_path'], // Include scatter plot path
//     });
//     // Save PDF to file
//     pdfFile = await PdfUtils.savePdfToFile(pdf);
//     // Navigate to the PDF Preview Screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PdfPreviewScreen(pdfFile: pdfFile!),
//       ),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error generating report: $e')),
//     );
//   } finally {
//     setState(() {
//       isGeneratingReport = false;
//     });
//   }
// }

  //3
  // Future<void> generateReport() async {
  //   if (selectedPatient == null) return;
  //   setState(() {
  //     isGeneratingReport = true;
  //   });
  //   try {
  //     // Refresh task data
  //     final taskProvider = Provider.of<TaskProvider>(context, listen: false);
  //     await taskProvider.getAllTasksFromFireStore(selectedPatient!.id);
  //     // Fetch data from taskProvider
  //     final totalTasks = taskProvider.tasksList.length;
  //     final completedTasks = taskProvider.completeTasks.length;
  //     final incompleteTasks = taskProvider.incompleteTasks.length;
  //     // Fetch data from Firestore (if needed)
  //     final reportData =
  //         await FirebaseUtils.fetchReportData(selectedPatient!.id);
  //     // Generate PDF
  //     final pdf = await PdfUtils.generatePdfReport({
  //       'patientName': selectedPatient!.name,
  //       'totalTasks': totalTasks,
  //       'completedTasks': completedTasks,
  //       'incompleteTasks': incompleteTasks,
  //       'forecastData': reportData['forecastData'] ?? {},
  //       'recommendations': reportData['recommendations'] ?? 'N/A',
  //       'scatter_plot_path':
  //           reportData['scatter_plot_path'], // Include scatter plot path
  //     });
  //     print({
  //       'patientName': selectedPatient!.name,
  //       'totalTasks': totalTasks,
  //       'completedTasks': completedTasks,
  //       'incompleteTasks': incompleteTasks,
  //       'forecastData': reportData['forecastData'] ?? {},
  //       'recommendations': reportData['recommendations'] ?? 'N/A',
  //       'scatter_plot_path': reportData['scatter_plot_path'],
  //     });
  //     // Save PDF to file
  //     pdfFile = await PdfUtils.savePdfToFile(pdf);
  //     // Navigate to the PDF Preview Screen
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PdfPreviewScreen(pdfFile: pdfFile!),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error generating report: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       isGeneratingReport = false;
  //     });
  //   }
  // }

  //4
//   Future<void> generateReport() async {
//   if (selectedPatient == null) return;
//   setState(() {
//     isGeneratingReport = true;
//   });

//   try {
//     // Refresh task data
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);
//     await taskProvider.getAllTasksFromFireStore(selectedPatient!.id);

//     // Fetch analysis data from taskProvider
//     final totalTasks = taskProvider.tasksList.length;
//     final completedTasks = taskProvider.completeTasks.length;
//     final incompleteTasks = taskProvider.incompleteTasks.length;

//     // Fetch additional data from Firestore (if needed)
//     final reportData = await FirebaseUtils.fetchReportData(selectedPatient!.id);

//     // Generate PDF
//     final pdf = await PdfUtils.generatePdfReport({
//       'patientName': selectedPatient!.name,
//       'totalTasks': totalTasks,
//       'completedTasks': completedTasks,
//       'incompleteTasks': incompleteTasks,
//       'forecastData': reportData['forecastData'] ?? {},
//       'recommendations': reportData['recommendations'] ?? 'N/A',
//       'scatter_plot_path': reportData['scatter_plot_path'], // Include scatter plot path
//     });

//     // Save PDF to file
//     pdfFile = await PdfUtils.savePdfToFile(pdf);
//     // Navigate to the PDF Preview Screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PdfPreviewScreen(pdfFile: pdfFile!),
//       ),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error generating report: $e')),
//     );
//   } finally {
//     setState(() {
//       isGeneratingReport = false;
//     });
//   }
// }

  //5  correct without scatter
  // Future<void> generateReport() async {
  //   if (selectedPatient == null) return;
  //   setState(() {
  //     isGeneratingReport = true;
  //   });

  //   try {
  //     // Refresh task data
  //     final taskProvider = Provider.of<TaskProvider>(context, listen: false);
  //     await taskProvider.getAllTasksFromFireStore(selectedPatient!.id);

  //     // Fetch analysis data from taskProvider
  //     final analysisData = taskProvider.analysisData;

  //     // Fetch additional data from Firestore (if needed)
  //     final reportData =
  //         await FirebaseUtils.fetchReportData(selectedPatient!.id);

  //     // Generate PDF
  //     final pdf = await PdfUtils.generatePdfReport({
  //       'patientName': selectedPatient!.name,
  //       'totalTasks': analysisData['totalTasks'],
  //       'completedTasks': analysisData['completedTasks'],
  //       'incompleteTasks': analysisData['incompleteTasks'],
  //       'delayedTasks': analysisData['delayedTasks'],
  //       'averageDelay': analysisData['averageDelay'],
  //       'mostDelayedTasks': analysisData['mostDelayedTasks'],
  //       'timeOfDayDelays': analysisData['timeOfDayDelays'],
  //       'forecastData': reportData['forecastData'] ?? {},
  //       'recommendations': reportData['recommendations'] ?? 'N/A',
  //       'scatter_plot_path':
  //           reportData['scatter_plot_path'], // Include scatter plot path
  //     });

  //     // Save PDF to file
  //     // pdfFile = await PdfUtils.savePdfToFile(pdf);

  //     // Navigate to the PDF Preview Screen
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PdfPreviewScreen(pdfFile: pdfFile!),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error generating report: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       isGeneratingReport = false;
  //     });
  //   }
  // }

//    Future<void> generateReport() async {
//   if (selectedPatient == null) return;
//   setState(() {
//     isGeneratingReport = true;
//   });

//   try {
//     // Refresh task data
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);
//     await taskProvider.getAllTasksFromFireStore(selectedPatient!.id);

//     // Fetch analysis data from taskProvider
//     final analysisData = taskProvider.analysisData;

//     // Fetch additional data from Firestore (if needed)
//     final reportData = await FirebaseUtils.fetchReportData(selectedPatient!.id);

//     // Generate PDF
//     final pdf = await PdfUtils.generatePdfReport({
//       'patientName': selectedPatient!.name,
//       'totalTasks': analysisData['totalTasks'],
//       'completedTasks': analysisData['completedTasks'],
//       'incompleteTasks': analysisData['incompleteTasks'],
//       'delayedTasks': analysisData['delayedTasks'],
//       'averageDelay': analysisData['averageDelay'],
//       'mostDelayedTasks': analysisData['mostDelayedTasks'],
//       'timeOfDayDelays': analysisData['timeOfDayDelays'],
//       'scatterPlotImage': analysisData['scatterPlotImage'], // Include scatter plot image
//       'forecastData': reportData['forecastData'] ?? {},
//       'recommendations': reportData['recommendations'] ?? 'N/A',
//     });

//     // Save PDF to file
//     pdfFile = await PdfUtils.savePdfToFile(pdf);

//     // Navigate to the PDF Preview Screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PdfPreviewScreen(pdfFile: pdfFile!),
//       ),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error generating report: $e')),
//     );
//   } finally {
//     setState(() {
//       isGeneratingReport = false;
//     });
//   }
// }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    List<Map<String, dynamic>> gridItems = [
      // 1-tasks
      {
        'icon': Icons.bar_chart,
        'label': 'Tasks Overview',
        'onTap': (BuildContext context) {
          if (selectedPatient != null) {
            if (taskProvider.tasksList.isEmpty) {
              DialogUtils.showMessage(
                context: context,
                title: 'No Tasks',
                message: 'The patient has no tasks.',
              );
            } else {
              // Navigate to Task Bar Chart
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskBarChart(
                    incompleteData: taskProvider.getIncompleteTaskChartData(),
                    completeData: taskProvider.getCompleteTaskChartData(),
                    delayedData: taskProvider.getDelayedTasks(),
                  ),
                ),
              );
            }
          } else {
            DialogUtils.showMessage(
              context: context,
              title: 'No Patient Selected',
              message: 'Please select a patient first.',
            );
          }
        },
      },
      // 2-delay
      {
        'icon': Icons.stacked_line_chart_outlined,
        'label': 'Tasks Delays',
        'onTap': (BuildContext context) {
          if (selectedPatient != null) {
            if (taskProvider.tasksList.isEmpty) {
              DialogUtils.showMessage(
                context: context,
                title: 'No Tasks',
                message: 'The patient has no tasks.',
              );
            } else {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DelayForecastScreen(
              //       userId: selectedPatient!.id,
              //       patientName: selectedPatient!.name, // Pass patient name
              //     ),
              //   ),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TasksDelayScreen(
                    userId: selectedPatient!.id,
                  ),
                ),
              );
            }
          } else {
            DialogUtils.showMessage(
              context: context,
              title: 'No Patient Selected',
              message: 'Please select a patient first.',
            );
          }
        },
      },
      // 3-gps
      {
        'icon': Icons.location_on,
        'label': 'Track Location',
        'onTap': (BuildContext context) {
          if (selectedPatient != null) {
            // Navigate to Location Tracker
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CaregiverLocationTracker(
                  // LocationTracker
                  patientId: selectedPatient!.id,
                ),
              ),
            );
          } else {
            DialogUtils.showMessage(
              context: context,
              title: 'No Patient Selected',
              message: 'Please select a patient first.',
            );
          }
        },
      },
      // 4-home
      {
        'icon': Icons.home,
        'label': 'Home Location',
        'onTap': (BuildContext context) {
          if (selectedPatient != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeLocationScreen(
                  patientId: selectedPatient!.id,
                ),
              ),
            );
          } else {
            DialogUtils.showMessage(
              context: context,
              title: 'No Patient Selected',
              message: 'Please select a patient first.',
            );
          }
        },
      },
      // 5-score
      {
        'icon': Icons.document_scanner,
        'label': 'Score of test',
        'onTap': (BuildContext context) async {
          if (selectedPatient != null) {
            // Show a loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(child: CircularProgressIndicator()),
            );

            try {
              // Fetch the patient's score from Firestore
              final scoreQuery = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(selectedPatient!.id)
                  .collection('patient_scores')
                  .orderBy('timestamp',
                      descending: true) // Fetch the latest score
                  .limit(1) // Limit to the most recent score
                  .get();

              // Close the loading dialog
              Navigator.pop(context);

              if (scoreQuery.docs.isNotEmpty) {
                // Extract the score from the document
                final scoreData = scoreQuery.docs.first.data();
                final totalScore = scoreData['totalScore'] ?? 0;

                // Show the score in a dialog
                DialogUtils.showMessage(
                  context: context,
                  title: 'Patient Score',
                  message: 'Total Score: $totalScore Out of 14',
                );
              } else {
                // If no score is found, show a message
                DialogUtils.showMessage(
                  context: context,
                  title: 'No Score Found',
                  message: 'No score found for this patient.',
                );
              }
            } catch (e) {
              // Close the loading dialog
              Navigator.pop(context);

              // Show an error message
              DialogUtils.showMessage(
                context: context,
                title: 'Error',
                message: 'Failed to fetch score: $e',
              );
            }
          } else {
            DialogUtils.showMessage(
              context: context,
              title: 'No Patient Selected',
              message: 'Please select a patient first.',
            );
          }
        },
      },
      // 6-reports
      {
        'icon': Icons.assignment,
        'label': 'Generate Report',
        'onTap': (BuildContext context) async {
          if (selectedPatient != null) {
            // Show a loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(child: CircularProgressIndicator()),
            );

            try {
              // Fetch analysis data from Firestore
              final taskProvider =
                  Provider.of<TaskProvider>(context, listen: false);
              await taskProvider
                  .calculateAndSaveAnalysisData(selectedPatient!.id);
              await taskProvider.fetchAnalysisData(selectedPatient!.id);

              // Get the analysis data from the provider
              final analysisData = taskProvider.analysisData;

              if (analysisData != null) {
                // Generate PDF and save it to a file
                final pdfFile = await PdfUtils.generatePdfReport(
                    analysisData, selectedPatient!.name);

                // Navigate to PDF Preview Screen
                Navigator.pop(context); // Close loading dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfPreviewScreen(pdfFile: pdfFile),
                  ),
                );
              } else {
                Navigator.pop(context); // Close loading dialog
                DialogUtils.showMessage(
                  context: context,
                  title: 'Error',
                  message: 'No analysis data found in Firestore.',
                );
              }
            } catch (e) {
              Navigator.pop(context); // Close loading dialog
              DialogUtils.showMessage(
                context: context,
                title: 'Error',
                message: 'Failed to generate report: $e',
              );
            }
          } else {
            DialogUtils.showMessage(
              context: context,
              title: 'No Patient Selected',
              message: 'Please select a patient first.',
            );
          }
        },
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Caregiver, ${userProvider.currentUser!.name}',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          IconButton(
            tooltip: 'Log Out',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            icon: const Icon(
              Icons.logout,
              color: AppColors.white,
              size: 35,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .1,
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'You are tracking the patient. Please select the patient to start.',
              textAlign: TextAlign.center,
            ),
          ),
          Consumer<PatientProvider>(
            builder: (context, patientProvider, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DropdownButton<MyUser>(
                  hint: Text(
                    // "Select Patient",
                    selectedPatient == null
                        ? "Select Patient"
                        : selectedPatient!.name,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  value: selectedPatient,
                  iconEnabledColor: AppColors.darkBlue,
                  isExpanded: true,
                  style: Theme.of(context).textTheme.bodySmall,
                  borderRadius: BorderRadius.circular(12),
                  onChanged: (MyUser? newPatient) async {
                    if (newPatient != null) {
                      setState(() {
                        selectedPatient = newPatient;
                      });
                      await taskProvider
                          .getAllTasksFromFireStore(newPatient.id);
                      // final analysisData = taskProvider.analysisData;
                      // print('Analysis Data: $analysisData');
                      // fetchTaskSummaryChart(); // Fetch the chart after patient selection
                      showPatientHomeLocation(selectedPatient!.id);
                    }
                  },
                  items: patientProvider.patientsList.map((patient) {
                    return DropdownMenuItem(
                      value: patient,
                      child: Text(patient.name),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          // GPS
          // ElevatedButton(
          //   onPressed: _fetchLocation,
          //   child: Text('Fetch Patient Location'),
          // ),
          // if (latitude != null && longitude != null)
          //   Expanded(
          //     child: GoogleMap(
          //       onMapCreated: _onMapCreated,
          //       initialCameraPosition: CameraPosition(
          //         target: LatLng(latitude!, longitude!),
          //         zoom: 15,
          //       ),
          //       markers: {
          //         Marker(
          //           markerId: MarkerId('patientLocation'),
          //           position: LatLng(latitude!, longitude!),
          //           infoWindow: InfoWindow(
          //             title: 'Patient Location',
          //             snippet: 'Last updated: $timestamp',
          //           ),
          //         ),
          //       },
          //     ),
          //   ),

          // ZoomableChartScreen(chartUrl: chartUrl!), xxx
          // Plotlyy
          // if (selectedPatient != null && chartUrl != null)

          // Grid for Different Functionalities
          Padding(
            padding: const EdgeInsets.all(15),
            child: GridView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust the number of columns as needed
                childAspectRatio: 1.5, // Adjust the aspect ratio of the cards
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: gridItems.length, // Use length of gridItems list
              itemBuilder: (context, index) {
                final item = gridItems[index];
                return GestureDetector(
                  onTap: () {
                    // Handle onTap for each item dynamically
                    if (item['onTap'] != null) {
                      item['onTap']!(
                          context); // Execute the onTap function if defined
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // color: Colors.amber[200],
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.mediumBlue),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'], // Use dynamic icon from gridItems
                          size: 50,
                          color: AppColors.darkBlue,
                        ),
                        Text(
                          item['label'], // Use dynamic label from gridItems
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkBlue),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /*
          ElevatedButton(
            onPressed: () {
              if (selectedPatient != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PlotlyChartScreen(userId: selectedPatient!.id),
                  ),
                );
              } else {
                // Optionally show a snackbar or dialog if no patient is selected
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select a patient first')),
                );
              }
            },
            child: Text('View Task Delay Chart'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedPatient != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DelayForecastScreen(
                      userId: selectedPatient!.id,
                      patientName: selectedPatient!.name, // Pass patient name
                    ),
                  ),
                );
              } else {
                // Optionally show a snackbar or dialog if no patient is selected
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select a patient first')),
                );
              }
            },
            child: Text('View Task Delay Forcasting'),
          ),
          */

          // _buildChartSection(taskProvider),
          // if (isLoadingChart)
          //   CircularProgressIndicator()
          // else if (errorMessageChart != null)
          //   Text(errorMessageChart!)
          // else if (chartUrl != null)
          // ZoomableChartScreen(chartUrl: chartUrl!)
          //   // Image.network(
          //   //   'http://10.0.2.2:5000/$chartUrl',
          //   //   loadingBuilder: (context, child, progress) {
          //   //     return progress == null ? child : CircularProgressIndicator();
          //   //   },
          //   // )
          // else
          //   Text('No chart available'),
          ///// successful task bar chart
          // Container(
          //   margin: const EdgeInsets.all(10),
          //   decoration: const BoxDecoration(
          //     color: AppColors.white,
          //   ),
          //   width: double.infinity,
          //   height: 300,
          //   child: Padding(
          //     padding: const EdgeInsets.all(10),
          //     child: taskProvider.incompleteTasks.isEmpty
          //         ? Center(child: const Text("No tasks to display"))
          //         : SizedBox(
          //             height: 300,
          //             child: TaskBarChart(
          //               incompleteData: taskProvider.getIncompleteTaskChartData(),
          //               completeData: taskProvider.getCompleteTaskChartData(),
          //               delayedData: taskProvider.getDelayedTasks(),
          //             ),
          //           ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildChartSection(TaskProvider taskProvider) {
    if (isLoadingChart) {
      return const Center(child: CircularProgressIndicator());
    } else if (errorMessageChart != null) {
      return Center(child: Text(errorMessageChart!));
    } else if (chartUrl != null) {
      return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.network(
            chartUrl!,
            loadingBuilder: (context, child, progress) {
              return progress == null
                  ? child
                  : const CircularProgressIndicator();
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('Error loading chart'));
            },
          ),
        ),
      );
    } else {
      return const Center(child: Text('No chart available'));
    }
  }
}




/////////////////////////**** */

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:graduation_app/utils/visualization/time_series.dart';
// import 'package:http/http.dart' as http;

// class CaregiverScreen extends StatefulWidget {
//   static const String routeName = 'caregiverScreen';
//   @override
//   _CaregiverScreenState createState() => _CaregiverScreenState();
// }

// class _CaregiverScreenState extends State<CaregiverScreen> {
//   List tasks = [];

//   // Fetch tasks from Flask API
//   Future<void> fetchTasks() async {
//     final url = Uri.parse('http://127.0.0.1:5000/tasks');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         setState(() {
//           tasks = json.decode(response.body);
//         });
//       } else {
//         throw Exception('Failed to load tasks');
//       }
//     } catch (error) {
//       print('Error fetching tasks: $error');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchTasks();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Caregiver Screen'),
//       ),
//       body: tasks.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 final task = tasks[index];
//                 return ListTile(
//                   title: Text(task['title']),
//                   subtitle: Text("Date: ${task['dateTime']}"),
//                   trailing: task['isDone']
//                       ? Icon(Icons.check, color: Colors.green)
//                       : Icon(Icons.close, color: Colors.red),
//                 );
//               },
//             ),
//     );
//   }
// }

/** works manually
import 'package:flutter/material.dart';
import 'package:graduation_app/utils/visualization/python_api.dart';
import 'package:graduation_app/utils/visualization/time_series.dart';

class CaregiverScreen extends StatefulWidget {
  static const String routeName = 'caregiverScreen';
  final String userId;

  CaregiverScreen({required this.userId});

  @override
  _CaregiverScreenState createState() => _CaregiverScreenState();
}

class _CaregiverScreenState extends State<CaregiverScreen> {
  Map<String, dynamic> taskSummary = {};

  @override
  void initState() {
    super.initState();
    fetchTaskSummary(widget.userId).then((data) {
      setState(() {
        taskSummary = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Summary')),
      body: taskSummary.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading until data is fetched
          : taskSummary.isNotEmpty &&
                  taskSummary['2024-12-02'] !=
                      null // Check if there's valid data
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TaskChart(summary: taskSummary),
                )
              : Center(
                  child: Text(
                      'No tasks available')), // Show a message if no valid data
    );
  }
}
*/

///////////xxxxx
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:graduation_app/model/user_data.dart';
// import 'package:graduation_app/providers/patient_provider.dart';
// import 'package:graduation_app/providers/task_provider.dart';
// import 'package:graduation_app/utils/theming/app_colors.dart';
// import 'package:graduation_app/utils/visualization/python_api.dart';
// import 'package:graduation_app/utils/visualization/time_series.dart';
// import 'package:provider/provider.dart'; // Adjust imports accordingly

// class CaregiverScreen extends StatefulWidget {
//   static const String routeName = 'caregiverScreen';
//   final String userId;

//   CaregiverScreen({required this.userId});

//   @override
//   _CaregiverScreenState createState() => _CaregiverScreenState();
// }

// class _CaregiverScreenState extends State<CaregiverScreen> {
//   Map<String, dynamic> taskSummary = {};
//   MyUser? selectedPatient;
//   // List<String> patientList = ['Patient 1', 'Patient 2', 'Patient 3']; // Replace with actual patient list

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final caregiverId = ModalRoute.of(context)!.settings.arguments as String;
//     Provider.of<PatientProvider>(context, listen: false)
//         .fetchPatients(caregiverId);
//     Provider.of<TaskProvider>(context, listen: false)
//         .fetchTaskSummary(selectedPatient!.id);
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Fetch tasks when the screen initializes
//     Provider.of<TaskProvider>(context, listen: false)
//         .getAllTasksFromFireStore(widget.userId);
//     Provider.of<TaskProvider>(context, listen: false)
//         .fetchTaskSummary(selectedPatient!.id);
//     // Fetch data for the first patient (or a default selection)
//     // if (PatientProvider..isNotEmpty) {
//     //   selectedPatient = patientList[0];
//     //   fetchTaskSummary(selectedPatient!).then((data) {
//     //     setState(() {
//     //       taskSummary = data;
//     //     });
//     //   });
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var taskProvider = Provider.of<TaskProvider>(context);
//     return Scaffold(
//       appBar: AppBar(title: Text('Task Summary')),
//       /*
//             body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         // crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(15),
//             child: Text('Choose Your Patient:'),
//           ),
//           Consumer<PatientProvider>(
//             builder: (context, patientProvider, _) {
//               //true
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25),
//                 child: DropdownButton<MyUser>(
//                   hint: Text(
//                     "Select Patient",
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                   value: selectedPatient,
//                   iconEnabledColor: AppColors.darkBlue,
//                   isExpanded: true,
//                   style: Theme.of(context).textTheme.bodySmall,
//                   borderRadius: BorderRadius.circular(12),
//                   onChanged: (MyUser? newPatient) async {
//                     if (newPatient != null) {
//                       print('Selected Patient: ${newPatient.name}');
//                       setState(() {
//                         selectedPatient =
//                             newPatient; // Set the selected patient
//                       });
//                       // // Fetch tasks for the selected patient *last*
//                       // await taskProvider.fetchTasksForPatient(newPatient.id);
//                       // await taskProvider.loadTasksForPatient(
//                       //     newPatient.id); // Call the loadTasksForPatient
//                       // Set current patient in TaskProvider to filter tasks
//                       // taskProvider.setCurrentPatient(newPatient); ////////
//                       await taskProvider
//                           .getAllTasksFromFireStore(newPatient.id);
//                       print(
//                           'Tasks for ${newPatient.name}: , Length of incomplete tasks: ${taskProvider.incompleteTasks.length}');
//                     }
//                   },
//                   items: patientProvider.patientsList.map((patient) {
//                     return DropdownMenuItem(
//                       value: patient, // Ensure patient is unique by ID
//                       child: Text(patient.name),
//                     );
//                   }).toList(),
//                 ),
//               );
//             },
//           ),
//        */
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // DropdownButton<String>(
//             //   value: selectedPatient,
//             //   onChanged: (String? newValue) {
//             //     setState(() {
//             //       selectedPatient = newValue;
//             //     });
//             //     if (selectedPatient != null) {
//             //       fetchTaskSummary(selectedPatient!).then((data) {
//             //         setState(() {
//             //           taskSummary = data;
//             //         });
//             //       });
//             //     }
//             //   },
//             //   items: patientList.map<DropdownMenuItem<String>>((String value) {
//             //     return DropdownMenuItem<String>(
//             //       value: value,
//             //       child: Text(value),
//             //     );
//             //   }).toList(),
//             // ),
//             // Expanded(
//             //   child: taskSummary.isEmpty
//             //       ? Center(child: CircularProgressIndicator())
//             //       : TaskChart(summary: taskSummary),
//             // ),
//             const Padding(
//               padding: EdgeInsets.all(15),
//               child: Text('Choose Your Patient:'),
//             ),
//             Consumer<PatientProvider>(
//               builder: (context, patientProvider, _) {
//                 //true
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: DropdownButton<MyUser>(
//                     hint: Text(
//                       "Select Patient",
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                     value: selectedPatient,
//                     iconEnabledColor: AppColors.darkBlue,
//                     isExpanded: true,
//                     style: Theme.of(context).textTheme.bodySmall,
//                     borderRadius: BorderRadius.circular(12),
//                     onChanged: (MyUser? newPatient) async {
//                       setState(() {
//                         selectedPatient =
//                             newPatient; // Set the selected patient
//                       });
//                       if (selectedPatient != null) {
//                         fetchTaskSummary(selectedPatient!.id).then((data) {
//                           setState(() {
//                             taskSummary = data;
//                           });
//                         });
//                       }
//                       //   if (newPatient != null) {
//                       //   print('Selected Patient: ${newPatient.name}');
//                       //   setState(() {
//                       //     selectedPatient =
//                       //         newPatient; // Set the selected patient
//                       //   });
//                       //   await taskProvider
//                       //       .fetchTaskSummary(newPatient.id);
//                       //   print(
//                       //       'Tasks for ${newPatient.name}: , Length of incomplete tasks: ${taskProvider.incompleteTasks.length}');
//                       // }
//                     },
//                     items: patientProvider.patientsList.map((patient) {
//                       return DropdownMenuItem(
//                         value: patient, // Ensure patient is unique by ID
//                         child: Text(patient.name),
//                       );
//                     }).toList(),
//                   ),
//                 );
//               },
//             ),
//             Expanded(
//               child: taskSummary.isEmpty
//                   ? Center(child: CircularProgressIndicator())
//                   : TaskChart(summary: taskSummary),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


//// last xxxxx

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:graduation_app/model/user_data.dart';
// import 'package:graduation_app/providers/patient_provider.dart';
// import 'package:graduation_app/providers/task_provider.dart';
// import 'package:graduation_app/utils/theming/app_colors.dart';
// import 'package:graduation_app/utils/visualization/python_api.dart';
// import 'package:graduation_app/utils/visualization/time_series.dart';
// import 'package:provider/provider.dart'; // Adjust imports accordingly

// class CaregiverScreen extends StatefulWidget {
//   static const String routeName = 'caregiverScreen';
//   final String userId;

//   CaregiverScreen({required this.userId});

//   @override
//   _CaregiverScreenState createState() => _CaregiverScreenState();
// }

// class _CaregiverScreenState extends State<CaregiverScreen> {
//   Map<String, dynamic> taskSummary = {};
//   MyUser? selectedPatient; // Initialize as null

//   @override
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final caregiverId = ModalRoute.of(context)!.settings.arguments as String;
//     Provider.of<PatientProvider>(context, listen: false)
//         .fetchPatients(caregiverId);

//     // Check if selectedPatient is not null before calling fetchTaskSummary
//     if (selectedPatient != null) {
//       Provider.of<TaskProvider>(context, listen: false)
//           .fetchTaskSummary(selectedPatient!.id);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Fetch tasks when the screen initializes
//     Provider.of<TaskProvider>(context, listen: false)
//         .getAllTasksFromFireStore(widget.userId);

//     // Check if selectedPatient is not null before calling fetchTaskSummary
//     if (selectedPatient != null) {
//       // Call the fetchTaskSummary method from TaskProvider
//       Provider.of<TaskProvider>(context, listen: false)
//           .fetchTaskSummary(selectedPatient!.id)
//           .then((data) {
//         setState(() {
//           taskSummary = data; // Update taskSummary state
//         });
//       }).catchError((error) {
//         print('Error fetching task summary: $error');
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var taskProvider = Provider.of<TaskProvider>(context);
//     return Scaffold(
//       appBar: AppBar(title: Text('Task Summary')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(15),
//               child: Text('Choose Your Patient:'),
//             ),
//             Consumer<PatientProvider>(
//               builder: (context, patientProvider, _) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: DropdownButton<MyUser>(
//                     hint: Text(
//                       "Select Patient",
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                     value: selectedPatient,
//                     iconEnabledColor: AppColors.darkBlue,
//                     isExpanded: true,
//                     style: Theme.of(context).textTheme.bodySmall,
//                     borderRadius: BorderRadius.circular(12),
//                     onChanged: (MyUser? newPatient) async {
//                       setState(() {
//                         selectedPatient =
//                             newPatient; // Set the selected patient
//                       });

//                       if (selectedPatient != null) {
//                         // Only fetch tasks if the selected patient is not null
//                         var data = await taskProvider
//                             .fetchTaskSummary(selectedPatient!.id);
//                         setState(() {
//                           taskSummary = data;
//                         });
//                       }
//                     },
//                     items: patientProvider.patientsList.map((patient) {
//                       return DropdownMenuItem(
//                         value: patient, // Ensure patient is unique by ID
//                         child: Text(patient.name),
//                       );
//                     }).toList(),
//                   ),
//                 );
//               },
//             ),
//             Expanded(
//               child: taskSummary.isEmpty
//                   ? Center(child: CircularProgressIndicator())
//                   : TaskChart(summary: taskSummary),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
