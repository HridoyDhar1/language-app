import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:languageapp/blocs/booking/%20booking_state.dart';
import '../../blocs/booking/booking_bloc.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state.bookedSlots.isEmpty) {
            return const Center(child: Text('No bookings yet'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: state.bookedSlots.entries.map((entry) {
              return Card(
                child: ListTile(
                  title: Text(entry.key),
                  subtitle: Text('Time: ${entry.value}'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
