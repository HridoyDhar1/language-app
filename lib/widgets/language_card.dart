import 'package:flutter/material.dart';
import '../models/language_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LanguageCard extends StatelessWidget {
  final Language language;
  final VoidCallback onTap;

  const LanguageCard({super.key, required this.language, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flag image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                language.flagImage,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              language.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms).scale(),
    );
  }
}
