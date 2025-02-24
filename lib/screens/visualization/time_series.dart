// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class TimeSeriesChart extends StatelessWidget {
//   final Map<String, int> data;

//   TimeSeriesChart({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final List<FlSpot> spots = [];
//     final sortedKeys = data.keys.toList()..sort();

//     for (int i = 0; i < sortedKeys.length; i++) {
//       final date = sortedKeys[i];
//       final value = data[date]!;
//       spots.add(FlSpot(i.toDouble(), value.toDouble()));
//     }

//     return LineChart(
//       LineChartData(
//         gridData: FlGridData(show: true),
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(sideTitles:SideTitles(showTitles: true),),
//           bottomTitles: AxisTitles(sideTitles:SideTitles(
//             showTitles: true,
//             // getTitlesWidget: (value,meta) {
//             //   final index = value.toInt();
//             //   return index >= 0 && index < sortedKeys.length
//             //       ? sortedKeys[index]
//             //       : '';
//             // },
//           ),),
//         ),
//         borderData: FlBorderData(show: true),
//         lineBarsData: [
//           LineChartBarData(
//             spots: spots,
//             isCurved: true,
//             color: Colors.blue,
//             barWidth: 4,
//             belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
//           ),
//         ],
//       ),
//     );
//   }
// }

/* works manually
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskChart extends StatelessWidget {
  final Map<String, dynamic> summary;

  TaskChart({required this.summary});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];
     if (summary.isEmpty) {
    return Center(child: Text('No task summary available.'));
  }

    summary.forEach((date, counts) {
      barGroups.add(
        BarChartGroupData(
          x: DateTime.parse(date).millisecondsSinceEpoch ~/ 86400000, // Convert date to days since epoch
          barRods: [
            BarChartRodData(
              toY: counts['complete'].toDouble(),
              color: Colors.green,
            ),
            BarChartRodData(
              toY: counts['incomplete'].toDouble(),
              color: Colors.red,
            ),
          ],
        ),
      );
    });

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles:SideTitles(showTitles: true),),
          bottomTitles: AxisTitles(sideTitles:SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
                return Text(
                  DateTime.fromMillisecondsSinceEpoch(value.toInt() * 86400000)
                      .toString()
                      .split(' ')[0],
                );
              },

          ),)
        ),
        barGroups: barGroups,
      ),
    );
  }
}  */

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskChart extends StatelessWidget {
  final Map<String, dynamic> summary;

  TaskChart({required this.summary});

  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> lineBarsData = [];

    summary.forEach((date, counts) {
      // Prepare the line chart data
      lineBarsData.add(
        LineChartBarData(
          spots: [
            FlSpot(DateTime.parse(date).millisecondsSinceEpoch.toDouble(),
                counts['complete'].toDouble()),
            FlSpot(DateTime.parse(date).millisecondsSinceEpoch.toDouble(),
                counts['incomplete'].toDouble()),
          ],
          isCurved: true,
          // color: [Colors.green, Colors.red],
          color: Colors.blue,
          belowBarData: BarAreaData(show: false),
        ),
      );
    });

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(
                DateTime.fromMillisecondsSinceEpoch(value.toInt())
                    .toString()
                    .split(' ')[0],
              );
            },
          )),
        ),
        lineBarsData: lineBarsData,
      ),
    );
  }
}
