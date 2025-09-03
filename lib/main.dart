import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:languageapp/blocs/auth/auth_bloc.dart';
import 'package:languageapp/blocs/booking/booking_bloc.dart';
import 'package:languageapp/blocs/language/language_bloc.dart';
import 'package:languageapp/blocs/schedule/schedule_bloc.dart';
import 'package:languageapp/blocs/schedule/schedule_event.dart';
import 'package:languageapp/core/config/app.dart';

import 'package:languageapp/feature/teacher/presentation/controller/notification_controller.dart';

import 'package:languageapp/firebase_options.dart';
import 'package:languageapp/feature/booking/presentation/controller/booking_controller.dart';

import 'package:languageapp/feature/schedule/presentation/controller/scheul_controller.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(NotificationController()); 
    // await PaymentService.initStripe();
  Get.put(BookingController());
  Get.put(ScheduleController());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageBloc()),
  
       BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),
        BlocProvider<ScheduleBloc>(
          create: (_) => ScheduleBloc()..add(LoadSchedules()),
        ),
        // ✅ Added TeacherBloc
      ],
      
      child: const languageApp(),
    ),
  );
}


