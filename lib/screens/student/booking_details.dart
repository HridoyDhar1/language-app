import 'package:flutter/material.dart';
import 'package:languageapp/models/booking_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7FAFF),
      appBar: AppBar(
        title: Center(child: const Text("Booking Details")),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            color: Colors.white,
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔹 Teacher Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurpleAccent,
                    child: Text(
                      booking.teacherName.substring(0, 1),
                      style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Teacher Name
                  Text(
                    booking.teacherName,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                  const SizedBox(height: 8),

                  // 🔹 Language
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.language, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        booking.language,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 🔹 Date & Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        booking.date,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.access_time, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        booking.time,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 🔹 Price
                  Text(
                    "\$${booking.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 24),

                  // 🔹 Action Buttons (Video / Audio / Back)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                        
                        },
                        icon: const Icon(Icons.videocam, color: Colors.white),
                        label: const Text("Video",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
            
                        },
                        icon: const Icon(Icons.call, color: Colors.white),
                        label: const Text("Call",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Back Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
