import 'package:aqi/Pages/homepage.dart';
import 'package:aqi/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/about.dart';
import 'package:flutter/material.dart';
import 'Pages/location_page.dart';
import 'Pages/historical_data.dart';
import 'Pages/gradientWrap.dart';

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
  bool isDarkMode = false;

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
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
              builder: (_) => GradientWrapper(
                child: HomePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
              ),
            );
          case '/location':
            return MaterialPageRoute(
              builder: (_) => const GradientWrapper(
                child: LocationPage(lat: 0.0, lng: 0.0),
              ),
            );
          case '/historical':
            final args = settings.arguments as Map<String, double>;
            return MaterialPageRoute(
              builder: (_) => GradientWrapper(
                child: HistoricalDataPage(
                  latitude: args['latitude']!,
                  longitude: args['longitude']!,
                ),
              ),
            );
          case '/about':
            return MaterialPageRoute(
              builder: (_) => GradientWrapper(child: AboutPage())
            );
          default:
            return null;
        }
      },
    );
  }
}
