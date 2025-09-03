import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:languageapp/feature/teacher/data/models/teacher_model.dart';
import 'package:languageapp/feature/teacher/presentation/screens/%20teacher_list_screen.dart';
import 'package:languageapp/feature/schedule/presentation/controller/scheul_controller.dart';
import 'package:languageapp/core/widgets/language_card.dart';


class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScheduleController scheduleController = Get.find<ScheduleController>();

    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        title: const Text("Available Languages"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Get unique languages from teachers
          final uniqueLanguages = _getUniqueLanguages(scheduleController.teachers);
          
          if (uniqueLanguages.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.language, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No languages available yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    "Add schedules to see languages here",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: uniqueLanguages.length,
            itemBuilder: (context, index) {
              final language = uniqueLanguages.keys.elementAt(index);
              final teacherCount = uniqueLanguages[language]!;
              
              return LanguageCard(
                language: language,
                teacherCount: teacherCount,
                onTap: () {
                  // Navigate to TeacherListScreen for this language
                  Get.to(() => TeacherListScreen(language: language));
                },
              );
            },
          );
        }),
      ),
    );
  }

  Map<String, int> _getUniqueLanguages(List<Teacher> teachers) {
    final Map<String, int> languageCount = {};
    
    for (var teacher in teachers) {
      languageCount.update(
        teacher.language,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    
    return languageCount;
  }
}

