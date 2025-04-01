import 'package:aqi/Pages/homepage.dart';
import 'package:aqi/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Pages/about.dart';
import 'package:flutter/material.dart';
import 'Pages/location_page.dart';
import 'Pages/historical_data.dart';
import 'Pages/gradientWrap.dart'; // Import the GradientWrapper

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false; // Global theme state

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(), // Apply theme dynamically
      initialRoute: '/home',
      routes: {
        //'/': (context) => GradientWrapper(child: Hello(toggleTheme: toggleTheme, isDarkMode: isDarkMode)), 
        '/home': (context) => GradientWrapper(child: HomePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode)),
        '/location': (context) => GradientWrapper(child: LocationPage()),
        '/historical': (context) => GradientWrapper(child: HistoricalDataPage()),
        '/about': (context) => GradientWrapper(child: AboutPage()),
      },
    );
  }
}
