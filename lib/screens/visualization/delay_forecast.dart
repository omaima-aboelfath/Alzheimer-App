// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// import '../../model/api_manager.dart';

// class DelayForecastScreen extends StatefulWidget {
//   final String userId;

//   DelayForecastScreen({required this.userId});

//   @override
//   _DelayForecastScreenState createState() => _DelayForecastScreenState();
// }

// class _DelayForecastScreenState extends State<DelayForecastScreen> {
//   List<FlSpot> spots = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchForecast();
//   }

//   // Fetch forecasted delays and populate the chart data
//   Future<void> fetchForecast() async {
//     try {
//       var forecastData = await ApiManager.fetchForecastDelays(widget.userId);
//       List<FlSpot> newSpots = [];
//       for (var data in forecastData) {
//         newSpots.add(FlSpot(data['day'].toDouble(), data['forecasted_delay'].toDouble()));
//       }
//       setState(() {
//         spots = newSpots;
//       });
//     } catch (e) {
//       print('Error fetching forecast: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Patient Delay Forecast')),
//       body: spots.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : LineChart(
//               LineChartData(
//                 gridData: FlGridData(show: true),
//                 titlesData: FlTitlesData(show: true),
//                 borderData: FlBorderData(show: true),
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: spots,
//                     isCurved: true,
//                     color: Colors.blue,
//                     dotData: FlDotData(show: false),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:graduation_app/model/api_manager.dart';

// class DelayForecastScreen extends StatefulWidget {
//   final String userId;

//   DelayForecastScreen({required this.userId});

//   @override
//   _DelayForecastScreenState createState() => _DelayForecastScreenState();
// }

// class _DelayForecastScreenState extends State<DelayForecastScreen> {
//   List<FlSpot> spots = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchForecast();
//   }

//   // Fetch forecasted delays and populate the chart data
//   Future<void> fetchForecast() async {
//     try {
//       var forecastData = await ApiManager.fetchForecastDelays(widget.userId);
//       List<FlSpot> newSpots = [];
//       for (var data in forecastData) {
//         // Assuming 'day' and 'forecasted_delay' are keys in the response data
//         newSpots.add(FlSpot(data['day'].toDouble(), data['forecasted_delay'].toDouble()));
//       }
//       setState(() {
//         spots = newSpots;
//       });
//     } catch (e) {
//       print('Error fetching forecast: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Patient Delay Forecast')),
//       body: spots.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : LineChart(
//               LineChartData(
//                 gridData: FlGridData(show: true),
//                 titlesData: FlTitlesData(show: true),
//                 borderData: FlBorderData(show: true),
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: spots,
//                     isCurved: true,
//                     color: Colors.blue,
//                     dotData: FlDotData(show: false),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:graduation_app/model/api_manager.dart';

// class DelayForecastScreen extends StatefulWidget {
//   final String userId;

//   DelayForecastScreen({required this.userId});

//   @override
//   _DelayForecastScreenState createState() => _DelayForecastScreenState();
// }

// class _DelayForecastScreenState extends State<DelayForecastScreen> {
//   List<FlSpot> spots = [];
//   Map<String, dynamic>? reminderStrategy;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchForecastAndStrategy();
//   }

//   Future<void> fetchForecastAndStrategy() async {
//     try {
//       // Fetch both forecast and adaptive reminder strategy
//       var forecastData = await ApiManager.fetchForecastDelays(widget.userId);
//       var strategyData = await ApiManager.fetchAdaptiveReminderStrategy(widget.userId);

//       List<FlSpot> newSpots = [];
//       for (var data in forecastData) {
//         newSpots.add(FlSpot(
//           data['day'].toDouble(),
//           data['forecasted_delay'].toDouble()
//         ));
//       }

//       setState(() {
//         spots = newSpots;
//         reminderStrategy = strategyData;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching data: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Patient Delay Forecast')),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // Existing Line Chart
//                 Expanded(
//                   child: LineChart(
//                     LineChartData(
//                       gridData: FlGridData(show: true),
//                       titlesData: FlTitlesData(show: true),
//                       borderData: FlBorderData(show: true),
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: spots,
//                           isCurved: true,
//                           color: Colors.blue,
//                           dotData: FlDotData(show: true),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Reminder Strategy Card
//                 if (reminderStrategy != null)
//                   Card(
//                     child: ListTile(
//                       title: Text('Adaptive Reminder Strategy'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Reminders per Day: ${reminderStrategy!['reminders_per_day']}'),
//                           Text('Intervals: ${reminderStrategy!['reminder_intervals']}'),
//                           Text('Severity: ${reminderStrategy!['severity']}'),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//     );
//   }
// }

