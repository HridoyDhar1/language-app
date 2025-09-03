// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../models/teacher_model.dart';

// class ScheduleRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Stream<List<Schedule>> getSchedules() {
//     return _firestore
//         .collection('schedules')
//         .orderBy('date')
//         .snapshots()
//         .map((snapshot) =>
//         snapshot.docs.map((doc) => Schedule.fromFirestore(doc)).toList());
//   }

//   Future<void> addSchedule(Schedule schedule) async {
//     await _firestore.collection('schedules').add({
//       'name': schedule.name,
//       'description': schedule.description,
//       'price': schedule.price,
//       'location': schedule.location,
//       'date': schedule.date,
//       'time': {'hour': schedule.time.hour, 'minute': schedule.time.minute},
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> deleteSchedule(String id) async {
//     await _firestore.collection('schedules').doc(id).delete();
//   }
// }
