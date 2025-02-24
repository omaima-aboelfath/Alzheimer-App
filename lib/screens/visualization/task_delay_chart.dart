import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TaskDelayChart extends StatelessWidget {
  final List<DateTime> dates;
  final List<int> delays; // Delay in minutes

  TaskDelayChart({required this.dates, required this.delays});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Delay Visualization")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: delays.asMap().entries.map((entry) {
                  int index = entry.key;
                  double delay = entry.value.toDouble();
                  return FlSpot(index.toDouble(), delay);
                }).toList(),
                isCurved: true,
                color: Colors.blue,
                belowBarData: BarAreaData(show: true, color: 
                  Colors.blue.withOpacity(0.3),
                ),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles:SideTitles(
                showTitles: true,
                interval: 30,
                // getTitlesWidget: (value, meta) => '${value.toInt()} mins',
              ),),
              bottomTitles: AxisTitles(sideTitles:SideTitles(
                showTitles: true,
                // getTitlesWidget: (value, meta) =>
                    // value < dates.length ? dates[value.toInt()].day.toString() : '',
              ),
            ),),
            borderData: FlBorderData(show: true),
            minX: 0,
            maxX: delays.length.toDouble() - 1,
            minY: 0,
          ),
        ),
      ),
    );
  }
}
