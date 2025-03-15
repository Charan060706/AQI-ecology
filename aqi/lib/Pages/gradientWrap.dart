import 'package:flutter/material.dart';

class GradientWrapper extends StatefulWidget {
  final Widget child;
  const GradientWrapper({super.key, required this.child});

  @override
  _GradientWrapperState createState() => _GradientWrapperState();
}

class _GradientWrapperState extends State<GradientWrapper> {
  double scrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        setState(() {
          scrollOffset = (scrollInfo.metrics.pixels / scrollInfo.metrics.maxScrollExtent).clamp(0.0, 1.0);
        });
        return true;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(Colors.black, Colors.black87, scrollOffset)!,
              Color.lerp(Colors.black87, Colors.black54, scrollOffset)!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: widget.child,
        ),
      ),
    );
  }
}
