// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:languageapp/Controllers/payment_service.dart';
// import '../models/booking_model.dart';

// class BookingController extends GetxController {
//   var bookings = <Booking>[].obs;

//   void bookLesson(Booking booking) async {
//     // Payment first
//     bool paid = await PaymentController().pay(10); // Dummy amount
//     if (paid) {
//       await FirebaseFirestore.instance.collection('bookings').add(booking.toMap());
//       bookings.add(booking);

//     } else {
//       Get.snackbar('Failed', 'Payment failed');
//     }
//   }
// }