// test 2
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:graduation_app/model/api_manager.dart';
// import 'package:graduation_app/model/user_data.dart';

// class DelayForecastScreen extends StatefulWidget {
//   final String userId;
//   final String patientName;
//   const DelayForecastScreen({Key? key, required this.userId, required this.patientName}) : super(key: key);
//   @override
//   _DelayForecastScreenState createState() => _DelayForecastScreenState();
// }
// class _DelayForecastScreenState extends State<DelayForecastScreen> {
//   List<FlSpot> spots = [];
//   Map<String, dynamic>? reminderStrategy;
//   Map<String, dynamic>? delayStatistics;
//   bool isLoading = true;
//   String errorMessage = '';
//   @override
//   void initState() {
//     super.initState();
//     fetchForecastAndStrategy();
//   }

//   Future<void> fetchForecastAndStrategy() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     try {
//       // Fetch forecast and reminder strategy concurrently
//       final results = await Future.wait([
//         ApiManager.fetchForecastDelays(widget.userId),
//         ApiManager.fetchAdaptiveReminderStrategy(widget.userId)
//       ]);

//       // Process forecast data
//       List<dynamic> forecastData = results[0];
//       Map<String, dynamic> strategyData = results[1];

//       List<FlSpot> newSpots = forecastData.map((data) {
//         return FlSpot((data['day'] as num).toDouble(),
//             (data['forecasted_delay'] as num).toDouble());
//       }).toList();

//       setState(() {
//         spots = newSpots;
//         reminderStrategy = strategyData['reminder_strategy'];
//         delayStatistics = strategyData['delay_statistics'];
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error fetching data: $e';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Patient Delay Forecast',
//           style: Theme.of(context).textTheme.displayMedium,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: fetchForecastAndStrategy,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage.isNotEmpty
//               ? Center(child: Text(errorMessage))
//               : SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         // Delay Forecast Chart
//                         Card(
//                           elevation: 4,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               children: [
//                                 Text(
//                                   'Delay Forecast for ${widget.patientName}',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 SizedBox(
//                                   height: 250,
//                                   child: LineChart(
//                                     LineChartData(
//                                       gridData: FlGridData(show: true),
//                                       titlesData: FlTitlesData(
//                                         show: true,
//                                         leftTitles: AxisTitles(
//                                           axisNameWidget:
//                                               const Text('Delay (minutes)'),
//                                         ),
//                                         bottomTitles: AxisTitles(
//                                           axisNameWidget: const Text('Days'),
//                                         ),
//                                       ),
//                                       borderData: FlBorderData(show: true),
//                                       lineBarsData: [
//                                         LineChartBarData(
//                                           spots: spots,
//                                           isCurved: true,
//                                           color: Colors.blue,
//                                           dotData: FlDotData(show: true),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 16),

//                         // Delay Statistics Card
//                         if (delayStatistics != null)
//                           Card(
//                             elevation: 4,
//                             child: ListTile(
//                               title: const Text(
//                                 'Delay Statistics',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                       'Mean Delay: ${delayStatistics!['mean_delay'].toStringAsFixed(2)} minutes'),
//                                   Text(
//                                       'Median Delay: ${delayStatistics!['median_delay'].toStringAsFixed(2)} minutes'),
//                                   Text(
//                                       'Delay Trend: ${delayStatistics!['recent_trend']}'),
//                                 ],
//                               ),
//                             ),
//                           ),

//                         const SizedBox(height: 16),

//                         // Reminder Strategy Card
//                         if (reminderStrategy != null)
//                           Card(
//                             elevation: 4,
//                             child: ListTile(
//                               title: const Text(
//                                 'Adaptive Reminder Strategy',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                       'Reminders per Day: ${reminderStrategy!['reminders_per_day']}'),
//                                   Text(
//                                       'Intervals: ${reminderStrategy!['reminder_intervals']}'),
//                                   Text(
//                                       'Severity: ${reminderStrategy!['severity']}'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//     );
//   }
// }

