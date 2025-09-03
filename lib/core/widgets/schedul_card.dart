import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final String time;
  final VoidCallback onTap;

  const ScheduleCard({super.key, required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(time, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.schedule),
        onTap: onTap,
      ),
    );
  }
}
