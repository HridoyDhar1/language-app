import 'package:flutter/material.dart';
import 'package:languageapp/feature/teacher/data/models/teacher_model.dart';

/// 🔹 Animated Teacher Card
class AnimatedTeacherCard extends StatelessWidget {
  final Animation<double> scale;
  final Animation<double> fade;
  final Teacher teacher;

  const AnimatedTeacherCard({
    super.key,
    required this.scale,
    required this.fade,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: FadeTransition(
        opacity: fade,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(teacher.image),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        teacher.language,
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