/////////////////////////////////////////////////////////////

/* my code
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:graduation_app/model/api_manager.dart';
import 'package:graduation_app/model/user_data.dart';
import 'package:graduation_app/utils/firebase_utils.dart';

class DelayForecastScreen extends StatefulWidget {
  final String userId;
  final String patientName;

  const DelayForecastScreen(
      {Key? key, required this.userId, required this.patientName})
      : super(key: key);

  @override
  _DelayForecastScreenState createState() => _DelayForecastScreenState();
}

class _DelayForecastScreenState extends State<DelayForecastScreen> {
  List<FlSpot> spots = [];
  Map<String, dynamic>? reminderStrategy;
  Map<String, dynamic>? delayStatistics;
  List<Map<String, dynamic>> recommendations = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchForecastAndStrategy();
  }

  // Future<void> fetchForecastAndStrategy() async {
  //   setState(() {
  //     isLoading = true;
  //     errorMessage = '';
  //   });
  //   try {
  //     // Fetch forecast and reminder strategy concurrently
  //     final results = await Future.wait([
  //       ApiManager.fetchForecastDelays(widget.userId),
  //       ApiManager.fetchAdaptiveReminderStrategy(widget.userId)
  //     ]);
  //     // Safely process forecast data
  //     List<dynamic> forecastData = results[0] as List<dynamic>;
  //     Map<String, dynamic> strategyData = results[1] as Map<String, dynamic>;
  //     // Parse spots (x, y) for LineChart
  //     List<FlSpot> newSpots = forecastData.map((data) {
  //       return FlSpot((data['day'] as num).toDouble(),
  //           (data['forecasted_delay'] as num).toDouble());
  //     }).toList();
  //     // Safely handle recommendations
  //     List<String> newRecommendations =
  //         List<String>.from(strategyData['recommendations'] ?? []);
  //     // Save data to Firestore
  //     await FirebaseUtils.saveAnalysisToFirestore(strategyData, widget.userId);
  //     setState(() {
  //       spots = newSpots;
  //       reminderStrategy = strategyData; // Adaptive reminder strategy data
  //       delayStatistics = strategyData['recent_task_performance'];
  //       recommendations =
  //           newRecommendations.map((message) => {'message': message}).toList();
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Error fetching data: $e';
  //       isLoading = false;
  //     });
  //   }
  // }

  //2222
  Future<void> fetchForecastAndStrategy() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      // Fetch forecast and reminder strategy concurrently with a timeout
      final results = await Future.wait([
        ApiManager.fetchForecastDelays(widget.userId)
            .timeout(Duration(seconds: 10)),
        ApiManager.fetchAdaptiveReminderStrategy(widget.userId)
            .timeout(Duration(seconds: 10)),
      ]);

      // Safely process forecast data
      List<dynamic> forecastData = results[0] as List<dynamic>;
      Map<String, dynamic> strategyData = results[1] as Map<String, dynamic>;

      // Parse spots (x, y) for LineChart
      List<FlSpot> newSpots = forecastData.map((data) {
        return FlSpot((data['day'] as num).toDouble(),
            (data['forecasted_delay'] as num).toDouble());
      }).toList();

      // Safely handle recommendations
      List<String> newRecommendations =
          List<String>.from(strategyData['recommendations'] ?? []);

      // Save data to Firestore
      await FirebaseUtils.saveAnalysisToFirestore(strategyData, widget.userId);

      setState(() {
        spots = newSpots;
        reminderStrategy = strategyData; // Adaptive reminder strategy data
        delayStatistics = strategyData['recent_task_performance'];
        recommendations =
            newRecommendations.map((message) => {'message': message}).toList();
        isLoading = false;
      });
    } on TimeoutException catch (e) {
      setState(() {
        errorMessage =
            'Request timed out. Please check your internet connection.';
        isLoading = false;
      });
      // Debug: Print the error
      print('Request timed out: $e');
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });

      // Debug: Print the error
      print('Error fetching data: $e');
    }
  }

  Widget buildChartSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Delay Forecast for ${widget.patientName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text('Delay (minutes)'),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Days'),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildStatisticsCard(String title, Map<String, dynamic> statistics) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: statistics.entries.map((entry) {
            return Text('${entry.key}: ${entry.value}');
          }).toList(),
        ),
      ),
    );
  }

  // Widget buildStatisticsCard(String title, Map<String, dynamic> statistics) {
  //   return Card(
  //     elevation: 4,
  //     child: ListTile(
  //       title: Text(
  //         title,
  //         style: const TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       subtitle: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('completed: ${reminderStrategy?['completed_tasks'] ?? 0}'),
  //           Text('incomplete: ${reminderStrategy?['incomplete_tasks'] ?? 0}'),
  //           Text('total_tasks: ${reminderStrategy?['total_tasks'] ?? 0}'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget buildRecommendationSection() {
    return Card(
      elevation: 4,
      child: ListTile(
        title: const Text(
          'Recommendations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: recommendations.map((rec) {
            return Text('- ${rec['message']}');
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Delay Forecast',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchForecastAndStrategy,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildChartSection(),
                        const SizedBox(height: 16),
                        if (delayStatistics != null)
                          //   buildStatisticsCard(
                          //       'Delay Statistics', delayStatistics!),
                          // const SizedBox(height: 16),
                          if (reminderStrategy != null)
                            buildStatisticsCard('Adaptive Reminder Strategy',
                                reminderStrategy!),
                        const SizedBox(height: 16),
                        if (recommendations.isNotEmpty)
                          buildRecommendationSection(),
                      ],
                    ),
                  ),
                ),
    );
  }
}
*/

