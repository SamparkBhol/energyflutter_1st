import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:community_energy_optimizer/models/energy_model.dart';

class EnergyChart extends StatelessWidget {
  final List<EnergyUsageData> data;

  EnergyChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data
                      .map((e) =>
                          FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.usage))
                      .toList(),
                  isCurved: true,
                  colors: [Colors.blue],
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    colors: [Colors.blue.withOpacity(0.3)],
                  ),
                ),
              ],
              minX: data.first.time.millisecondsSinceEpoch.toDouble(),
              maxX: data.last.time.millisecondsSinceEpoch.toDouble(),
              minY: 0,
              maxY: data.map((e) => e.usage).reduce((a, b) => a > b ? a : b),
            ),
          ),
        ),
      ),
    );
  }
}

class EnergyUsageData {
  final DateTime time;
  final double usage;

  EnergyUsageData({
    required this.time,
    required this.usage,
  });
}

class EnergyChartPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.grey[300],
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.grey[700], fontSize: 18),
          ),
        ),
      ),
    );
  }
}
