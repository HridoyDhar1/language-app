
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:languageapp/blocs/schedule/schedule_bloc.dart';
import 'package:languageapp/blocs/schedule/schedule_event.dart';
import 'package:languageapp/blocs/schedule/schedule_state.dart';
import 'package:languageapp/feature/booking/presentation/controller/booking_controller.dart';
import 'package:languageapp/feature/booking/presentation/widgets/booking_list.dart';

import '../../../../../blocs/language/language_bloc.dart';
import '../../../../../blocs/language/language_event.dart';
import '../../widgets/language_selection_screen.dart';
class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final BookingController bookingController = Get.put(BookingController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    // Trigger Bloc to load schedules
    context.read<ScheduleBloc>().add(LoadSchedules());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffF7FAFF),
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
                      color: Colors.black,
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
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        context.read<LanguageBloc>().add(LoadLanguages());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LanguageSelectionScreen()),
                        );
                      },
                      icon: const Icon(Icons.language, color: Colors.white),
                      label: const Text(
                        "Select Language",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "My Bookings",
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  MyBookingList(bookingController: bookingController),
                  const SizedBox(height: 30),
                  const Text(
                    "Schedules",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: BlocBuilder<ScheduleBloc, ScheduleState>(
                      builder: (context, state) {
                        if (state is ScheduleLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is ScheduleLoaded) {
                          if (state.schedules.isEmpty) {
                            return const Center(
                              child: Text(
                                "No upcoming schedules yet",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: state.schedules.length,
                            itemBuilder: (context, index) {
                              final data =
                                  state.schedules[index].data() as Map<String, dynamic>;

                              final name = data['name'] ?? "No Name";
                              final description = data['description'] ?? "";
                              final price = data['price']?.toString() ?? "0";
                              final location = data['location'] ?? "N/A";

                              final date =
                                  (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

                              final timeData = data['time'];
                              TimeOfDay time;
                              if (timeData is Map<String, dynamic>) {
                                time = TimeOfDay(
                                  hour: timeData['hour'] ?? 0,
                                  minute: timeData['minute'] ?? 0,
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
                        } else if (state is ScheduleError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox.shrink();
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
