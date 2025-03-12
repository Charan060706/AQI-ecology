import 'package:flutter/material.dart';


class Hello extends StatefulWidget {
  const Hello({super.key});

    @override
  _HelloState createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  bool isDarkMode = false; // Moved inside StatefulWidget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 700), // Smooth transition
        curve: Curves.easeInOut, // Easing effect
        color: isDarkMode ? const Color(0xFF0F3460) : const Color(0xFFE8F8F5),
        child: Stack(
          children:[
            Positioned(
              top:40,
              right: 20,
              child: IconButton(
                iconSize: 35,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                     return RotationTransition(turns: animation, child: child);
                  },
                  child: isDarkMode
                      ? const Icon(Icons.dark_mode, key: ValueKey('dark'), color: Colors.white)
                      : const Icon(Icons.wb_sunny, key: ValueKey('light'), color: Colors.orange),
                  ),
                  onPressed: (){
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
              )

          ),

          ]

        ),
      ),
    );
  }
}