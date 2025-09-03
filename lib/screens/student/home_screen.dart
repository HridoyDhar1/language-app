// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:languageapp/models/booking_controller.dart';
//
// import 'package:languageapp/screens/student/widgets/booking_list.dart';
// import 'package:languageapp/screens/teacher/scheul_controller.dart';
// import '../../blocs/language/language_bloc.dart';
// import '../../blocs/language/language_event.dart';
// import 'language_selection_screen.dart';
// import 'dart:async';
//
// class StudentHomeScreen extends StatefulWidget {
//   const StudentHomeScreen({super.key});
//
//   @override
//   State<StudentHomeScreen> createState() => _StudentHomeScreenState();
// }
//
// class _StudentHomeScreenState extends State<StudentHomeScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Timer _timer;
//   int _gradientIndex = 0;
// final ScheduleController scheduleController = Get.find<ScheduleController>();
//
//   final List<List<Color>> gradientColors = [
//     [Colors.purple, Colors.deepPurpleAccent],
//     [Colors.blue, Colors.cyan],
//     [Colors.orange, Colors.deepOrangeAccent],
//     [Colors.pink, Colors.redAccent],
//   ];
//
//   final BookingController bookingController = Get.put(BookingController());
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Screen fade animation
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeIn),
//     );
//     _controller.forward();
//
//     // Gradient background timer
//     _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       setState(() {
//         _gradientIndex = (_gradientIndex + 1) % gradientColors.length;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: AnimatedContainer(
//         duration: const Duration(seconds: 5),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: gradientColors[_gradientIndex],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Welcome, Student!",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Center(
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 24, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30)),
//                         backgroundColor: Colors.white,
//                       ),
//                       onPressed: () {
//                         context.read<LanguageBloc>().add(LoadLanguages());
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) =>  LanguageSelectionScreen()),
//                         );
//                       },
//                       icon: const Icon(Icons.language, color: Colors.deepPurple),
//                       label: const Text(
//                         "Select Language",
//                         style:
//                             TextStyle(fontSize: 18, color: Colors.deepPurple),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   const Text(
//                     "My Bookings",
//                     style: TextStyle(
//                         fontSize: 22,
//                         color: Colors.white),
//                   ),
//                   const SizedBox(height: 10),
//                   MyBookingList(bookingController: bookingController),   const SizedBox(height: 30),
//                   const Text(
//                     "Schedules",
//                     style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white),
//                   ),
//                   Expanded(
//   child: Expanded(
//     child: StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('schedules')
//           .orderBy('date')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(color: Colors.white),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(
//             child: Text(
//               "No upcoming schedules yet",
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           );
//         }
//
//         final schedules = snapshot.data!.docs;
//
//         return ListView.builder(
//           itemCount: schedules.length,
//           itemBuilder: (context, index) {
//             final doc = schedules[index];
//             final data = doc.data() as Map<String, dynamic>;
//
//             final date = (data['date'] as Timestamp).toDate();
//             final timeData = data['time'];
//             final time = timeData != null
//                 ? TimeOfDay(
//               hour: timeData['hour'] ?? 0,
//               minute: timeData['minute'] ?? 0,
//             )
//                 : TimeOfDay(hour: 0, minute: 0);
//
//             return Card(
//               color: Colors.white,
//               margin: const EdgeInsets.symmetric(vertical: 6),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: ListTile(
//                 title: Text("${data['name']} - ${data['description']}"),
//                 subtitle: Text(
//                   "${DateFormat('yyyy-MM-dd').format(date)} at ${time.format(context)}\n${data['location']} | ${data['price']} BDT",
//                 ),
//               ),
//             );
//           },
//         );
//
//       },
//     ),
//   ),
//
//                   )
//
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:languageapp/models/booking_controller.dart';
import 'package:languageapp/screens/student/widgets/booking_list.dart';
import 'package:languageapp/screens/teacher/scheul_controller.dart';
import '../../blocs/language/language_bloc.dart';
import '../../blocs/language/language_event.dart';
import 'language_selection_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Timer _timer;
  int _gradientIndex = 0;

  final ScheduleController scheduleController = Get.find<ScheduleController>();
  final BookingController bookingController = Get.put(BookingController());

  final List<List<Color>> gradientColors = [
    [Colors.purple, Colors.deepPurpleAccent],
    [Colors.blue, Colors.cyan],
    [Colors.orange, Colors.deepOrangeAccent],
    [Colors.pink, Colors.redAccent],
  ];

  @override
  void initState() {
    super.initState();

    // Fade animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    // Gradient background timer
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _gradientIndex = (_gradientIndex + 1) % gradientColors.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors[_gradientIndex],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome, Student!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.read<LanguageBloc>().add(LoadLanguages());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LanguageSelectionScreen()),
                        );
                      },
                      icon: const Icon(Icons.language, color: Colors.deepPurple),
                      label: const Text(
                        "Select Language",
                        style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "My Bookings",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  MyBookingList(bookingController: bookingController),
                  const SizedBox(height: 30),
                  const Text(
                    "Schedules",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // StreamBuilder for schedules
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('schedules')
                          .orderBy('date')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              "No upcoming schedules yet",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          );
                        }

                        final schedules = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            final doc = schedules[index];
                            final data = doc.data() as Map<String, dynamic>;

                            // Safe null/type handling
                            final name = data['name'] as String? ?? "No Name";
                            final description =
                                data['description'] as String? ?? "";
                            final price = data['price']?.toString() ?? "0";
                            final location = data['location'] as String? ?? "N/A";

                            final date = (data['date'] as Timestamp?)?.toDate() ??
                                DateTime.now();

                            // Handle time as map or string
                            final timeData = data['time'];
                            TimeOfDay time;
                            if (timeData is Map<String, dynamic>) {
                              time = TimeOfDay(
                                hour: (timeData['hour'] is int)
                                    ? timeData['hour']
                                    : 0,
                                minute: (timeData['minute'] is int)
                                    ? timeData['minute']
                                    : 0,
                              );
                            } else if (timeData is String) {
                              final parts = timeData.split(":");
                              time = TimeOfDay(
                                hour: int.tryParse(parts[0]) ?? 0,
                                minute: int.tryParse(parts[1]) ?? 0,
                              );
                            } else {
                              time = const TimeOfDay(hour: 0, minute: 0);
                            }

                            return Card(
                              color: Colors.white,
                              margin:
                              const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                title: Text("$name - $description"),
                                subtitle: Text(
                                  "${DateFormat('yyyy-MM-dd').format(date)} at ${time.format(context)}\n$location | $price BDT",
                                ),
                              ),
                            );
                          },
                        );
                      },
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
}
