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
        doc.data().forEach((key, value) {
          if (value is GeoPoint) {
            double lat = value.latitude;
            double lng = value.longitude;

            setState(() {
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
                      color: widget.isDarkMode ? Colors.greenAccent : Colors.pinkAccent,
                      size: 40,
                    ),
                  ),
                ),
              );
            });
          }
        });
      }
      setState(() {});
    }).catchError((error) {
      print("Error fetching locations: $error");
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
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.grey[900],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isDarkMode
                  ? [Colors.purple.shade900, Colors.cyan.shade700] // Dark neon gradient
                  : [Colors.deepPurple.shade600, Colors.cyan.shade400], // Light neon gradient
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isDarkMode ? Colors.cyanAccent.withOpacity(0.5) : Colors.pinkAccent.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: AppBar(
            title: Text(
              'Air Index',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: widget.isDarkMode
                        ? [Colors.cyanAccent, Colors.pinkAccent]
                        : [Colors.greenAccent, Colors.yellowAccent],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: widget.isDarkMode ? Colors.cyanAccent : Colors.pinkAccent,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: widget.isDarkMode ? Colors.cyanAccent : Colors.pinkAccent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDarkMode ? Colors.cyanAccent.withOpacity(0.5) : Colors.pinkAccent.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return RotationTransition(turns: animation, child: child);
                    },
                    child: widget.isDarkMode
                        ? const Icon(Icons.dark_mode, key: ValueKey('dark'), color: Colors.cyanAccent)
                        : const Icon(Icons.wb_sunny, key: ValueKey('light'), color: Colors.pinkAccent),
                  ),
                  onPressed: widget.toggleTheme,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.isDarkMode
                ? [Colors.black, Colors.purple.shade900]
                : [Colors.grey.shade900, Colors.deepPurple.shade800],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: widget.isDarkMode ? Colors.black : Colors.grey[850],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: widget.isDarkMode ? Colors.cyanAccent : Colors.pinkAccent,
                    width: 2,
                  ),
                ),
                elevation: 8,
                shadowColor: widget.isDarkMode ? Colors.cyanAccent.withOpacity(0.5) : Colors.pinkAccent.withOpacity(0.5),
                child: Container(
                  width: 375,
                  height: 550,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isDarkMode ? Colors.cyanAccent.withOpacity(0.3) : Colors.pinkAccent.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: -5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      children: [
                        // Map section - unchanged as requested
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
                        // Zoom controls - updated styling
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.isDarkMode ? Colors.cyanAccent.withOpacity(0.5) : Colors.pinkAccent.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: FloatingActionButton(
                                  mini: true,
                                  backgroundColor: widget.isDarkMode ? Colors.black : Colors.grey[850],
                                  heroTag: "zoom_in",
                                  onPressed: _zoomIn,
                                  child: Icon(
                                    Icons.add,
                                    color: widget.isDarkMode ? Colors.cyanAccent : Colors.pinkAccent,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.isDarkMode ? Colors.cyanAccent.withOpacity(0.5) : Colors.pinkAccent.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: FloatingActionButton(
                                  mini: true,
                                  backgroundColor: widget.isDarkMode ? Colors.black : Colors.grey[850],
                                  heroTag: "zoom_out",
                                  onPressed: _zoomOut,
                                  child: Icon(
                                    Icons.remove,
                                    color: widget.isDarkMode ? Colors.cyanAccent : Colors.pinkAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDarkMode ? Colors.cyanAccent.withOpacity(0.6) : Colors.pinkAccent.withOpacity(0.6),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.isDarkMode
                            ? [Colors.deepPurple.shade900, Colors.cyan.shade800]
                            : [Colors.pinkAccent, Colors.deepPurpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.isDarkMode ? Colors.cyanAccent : Colors.yellowAccent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 26,
                          color: widget.isDarkMode ? Colors.cyanAccent : Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'About',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: widget.isDarkMode ? Colors.cyanAccent : Colors.pinkAccent,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}