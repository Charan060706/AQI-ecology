import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoricalDataPage extends StatelessWidget {
  const HistoricalDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historical Data')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildChart(
                title: 'NO Levels Over Time',
                spots: [
                  FlSpot(0, 1),
                  FlSpot(1, 1.5),
                  FlSpot(2, 1.4),
                  FlSpot(3, 2),
                  FlSpot(4, 1.8),
                  FlSpot(5, 2.5),
                ],
                color: Colors.blue,
                xAxisTitle: 'Time',
                yAxisTitle: 'NO Concentration (ppm)',
              ),
              const SizedBox(height: 20),
              _buildChart(
                title: 'CH4 Levels Over Time',
                spots: [
                  FlSpot(0, 0.2),
                  FlSpot(1, 0.3),
                  FlSpot(2, 0.25),
                  FlSpot(3, 0.4),
                  FlSpot(4, 0.35),
                  FlSpot(5, 0.5),
                ],
                color: Colors.red,
                xAxisTitle: 'Time',
                yAxisTitle: 'CH4 Concentration (ppm)',
              ),
              const SizedBox(height: 20),
              _buildChart(
                title: 'NH3 Levels Over Time',
                spots: [
                  FlSpot(0, 0.5),
                  FlSpot(1, 0.7),
                  FlSpot(2, 0.6),
                  FlSpot(3, 0.8),
                  FlSpot(4, 0.9),
                  FlSpot(5, 1.2),
                ],
                color: Colors.green,
                xAxisTitle: 'Time',
                yAxisTitle: 'NH3 Concentration (ppm)',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart({
    required String title,
    required List<FlSpot> spots,
    required Color color,
    required String xAxisTitle,
    required String yAxisTitle,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          // Convert the value to a time string (e.g., 0 -> 12 AM, 1 -> 1 AM, etc.)
                          final hour = value.toInt() % 12;
                          final period = value.toInt() < 12 ? 'AM' : 'PM';
                          final timeLabel = hour == 0 ? '12 $period' : '$hour $period';
                          return Text(timeLabel);
                        },
                      ),
                      axisNameWidget: Text(
                        xAxisTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 0.5,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toStringAsFixed(1)); // Y-axis labels
                        },
                      ),
                      axisNameWidget: Text(
                        yAxisTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d), width: 1),
                  ),
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: 3,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
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
}

