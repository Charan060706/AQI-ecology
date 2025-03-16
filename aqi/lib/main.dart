import 'package:aqi/Pages/homepage.dart';
import 'package:aqi/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Pages/about.dart';
import 'package:flutter/material.dart';
import 'Pages/location_page.dart';
import 'Pages/historical_data.dart';
import 'Pages/Hello.dart';
import 'Pages/gradientWrap.dart'; // Import the GradientWrapper

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/': (context) => const GradientWrapper(child: Hello()), // Apply wrapper to pages
        '/home': (context) => const GradientWrapper(child: HomePage()),
        '/location': (context) => const GradientWrapper(child: LocationPage()),
        '/historical': (context) => const GradientWrapper(child: HistoricalDataPage()),
        '/about': (context) => const GradientWrapper(child: AboutPage()),
      },
    );
  }
}
