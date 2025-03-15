import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';  // Import Syncfusion Gauge package

class HistoricalDataPage extends StatefulWidget {
  const HistoricalDataPage({super.key});

  @override
  _HistoricalDataPageState createState() => _HistoricalDataPageState();
}

class _HistoricalDataPageState extends State<HistoricalDataPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  int _currentIndex = 0;

  // Simulating some AQI value to animate
  double targetAQI = 150.0;
  double currentAQI = 0.0;  // Start from zero

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
      duration: const Duration(seconds: 3), // Shortened animation duration (3 seconds)
    );

    // Start the animation and listen to its value change
    _controller.addListener(() {
      setState(() {
        // Animate from 0 to the target value
        currentAQI = targetAQI * _controller.value;
      });
    });

    // Start the animation
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
      appBar: AppBar(
        title: const Text('Historical Data'),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: SingleChildScrollView( // Wrap the entire body with SingleChildScrollView
        child: Column(
          children: [
            const SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(
                height: 400,
                enlargeCenterPage: false,
                autoPlay: false,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                onPageChanged: (index, reason) => _onPageChanged(index),
              ),
              items: List.generate(_dataSets.length, (index) {
                return _buildChart(
                  title: index == 0
                      ? 'NO Levels Over Time'
                      : index == 1
                          ? 'CH4 Levels Over Time'
                          : 'NH3 Levels Over Time',
                  spots: _dataSets[index],
                  color: _colors[index],
                  xAxisTitle: 'Time',
                  yAxisTitle: index == 0
                      ? 'NO Concentration (ppm)'
                      : index == 1
                          ? 'CH4 Concentration (ppm)'
                          : 'NH3 Concentration (ppm)',
                  isAnimated: index == _currentIndex,
                );
              }),
            ),
            const SizedBox(height: 20), // Space between chart and gauge
            // Add the Gauge Chart with animation
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SizedBox(
                  height: 200, // Set appropriate height for the gauge
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
                            endWidth: 10,
                          ),
                          GaugeRange(
                            startValue: 100,
                            endValue: 200,
                            color: Colors.yellow,
                            startWidth: 10,
                            endWidth: 10,
                          ),
                          GaugeRange(
                            startValue: 200,
                            endValue: 300,
                            color: Colors.orange,
                            startWidth: 10,
                            endWidth: 10,
                          ),
                          GaugeRange(
                            startValue: 300,
                            endValue: 500,
                            color: Colors.red,
                            startWidth: 10,
                            endWidth: 10,
                          ),
                        ],
                        pointers: [
                          NeedlePointer(value: currentAQI) // Animate needle to current AQI
                        ],
                        annotations: [
                          GaugeAnnotation(
                            widget: Text(
                              '${currentAQI.toStringAsFixed(0)}', // Display the animated AQI value
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
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
              height: 300,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return LineChart(
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
                          belowBarData: BarAreaData(show: true, color: color.withOpacity(0.3)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
