// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';
// import '../../providers/task_provider.dart';

// class TasksDelayScreen extends StatelessWidget {
//   final String userId;
//   TasksDelayScreen({required this.userId});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tasks Delay Over Time'),
//       ),
//       body: Consumer<TaskProvider>(
//         builder: (context, taskProvider, child) {
//           // Get scatter plot data
//           final scatterData = taskProvider.getDelayedTasksScatterData(userId);

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: LineChart(
//                     LineChartData(
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: scatterData
//                               .map((spot) => FlSpot(spot.x, spot.y))
//                               .toList(),
//                           isCurved: true,
//                           color: Colors.blue,
//                           dotData: FlDotData(show: true),
//                           belowBarData: BarAreaData(show: false),
//                         ),
//                       ],
//                       minX: scatterData.isEmpty
//                           ? 0
//                           : scatterData
//                               .map((spot) => spot.x)
//                               .reduce((a, b) => a < b ? a : b),
//                       maxX: scatterData.isEmpty
//                           ? 1
//                           : scatterData
//                               .map((spot) => spot.x)
//                               .reduce((a, b) => a > b ? a : b),
//                       minY: scatterData.isEmpty
//                           ? 0
//                           : scatterData
//                               .map((spot) => spot.y)
//                               .reduce((a, b) => a < b ? a : b),
//                       maxY: scatterData.isEmpty
//                           ? 1
//                           : scatterData
//                               .map((spot) => spot.y)
//                               .reduce((a, b) => a > b ? a : b),
//                       borderData: FlBorderData(
//                         show: true,
//                         border: Border(
//                           bottom: BorderSide(color: Colors.black, width: 1),
//                           left: BorderSide(color: Colors.black, width: 1),
//                         ),
//                       ),
//                       gridData: FlGridData(
//                         show: true,
//                         drawVerticalLine: true,
//                         drawHorizontalLine: true,
//                         getDrawingHorizontalLine: (value) {
//                           return FlLine(
//                             color: Colors.grey.withOpacity(0.3),
//                             strokeWidth: 1,
//                           );
//                         },
//                         getDrawingVerticalLine: (value) {
//                           return FlLine(
//                             color: Colors.grey.withOpacity(0.3),
//                             strokeWidth: 1,
//                           );
//                         },
//                       ),
//                       titlesData: FlTitlesData(
//                         show: true,
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             getTitlesWidget: (value, meta) {
//                               final date = DateTime.fromMillisecondsSinceEpoch(
//                                   value.toInt());
//                               return Text('${date.day}/${date.month}');
//                             },
//                           ),
//                         ),
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             getTitlesWidget: (value, meta) {
//                               return Text('${value.toInt()}m');
//                             },
//                           ),
//                         ),
//                         topTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                         rightTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

//2
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';
// import '../../providers/task_provider.dart';

// class TasksDelayScreen extends StatelessWidget {
//   final String userId;
//   TasksDelayScreen({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tasks Delay Over Time'),
//       ),
//       body: Consumer<TaskProvider>(
//         builder: (context, taskProvider, child) {
//           // Get scatter plot data
//           final scatterData = taskProvider.getDelayedTasksScatterData(userId);

//           // Filter out invalid or zero values
//           final filteredScatterData =
//               scatterData.where((spot) => spot.y > 0).toList();

//           return Padding(
//             padding: const EdgeInsets.all(8.0), // Reduced padding
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 300, // Set a fixed height for the chart
//                     child: ScatterChart(
//                       ScatterChartData(
//                         scatterSpots: filteredScatterData,
//                         minX: filteredScatterData.isEmpty
//                             ? 0
//                             : filteredScatterData
//                                 .map((spot) => spot.x)
//                                 .reduce((a, b) => a < b ? a : b),
//                         maxX: filteredScatterData.isEmpty
//                             ? 1
//                             : filteredScatterData
//                                 .map((spot) => spot.x)
//                                 .reduce((a, b) => a > b ? a : b),
//                         minY: filteredScatterData.isEmpty
//                             ? 0
//                             : filteredScatterData
//                                 .map((spot) => spot.y)
//                                 .reduce((a, b) => a < b ? a : b),
//                         maxY: filteredScatterData.isEmpty
//                             ? 1
//                             : filteredScatterData
//                                 .map((spot) => spot.y)
//                                 .reduce((a, b) => a > b ? a : b),
//                         borderData: FlBorderData(
//                           show: true,
//                           border: Border(
//                             bottom: BorderSide(color: Colors.black, width: 1),
//                             left: BorderSide(color: Colors.black, width: 1),
//                           ),
//                         ),
//                         gridData: FlGridData(
//                           show: true,
//                           drawVerticalLine: true,
//                           drawHorizontalLine: true,
//                           getDrawingHorizontalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                           getDrawingVerticalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                         ),
//                         titlesData: FlTitlesData(
//                           show: true,
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 22, // Space for titles
//                               interval: (filteredScatterData.isEmpty
//                                   ? 1
//                                   : (filteredScatterData
//                                               .map((spot) => spot.x)
//                                               .reduce((a, b) => a > b ? a : b) -
//                                           filteredScatterData
//                                               .map((spot) => spot.x)
//                                               .reduce(
//                                                   (a, b) => a < b ? a : b)) /
//                                       5), // Adjust interval
//                               getTitlesWidget: (value, meta) {
//                                 // Convert timestamp to date
//                                 final date =
//                                     DateTime.fromMillisecondsSinceEpoch(
//                                         value.toInt());
//                                 return Text('${date.day}/${date.month}',
//                                     style: TextStyle(
//                                         fontSize: 10)); // Smaller font size
//                               },
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 28, // Space for titles
//                               interval: (filteredScatterData.isEmpty
//                                   ? 1
//                                   : (filteredScatterData
//                                               .map((spot) => spot.y)
//                                               .reduce((a, b) => a > b ? a : b) -
//                                           filteredScatterData
//                                               .map((spot) => spot.y)
//                                               .reduce(
//                                                   (a, b) => a < b ? a : b)) /
//                                       5), // Adjust interval
//                               getTitlesWidget: (value, meta) {
//                                 return Text('${value.toInt()}m',
//                                     style: TextStyle(
//                                         fontSize: 10)); // Smaller font size
//                               },
//                             ),
//                           ),
//                           topTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           rightTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                         ),
//                         // scatterTouchData: ScatterTouchData(
//                         //   enabled: true,
//                         //   touchTooltipData: ScatterTouchTooltipData(
//                         //     getTooltipItems: (List<ScatterSpot> spots) {
//                         //       if (spots.isEmpty) {
//                         //         return null; // Return null if no spots are available
//                         //       }
//                         //       return spots.map((spot) {
//                         //         final date =
//                         //             DateTime.fromMillisecondsSinceEpoch(
//                         //                 spot.x.toInt());
//                         //         return ScatterTooltipItem(
//                         //           'Date: ${date.day}/${date.month}\nDelay: ${spot.y.toInt()}m',
//                         //           textStyle: const TextStyle(
//                         //               color:
//                         //                   Colors.white), // Use named argument
//                         //         );
//                         //       }).toList();
//                         //     },
//                         //   ),
//                         // ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

//3
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../providers/task_provider.dart';

// class TasksDelayScreen extends StatelessWidget {
//   final String userId;
//   TasksDelayScreen({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tasks Delay Over Time'),
//       ),
//       body: Consumer<TaskProvider>(
//         builder: (context, taskProvider, child) {
//           // Get scatter plot data
//           final scatterData = taskProvider.getDelayedTasksScatterData(userId);

//           // Filter out invalid or zero values
//           final filteredScatterData =
//               scatterData.where((spot) => spot.y > 0).toList();

//           // Extract unique dates for the x-axis
//           final dates = filteredScatterData
//               .map(
//                   (spot) => DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()))
//               .toSet()
//               .toList()
//             ..sort();

//           // Calculate the interval for the y-axis
//           final maxDelay = filteredScatterData.isEmpty
//               ? 1.0
//               : filteredScatterData
//                   .map((spot) => spot.y)
//                   .reduce((a, b) => a > b ? a : b)
//                   .toDouble();
//           final yInterval = (maxDelay / 5).ceilToDouble();

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 300, // Fixed height for the chart
//                     child: ScatterChart(
//                       ScatterChartData(
//                         scatterSpots: filteredScatterData,
//                         minX: dates.isEmpty
//                             ? 0
//                             : dates.first.millisecondsSinceEpoch.toDouble(),
//                         maxX: dates.isEmpty
//                             ? 1
//                             : dates.last.millisecondsSinceEpoch.toDouble(),
//                         minY: 0,
//                         maxY: maxDelay,
//                         borderData: FlBorderData(
//                           show: true,
//                           border: Border(
//                             bottom: BorderSide(color: Colors.black, width: 1),
//                             left: BorderSide(color: Colors.black, width: 1),
//                           ),
//                         ),
//                         gridData: FlGridData(
//                           show: true,
//                           drawVerticalLine: true,
//                           drawHorizontalLine: true,
//                           getDrawingHorizontalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                           getDrawingVerticalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                         ),
//                         titlesData: FlTitlesData(
//                           show: true,
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 22,
//                               getTitlesWidget: (value, meta) {
//                                 final date =
//                                     DateTime.fromMillisecondsSinceEpoch(
//                                         value.toInt());
//                                 return Text(
//                                   DateFormat('dd/MM').format(date),
//                                   style: const TextStyle(fontSize: 10),
//                                 );
//                               },
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 28,
//                               interval: yInterval,
//                               getTitlesWidget: (value, meta) {
//                                 return Text(
//                                   '${value.toInt()}m',
//                                   style: const TextStyle(fontSize: 10),
//                                 );
//                               },
//                             ),
//                           ),
//                           topTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           rightTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                         ),
//                         scatterTouchData: ScatterTouchData(
//                           enabled: true,
//                           touchTooltipData: ScatterTouchTooltipData(
//                             getTooltipItems: (List<ScatterSpot> spots) {
//                               if (spots.isEmpty) {
//                                 return null; // Return null if no spots are available
//                               }
//                               return spots.map((spot) {
//                                 final date =
//                                     DateTime.fromMillisecondsSinceEpoch(
//                                         spot.x.toInt());
//                                 return ScatterTooltipItem(
//                                   'Date: ${DateFormat('dd/MM').format(date)}\nDelay: ${spot.y.toInt()}m',
//                                   textStyle:
//                                       const TextStyle(color: Colors.white),
//                                 );
//                               }).toList();
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../providers/task_provider.dart';

// class TasksDelayScreen extends StatelessWidget {
//   final String userId;
//   TasksDelayScreen({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tasks Delay Over Time'),
//       ),
//       body: Consumer<TaskProvider>(
//         builder: (context, taskProvider, child) {
//           // Get scatter plot data
//           final scatterData = taskProvider.getDelayedTasksScatterData(userId);

//           // Filter out invalid or zero values
//           final filteredScatterData = scatterData.where((spot) => spot.y > 0).toList();

//           // Extract unique dates for the x-axis
//           final dates = filteredScatterData
//               .map((spot) => DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()))
//               .toSet()
//               .toList()
//             ..sort();

//           // Calculate the interval for the y-axis
//           final maxDelay = filteredScatterData.isEmpty
//               ? 1.0
//               : filteredScatterData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b).toDouble();
//           final yInterval = (maxDelay / 5).ceilToDouble();

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 300, // Fixed height for the chart
//                     child: ScatterChart(
//                       ScatterChartData(
//                         scatterSpots: filteredScatterData,
//                         minX: dates.isEmpty ? 0 : dates.first.millisecondsSinceEpoch.toDouble(),
//                         maxX: dates.isEmpty ? 1 : dates.last.millisecondsSinceEpoch.toDouble(),
//                         minY: 0,
//                         maxY: maxDelay,
//                         borderData: FlBorderData(
//                           show: true,
//                           border: Border(
//                             bottom: BorderSide(color: Colors.black, width: 1),
//                             left: BorderSide(color: Colors.black, width: 1),
//                           ),
//                         ),
//                         gridData: FlGridData(
//                           show: true,
//                           drawVerticalLine: true,
//                           drawHorizontalLine: true,
//                           getDrawingHorizontalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                           getDrawingVerticalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                         ),
//                         titlesData: FlTitlesData(
//                           show: true,
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 22,
//                               getTitlesWidget: (value, meta) {
//                                 final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
//                                 return Text(
//                                   DateFormat('dd/MM').format(date),
//                                   style: const TextStyle(fontSize: 10),
//                                 );
//                               },
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 28,
//                               interval: yInterval,
//                               getTitlesWidget: (value, meta) {
//                                 return Text(
//                                   '${value.toInt()}m',
//                                   style: const TextStyle(fontSize: 10),
//                                 );
//                               },
//                             ),
//                           ),
//                           topTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           rightTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                         ),
//                         scatterTouchData: ScatterTouchData(
//                           enabled: true,
//                           touchTooltipData: ScatterTouchTooltipData(
//                             tooltipBgColor: Colors.blueGrey,
//                             getTooltipItems: (List<ScatterSpot> spots) {
//                               return spots.map((spot) {
//                                 final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
//                                 return ScatterTooltipItem(
//                                   'Date: ${DateFormat('dd/MM').format(date)}\nDelay: ${spot.y.toInt()}m',
//                                   textStyle: const TextStyle(color: Colors.white),
//                                 );
//                               }).toList();
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../providers/task_provider.dart';

// class TasksDelayScreen extends StatelessWidget {
//   final String userId;
//   TasksDelayScreen({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tasks Delay Over Time'),
//       ),
//       body: Consumer<TaskProvider>(
//         builder: (context, taskProvider, child) {
//           // Get scatter plot data
//           final scatterData = taskProvider.getDelayedTasksScatterData(userId);

//           // Filter out invalid or zero values
//           final filteredScatterData =
//               scatterData.where((spot) => spot.y > 0).toList();

//           // Extract unique dates for the x-axis
//           final dates = filteredScatterData
//               .map(
//                   (spot) => DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()))
//               .toSet()
//               .toList()
//             ..sort();

//           // Calculate the interval for the y-axis
//           final maxDelay = filteredScatterData.isEmpty
//               ? 1.0
//               : filteredScatterData
//                   .map((spot) => spot.y)
//                   .reduce((a, b) => a > b ? a : b)
//                   .toDouble();
//           final yInterval = (maxDelay / 5).ceilToDouble();

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 300, // Fixed height for the chart
//                     child: ScatterChart(
//                       ScatterChartData(
//                         scatterSpots: filteredScatterData,
//                         minX: dates.isEmpty
//                             ? 0
//                             : dates.first.millisecondsSinceEpoch.toDouble(),
//                         maxX: dates.isEmpty
//                             ? 1
//                             : dates.last.millisecondsSinceEpoch.toDouble(),
//                         minY: 0,
//                         maxY: maxDelay,
//                         borderData: FlBorderData(
//                           show: true,
//                           border: Border(
//                             bottom: BorderSide(color: Colors.black, width: 1),
//                             left: BorderSide(color: Colors.black, width: 1),
//                           ),
//                         ),
//                         gridData: FlGridData(
//                           show: true,
//                           drawVerticalLine: true,
//                           drawHorizontalLine: true,
//                           getDrawingHorizontalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                           getDrawingVerticalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                         ),
//                         titlesData: FlTitlesData(
//                           show: true,
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 22,
//                               getTitlesWidget: (value, meta) {
//                                 final date =
//                                     DateTime.fromMillisecondsSinceEpoch(
//                                         value.toInt());
//                                 return Text(
//                                   DateFormat('dd/MM').format(date),
//                                   style: const TextStyle(fontSize: 10),
//                                 );
//                               },
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 28,
//                               interval: yInterval,
//                               getTitlesWidget: (value, meta) {
//                                 return Text(
//                                   '${value.toInt()}m',
//                                   style: const TextStyle(fontSize: 10),
//                                 );
//                               },
//                             ),
//                           ),
//                           topTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           rightTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                         ),
//                         scatterTouchData: ScatterTouchData(
//                           enabled:
//                               true, // Disable touch interactions if not needed
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

/// ********* correct but need to enhance design
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../providers/task_provider.dart';

// class TasksDelayScreen extends StatelessWidget {
//   final String userId;
//   TasksDelayScreen({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Tasks Delay Over Time',
//           style: Theme.of(context).textTheme.displayMedium,
//         ),
//       ),
//       body: Consumer<TaskProvider>(
//         builder: (context, taskProvider, child) {
//           // Get scatter plot data
//           final scatterData = taskProvider.getDelayedTasksScatterData(userId);

//           // Filter out invalid or zero values
//           final filteredScatterData =
//               scatterData.where((spot) => spot.y > 0).toList();

//           // Extract unique dates for the x-axis
//           final dates = filteredScatterData
//               .map(
//                   (spot) => DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()))
//               .toSet()
//               .toList()
//             ..sort();

//           // Calculate the interval for the y-axis
//           final maxDelay = filteredScatterData.isEmpty
//               ? 1.0
//               : filteredScatterData
//                   .map((spot) => spot.y)
//                   .reduce((a, b) => a > b ? a : b)
//                   .toDouble();
//           final yInterval = (maxDelay / 5).ceilToDouble();

//           // Convert scatter spots to line chart spots
//           final lineSpots = filteredScatterData
//               .map((spot) => FlSpot(spot.x, spot.y))
//               .toList();

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.8,
//                     width: MediaQuery.of(context).size.width * 0.9,
//                     child: LineChart(
//                       LineChartData(
//                         lineBarsData: [
//                           LineChartBarData(
//                             spots: lineSpots,
//                             // isCurved: true, // Smooth curve for the line
//                             color: Colors.blue, // Blue color for the line
//                             barWidth: 2, // Thickness of the line
//                             dotData: FlDotData(
//                               show: true, // Show dots on the line
//                               getDotPainter: (spot, percent, barData, index) {
//                                 return FlDotCirclePainter(
//                                   radius: 4, // Size of the dots
//                                   color: Colors.blue, // Blue color for the dots
//                                   strokeWidth: 1,
//                                   strokeColor: Colors.white,
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                         minX: dates.isEmpty
//                             ? 0
//                             : dates.first.millisecondsSinceEpoch.toDouble(),
//                         maxX: dates.isEmpty
//                             ? 1
//                             : dates.last.millisecondsSinceEpoch.toDouble(),
//                         minY: 0,
//                         maxY: maxDelay,
//                         borderData: FlBorderData(
//                           show: true,
//                           border: Border(
//                             bottom: BorderSide(color: Colors.black, width: 1),
//                             left: BorderSide(color: Colors.black, width: 1),
//                           ),
//                         ),
//                         gridData: FlGridData(
//                           show: true,
//                           drawVerticalLine: true,
//                           drawHorizontalLine: true,
//                           getDrawingHorizontalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                           getDrawingVerticalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                         ),
//                         titlesData: FlTitlesData(
//                           show: true,
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 22,
//                               getTitlesWidget: (value, meta) {
//                                 final date =
//                                     DateTime.fromMillisecondsSinceEpoch(
//                                         value.toInt());
//                                 return Text(
//                                   DateFormat('dd/MM').format(date),
//                                   style: const TextStyle(fontSize: 10),
//                                 );
//                               },
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 28,
//                               interval: yInterval,
//                               getTitlesWidget: (value, meta) {
//                                 return Text(
//                                   '${value.toInt()}m',
//                                   style: const TextStyle(fontSize: 10),
//                                 );
//                               },
//                             ),
//                           ),
//                           topTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           rightTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../providers/task_provider.dart';

// class TasksDelayScreen extends StatelessWidget {
//   final String userId;
//   TasksDelayScreen({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Tasks Delay Over Time',
//           style: Theme.of(context).textTheme.displayMedium,
//         ),
//       ),
//       body: Consumer<TaskProvider>(
//         builder: (context, taskProvider, child) {
//           // Get scatter plot data
//           final scatterData = taskProvider.getDelayedTasksScatterData(userId);

//           // Filter out invalid or zero values
//           final filteredScatterData =
//               scatterData.where((spot) => spot.y > 0).toList();

//           // Aggregate delays by day
//           final Map<DateTime, double> delaysByDay = {};
//           for (final spot in filteredScatterData) {
//             final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
//             final dayStart = DateTime(
//                 date.year, date.month, date.day); // Normalize to start of day
//             delaysByDay[dayStart] =
//                 (delaysByDay[dayStart] ?? 0) + spot.y; // Sum delays for the day
//           }

//           // Convert aggregated data to line chart spots
//           final lineSpots = delaysByDay.entries
//               .map((entry) => FlSpot(
//                     entry.key.millisecondsSinceEpoch.toDouble(),
//                     entry.value,
//                   ))
//               .toList();

//           // Extract unique dates for the x-axis
//           final dates = delaysByDay.keys.toList()..sort();

//           // Calculate the interval for the y-axis
//           final maxDelay = delaysByDay.values.isEmpty
//               ? 1.0
//               : delaysByDay.values.reduce((a, b) => a > b ? a : b);

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height *
//                         0.6, // Reduced height
//                     width: MediaQuery.of(context).size.width *
//                         0.8, // Reduced width
//                     child: LineChart(
//                       LineChartData(
//                         lineBarsData: [
//                           LineChartBarData(
//                             spots: lineSpots,
//                             isCurved: true, // Smooth curve for the line
//                             color: Colors.blue, // Blue color for the line
//                             barWidth: 2, // Thickness of the line
//                             dotData: FlDotData(
//                               show: true, // Show dots on the line
//                               getDotPainter: (spot, percent, barData, index) {
//                                 return FlDotCirclePainter(
//                                   radius: 4, // Size of the dots
//                                   color: Colors.blue, // Blue color for the dots
//                                   strokeWidth: 1,
//                                   strokeColor: Colors.white,
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                         minX: dates.isEmpty
//                             ? 0
//                             : dates.first.millisecondsSinceEpoch.toDouble(),
//                         maxX: dates.isEmpty
//                             ? 1
//                             : dates.last.millisecondsSinceEpoch.toDouble(),
//                         minY: 0,
//                         maxY: maxDelay,
//                         borderData: FlBorderData(
//                           show: true,
//                           border: Border(
//                             bottom: BorderSide(color: Colors.black, width: 1),
//                             left: BorderSide(color: Colors.black, width: 1),
//                           ),
//                         ),
//                         gridData: FlGridData(
//                           show: true,
//                           drawVerticalLine: true,
//                           drawHorizontalLine: true,
//                           getDrawingHorizontalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                           getDrawingVerticalLine: (value) {
//                             return FlLine(
//                               color: Colors.grey.withOpacity(0.3),
//                               strokeWidth: 1,
//                             );
//                           },
//                         ),
//                         titlesData: FlTitlesData(
//                           show: true,
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 22,
//                               getTitlesWidget: (value, meta) {
//                                 // Only show titles for actual data points
//                                 final date =
//                                     DateTime.fromMillisecondsSinceEpoch(
//                                         value.toInt());
//                                 if (dates.contains(date)) {
//                                   return Text(
//                                     DateFormat('dd/MM').format(date),
//                                     style: const TextStyle(fontSize: 10),
//                                   );
//                                 }
//                                 return const SizedBox
//                                     .shrink(); // Hide in-between values
//                               },
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 28,
//                               getTitlesWidget: (value, meta) {
//                                 return Text(
//                                   '${value.toInt()}m',
//                                   style: const TextStyle(fontSize: 10),
//                                 );
//                               },
//                             ),
//                           ),
//                           topTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           rightTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

/// goood until now
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';

class TasksDelayScreen extends StatelessWidget {
  final String userId;
  TasksDelayScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tasks Delay Over Time',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          // Get scatter plot data
          final scatterData = taskProvider.getDelayedTasksScatterData(userId);

          // Filter out invalid or zero values
          final filteredScatterData =
              scatterData.where((spot) => spot.y > 0).toList();

          // Aggregate delays by day
          final Map<DateTime, double> delaysByDay = {};
          for (final spot in filteredScatterData) {
            final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
            final dayStart = DateTime(
                date.year, date.month, date.day); // Normalize to start of day
            delaysByDay[dayStart] =
                (delaysByDay[dayStart] ?? 0) + spot.y; // Sum delays for the day
          }

          // Convert aggregated data to line chart spots
          final lineSpots = delaysByDay.entries
              .map((entry) => FlSpot(
                    entry.key.millisecondsSinceEpoch.toDouble(),
                    entry.value,
                  ))
              .toList();

          // Extract unique dates for the x-axis
          final dates = delaysByDay.keys.toList()..sort();

          // Calculate the interval for the y-axis
          final maxDelay = delaysByDay.values.isEmpty
              ? 1.0
              : delaysByDay.values.reduce((a, b) => a > b ? a : b);
          final yInterval =
              (maxDelay / 4).ceilToDouble(); // Adjust interval for y-axis

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.6, // Reduced height
                    width: MediaQuery.of(context).size.width *
                        0.90, // Reduced width
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: lineSpots,
                            // isCurved: true, // Smooth curve for the line
                            color: Colors.blue, // Blue color for the line
                            barWidth: 2, // Thickness of the line
                            dotData: FlDotData(
                              show: true, // Show dots on the line
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4, // Size of the dots
                                  color: Colors.blue, // Blue color for the dots
                                  strokeWidth: 1,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                          ),
                        ],
                        minX: dates.isEmpty
                            ? 0
                            : dates.first.millisecondsSinceEpoch.toDouble(),
                        maxX: dates.isEmpty
                            ? 1
                            : dates.last.millisecondsSinceEpoch.toDouble(),
                        minY: 0,
                        maxY: maxDelay,
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1),
                            left: BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          drawHorizontalLine: true,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              getTitlesWidget: (value, meta) {
                                // Only show titles for actual data points
                                final date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        value.toInt());
                                if (dates.contains(date)) {
                                  return Text(
                                    DateFormat('dd/MM').format(date),
                                    style: const TextStyle(fontSize: 10),
                                  );
                                }
                                return const SizedBox
                                    .shrink(); // Hide in-between values
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: yInterval, // Use calculated interval
                              getTitlesWidget: (value, meta) {
                                // Only show titles for specific intervals
                                if (value % yInterval == 0) {
                                  return Text(
                                    '${value.toInt()}m',
                                    style: const TextStyle(fontSize: 10),
                                  );
                                }
                                return const SizedBox
                                    .shrink(); // Hide in-between values
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
