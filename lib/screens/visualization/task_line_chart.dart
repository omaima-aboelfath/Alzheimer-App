import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskLineChart extends StatelessWidget {
  final Map<DateTime, int> completedData;
  final Map<DateTime, int> incompleteData;

  const TaskLineChart({super.key, required this.completedData, required this.incompleteData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: getTitles,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Color(0xff37434d)),
            left: BorderSide(color: Color(0xff37434d)),
            top: BorderSide(color: Color(0xff37434d)),
            right: BorderSide(color: Color(0xff37434d)),
          ),
        ),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: convertDataToFlSpots(completedData),
            isCurved: true,
            curveSmoothness: 0.2,
            color: 
              const Color(0xff4af699),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              color: 
                const Color(0xff4af699).withOpacity(0.3),
            ),
          ),
          LineChartBarData(
            spots: convertDataToFlSpots(incompleteData),
            // ... similar configuration for the incomplete tasks line
          ),
        ],
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
  switch (value.toInt()) {
    case 0:
      return const Text('Mn');
    case 1:
      return const Text('Tu');
    case 2:
      return const Text('Wd');
    case 3:
      return const Text('Th');
    case 4:
      return const Text('Fr');
    case 5:
      return const Text('St');
    case 6:
      return const Text('Su');
    default:
      return const Text('');
  }
}
  
  List<FlSpot> convertDataToFlSpots(Map<DateTime, int> data) {
    return data.entries.map((entry) {
      return FlSpot(
        entry.key.millisecondsSinceEpoch.toDouble(),
        entry.value.toDouble(),
      );
    }).toList();
  }
 }