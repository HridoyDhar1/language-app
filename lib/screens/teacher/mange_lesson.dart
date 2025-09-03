import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:languageapp/models/booking_controller.dart';
import 'package:languageapp/models/booking_model.dart';
import 'package:languageapp/screens/teacher/student_booking.dart';

class ManageLessonsScreen extends StatelessWidget {
  ManageLessonsScreen({super.key});

  final BookingController bookingController = Get.find<BookingController>();

  Widget _buildLessonCard(Booking booking) {
    return Card(
      elevation: 4,
      shadowColor: Colors.indigo.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.indigoAccent,
          child: Text(
            booking.teacherName.substring(0, 1),
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        title: Text(
          "${booking.language} with ${booking.teacherName}",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          "${booking.date} at ${booking.time}",
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 20),
        onTap: () {
          // Navigate to lesson/booking details
          Get.to(() => StudentBookingDetails(booking: booking));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Lessons"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final lessons = bookingController.bookings; // use lessons list here

          if (lessons.isEmpty) {
            return const Center(
              child: Text(
                "No lessons available",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              return _buildLessonCard(lessons[index]);
            },
          );
        }),
      ),
    );
  }
}
