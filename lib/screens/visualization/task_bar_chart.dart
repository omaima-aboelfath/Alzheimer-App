/// the duration of delay -- stacked
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// class TaskBarChart extends StatelessWidget {
//   final Map<DateTime, int> incompleteData;
//   final Map<DateTime, int> completeData;
//   final Map<DateTime, int> delayedData;
//   const TaskBarChart({
//     Key? key,
//     required this.incompleteData,
//     required this.completeData,
//     this.delayedData = const {},
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final allDates = {
//       ...incompleteData.keys,
//       ...completeData.keys,
//       ...delayedData.keys
//     }.toList()
//       ..sort();
//     final barGroups = allDates.map((date) {
//       final incompleteCount = incompleteData[date] ?? 0;
//       final completeCount = completeData[date] ?? 0;
//       final delayedCount = delayedData[date] ?? 0;

//       return BarChartGroupData(
//         x: date.day,
//         barRods: [
//           BarChartRodData(
//             toY: (incompleteCount + completeCount + delayedCount).toDouble(),
//             rodStackItems: [
//               BarChartRodStackItem(
//                 0,
//                 incompleteCount.toDouble(),
//                 Colors.red,
//               ),
//               BarChartRodStackItem(
//                 incompleteCount.toDouble(),
//                 (incompleteCount + completeCount).toDouble(),
//                 Colors.green,
//               ),
//               BarChartRodStackItem(
//                 (incompleteCount + completeCount).toDouble(),
//                 (incompleteCount + completeCount + delayedCount).toDouble(),
//                 Colors.blue,
//               ),
//             ],
//             width: 20,
//             borderRadius: BorderRadius.circular(5),
//           ),
//         ],
//       );
//     }).toList();

//     return Column(
//       children: [
//         const Text(
//           'Task Overview',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 200, // Reduced chart height
//           child: BarChart(
//             BarChartData(
//               alignment: BarChartAlignment.spaceAround,
//               titlesData: FlTitlesData(
//                 leftTitles:
//                     AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 // leftTitles: AxisTitles(
//                 //   sideTitles: SideTitles(
//                 //     showTitles: true,
//                 //     reservedSize: 40,
//                 //     interval: 1,
//                 //     getTitlesWidget: (value, meta) => Padding(
//                 //       padding: const EdgeInsets.only(right: 8.0),
//                 //       child: Text(
//                 //         value.toInt().toString(),
//                 //         style: const TextStyle(fontSize: 12),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       final date = DateTime(DateTime.now().year,
//                           DateTime.now().month, value.toInt());
//                       return Padding(
//                         padding: const EdgeInsets.only(top: 5.0),
//                         child: Text(
//                           DateFormat('dd-MM').format(date),
//                           style: const TextStyle(fontSize: 10),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 topTitles:
//                     const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 rightTitles:
//                     const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//               ),
//               barGroups: barGroups,
//               gridData: FlGridData(show: false), // Hide grid lines
//               borderData: FlBorderData(
//                 show: true,
//                 border: Border(
//                   left: BorderSide(
//                       color: Colors.black, width: 1), // Left axis only
//                   bottom: BorderSide(
//                       color: Colors.black, width: 1), // Bottom axis only
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Legend(color: Colors.red, label: 'Incomplete'),
//             const SizedBox(width: 10),
//             Legend(color: Colors.green, label: 'Complete'),
//             const SizedBox(width: 10),
//             Legend(color: Colors.blue, label: 'Delayed'),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class Legend extends StatelessWidget {
//   final Color color;
//   final String label;
//   const Legend({Key? key, required this.color, required this.label})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           height: 15,
//           width: 15,
//           color: color,
//         ),
//         const SizedBox(width: 5),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//   }
// }

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class TaskBarChart extends StatefulWidget {
  final Map<DateTime, int> incompleteData; // Count of incomplete tasks
  final Map<DateTime, int> completeData; // Count of complete tasks
  final Map<DateTime, int> delayedData; // Count of delayed tasks

  const TaskBarChart({
    Key? key,
    required this.incompleteData,
    required this.completeData,
    required this.delayedData,
  }) : super(key: key);

  @override
  State<TaskBarChart> createState() => _TaskBarChartState();
  final double initialXAxisOffset = 0.0; // Initial offset for scrolling
}

class _TaskBarChartState extends State<TaskBarChart> {
  @override
  Widget build(BuildContext context) {
    // Combine dates from all three datasets
    final allDates = {
      ...widget.incompleteData.keys,
      ...widget.completeData.keys,
      ...widget.delayedData.keys
    }.toList()
      ..sort();

    // Generate bar groups
    final barGroups = allDates.map((date) {
      final incompleteCount = widget.incompleteData[date] ?? 0;
      final completeCount = widget.completeData[date] ?? 0;
      final delayedCount = widget.delayedData[date] ?? 0;
      final barRods = [
        if (incompleteCount > 0)
          BarChartRodData(
            toY: incompleteCount.toDouble(),
            color: Colors.red,
            width: 20,
            borderRadius: BorderRadius.circular(5),
            // backDrawRodData: BackgroundBarChartRodData(show: false),
          ),
        if (completeCount > 0)
          BarChartRodData(
            toY: completeCount.toDouble(),
            color: Colors.green,
            width: 20,
            borderRadius: BorderRadius.circular(5),
          ),
        if (delayedCount > 0)
          BarChartRodData(
            toY: delayedCount.toDouble(),
            color: Colors.blue,
            width: 20,
            borderRadius: BorderRadius.circular(5),
          ),
      ];

      return BarChartGroupData(
        x: date.day,
        barRods: barRods,
        barsSpace: 5, // Space between bars
      );
    }).toList();

// final maxCount = allDates.fold<double?>(null, (previousMax, date) {
//   final incompleteCount = widget.incompleteData[date] ?? 0;
//   final completeCount = widget.completeData[date] ?? 0;
//   final delayedCount = widget.delayedData[date] ?? 0;
//   final currentCount = incompleteCount + completeCount + delayedCount;
//   return previousMax == null ? currentCount.toDouble() : math.max(previousMax, currentCount.toDouble());
// });

// final interval = (maxCount ?? 0) / 5.ceilToDouble();

    final maxCount = allDates.fold<double?>(null, (previousMax, date) {
      final incompleteCount = widget.incompleteData[date] ?? 0;
      final completeCount = widget.completeData[date] ?? 0;
      final delayedCount = widget.delayedData[date] ?? 0;
      final currentCount = incompleteCount + completeCount + delayedCount;
      return previousMax == null
          ? currentCount.toDouble()
          : math.max(previousMax, currentCount.toDouble());
    });
// final interval = (maxCount ?? 1.0) / 5.ceilToDouble();
    final interval =
        maxCount == null || maxCount == 0 ? 1 : (maxCount / 5).ceilToDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task compeletion overview',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Task Counts Per Day',
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, // Compact height
              width: allDates.length * 70.0, // Width based on number of dates
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        // interval: barGroups.length.toDouble(),
                        interval: interval.toDouble(),
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            value.toInt(),
                          );
                          return Text(
                            DateFormat('dd/MM').format(date),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: barGroups,
                  gridData: FlGridData(show: true), // Hide grid lines
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(
                          color: Colors.black, width: 1), // Left y-axis
                      bottom: BorderSide(
                          color: Colors.black, width: 1), // Bottom x-axis
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Legend(color: Colors.red, label: 'Incomplete'),
                const SizedBox(width: 10),
                Legend(color: Colors.green, label: 'Complete'),
                const SizedBox(width: 10),
                Legend(color: Colors.blue, label: 'Delayed'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final Color color;
  final String label;

  const Legend({Key? key, required this.color, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 15,
          width: 15,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class ScrollableChart extends StatelessWidget {
  final Widget child;

  const ScrollableChart({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: child,
    );
  }
}