// first try
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:graduation_app/model/api_manager.dart';
import 'package:graduation_app/utils/firebase_utils.dart';

class DelayForecastScreen extends StatefulWidget {
  final String userId;
  final String patientName;

  const DelayForecastScreen({
    Key? key,
    required this.userId,
    required this.patientName,
  }) : super(key: key);

  @override
  _DelayForecastScreenState createState() => _DelayForecastScreenState();
}

class _DelayForecastScreenState extends State<DelayForecastScreen> {
  List<FlSpot> spots = [];
  Map<String, dynamic>? reminderStrategy;
  Map<String, dynamic>? delayStatistics;
  List<Map<String, dynamic>> recommendations = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchForecastAndStrategy();
  }

  // my function
  // Future<void> fetchForecastAndStrategy() async {
  //   setState(() {
  //     isLoading = true;
  //     errorMessage = '';
  //   });
  //   try {
  //     final results = await Future.wait([
  //       ApiManager.fetchForecastDelays(widget.userId).timeout(Duration(seconds: 10)),
  //       ApiManager.fetchAdaptiveReminderStrategy(widget.userId).timeout(Duration(seconds: 10)),
  //     ]);
  //     List<dynamic> forecastData = results[0] as List<dynamic>;
  //     Map<String, dynamic> strategyData = results[1] as Map<String, dynamic>;
  //     List<FlSpot> newSpots = forecastData.map((data) {
  //       return FlSpot((data['day'] as num).toDouble(), (data['forecasted_delay'] as num).toDouble());
  //     }).toList();
  //     List<String> newRecommendations = List<String>.from(strategyData['recommendations'] ?? []);
  //     await FirebaseUtils.saveAnalysisToFirestore(strategyData, widget.userId);
  //     setState(() {
  //       spots = newSpots;
  //       reminderStrategy = strategyData;
  //       delayStatistics = strategyData['recent_task_performance'];
  //       recommendations = newRecommendations.map((message) => {'message': message}).toList();
  //       isLoading = false;
  //     });
  //   } on TimeoutException catch (e) {
  //     setState(() {
  //       errorMessage = 'Request timed out. Please check your internet connection.';
  //       isLoading = false;
  //     });
  //     print('Request timed out: $e');
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Error fetching data: $e';
  //       isLoading = false;
  //     });
  //     print('Error fetching data: $e');
  //   }
  // }

  // Future<void> fetchForecastAndStrategy() async {
  //   setState(() {
  //     isLoading = true;
  //     errorMessage = '';
  //   });
  //   try {
  //     final forecastData = await ApiManager.fetchForecastDelays(widget.userId)
  //         .timeout(Duration(seconds: 10));
  //     // Process forecast data
  //     List<FlSpot> newSpots = forecastData.map((data) {
  //       return FlSpot((data['day'] as num).toDouble(),
  //           (data['forecasted_delay'] as num).toDouble());
  //     }).toList();
  //     // Fetch reminder strategy (handle errors separately)
  //     Map<String, dynamic> strategyData;
  //     try {
  //       strategyData =
  //           await ApiManager.fetchAdaptiveReminderStrategy(widget.userId)
  //               .timeout(Duration(seconds: 10));
  //     } catch (e) {
  //       strategyData = {
  //         "recommendations": [],
  //         "recent_task_performance": {},
  //         "total_tasks": 0,
  //         "completed_tasks": 0,
  //         "incomplete_tasks": 0,
  //         "delayed_tasks": 0,
  //         "trend": "No trend data",
  //         "reminder_adjustment": "No adjustment data",
  //       };
  //       setState(() {
  //         errorMessage = 'Failed to load reminder strategy: $e';
  //       });
  //     }
  //     // Save data to Firestore
  //     await FirebaseUtils.saveAnalysisToFirestore(strategyData, widget.userId);
  //     setState(() {
  //       spots = newSpots;
  //       reminderStrategy = strategyData;
  //       delayStatistics = strategyData['recent_task_performance'];
  //       recommendations =
  //           (strategyData['recommendations'] as List<dynamic>? ?? [])
  //               .map((message) => {'message': message.toString()})
  //               .toList();
  //       isLoading = false;
  //     });
  //   } on TimeoutException catch (e) {
  //     setState(() {
  //       errorMessage =
  //           'Request timed out. Please check your internet connection.';
  //       isLoading = false;
  //     });
  //     print('Request timed out: $e');
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Error fetching data: $e';
  //       isLoading = false;
  //     });
  //     print('Error fetching data: $e');
  //   }
  // }


