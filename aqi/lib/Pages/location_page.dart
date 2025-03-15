
import 'package:flutter/material.dart';
import 'historical_data.dart'; // Import the historical data page

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  // Animation controller for icon animations (scaling and rotation)
  late AnimationController _iconAnimationController;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Repeat animation for continuous effect

    // Animation for scaling icon
    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _iconAnimationController, curve: Curves.easeInOut),
    );

    // Animation for rotating icon
    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _iconAnimationController, curve: Curves.easeInOut),
    );

    // Initialize pages after the controller is set
    _pages.addAll([
      _pollutantCardsPage(),
      const HistoricalDataPage(),
    ]);
  }

  @override
  void dispose() {
    _iconAnimationController.dispose(); // Clean up animation controller
    super.dispose();
  }

  // Function to create pollutant parameter cards page
  Widget _pollutantCardsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildParameterCard('Methane', 'CH₄', '100 μ % (v/v)', Colors.teal, Icons.local_fire_department), // Fire hazard
            _buildParameterCard('Ammonia', 'NH₃', '17.38 μg/m³', Colors.amber, Icons.science), // Chemical indicator
            _buildParameterCard('Humidity', '', '32%', Colors.lightBlue, Icons.water_drop), // Water drop
            _buildParameterCard('Nitrogen Dioxide', 'NO₂', '53 ppb', Colors.redAccent, Icons.cloud), // Pollution/cloud
            _buildParameterCard('Particulate Matter', 'PM2.5', '40 ng/L', Colors.grey.shade400, Icons.grain), // Particles
            _buildParameterCard('Pressure', '', '1017 mb', Colors.deepPurple, Icons.speed), // Pressure gauge
            _buildParameterCard('Particulate Matter', 'PM10', '4.10 ng/L', Colors.grey.shade600, Icons.lens_blur), // Air particles
            _buildParameterCard('Temperature', '', '22.78 °C', Colors.orange, Icons.thermostat), // Thermometer
          ],
        ),
      ),
    );
  }

  // Pages in bottom navigation bar
  final List<Widget> _pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Page'),
      ),
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

  // Function to create each pollutant parameter card with animated icons
  Widget _buildParameterCard(String name, String unit, String value, Color color, IconData icon) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
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
                      child: Icon(
                        icon,
                        color: color,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  unit.isNotEmpty ? '$unit $value' : value,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
