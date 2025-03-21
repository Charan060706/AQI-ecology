import 'package:flutter/material.dart';

class Hello extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const Hello({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        color: isDarkMode ? const Color(0xFF0F3460) : const Color(0xFFE8F8F5),
        child: Stack(
          children: [
            Positioned(
              top: 40,
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
                onPressed: toggleTheme, // Toggle theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}
