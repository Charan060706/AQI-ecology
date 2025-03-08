import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historical Data')),
      body: Center(
        child: const Text('AboutData Information Goes Here'),
      ),
    );
  }
}