import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:languageapp/models/booking_controller.dart';
import 'package:languageapp/screens/student/booking_details.dart';
import 'package:languageapp/screens/student/widgets/shimmer_card.dart';
class MyBookingList extends StatelessWidget {
  const MyBookingList({
    super.key,
    required this.bookingController,
  });

  final BookingController bookingController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
  child: Obx(() {
    if (bookingController.bookings.isEmpty) {
      return const Center(
        child: Text(
          "No bookings yet",
          style: TextStyle(fontSize: 18,color: Colors.white70),
        ),
      );
    }
    return ListView.builder(
      itemCount: bookingController.bookings.length,
      itemBuilder: (context, index) {
        final booking = bookingController.bookings[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ShimmerCard(
            title: "${booking.teacherName} (${booking.language})",
            subtitle: "${booking.date} at ${booking.time} - \$${booking.price.toStringAsFixed(2)}",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingDetailsScreen(booking: booking),
                ),
              );
            },
          ),
        );
      },
    );
  }),
)
;
  }
}