import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HistoricalDataPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const HistoricalDataPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  _HistoricalDataPageState createState() => _HistoricalDataPageState();
}

class _HistoricalDataPageState extends State<HistoricalDataPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;
  double targetAQI = 150.0;
  double currentAQI = 0.0;

  final List<String> timeLabels = ['15:42', '15:47', '15:52', '15:57', '16:02', '16:07'];

  final List<List<FlSpot>> _dataSets = [
    [FlSpot(0, 1.07), FlSpot(1, 1.09), FlSpot(2, 1.12), FlSpot(3, 1.12), FlSpot(4, 1.10), FlSpot(5, 1.06)],
    [FlSpot(0, 17.92), FlSpot(1, 17.42), FlSpot(2, 17.20), FlSpot(3, 17.12), FlSpot(4, 16.85), FlSpot(5, 16.62)],
    [FlSpot(0, 3.02), FlSpot(1, 3.07), FlSpot(2, 3.11), FlSpot(3, 3.15), FlSpot(4, 3.08), FlSpot(5, 2.95)],
    [FlSpot(0, 36.58), FlSpot(1, 36.57), FlSpot(2, 36.50), FlSpot(3, 36.42), FlSpot(4, 36.35), FlSpot(5, 36.28)],
    [FlSpot(0, 1001.58), FlSpot(1, 1001.58), FlSpot(2, 1001.59), FlSpot(3, 1001.55), FlSpot(4, 1001.54), FlSpot(5, 1001.52)],
    [FlSpot(0, 97.59), FlSpot(1, 97.58), FlSpot(2, 97.50), FlSpot(3, 97.86), FlSpot(4, 97.45), FlSpot(5, 97.52)],
    [FlSpot(0, 32.4), FlSpot(1, 30.8), FlSpot(2, 29.5), FlSpot(3, 28.9), FlSpot(4, 28.0), FlSpot(5, 27.3)],
  ];

  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
  ];

  final List<double> _maxYValues = [1.5, 20, 4, 40, 1002, 98, 50];

  final List<String> _yAxisTitles = [
    'NO₂ (ppm)',
    'CO (ppm)',
    'NH₃ (ppm)',
    'Temp (°C)',
    'Pressure (hPa)',
    'Altitude (m)',
    'PM2.5 (µg/m³)',
  ];

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
      appBar: AppBar(
        // Option 1: Show coordinates beside the title
        title: Text(
          'Air & Environmental Quality (${widget.latitude.toStringAsFixed(4)}, ${widget.longitude.toStringAsFixed(4)})',
        ),

        // Option 2: Show coordinates on new line under the title
        // title: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     const Text('Air & Environmental Quality'),
        //     Text(
        //       '(${widget.latitude.toStringAsFixed(4)}, ${widget.longitude.toStringAsFixed(4)})',
        //       style: const TextStyle(fontSize: 14),
        //     ),
        //   ],
        // ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 420,
                      enlargeCenterPage: false,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) => _onPageChanged(index),
                    ),
                    items: List.generate(_dataSets.length, (index) {
                      return _buildChart(
                        title: _getChartTitle(index),
                        spots: _dataSets[index],
                        color: _colors[index],
                        xAxisTitle: 'Time',
                        yAxisTitle: _yAxisTitles[index],
                        isAnimated: index == _currentIndex,
                        maxY: _maxYValues[index],
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
                                GaugeRange(startValue: 0, endValue: 100, color: Colors.green, startWidth: 10, endWidth: 10),
                                GaugeRange(startValue: 100, endValue: 200, color: Colors.yellow, startWidth: 10, endWidth: 10),
                                GaugeRange(startValue: 200, endValue: 300, color: Colors.orange, startWidth: 10, endWidth: 10),
                                GaugeRange(startValue: 300, endValue: 500, color: Colors.red, startWidth: 10, endWidth: 10),
                              ],
                              pointers: [NeedlePointer(value: currentAQI)],
                              annotations: [
                                GaugeAnnotation(
                                  widget: Text(
                                    '${currentAQI.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

  String _getChartTitle(int index) {
    switch (index) {
      case 0: return 'NO₂ Levels Over Time';
      case 1: return 'CO Levels Over Time';
      case 2: return 'NH₃ Levels Over Time';
      case 3: return 'Temperature Over Time';
      case 4: return 'Pressure Over Time';
      case 5: return 'Altitude Over Time';
      case 6: return 'PM2.5 Levels Over Time';
      default: return '';
    }
  }

  Widget _buildChart({
    required String title,
    required List<FlSpot> spots,
    required Color color,
    required String xAxisTitle,
    required String yAxisTitle,
    required bool isAnimated,
    required double maxY,
  }) {
    return Container(
      height: 380,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withAlpha(76), blurRadius: 10, spreadRadius: 2)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: timeLabels.length.toDouble() - 1,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots.map((spot) => FlSpot(spot.x, isAnimated ? spot.y * _controller.value : spot.y)).toList(),
                    isCurved: true,
                    color: color,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: true, color: color.withAlpha(51)),
                    curveSmoothness: 0.5,
                  ),
                ],
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(xAxisTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        return index >= 0 && index < timeLabels.length
                            ? Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(timeLabels[index]))
                            : const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(yAxisTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: _getInterval(maxY)),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withAlpha(76), width: 1)),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: _getInterval(maxY),
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.withAlpha(25), strokeWidth: 1),
                  getDrawingVerticalLine: (_) => FlLine(color: Colors.grey.withAlpha(25), strokeWidth: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getInterval(double maxY) {
    if (maxY <= 2) return 0.5;
    if (maxY <= 5) return 1;
    if (maxY <= 10) return 2;
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    if (maxY <= 1000) return 200;
    return 500;
  }
}
