import 'package:flutter/material.dart';
import 'package:languageapp/feature/auth/presentation/screens/login_screen.dart';
import 'package:languageapp/feature/student/presentation/screens/student/home_screen.dart';
import 'package:languageapp/feature/teacher/presentation/screens/dashboard_screen.dart';

class AuthDecider extends StatelessWidget {
  const AuthDecider({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = false; 
    final String userType = 'student'; 
    if (isLoggedIn) {
      return userType == 'student'
          ? const StudentHomeScreen()
          : TeacherDashboardScreen();
    } else {
      return const LoginScreens();
    }
  }
}
