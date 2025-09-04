import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:languageapp/feature/student/presentation/widgets/animated_date_selector.dart';
import 'package:languageapp/feature/student/presentation/widgets/animated_slote_grid.dart';
import 'package:languageapp/feature/student/presentation/widgets/animated_teacher_card.dart';
import 'package:languageapp/feature/booking/presentation/controller/booking_controller.dart';
import 'package:languageapp/feature/booking/data/models/booking_model.dart';
import 'package:languageapp/feature/teacher/data/models/teacher_model.dart';
import 'package:languageapp/feature/student/presentation/screens/student/home_screen.dart';
import 'package:languageapp/feature/student/presentation/screens/student/pay_screen.dart';




class BookingScreen extends StatefulWidget {
  final Teacher teacher;
  const BookingScreen({super.key, required this.teacher});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with TickerProviderStateMixin {
  final Map<String, List<String>> availableSlots = const {
    "Monday": ["10:00 AM", "12:00 PM", "2:00 PM"],
    "Tuesday": ["11:00 AM", "1:00 PM", "3:00 PM"],
    "Wednesday": ["10:00 AM", "12:00 PM", "4:00 PM"],
    "Thursday": ["9:00 AM", "11:00 AM", "1:00 PM"],
    "Friday": ["10:00 AM", "2:00 PM", "3:00 PM"],
  };

  final BookingController bookingController = Get.find<BookingController>();
  DateTime selectedDate = DateTime.now();
  String? selectedTime;

  late AnimationController _cardAnimationController;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _cardFadeAnimation;

  late AnimationController _dateAnimationController;
  late Animation<Offset> _dateSlideAnimation;
  late Animation<double> _dateFadeAnimation;
  final currentUser = FirebaseAuth.instance.currentUser;
  late AnimationController _slotAnimationController;

  @override
  void initState() {
    super.initState();

    // 🔹 Teacher Card Animation
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _cardScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeOutBack),
    );
    _cardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeIn),
    );

    // 🔹 Date Selector Animation
    _dateAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _dateSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _dateAnimationController, curve: Curves.easeOut));
    _dateFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_dateAnimationController);

    // 🔹 Slots Animation
    _slotAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Start animations sequentially
    _cardAnimationController.forward().then((_) {
      _dateAnimationController.forward().then((_) {
        _slotAnimationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _dateAnimationController.dispose();
    _slotAnimationController.dispose();
    super.dispose();
  }

  /// 🔹 Extracted Confirm Booking Logic
  Future<void> _handleConfirmBooking(String day) async {
    final teacher = widget.teacher;

    final paymentResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          teacherName: teacher.name,
          day: day,
          time: selectedTime!,
          amount: teacher.price,
        ),
      ),
    );

    if (paymentResult == true&&currentUser!=null) {
      final booking = Booking(
        teacherId: teacher.id,
        teacherName: teacher.name,
        language: teacher.language,
        date: day,
        time: selectedTime!,
        price: teacher.price,
        meetingId: '',
        meetingLink: '',
      );

      try {
        await bookingController.addBooking(booking);

        await FirebaseFirestore.instance.collection('payments').add({
          'teacherName': booking.teacherName,
          'amount': booking.price,
          'date': Timestamp.now(),
          'status': 'Paid',

        });final currentUser = FirebaseAuth.instance.currentUser;
          await FirebaseFirestore.instance.collection('notifications').add({
    'title': 'Booking Confirmed',
    'message': 'You booked ${teacher.name} on $day at $selectedTime',
    'timestamp': Timestamp.now(),
            'userId': currentUser!.uid,
  });

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Booking Confirmed"),
            content: Text("You booked ${teacher.name} on $day at $selectedTime"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentHomeScreen(),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save booking: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final teacher = widget.teacher;

    final String day = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ][selectedDate.weekday - 1];

    final List<String> slots = availableSlots[day] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xffF7FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text("Book Teacher", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Animated Teacher Card
            AnimatedTeacherCard(
              scale: _cardScaleAnimation,
              fade: _cardFadeAnimation,
              teacher: teacher,
            ),
            const SizedBox(height: 25),

            /// 🔹 Animated Date Selector
            AnimatedDateSelector(
              slide: _dateSlideAnimation,
              fade: _dateFadeAnimation,
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                  selectedTime = null;
                });
              },
            ),
            const SizedBox(height: 25),

            /// 🔹 Animated Slots
            const Text(
              "Available Slots",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            AnimatedSlotsGrid(
              controller: _slotAnimationController,
              slots: slots,
              selectedTime: selectedTime,
              onSlotSelected: (time) {
                setState(() => selectedTime = time);
              },
            ),
            const SizedBox(height: 40),

            /// 🔹 Confirm Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.indigo,
                ),
                onPressed: selectedTime == null ? null : () => _handleConfirmBooking(day),
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
