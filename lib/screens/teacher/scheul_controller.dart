
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ScheduleController extends GetxController {
//   final RxList<Map<String, dynamic>> schedules = <Map<String, dynamic>>[].obs;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchSchedules();
//   }

//   Future<void> fetchSchedules() async {
//     _firestore
//         .collection('schedules')
//         .orderBy('date')
//         .snapshots()
//         .listen((snapshot) {
//       schedules.clear();
//       for (var doc in snapshot.docs) {
//         schedules.add({
//           'id': doc.id,
//           'name': doc['name'],
//           'description': doc['description'],
//           'price': doc['price'],
//           'location': doc['location'],
//           'date': (doc['date'] as Timestamp).toDate(),
//           'time': TimeOfDay(
//             hour: doc['time']['hour'],
//             minute: doc['time']['minute'],
//           ),
//         });
//       }
//     });
//   }

//   Future<void> addSchedule({
//     required DateTime date,
//     required TimeOfDay time,
//     required String description,
//     required String name,
//     required double price,
//     required String location,
//   }) async {
//     await _firestore.collection('schedules').add({
//       'name': name,
//       'description': description,
//       'price': price,
//       'location': location,
//       'date': date,
//       'time': {'hour': time.hour, 'minute': time.minute},
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> removeSchedule(Map<String, dynamic> schedule) async {
//     if (schedule['id'] != null) {
//       await _firestore.collection('schedules').doc(schedule['id']).delete();
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:languageapp/models/teacher_model.dart'; // You'll need to create this model

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