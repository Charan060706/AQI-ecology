import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HistoricalDataPage extends StatelessWidget {
  const HistoricalDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Data'),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CarouselSlider(
            options: CarouselOptions(
              height: 400, // Increased height for the carousel
              enlargeCenterPage: false, // Enlarge the center graph
              autoPlay: false, // Disable auto-play
              enableInfiniteScroll: false, // Disable infinite scroll
              viewportFraction: 1, // Fraction of the viewport to show
            ),
            items: [
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
          
        ],
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
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10,10, 10, 20),

       child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300, // Increased height for the graph
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 0.5,
                    verticalInterval: 1,
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
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final hour = value.toInt() % 12;
                          final period = value.toInt() < 12 ? 'AM' : 'PM';
                          final timeLabel = hour == 0 ? '12 $period' : '$hour $period';
                          return Text(
                            timeLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          );
                        },
                      ),
                      axisNameWidget: Text(
                        xAxisTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 0.5,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          );
                        },
                      ),
                      axisNameWidget: Text(
                        yAxisTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1,
                    ),
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
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: color,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.3),
                            color.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      shadow: Shadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
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