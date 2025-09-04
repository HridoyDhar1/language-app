import 'package:flutter/material.dart';
import 'package:languageapp/feature/booking/data/models/booking_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../student/presentation/screens/student/chat_screen.dart';

class StudentBookingDetails extends StatefulWidget {
  final Booking booking;

  const StudentBookingDetails({super.key, required this.booking});

  @override
  State<StudentBookingDetails> createState() => _StudentBookingDetailsState();
}

class _StudentBookingDetailsState extends State<StudentBookingDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  Future<void> _startVideoCall() async {
    final meetingLink = widget.booking.meetingLink;
    if (meetingLink.isNotEmpty) {
      final Uri url = Uri.parse(meetingLink);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch MeetHout video call')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting link not available yet')),
      );
    }
  }
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  void _callTeacher(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone dialer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final hasMeetingLink = widget.booking.meetingLink.isNotEmpty;
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                elevation: 8, // Material-like elevation
                shadowColor: Colors.indigo.withOpacity(0.3),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.indigoAccent,
                          child: Text(
                            booking.teacherName.substring(0, 1),
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          booking.teacherName,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          booking.language,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildDetailRow("Date", booking.date),
                      _buildDetailRow("Time", booking.time),
                      _buildDetailRow("Price", "\$${booking.price.toString()}"),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: hasMeetingLink ? _startVideoCall : null,
                            icon: const Icon(Icons.call),
                            label: const Text(
                              "Call",
                              style: TextStyle(fontSize: 16,color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    receiverId: widget.booking.teacherId,
                                    receiverName: widget.booking.teacherName,
                                    bookingId: widget.booking.teacherId,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Message",
                              style: TextStyle(fontSize: 16,color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
