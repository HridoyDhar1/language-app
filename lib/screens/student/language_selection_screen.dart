import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:languageapp/models/teacher_model.dart';
import 'package:languageapp/screens/student/%20teacher_list_screen.dart';
import 'package:languageapp/screens/teacher/scheul_controller.dart';


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
              
              return _LanguageCard(
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

class _LanguageCard extends StatelessWidget {
  final String language;
  final int teacherCount;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.language,
    required this.teacherCount,
    required this.onTap,
  });

  String _getLanguageImagePath(String language) {
    switch (language.toLowerCase()) {
      case 'english':
        return 'assets/icons/united-states.png';
      case 'spanish':
        return 'assets/icons/spain.png';
      case 'french':
        return 'assets/icons/france.png';
      case 'german':
        return 'assets/flags/german.png';
      case 'chinese':
        return 'assets/flags/chinese.png';
      case 'arabic':
        return 'assets/flags/arabic.png';
      case 'japanese':
        return 'assets/icons/flag.png';
      case 'hindi':
        return 'assets/flags/hindi.png';
      case 'russian':
        return 'assets/flags/russian.png';
      case 'portuguese':
        return 'assets/flags/portuguese.png';
      case 'italian':
        return 'assets/flags/italian.png';
      case 'korean':
        return 'assets/flags/korean.png';
      default:
        return 'assets/flags/default.png';
    }
  }

  Color _getLanguageColor(String language) {
    switch (language.toLowerCase()) {
      case 'english':
        return const Color(0xFF012169); // UK blue
      case 'spanish':
        return const Color(0xFFAA151B); // Spanish red
      case 'french':
        return const Color(0xFF0055A4); // French blue
      case 'german':
        return const Color(0xFF000000); // German black
      case 'chinese':
        return const Color(0xFFDE2910); // Chinese red
      case 'arabic':
        return const Color(0xFF007A3D); // Arabic green
      case 'japanese':
        return const Color(0xFFBC002D); // Japanese red
      case 'hindi':
        return const Color(0xFFFF9933); // Indian orange
      case 'russian':
        return const Color(0xFFD52B1E); // Russian red
      case 'portuguese':
        return const Color(0xFF006600); // Portuguese green
      case 'italian':
        return const Color(0xFF009246); // Italian green
      case 'korean':
        return const Color(0xFF002496); // Korean blue
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getLanguageColor(language).withOpacity(0.9),
                _getLanguageColor(language).withOpacity(0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Language flag image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      _getLanguageImagePath(language),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.language,
                            size: 30,
                            color: Colors.orange,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  language,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$teacherCount teacher${teacherCount > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
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