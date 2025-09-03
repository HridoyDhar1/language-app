
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:languageapp/models/booking_controller.dart';
import 'package:languageapp/models/booking_model.dart';
import 'package:languageapp/models/teacher_model.dart';
import 'package:languageapp/screens/student/home_screen.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Teacher teacher;
  const BookingScreen({super.key, required this.teacher});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  final Map<String, List<String>> availableSlots = const {
    "Monday": ["10:00 AM", "12:00 PM", "2:00 PM"],
    "Tuesday": ["11:00 AM", "1:00 PM", "3:00 PM"],
    "Wednesday": ["10:00 AM", "12:00 PM", "4:00 PM"],
    "Thursday": ["9:00 AM", "11:00 AM", "1:00 PM"],
    "Friday": ["10:00 AM", "2:00 PM", "3:00 PM"],
  };

  final BookingController bookingController = Get.put(BookingController());

  DateTime selectedDate = DateTime.now();
  String? selectedTime;

  late AnimationController _cardAnimationController;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _cardFadeAnimation;

  late AnimationController _dateAnimationController;
  late Animation<Offset> _dateSlideAnimation;
  late Animation<double> _dateFadeAnimation;

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
      CurvedAnimation(
          parent: _cardAnimationController, curve: Curves.easeOutBack),
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
            begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _dateAnimationController, curve: Curves.easeOut));
    _dateFadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_dateAnimationController);

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
          child:
              Text("Book Teacher", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Animated Teacher Card
            ScaleTransition(
              scale: _cardScaleAnimation,
              child: FadeTransition(
                opacity: _cardFadeAnimation,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(teacher.image),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(teacher.name,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(teacher.language,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 16)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔹 Animated Date Selector
            SlideTransition(
              position: _dateSlideAnimation,
              child: FadeTransition(
                opacity: _dateFadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Select Date",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          DateTime date =
                              DateTime.now().add(Duration(days: index));
                          bool isSelected = selectedDate.day == date.day &&
                              selectedDate.month == date.month;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = date;
                                selectedTime = null;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(14),
                              width: 70,
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [Colors.indigo, Colors.blueAccent],
                                      )
                                    : null,
                                color: isSelected ? null : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                            color: Colors.blueAccent
                                                .withOpacity(0.5),
                                            blurRadius: 8)
                                      ]
                                    : [],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${date.day}",
                                      style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                                          [date.weekday - 1],
                                      style: TextStyle(
                                          color: isSelected
                                              ? Colors.white70
                                              : Colors.black54)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🔹 Slots
            const Text("Available Slots",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            slots.isEmpty
                ? const Text("No slots available",
                    style: TextStyle(color: Colors.grey))
                : Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(slots.length, (index) {
                      final time = slots[index];
                      final bool isSelected = selectedTime == time;
                      return FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _slotAnimationController,
                          curve: Interval(0.1 * index, 0.6 + 0.1 * index,
                              curve: Curves.easeIn),
                        ),
                        child: ScaleTransition(
                          scale: CurvedAnimation(
                            parent: _slotAnimationController,
                            curve: Interval(0.1 * index, 0.6 + 0.1 * index,
                                curve: Curves.easeOutBack),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTime = time;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [Colors.indigo, Colors.blueAccent])
                                    : null,
                                color: isSelected ? null : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                            color: Colors.blueAccent
                                                .withOpacity(0.4),
                                            blurRadius: 6)
                                      ]
                                    : [],
                              ),
                              child: Text(time,
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

            const SizedBox(height: 40),

            // 🔹 Confirm Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.indigo,
                ),
                onPressed: selectedTime == null
                    ? null
                    : () async {
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

                        if (paymentResult == true) {
                          final booking = Booking(
                            teacherName: teacher.name,
                            language: teacher.language,
                            date: day,
                            time: selectedTime!,
                            price: 20.0,
                          );

                          bookingController.addBooking(booking);

                          try {
                            await FirebaseFirestore.instance
                                .collection('bookings')
                                .add({
                              'teacherName': booking.teacherName,
                              'language': booking.language,
                              'date': booking.date,
                              'time': booking.time,
                              'price': booking.price,
                              'createdAt': Timestamp.now(),
                            });

                            await FirebaseFirestore.instance
                                .collection('payments')
                                .add({
                              'teacherName': booking.teacherName,
                              'amount': booking.price,
                              'date': Timestamp.now(),
                              'status': 'Paid',
                            });

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AlertDialog(
                                title: const Text("Booking Confirmed"),
                                content: Text(
                                    "You booked ${teacher.name} on $day at $selectedTime"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const StudentHomeScreen()),
                                      );
                                    },
                                    child: const Text("OK"),
                                  )
                                ],
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Failed to save booking: $e")),
                            );
                          }
                        }
                      },
                child: const Text("Confirm Booking",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
