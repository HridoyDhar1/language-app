import 'package:flutter/material.dart';

class AnimatedDateSelector extends StatelessWidget {
  final Animation<Offset> slide;
  final Animation<double> fade;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const AnimatedDateSelector({
    super.key,
    required this.slide,
    required this.fade,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slide,
      child: FadeTransition(
        opacity: fade,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  DateTime date = DateTime.now().add(Duration(days: index));
                  bool isSelected = selectedDate.day == date.day && selectedDate.month == date.month;
                  return GestureDetector(
                    onTap: () => onDateSelected(date),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(14),
                      width: 70,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(colors: [Colors.indigo, Colors.blueAccent])
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isSelected
                            ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.5), blurRadius: 8)]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${date.day}",
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1],
                            style: TextStyle(
                              color: isSelected ? Colors.white70 : Colors.black54,
                            ),
                          ),
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
    );
  }
}
