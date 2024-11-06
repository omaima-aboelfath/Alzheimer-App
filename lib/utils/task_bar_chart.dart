//5
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskBarChart extends StatelessWidget {
  final Map<DateTime, int> incompleteData; // Data for incomplete tasks
  final Map<DateTime, int> completeData; // Data for complete tasks

  TaskBarChart({required this.incompleteData, required this.completeData});

  @override
  Widget build(BuildContext context) {
    // Combine both data sets
    List<BarChartGroupData> barGroups = [];

    // Get the unique days from both datasets
    final allDates = {...incompleteData.keys, ...completeData.keys};

    for (DateTime date in allDates) {
      final incompleteCount = incompleteData[date] ?? 0;
      final completeCount = completeData[date] ?? 0;

      barGroups.add(BarChartGroupData(
        x: date.day,
        barRods: [
          BarChartRodData(
              toY: incompleteCount.toDouble(),
              color: Colors.red,
              width: 20,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7), topRight: Radius.circular(7))),
          BarChartRodData(
              toY: completeCount.toDouble(),
              color: Colors.green,
              width: 20,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7), topRight: Radius.circular(7))),
        ],
      ));
    }

    return Column(
      children: [
        Text(
          'Number of Tasks',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 200, // Define a height for the BarChart
          width: 350,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: Theme.of(context).textTheme.bodySmall,
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
                        DateFormat('dd-MM').format(date),
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              barGroups: barGroups,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black, width: 1),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 20,
              width: 20,
              color: Colors.red,
            ),
            SizedBox(width: 5),
            Text('Incomplete Tasks', style: TextStyle(fontSize: 14)),
            SizedBox(width: 20),
            Container(
              height: 20,
              width: 20,
              color: Colors.green,
            ),
            SizedBox(width: 5),
            Text('Complete Tasks', style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
