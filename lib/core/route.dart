import 'package:get/get.dart';
import 'package:languageapp/feature/auth/login_screen.dart';


class AppRoutes {
  static const login = '/login';
  static const language = '/language';
  static const teacherList = '/teacher-list';
  static const schedule = '/schedule';
  static const studentDashboard = '/student-dashboard';

  static final routes = [
    GetPage(name: login, page: () => LoginScreens()),
    // GetPage(name: language, page: () => LanguageScreen()),
    // GetPage(name: teacherList, page: () => TeacherListScreen()),
    // GetPage(name: schedule, page: () => ScheduleScreen()),
    // GetPage(name: studentDashboard, page: () => StudentDashboard()),
  ];
}
