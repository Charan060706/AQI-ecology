import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  double _zoomLevel = 14.0; // Default zoom level

  // Fixed location for the marker
  static const LatLng fixedLocation = LatLng(13.7072, 79.5945); // San Francisco

  // Zoom in function
  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 1).clamp(2.0, 18.0);
      _mapController.move(_mapController.camera.center, _zoomLevel);
    });
  }

  // Zoom out function
  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 1).clamp(2.0, 18.0);
      _mapController.move(_mapController.camera.center, _zoomLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: SizedBox(
                width: 400, // Square field
                height: 700,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController, // Attach controller
                        options: MapOptions(
                          initialCenter: fixedLocation, // Fixed map center
                          initialZoom: _zoomLevel, // Initial zoom level
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.all, // Allow panning & zooming
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          // Marker Layer (Pin always at fixedLocation)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: fixedLocation,
                                width: 40,
                                height: 40,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/location');
                                  },
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Zoom Buttons
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Column(
                          children: [
                            FloatingActionButton(
                              mini: true,
                              heroTag: "zoom_in",
                              onPressed: _zoomIn,
                              child: const Icon(Icons.add),
                            ),
                            const SizedBox(height: 5),
                            FloatingActionButton(
                              mini: true,
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
            const SizedBox(height: 20,  width: 100),
            ElevatedButton( 
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
              child: const Text('About'),
              
            ),
          ],
        ),
      ),
    );
  }
}
