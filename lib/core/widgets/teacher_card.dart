import 'package:flutter/material.dart';
import '../../feature/teacher/data/models/teacher_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TeacherCard extends StatelessWidget {
  final Teacher teacher;
  final VoidCallback onTap;

  const TeacherCard({super.key, required this.teacher, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // CircleAvatar(
              //   radius: 30,
              //   backgroundImage: AssetImage(teacher.image),
              // ).animate().fadeIn(duration: 500.ms).scale(),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(teacher.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Language: ${teacher.language}", style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ],
          ),
        ),
      ).animate().slideX(begin: -1.0, end: 0).fadeIn(),
    );
  }
}
