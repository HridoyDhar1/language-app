import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:languageapp/blocs/language/language_bloc.dart';

import 'package:languageapp/firebase_options.dart';
import 'package:languageapp/models/booking_controller.dart';
import 'package:languageapp/screens/student/home_screen.dart';
import 'package:languageapp/screens/teacher/dashboard_screen.dart';
import 'package:languageapp/screens/teacher/scheul_controller.dart';
import 'package:languageapp/feature/auth/login_screen.dart';
import 'package:languageapp/services/payment_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    await PaymentService.initStripe();
  Get.put(BookingController());
  Get.put(ScheduleController());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageBloc()),
        // ✅ Added TeacherBloc
      ],
      
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Learning App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthDecider(),
    );
  }
}

// // Simple widget to decide where to go
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
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'app/routes/app_pages.dart';
// import 'app/bindings/initial_binding.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//     await GetStorage.init();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Language Tutor App',
//       debugShowCheckedModeBanner: false,
//       initialBinding: InitialBinding(),
//       initialRoute: AppPages.LOGIN,
//       getPages: AppPages.routes,

//     );
//   }
// }
