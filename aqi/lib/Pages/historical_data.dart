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
                
                // 1. AQI Gauge (moved to top)
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
                
                // 2. AQI Precaution Card
                _buildAQIPrecautionCard(),
                
                const SizedBox(height: 20),
                
                // 3. Chart Carousel
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
                
                // 4. Pollutant Precaution Card
                _buildPrecautionCard(_currentIndex),
                
                const SizedBox(height: 20),
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

  // New method for precaution cards
  Widget _buildPrecautionCard(int index) {
    if (index == 0) {
      // NO2 precaution card
      return PrecautionCard(
        pollutantName: 'NO2 (Nitrogen Dioxide)',
        description: 'Nitrogen Dioxide is a reddish-brown gas that primarily gets in the air from burning fuel. It forms from emissions from cars, trucks, buses, power plants, and off-road equipment.',
        precautions: [
          'Limit outdoor activities when NO2 levels are high',
          'Keep windows closed during peak traffic hours if you live near busy roads',
          'Use air purifiers with HEPA filters indoors',
          'Consider wearing a mask in heavily polluted areas',
          'People with asthma should keep rescue inhalers readily available',
        ],
        accentColor: Colors.blue,
      );
    } else if (index == 1) {
      // CO precaution card
      return PrecautionCard(
        pollutantName: 'CO (Carbon Monoxide)',
        description: 'Carbon Monoxide is an odorless, colorless gas that can cause sudden illness and death. It\'s produced by burning gasoline, wood, propane, charcoal or other fuel.',
        precautions: [
          'Install carbon monoxide detectors in your home',
          'Never use gas-powered equipment or burn charcoal indoors',
          'Ensure proper ventilation when using fuel-burning appliances',
          'Have heating systems, water heaters, and gas appliances serviced annually',
          'Never leave a car running in an enclosed space',
        ],
        accentColor: Colors.red,
      );
    } else {
      // NH3 precaution card
      return PrecautionCard(
        pollutantName: 'NH3 (Ammonia)',
        description: 'Ammonia is a colorless gas with a pungent smell. It\'s commonly used in agricultural fertilizers and cleaning products. High levels can irritate the respiratory system.',
        precautions: [
          'Ensure proper ventilation when using ammonia-based cleaning products',
          'Avoid using ammonia-based products if you have respiratory conditions',
          'Store ammonia products properly and away from children',
          'Never mix ammonia with bleach as it creates toxic chloramine vapors',
          'Consider wearing a mask and gloves when handling ammonia products',
        ],
        accentColor: Colors.green,
      );
    }
  }

  // New method for AQI precaution card
  Widget _buildAQIPrecautionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
      child: ExpansionTile(
        title: const Text(
          'AQI Guide & Precautions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Understanding AQI (Air Quality Index):',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildAQIGuideItem('0-50', 'Good', Colors.green, 'Air quality is satisfactory, and air pollution poses little or no risk.'),
                _buildAQIGuideItem('51-100', 'Moderate', Colors.yellow, 'Air quality is acceptable. However, some pollutants may be a concern for a very small number of people.'),
                _buildAQIGuideItem('101-200', 'Unhealthy', Colors.orange, 'Members of sensitive groups may experience health effects. The general public is less likely to be affected.'),
                _buildAQIGuideItem('201-300', 'Very Unhealthy', Colors.red, 'Health alert: The risk of health effects is increased for everyone.'),
                _buildAQIGuideItem('301-500', 'Hazardous', Colors.purple, 'Health warning of emergency conditions: everyone is more likely to be affected.'),
                
                const SizedBox(height: 16),
                const Text(
                  'General Precautions:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildPrecautionItem('Keep windows closed when AQI is high'),
                _buildPrecautionItem('Use air purifiers with HEPA filters indoors'),
                _buildPrecautionItem('Limit outdoor activities during poor air quality days'),
                _buildPrecautionItem('Stay hydrated to help your body filter toxins'),
                _buildPrecautionItem('Consider wearing N95 masks when outdoors in hazardous conditions'),
                _buildPrecautionItem('Follow local air quality advisories and health recommendations'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for AQI guide items
  Widget _buildAQIGuideItem(String range, String level, Color color, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  TextSpan(
                    text: '$range ($level): ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for precaution items
  Widget _buildPrecautionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.deepPurple, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// New PrecautionCard widget class
class PrecautionCard extends StatelessWidget {
  final String pollutantName;
  final String description;
  final List<String> precautions;
  final Color accentColor;

  const PrecautionCard({
    required this.pollutantName,
    required this.description,
    required this.precautions,
    required this.accentColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
      child: ExpansionTile(
        title: Text(
          'About $pollutantName',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Precautions:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...precautions.map((precaution) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle, color: accentColor, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              precaution,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}