
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:languageapp/feature/teacher/data/models/teacher_model.dart'; // You'll need to create this model

class ScheduleController extends GetxController {
  final RxList<Teacher> teachers = <Teacher>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    _firestore
        .collection('schedules')
        .orderBy('date')
        .snapshots()
        .listen((snapshot) {
      teachers.clear();
      for (var doc in snapshot.docs) {
        teachers.add(Teacher.fromFirestore(doc.data(), doc.id));
      }
    });
  }

  Future<void> addSchedule({
    required DateTime date,
    required TimeOfDay time,
    required String description,
    required String name,
    required double price,
    required String location,
    required String language,
    required String image,
  }) async {
    await _firestore.collection('schedules').add({
      'name': name,
      'description': description,
      'price': price,
      'location': location,
      'language': language,
      'image': image,
      'date': date,
      'time': {'hour': time.hour, 'minute': time.minute},
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeSchedule(String teacherId) async {
    await _firestore.collection('schedules').doc(teacherId).delete();
  }
}