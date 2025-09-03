
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:languageapp/feature/booking/presentation/controller/booking_controller.dart';
import 'package:languageapp/feature/booking/data/models/booking_model.dart';
import 'package:languageapp/feature/schedule/presentation/widgets/mange_lesson.dart';
import 'package:languageapp/feature/schedule/presentation/widgets/mange_schudule.dart';
import 'package:languageapp/feature/teacher/presentation/controller/notification_controller.dart';
import 'package:languageapp/feature/teacher/presentation/screens/notification_screen.dart';
import 'package:languageapp/feature/teacher/presentation/widgets/student_booking.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});
static const String name='/teacher_dashboard'
;  @override
  State<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen>
    with SingleTickerProviderStateMixin {
  final BookingController bookingController = Get.find<BookingController>();
final notificationController = Get.find<NotificationController>();

  late final AnimationController _controller;
  final Map<int, double> cardScale = {}; // for top action cards
  final Map<int, double> bookingScale = {}; // for bookings

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Top Action Card with tap animation
  Widget _buildActionCard({
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
  required int index,
  int? badgeCount,
}) {
  cardScale.putIfAbsent(index, () => 1.0);

  final animation = CurvedAnimation(
    parent: _controller,
    curve: Interval(0.2 * index, 1.0, curve: Curves.easeOut),
  );

  return Expanded(
    child: FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(animation),
        child: GestureDetector(
          onTapDown: (_) => setState(() => cardScale[index] = 0.95),
          onTapUp: (_) {
            setState(() => cardScale[index] = 1.0);
            onTap();
          },
          onTapCancel: () => setState(() => cardScale[index] = 1.0),
          child: AnimatedScale(
            scale: cardScale[index]!,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 36, color: Colors.white),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // 🔹 Badge
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "$badgeCount",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  // Booking Card with tap animation
  Widget _buildBookingCard(Booking booking, int index) {
    bookingScale.putIfAbsent(index, () => 1.0);

    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2 * index, 1.0, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTapDown: (_) => setState(() => bookingScale[index] = 0.97),
            onTapUp: (_) => setState(() => bookingScale[index] = 1.0),
            onTapCancel: () => setState(() => bookingScale[index] = 1.0),
            child: AnimatedScale(
              scale: bookingScale[index]!,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
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

  void _navigateToDetails(Booking booking) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            StudentBookingDetails(booking: booking),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween =
              Tween(begin: const Offset(0, 0.2), end: Offset.zero).chain(
                  CurveTween(curve: Curves.easeOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(
        title: const Center(child: Text("Dashboard")),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text
            FadeTransition(
              opacity: CurvedAnimation(
                  parent: _controller, curve: const Interval(0.0, 0.3)),
              child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0, -0.3), end: Offset.zero)
                    .animate(CurvedAnimation(
                        parent: _controller, curve: const Interval(0.0, 0.3))),
                child: const Text(
                  "Welcome, Teacher!",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Top Action Cards
            Row(
              children: [
                _buildActionCard(
                    title: "Manage Lessons",
                    icon: Icons.menu_book,
                    color: Colors.indigo,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ManageLessonsScreen()));
                    },
                    index: 0),
                _buildActionCard(
                    title: "Schedules",
                    icon: Icons.schedule,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ManageSchedulesScreen()));
                    },
                    index: 1),
               Obx(() => _buildActionCard(
          title: "Notifications",
          icon: Icons.notifications,
          color: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationScreen()),
            );
            // reset badge when opened
            notificationController.clearNotifications();
          },
          index: 2,
          badgeCount: notificationController.unreadCount.value,
        )),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "Your Bookings",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // Booking List
            Expanded(
              child: Obx(() {
                final bookings = bookingController.bookings;

                if (bookings.isEmpty) {
                  return Center(
                    child: FadeTransition(
                      opacity:
                          CurvedAnimation(parent: _controller, curve: Curves.easeIn),
                      child: const Text(
                        "No bookings yet",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
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
              }),
            ),
          ],
        ),
      ),
    );
  }
}
