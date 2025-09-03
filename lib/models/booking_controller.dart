import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking_model.dart';

class BookingController extends GetxController {
  final bookings = <Booking>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  // Add booking locally + Firestore
  void addBooking(Booking booking) {
    bookings.add(booking);

    _firestore.collection('bookings').add({
      'teacherName': booking.teacherName,
      'language': booking.language,
      'date': booking.date,
      'time': booking.time,
      'price': booking.price,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((docRef) {
      print("Booking saved with ID: ${docRef.id}");
    }).catchError((error) {
      print("Error adding booking: $error");
    });
  }

  // Fetch bookings from Firestore in real-time
  void fetchBookings() {
    _firestore
        .collection('bookings')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      bookings.value = snapshot.docs.map((doc) {
        return Booking(
          teacherName: doc['teacherName'] ?? '',
          language: doc['language'] ?? '',
          date: doc['date'] ?? '',
          time: doc['time'] ?? '',
          price: (doc['price'] ?? 0).toDouble(),
        );
      }).toList();
    }, onError: (error) {
      print("Error fetching bookings: $error");
    });
  }
}
