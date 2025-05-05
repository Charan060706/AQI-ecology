import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'historical_data.dart';

class LocationPage extends StatefulWidget {
  final double lat;
  final double lng;

  const LocationPage({super.key, required this.lat, required this.lng});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _iconAnimationController;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _iconAnimationController, curve: Curves.easeInOut),
    );

    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _iconAnimationController, curve: Curves.easeInOut),
    );

    _pages.addAll([
      _pollutantCardsPage(),
      HistoricalDataPage(latitude: widget.lat, longitude: widget.lng), // Pass coordinates here
    ]);
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  Widget _pollutantCardsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildParameterCard(
              'Location Coordinates',
              '',
              'Lat: ${widget.lat.toStringAsFixed(5)}, Lng: ${widget.lng.toStringAsFixed(5)}',
              Colors.green,
              Icons.explore,
            ),
            _buildParameterCard('Methane', 'CH₄', '100 μ % (v/v)', Colors.teal, Icons.local_fire_department),
            _buildParameterCard('Ammonia', 'NH₃', '17.38 μg/m³', Colors.amber, Icons.science),
            _buildParameterCard('Humidity', '', '32%', Colors.lightBlue, Icons.water_drop),
            _buildParameterCard('Nitrogen Dioxide', 'NO₂', '53 ppb', Colors.redAccent, Icons.cloud),
            _buildParameterCard('Particulate Matter', 'PM2.5', '40 ng/L', Colors.grey.shade400, Icons.grain),
            _buildParameterCard('Pressure', '', '1017 mb', Colors.deepPurple, Icons.speed),
            _buildParameterCard('Particulate Matter', 'PM10', '4.10 ng/L', Colors.grey.shade600, Icons.lens_blur),
            _buildParameterCard('Temperature', '', '22.78 °C', Colors.orange, Icons.thermostat),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Page')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.location_on,
                key: ValueKey<int>(_selectedIndex),
                size: _selectedIndex == 0 ? 35.0 : 25.0,
              ),
            ),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.history,
                key: ValueKey<int>(_selectedIndex),
                size: _selectedIndex == 1 ? 35.0 : 25.0,
              ),
            ),
            label: 'Historical',
          ),
        ],
      ),
    );
  }

  Widget _buildParameterCard(String name, String unit, String value, Color color, IconData icon) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              child: AnimatedBuilder(
                animation: _iconAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _iconScaleAnimation.value,
                    child: Transform.rotate(
                      angle: _iconRotationAnimation.value,
                      child: Icon(icon, color: color, size: 40),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(
                    unit.isNotEmpty ? '$unit $value' : value,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
