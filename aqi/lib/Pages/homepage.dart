import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'about.dart';
import 'location_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomePage({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  double _zoomLevel = 14.0;
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  void _fetchLocations() async {
    FirebaseFirestore.instance.collection('locations').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();

        for (var key in data.keys) {
          final value = data[key];

          // Case 1: GeoPoint field (like: location1: GeoPoint)
          if (value is GeoPoint) {
            double lat = value.latitude;
            double lng = value.longitude;

            _addMarker(lat, lng);
          }

          // Case 2: lat and long fields (like: lat: 13.7, long: 79.5)
          else if (data.containsKey('lat') && data.containsKey('long')) {
            final lat = data['lat'];
            final lng = data['long'];

            if (lat is num && lng is num) {
              _addMarker(lat.toDouble(), lng.toDouble());
            }
          }
        }
      }

      setState(() {});
    }).catchError((error) {
      print("Error fetching locations: $error");
    });
  }

  void _addMarker(double lat, double lng) {
    _markers.add(
      Marker(
        point: LatLng(lat, lng),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LocationPage(),
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                      SlideTransition(position: offsetAnimation, child: child),
                    ],
                  );
                },
              ),
            );
          },
          child: Icon(
            Icons.location_pin,
            color: widget.isDarkMode ? Colors.orangeAccent : Colors.red,
            size: 40,
          ),
        ),
      ),
    );
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 1).clamp(2.0, 18.0);
      _mapController.move(_mapController.camera.center, _zoomLevel);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 1).clamp(2.0, 18.0);
      _mapController.move(_mapController.camera.center, _zoomLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isDarkMode
                  ? [Colors.black, Colors.white54]
                  : [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: AppBar(
            title: const Text('Air Index'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(turns: animation, child: child);
                  },
                  child: widget.isDarkMode
                      ? const Icon(Icons.dark_mode, key: ValueKey('dark'), color: Colors.white)
                      : const Icon(Icons.wb_sunny, key: ValueKey('light'), color: Colors.orange),
                ),
                onPressed: widget.toggleTheme,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: widget.isDarkMode ? Colors.grey[900] : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: SizedBox(
                width: 375,
                height: 550,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _markers.isNotEmpty
                              ? _markers[0].point
                              : LatLng(13.7072, 79.5945),
                          initialZoom: _zoomLevel,
                          interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(markers: _markers),
                        ],
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Column(
                          children: [
                            FloatingActionButton(
                              mini: true,
                              backgroundColor: widget.isDarkMode ? Colors.white24 : Colors.blue,
                              heroTag: "zoom_in",
                              onPressed: _zoomIn,
                              child: const Icon(Icons.add),
                            ),
                            const SizedBox(height: 5),
                            FloatingActionButton(
                              mini: true,
                              backgroundColor: widget.isDarkMode ? Colors.white24 : Colors.blue,
                              heroTag: "zoom_out",
                              onPressed: _zoomOut,
                              child: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  AboutPage()),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.isDarkMode
                        ? [Colors.deepPurpleAccent, Colors.blueAccent]
                        : [Colors.blueAccent, Colors.deepPurpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.info_outline, size: 24, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'About',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
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
