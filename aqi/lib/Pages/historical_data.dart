import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HistoricalDataPage extends StatefulWidget {
  const HistoricalDataPage({super.key});

  @override
  _HistoricalDataPageState createState() => _HistoricalDataPageState();
}

class _HistoricalDataPageState extends State<HistoricalDataPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;
  double targetAQI = 150.0;
  double currentAQI = 0.0;

  final List<List<FlSpot>> _dataSets = [
    [
      FlSpot(0, 1),
      FlSpot(1, 1.5),
      FlSpot(2, 1.4),
      FlSpot(3, 2),
      FlSpot(4, 1.8),
      FlSpot(5, 2.5),
    ],
    [
      FlSpot(0, 0.2),
      FlSpot(1, 0.3),
      FlSpot(2, 0.25),
      FlSpot(3, 0.4),
      FlSpot(4, 0.35),
      FlSpot(5, 0.5),
    ],
    [
      FlSpot(0, 0.5),
      FlSpot(1, 0.7),
      FlSpot(2, 0.6),
      FlSpot(3, 0.8),
      FlSpot(4, 0.9),
      FlSpot(5, 1.2),
    ],
  ];

  final List<Color> _colors = [Colors.blue, Colors.red, Colors.green];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {
          currentAQI = targetAQI * _controller.value;
        });
      });

    _controller.forward();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 420, // Increased height to avoid clipping
                      enlargeCenterPage: false,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) => _onPageChanged(index),
                    ),
                    items: List.generate(_dataSets.length, (index) {
                      return _buildChart(
                        title: index == 0
                            ? 'NO2 Levels Over Time'
                            : index == 1
                                ? 'CO Levels Over Time'
                                : 'NH3 Levels Over Time',
                        spots: _dataSets[index],
                        color: _colors[index],
                        xAxisTitle: 'Time',
                        yAxisTitle: index == 0
                            ? 'NO2 Concentration (ppm)'
                            : index == 1
                                ? 'CO Concentration (ppm)'
                                : 'NH3 Concentration (ppm)',
                        isAnimated: index == _currentIndex,
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return SizedBox(
                        height: 200,
                        child: SfRadialGauge(
                          axes: [
                            RadialAxis(
                              minimum: 0,
                              maximum: 500,
                              ranges: [
                                GaugeRange(
                                    startValue: 0,
                                    endValue: 100,
                                    color: Colors.green,
                                    startWidth: 10,
                                    endWidth: 10),
                                GaugeRange(
                                    startValue: 100,
                                    endValue: 200,
                                    color: Colors.yellow,
                                    startWidth: 10,
                                    endWidth: 10),
                                GaugeRange(
                                    startValue: 200,
                                    endValue: 300,
                                    color: Colors.orange,
                                    startWidth: 10,
                                    endWidth: 10),
                                GaugeRange(
                                    startValue: 300,
                                    endValue: 500,
                                    color: Colors.red,
                                    startWidth: 10,
                                    endWidth: 10),
                              ],
                              pointers: [NeedlePointer(value: currentAQI)],
                              annotations: [
                                GaugeAnnotation(
                                  widget: Text(
                                    '${currentAQI.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  positionFactor: 0.9,
                                  angle: 90,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
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
    required bool isAnimated,
  }) {
    return Container(
      height: 380, // Ensure the graph has enough space
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // More margin
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
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
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 3,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots
                        .map((spot) => FlSpot(
                              spot.x,
                              spot.y * (isAnimated ? _controller.value : 0),
                            ))
                        .toList(),
                    isCurved: true,
                    color: color,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData:
                        BarAreaData(show: true, color: color.withOpacity(0.3)),
                    curveSmoothness: 0.5,
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 22),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
