import 'Pages/about.dart';
import 'package:flutter/material.dart';
import 'Pages/homepage.dart';
import 'Pages/location_page.dart';
import 'Pages/historical_data.dart';

void main() {
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
        '/home': (context) => const HomePage(),
        '/location': (context) => const LocationPage(),
        '/historical': (context) => const HistoricalDataPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}
