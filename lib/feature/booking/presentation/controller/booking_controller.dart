// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'booking_model.dart';

// class BookingController extends GetxController {
//   final bookings = <Booking>[].obs;

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchBookings();
//   }

//   // Add booking locally + Firestore
//   void addBooking(Booking booking) {
//     bookings.add(booking);

//     _firestore.collection('bookings').add({
//       'teacherName': booking.teacherName,
//       'language': booking.language,
//       'date': booking.date,
//       'time': booking.time,
//       'price': booking.price,
//       'timestamp': FieldValue.serverTimestamp(),
//     }).then((docRef) {
//       print("Booking saved with ID: ${docRef.id}");
//     }).catchError((error) {
//       print("Error adding booking: $error");
//     });
//   }

//   // Fetch bookings from Firestore in real-time
//   void fetchBookings() {
//     _firestore
//         .collection('bookings')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .listen((snapshot) {
//       bookings.value = snapshot.docs.map((doc) {
//         return Booking(
//           teacherName: doc['teacherName'] ?? '',
//           language: doc['language'] ?? '',
//           date: doc['date'] ?? '',
//           time: doc['time'] ?? '',
//           price: (doc['price'] ?? 0).toDouble(), teacherId: '',
//         );
//       }).toList();
//     }, onError: (error) {
//       print("Error fetching bookings: $error");
//     });
//   }
// }
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/booking_model.dart';

class BookingController extends GetxController {
  final bookings = <Booking>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  // Generate a MeetHout meeting link (mock implementation for testing)
  Future<Map<String, String>> _generateMeetingLink(String teacherId) async {
    try {
      // Simulate API call (replace with actual MeetHout API when available)
      // For testing, return a mock meeting link
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      final mockMeetingId = 'meet_${teacherId}_${DateTime.now().millisecondsSinceEpoch}';
      final mockMeetingLink = 'https://meethout.com/join?meetingId=$mockMeetingId';
      return {
        'meetingId': mockMeetingId,
        'meetingLink': mockMeetingLink,
      };
      
      // Actual API call (uncomment when you have MeetHout API details)
      /*
      final response = await http.post(
        Uri.parse('https://api.meethout.com/create-meeting'),
        headers: {'Authorization': 'Bearer your-api-key'},
        body: json.encode({
          'teacherId': teacherId,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'meetingId': data['meetingId'] ?? '',
          'meetingLink': data['meetingLink'] ?? '',
        };
      }
      throw Exception('Failed to generate meeting link');
      */
    } catch (e) {
      print('Error generating meeting link: $e');
      return {'meetingId': '', 'meetingLink': ''};
    }
  }

  // Add booking locally + Firestore
  Future<void> addBooking(Booking booking) async {
    // Generate MeetHout meeting details
    final meetingDetails = await _generateMeetingLink(booking.teacherId);

    // Create updated booking with meeting details
    final updatedBooking = Booking(
      teacherId: booking.teacherId,
      teacherName: booking.teacherName,
      language: booking.language,
      date: booking.date,
      time: booking.time,
      price: booking.price,
      meetingId: meetingDetails['meetingId'] ?? '',
      meetingLink: meetingDetails['meetingLink'] ?? '',
    );

    // Add to local list
    bookings.add(updatedBooking);

    // Save to Firestore
    await _firestore.collection('bookings').add({
      'teacherId': updatedBooking.teacherId,
      'teacherName': updatedBooking.teacherName,
      'language': updatedBooking.language,
      'date': updatedBooking.date,
      'time': updatedBooking.time,
      'price': updatedBooking.price,
      'meetingId': updatedBooking.meetingId,
      'meetingLink': updatedBooking.meetingLink,
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
          teacherId: doc['teacherId'] ?? '',
          teacherName: doc['teacherName'] ?? '',
          language: doc['language'] ?? '',
          date: doc['date'] ?? '',
          time: doc['time'] ?? '',
          price: (doc['price'] ?? 0).toDouble(),
          meetingId: doc['meetingId'] ?? '',
          meetingLink: doc['meetingLink'] ?? '',
        );
      }).toList();
    }, onError: (error) {
      print("Error fetching bookings: $error");
    });
  }
}