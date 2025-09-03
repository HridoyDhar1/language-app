import 'package:flutter/material.dart';

class AnimatedSlotsGrid extends StatelessWidget {
  final AnimationController controller;
  final List<String> slots;
  final String? selectedTime;
  final Function(String) onSlotSelected;

  const AnimatedSlotsGrid({
    super.key,
    required this.controller,
    required this.slots,
    required this.selectedTime,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return slots.isEmpty
        ? const Text("No slots available", style: TextStyle(color: Colors.grey))
        : Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(slots.length, (index) {
              final time = slots[index];
              final bool isSelected = selectedTime == time;
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: controller,
                  curve: Interval(0.1 * index, 0.6 + 0.1 * index, curve: Curves.easeIn),
                ),
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: controller,
                    curve: Interval(0.1 * index, 0.6 + 0.1 * index, curve: Curves.easeOutBack),
                  ),
                  child: GestureDetector(
                    onTap: () => onSlotSelected(time),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(colors: [Colors.indigo, Colors.blueAccent])
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected
                            ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 6)]
                            : [],
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
  }
}
