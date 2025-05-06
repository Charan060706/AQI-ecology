import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:math';

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
  
  // Added map to track pollutant levels
  late Map<String, double> pollutantLevels = {
    'NO2': 0.0,
    'CO': 0.0,
    'NH3': 0.0,
  };

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
    
    // Add listener to update pollutant levels when animation runs
    _controller.addListener(_updatePollutantLevels);
  }
  
  // This method updates the current pollutant levels based on chart data
  void _updatePollutantLevels() {
    // Get current spot from each dataset (last point in the chart)
    if (_dataSets.isNotEmpty && _dataSets[0].isNotEmpty) {
      pollutantLevels['NO2'] = _dataSets[0].last.y * _controller.value;
    }
    if (_dataSets.length > 1 && _dataSets[1].isNotEmpty) {
      pollutantLevels['CO'] = _dataSets[1].last.y * _controller.value;
    }
    if (_dataSets.length > 2 && _dataSets[2].isNotEmpty) {
      pollutantLevels['NH3'] = _dataSets[2].last.y * _controller.value;
    }
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

  // Method to simulate changing AQI for testing
  void _simulateChangingAQI() {
    // Create random AQI value between 0 and 500
    final random = Random();
    setState(() {
      targetAQI = random.nextDouble() * 500;
      _controller.reset();
      _controller.forward();
    });
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
      // Optional floating action button to test different AQI values
      floatingActionButton: FloatingActionButton(
        onPressed: _simulateChangingAQI,
        child: const Icon(Icons.refresh),
        tooltip: 'Simulate different AQI',
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

  // Updated method for dynamic precaution cards based on pollutant levels
  Widget _buildPrecautionCard(int index) {
    String pollutantName;
    String description;
    List<String> precautions;
    Color accentColor;
    
    if (index == 0) {
      // NO2 precaution card
      pollutantName = 'NO2 (Nitrogen Dioxide)';
      description = 'Nitrogen Dioxide is a reddish-brown gas that primarily gets in the air from burning fuel. It forms from emissions from cars, trucks, buses, power plants, and off-road equipment.';
      accentColor = Colors.blue;
      
      double no2Level = pollutantLevels['NO2'] ?? 0.0;
      
      if (no2Level < 0.5) {
        precautions = [
          'Current NO2 levels are low (${no2Level.toStringAsFixed(2)} ppm)',
          'Continue monitoring air quality',
          'No special precautions needed at this time',
          'Ideal conditions for outdoor activities',
          'Keep windows open for fresh air circulation',
        ];
      } else if (no2Level < 1.0) {
        precautions = [
          'Moderate NO2 levels detected (${no2Level.toStringAsFixed(2)} ppm)',
          'Consider limiting prolonged outdoor activities if you have respiratory conditions',
          'Keep windows closed during peak traffic hours',
          'Monitor local air quality reports',
          'Ensure good ventilation when using gas appliances',
        ];
      } else if (no2Level < 2.0) {
        precautions = [
          'Elevated NO2 levels detected (${no2Level.toStringAsFixed(2)} ppm)',
          'People with asthma should keep rescue inhalers readily available',
          'Limit outdoor activities, especially near busy roads',
          'Use air purifiers with HEPA filters indoors',
          'Consider wearing a mask in heavily polluted areas',
        ];
      } else {
        precautions = [
          'High NO2 levels detected (${no2Level.toStringAsFixed(2)} ppm)',
          'Stay indoors with windows closed if possible',
          'Use air purifiers with activated carbon filters',
          'Wear N95 masks when outdoors',
          'Seek medical attention if experiencing difficulty breathing or irritation',
          'Follow local health advisories',
        ];
      }
    } else if (index == 1) {
      // CO precaution card
      pollutantName = 'CO (Carbon Monoxide)';
      description = 'Carbon Monoxide is an odorless, colorless gas that can cause sudden illness and death. It\'s produced by burning gasoline, wood, propane, charcoal or other fuel.';
      accentColor = Colors.red;
      
      double coLevel = pollutantLevels['CO'] ?? 0.0;
      
      if (coLevel < 0.2) {
        precautions = [
          'Current CO levels are low (${coLevel.toStringAsFixed(2)} ppm)',
          'Maintain regular inspection of fuel-burning appliances',
          'Continue using carbon monoxide detectors in your home',
          'No special precautions needed at this time',
          'Safe for normal activities',
        ];
      } else if (coLevel < 0.3) {
        precautions = [
          'Moderate CO levels detected (${coLevel.toStringAsFixed(2)} ppm)',
          'Ensure proper ventilation when using fuel-burning appliances',
          'Check that your carbon monoxide detectors are working properly',
          'Have heating systems and gas appliances inspected',
          'Monitor for symptoms like headache or dizziness',
        ];
      } else if (coLevel < 0.4) {
        precautions = [
          'Elevated CO levels detected (${coLevel.toStringAsFixed(2)} ppm)',
          'Increase ventilation in enclosed spaces',
          'Never use gas-powered equipment or burn charcoal indoors',
          'Have heating systems, water heaters, and gas appliances serviced immediately',
          'Be alert for symptoms like headache, dizziness, or nausea',
        ];
      } else {
        precautions = [
          'High CO levels detected (${coLevel.toStringAsFixed(2)} ppm)',
          'Leave the area immediately and get fresh air',
          'Never leave a car running in an enclosed space',
          'Call emergency services if experiencing symptoms',
          'Have all fuel-burning appliances professionally inspected',
          'Consider temporary alternative accommodation if levels persist',
        ];
      }
    } else {
      // NH3 precaution card
      pollutantName = 'NH3 (Ammonia)';
      description = 'Ammonia is a colorless gas with a pungent smell. It\'s commonly used in agricultural fertilizers and cleaning products. High levels can irritate the respiratory system.';
      accentColor = Colors.green;
      
      double nh3Level = pollutantLevels['NH3'] ?? 0.0;
      
      if (nh3Level < 0.5) {
        precautions = [
          'Current NH3 levels are low (${nh3Level.toStringAsFixed(2)} ppm)',
          'Continue normal activities',
          'No special precautions needed',
          'Safe to use household cleaning products as directed',
          'Monitor local agricultural activities if you live in a rural area',
        ];
      } else if (nh3Level < 0.8) {
        precautions = [
          'Moderate NH3 levels detected (${nh3Level.toStringAsFixed(2)} ppm)',
          'Ensure proper ventilation when using ammonia-based cleaning products',
          'Store ammonia products properly and away from children',
          'Consider using alternatives to ammonia-based cleaners',
          'Be aware of local agricultural fertilizer application schedules',
        ];
      } else if (nh3Level < 1.0) {
        precautions = [
          'Elevated NH3 levels detected (${nh3Level.toStringAsFixed(2)} ppm)',
          'Avoid using ammonia-based products if you have respiratory conditions',
          'Ensure adequate ventilation in all indoor spaces',
          'Never mix ammonia with bleach as it creates toxic chloramine vapors',
          'Consider wearing a mask when outdoors if near agricultural areas',
        ];
      } else {
        precautions = [
          'High NH3 levels detected (${nh3Level.toStringAsFixed(2)} ppm)',
          'Wear protective masks and gloves when handling ammonia products',
          'Limit outdoor exposure, especially near agricultural or industrial areas',
          'Use ammonia-free cleaning alternatives',
          'Seek medical attention if experiencing eye or respiratory irritation',
          'Keep children and pets indoors if possible',
        ];
      }
    }

    return PrecautionCard(
      pollutantName: pollutantName,
      description: description,
      precautions: precautions,
      accentColor: accentColor,
    );
  }

  // Updated method for dynamic AQI precaution card
  Widget _buildAQIPrecautionCard() {
    // Determine AQI status and color based on current AQI value
    String aqiStatus;
    Color aqiColor;
    List<String> aqiPrecautions;
    
    if (currentAQI <= 50) {
      aqiStatus = 'Good';
      aqiColor = Colors.green;
      aqiPrecautions = [
        'Air quality is good - enjoy outdoor activities',
        'Perfect time for outdoor exercise',
        'Open windows to let in fresh air',
        'No special precautions needed',
        'Great day for outdoor gatherings',
      ];
    } else if (currentAQI <= 100) {
      aqiStatus = 'Moderate';
      aqiColor = Colors.yellow;
      aqiPrecautions = [
        'Air quality is acceptable for most individuals',
        'Unusually sensitive people should consider reducing prolonged outdoor exertion',
        'Keep monitoring the AQI if you have respiratory issues',
        'Good idea to keep windows closed during peak pollution hours',
        'Consider using air purifiers if you have allergies',
      ];
    } else if (currentAQI <= 200) {
      aqiStatus = 'Unhealthy';
      aqiColor = Colors.orange;
      aqiPrecautions = [
        'Members of sensitive groups may experience health effects',
        'Keep windows closed to prevent outdoor air pollution from coming inside',
        'Use air purifiers with HEPA filters indoors',
        'Limit prolonged outdoor activities, especially near busy roads',
        'Stay hydrated to help your body filter toxins',
        'Consider using N95 masks when outdoors',
      ];
    } else if (currentAQI <= 300) {
      aqiStatus = 'Very Unhealthy';
      aqiColor = Colors.red;
      aqiPrecautions = [
        'Health alert: Risk of health effects is increased for everyone',
        'Avoid all outdoor physical activities',
        'Keep all windows and doors closed',
        'Run air purifiers continuously',
        'Wear N95 masks when outdoors',
        'Consider relocating temporarily if you have respiratory conditions',
        'Follow local health department advisories',
      ];
    } else {
      aqiStatus = 'Hazardous';
      aqiColor = Colors.purple;
      aqiPrecautions = [
        'Health emergency: Everyone is likely to be affected',
        'Stay indoors with windows and doors closed',
        'Use multiple air purifiers if available',
        'Avoid any outdoor activities',
        'Wear N95 masks if you must go outside',
        'Consider evacuation to areas with better air quality',
        'Seek medical attention if experiencing respiratory symptoms',
        'Follow emergency instructions from local authorities',
      ];
    }

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
        title: Row(
          children: [
            Text(
              'AQI Guide & Precautions',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: aqiColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${currentAQI.toStringAsFixed(0)} - $aqiStatus',
                style: TextStyle(
                  color: aqiColor == Colors.yellow ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
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
                Text(
                  'Current AQI: ${currentAQI.toStringAsFixed(0)} - $aqiStatus',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: aqiColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Recommended Precautions:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...aqiPrecautions.map((precaution) => _buildPrecautionItem(precaution)),
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

// PrecautionCard widget class
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