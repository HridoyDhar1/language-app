import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:languageapp/blocs/auth/auth_decider.dart';

class languageApp extends StatelessWidget {
  const languageApp({super.key});

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
