import 'package:get/get.dart';
import 'booking_model.dart';

class TeacherBookingController extends GetxController {
  // Observable list of bookings
  var bookings = <Booking>[].obs;

  // Add a booking (this would be called when student books)
  void addBooking(Booking booking) {
    bookings.add(booking);
  }

  // Remove or update bookings as needed
  void removeBooking(Booking booking) {
    bookings.remove(booking);
  }
}