// Future<void> fetchForecastAndStrategy() async {
//   setState(() {
//     isLoading = true;
//     errorMessage = '';
//   });
//   try {
//     // Fetch forecast data
//     final forecastData = await ApiManager.fetchForecastDelays(widget.userId).timeout(Duration(seconds: 10));

//     // // Extract forecast data
//     // final forecastData = forecastResponse['forecast_data'] as List<dynamic>;
//     // final averageDailyDelays = forecastResponse['average_daily_delays'] as Map<String, dynamic>;
//     // final completedTasks = int.parse(forecastResponse['completed_tasks'].toString());
//     // final delayedTasks = forecastResponse['delayed_tasks'] as int;
//     // final totalTasks = forecastResponse['total_tasks'] as int;
//     // final trend = forecastResponse['trend'] as String;
//     // final reminderAdjustment = forecastResponse['reminder_adjustment'] as String;

//     // Process forecast data for the chart
//     List<FlSpot> newSpots = forecastData.map((data) {
//       return FlSpot((data['day'] as num).toDouble(), (data['forecasted_delay'] as num).toDouble());
//     }).toList();

//     // Update state
//     setState(() {
//       spots = newSpots;
//       reminderStrategy = {
//         'average_daily_delays': averageDailyDelays,
//         'completed_tasks': completedTasks,
//         'delayed_tasks': delayedTasks,
//         'total_tasks': totalTasks,
//         'trend': trend,
//         'reminder_adjustment': reminderAdjustment,
//       };
//       isLoading = false;
//     });
//   } on TimeoutException catch (e) {
//     setState(() {
//       errorMessage = 'Request timed out. Please check your internet connection.';
//       isLoading = false;
//     });
//     print('Request timed out: $e');
//   } catch (e) {
//     setState(() {
//       errorMessage = 'Error fetching data: $e';
//       isLoading = false;
//     });
//     print('Error fetching data: $e');
//   }
// }


