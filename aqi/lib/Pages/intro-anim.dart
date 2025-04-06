import 'package:flutter/material.dart';
import 'dart:async';
import 'homepage.dart'; // your actual homepage

class IntroAnimationScreen extends StatefulWidget {
  const IntroAnimationScreen({super.key});

  @override
  State<IntroAnimationScreen> createState() => _IntroAnimationScreenState();
}

class _IntroAnimationScreenState extends State<IntroAnimationScreen> with TickerProviderStateMixin {
  late AnimationController _fadeScaleController;
  late AnimationController _moveController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _logoSlideUp;
  late Animation<Offset> _bgSlideDown;

  @override
  void initState() {
    super.initState();

    // Animation for fade + scale
    _fadeScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeScaleController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _fadeScaleController, curve: Curves.elasticOut),
    );

    // Animation for logo up and bg down
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoSlideUp = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.5),
    ).animate(CurvedAnimation(parent: _moveController, curve: Curves.easeInOut));

    _bgSlideDown = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(parent: _moveController, curve: Curves.easeInOut));

    _fadeScaleController.forward();

    // Start slide-up after initial entrance
    Timer(const Duration(milliseconds: 1800), () {
      _moveController.forward();
    });

    // Navigate to homepage after all animations
    Timer(const Duration(milliseconds: 3200), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomePage(
            isDarkMode: false,
            toggleTheme: () {},
          ),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _fadeScaleController.dispose();
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background sliding down
          SlideTransition(
            position: _bgSlideDown,
            child: Container(
              color: Colors.blue.shade100,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Logo sliding up
          Center(
            child: SlideTransition(
              position: _logoSlideUp,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 20,
                          spreadRadius: 5,
                          color: Colors.black26,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset("assets/logo.png", fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
