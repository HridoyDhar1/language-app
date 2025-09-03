import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Language Learning App",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ).animate().fadeIn(duration: 1.seconds).slideY(begin: 1.0, end: 0),
      ),
    );
  }
}