Future<void> fetchForecastAndStrategy() async {
  setState(() {
    isLoading = true;
    errorMessage = '';
  });

  try {
    // Fetch forecast data
    final forecastData = await ApiManager.fetchForecastDelays(widget.userId).timeout(Duration(seconds: 10));

    // Process forecast data
    List<FlSpot> newSpots = forecastData.map((data) {
      return FlSpot(
        (data['day'] as num).toDouble(), // Ensure 'day' is a number
        (data['forecasted_delay'] as num).toDouble(), // Ensure 'forecasted_delay' is a number
      );
    }).toList();

    // Fetch reminder strategy (handle errors separately)
    Map<String, dynamic> strategyData;
    try {
      strategyData = await ApiManager.fetchAdaptiveReminderStrategy(widget.userId).timeout(Duration(seconds: 10));
    } catch (e) {
      strategyData = {
        "average_daily_delays": {},
        "recent_task_performance": {},
        "total_tasks": 0,
        "completed_tasks": 0,
        "incomplete_tasks": 0,
        "delayed_tasks": 0,
        "trend": "No trend data",
        "reminder_adjustment": "No adjustment data",
      };
      setState(() {
        errorMessage = 'Failed to load reminder strategy: $e';
      });
    }

    // Convert string values to integers (if necessary)
    final completedTasks = int.tryParse(strategyData['completed_tasks'].toString()) ?? 0;
    final delayedTasks = int.tryParse(strategyData['delayed_tasks'].toString()) ?? 0;
    final totalTasks = int.tryParse(strategyData['total_tasks'].toString()) ?? 0;

    // Save data to Firestore
    await FirebaseUtils.saveAnalysisToFirestore(strategyData, widget.userId);

    // Update state
    setState(() {
      spots = newSpots;
      reminderStrategy = strategyData;
      delayStatistics = strategyData['recent_task_performance'];
      recommendations = (strategyData['recommendations'] as List<dynamic>? ?? [])
          .map((message) => {'message': message.toString()})
          .toList();
      isLoading = false;
    });
  } on TimeoutException catch (e) {
    setState(() {
      errorMessage = 'Request timed out. Please check your internet connection.';
      isLoading = false;
    });
    print('Request timed out: $e');
  } catch (e) {
    setState(() {
      errorMessage = 'Error fetching data: $e';
      isLoading = false;
    });
    print('Error fetching data: $e');
  }
}

  // Widget buildChartSection() {
  //   return Card(
  //     elevation: 4,
  //     margin: EdgeInsets.all(8),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           Text(
  //             'Delay Forecast for ${widget.patientName}',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 10),
  //           SizedBox(
  //             height: 250,
  //             child: LineChart(
  //               LineChartData(
  //                 gridData: FlGridData(show: true),
  //                 titlesData: FlTitlesData(
  //                   show: true,
  //                   leftTitles: AxisTitles(
  //                     axisNameWidget: Text('Delay (minutes)'),
  //                   ),
  //                   bottomTitles: AxisTitles(
  //                     axisNameWidget: Text('Days'),
  //                   ),
  //                 ),
  //                 borderData: FlBorderData(show: true),
  //                 lineBarsData: [
  //                   LineChartBarData(
  //                     spots: spots,
  //                     isCurved: true,
  //                     color: Colors.blue,
  //                     dotData: FlDotData(show: true),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget buildStatisticsCard(String title, Map<String, dynamic> statistics) {
  //   return Card(
  //     elevation: 4,
  //     margin: EdgeInsets.all(8),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             title,
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 10),
  //           Text('Total Tasks: ${statistics['total_tasks'] ?? 0}'),
  //           Text('Completed Tasks: ${statistics['completed_tasks'] ?? 0}'),
  //           Text('Incomplete Tasks: ${statistics['incomplete_tasks'] ?? 0}'),
  //           Text('Delayed Tasks: ${statistics['delayed_tasks'] ?? 0}'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget buildTrendCard(String trend, String reminderAdjustment) {
  //   return Card(
  //     elevation: 4,
  //     margin: EdgeInsets.all(8),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Trend & Reminders',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 10),
  //           Text('Trend: $trend'),
  //           Text('Reminder Adjustment: $reminderAdjustment'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget buildRecommendationSection() {
  //   return Card(
  //     elevation: 4,
  //     margin: EdgeInsets.all(8),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Recommendations',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 10),
  //           ...recommendations.map((rec) => Text('- ${rec['message']}')).toList(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(
  //         'Patient Delay Forecast',
  //         style: Theme.of(context).textTheme.displayMedium,
  //       ),
  //       actions: [
  //         IconButton(
  //           icon: const Icon(Icons.refresh),
  //           onPressed: fetchForecastAndStrategy,
  //         ),
  //       ],
  //     ),
  //     body: isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : errorMessage.isNotEmpty
  //             ? Center(child: Text(errorMessage))
  //             : SingleChildScrollView(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.stretch,
  //                     children: [
  //                       buildChartSection(),
  //                       SizedBox(height: 16),
  //                       if (reminderStrategy != null)
  //                         buildStatisticsCard('Task Statistics', reminderStrategy!),
  //                       SizedBox(height: 16),
  //                       buildTrendCard(
  //                         reminderStrategy?['trend'] ?? 'No trend data',
  //                         reminderStrategy?['reminder_adjustment'] ?? 'No adjustment data',
  //                       ),
  //                       SizedBox(height: 16),
  //                       if (recommendations.isNotEmpty) buildRecommendationSection(),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //   );
  // }

  //seconddd
  // Widget buildChartSection() {
  //   return Card(
  //     elevation: 4,
  //     margin: EdgeInsets.all(8),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           Text(
  //             'Delay Forecast for ${widget.patientName}',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 10),
  //           spots.isEmpty
  //               ? Text('No delay data available for visualization.')
  //               : SizedBox(
  //                   height: 250,
  //                   child: LineChart(
  //                     LineChartData(
  //                       gridData: FlGridData(show: true),
  //                       titlesData: FlTitlesData(
  //                         show: true,
  //                         leftTitles: AxisTitles(
  //                           axisNameWidget: Text('Delay (minutes)'),
  //                         ),
  //                         bottomTitles: AxisTitles(
  //                           axisNameWidget: Text('Days'),
  //                         ),
  //                       ),
  //                       borderData: FlBorderData(show: true),
  //                       lineBarsData: [
  //                         LineChartBarData(
  //                           spots: spots,
  //                           isCurved: true,
  //                           color: Colors.blue,
  //                           dotData: FlDotData(show: true),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget buildStatisticsCard(String title, Map<String, dynamic> statistics) {
  //   return Card(
  //     elevation: 4,
  //     margin: EdgeInsets.all(8),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             title,
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 10),
  //           Text('Total Tasks: ${statistics['total_tasks'] ?? 0}'),
  //           Text('Completed Tasks: ${statistics['completed_tasks'] ?? 0}'),
  //           Text('Incomplete Tasks: ${statistics['incomplete_tasks'] ?? 0}'),
  //           Text('Delayed Tasks: ${statistics['delayed_tasks'] ?? 0}'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget buildTrendCard(String trend, String reminderAdjustment) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trend & Reminders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Trend: $trend'),
            Text('Reminder Adjustment: $reminderAdjustment'),
          ],
        ),
      ),
    );
  }

