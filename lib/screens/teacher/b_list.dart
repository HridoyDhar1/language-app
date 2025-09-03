import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:languageapp/models/booking_controller.dart';
import 'package:languageapp/models/booking_model.dart';
import 'package:languageapp/screens/teacher/student_booking.dart';

class BookingListWidget extends StatefulWidget {
  const BookingListWidget({super.key});

  @override
  State<BookingListWidget> createState() => _BookingListWidgetState();
}

class _BookingListWidgetState extends State<BookingListWidget>
    with SingleTickerProviderStateMixin {
  final BookingController bookingController = Get.find<BookingController>();
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final Map<int, double> scaleValue = {};

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToDetails(Booking booking) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            StudentBookingDetails(booking: booking),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: const Offset(0, 0.2), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, int index) {
    scaleValue.putIfAbsent(index, () => 1.0);

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.1 * index, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTapDown: (_) => setState(() => scaleValue[index] = 0.97),
            onTapUp: (_) => setState(() => scaleValue[index] = 1.0),
            onTapCancel: () => setState(() => scaleValue[index] = 1.0),
            child: Transform.scale(
              scale: scaleValue[index]!,
              child: Material(
                color: Colors.white,
                elevation: 6,
                shadowColor: Colors.indigo.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.indigoAccent,
                    child: Text(
                      booking.teacherName.substring(0, 1),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  title: Text(
                    "${booking.language} with ${booking.teacherName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Text(
                    "${booking.date} at ${booking.time}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  onTap: () => _navigateToDetails(booking),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bookings = bookingController.bookings;

      if (bookings.isEmpty) {
        return Center(
          child: FadeTransition(
            opacity: _animation,
            child: const Text(
              "No bookings yet",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildBookingCard(booking, index);
        },
      );
    });
  }
}
