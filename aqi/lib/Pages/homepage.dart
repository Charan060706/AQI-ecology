import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

  // Fetch locations from Firestore
 void _fetchLocations() async {
  FirebaseFirestore.instance.collection('locations').get().then((snapshot) {
    print("📢 Firestore Query Result: ${snapshot.docs.length} documents found");

    for (var doc in snapshot.docs) {
      print("📌 Document ID: ${doc.id}");
      print("📝 Data: ${doc.data()}");

      doc.data().forEach((key, value) {
        if (value is GeoPoint) { // ✅ Correctly handling Firestore GeoPoints
          double lat = value.latitude;
          double lng = value.longitude;

          print("✅ Found GeoPoint -> Lat: $lat, Lng: $lng");

          setState(() {
            _markers.add(
              Marker(
                point: LatLng(lat, lng),
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
            );
          });
        } else {
          print("⚠️ Skipped field '$key' - Not a valid GeoPoint");
        }
      });
    }

    print("📍 Total Markers Added: ${_markers.length}");
    setState(() {}); // ✅ Refresh UI to show markers
  }).catchError((error) {
    print("❌ Error fetching locations: $error");
  });
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
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: SizedBox(
                width: 400,
                height: 700,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _markers.isNotEmpty ? _markers[0].point : LatLng(13.7072, 79.5945),
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
            const SizedBox(height: 20),
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