//// third
  Widget buildStatisticsCard(String title, Map<String, dynamic> statistics) {
  return Card(
    elevation: 4,
    margin: EdgeInsets.all(8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Total Tasks: ${statistics['total_tasks'] ?? 0}'),
          Text('Completed Tasks: ${statistics['completed_tasks'] ?? 0}'),
          Text('Delayed Tasks: ${statistics['delayed_tasks'] ?? 0}'),
          Text('Trend: ${statistics['trend'] ?? "No trend data"}'),
          Text('Reminder Adjustment: ${statistics['reminder_adjustment'] ?? "No adjustment data"}'),
        ],
      ),
    ),
  );
}

Widget buildChartSection() {
  return Card(
    elevation: 4,
    margin: EdgeInsets.all(8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Delay Forecast for ${widget.patientName}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          spots.isEmpty
              ? Text('No delay data available for visualization.')
              : SizedBox(
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          axisNameWidget: Text('Delay (minutes)'),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget: Text('Days'),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.blue,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Delay Forecast',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchForecastAndStrategy,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildChartSection(),
                        SizedBox(height: 16),
                        if (reminderStrategy != null)
                          buildStatisticsCard(
                              'Task Statistics', reminderStrategy!),
                        SizedBox(height: 16),
                        buildTrendCard(
                          reminderStrategy?['trend'] ?? 'No trend data',
                          reminderStrategy?['reminder_adjustment'] ??
                              'No adjustment data',
                        ),
                        SizedBox(height: 16),
                        if (errorMessage.contains('reminder strategy'))
                          Text(
                              'Error fetching reminder strategy: Failed to load reminder strategy.'),
                      ],
                    ),
                  ),
                ),
    );
  }
}

///second try
