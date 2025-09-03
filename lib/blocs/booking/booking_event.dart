abstract class BookingEvent {}

class SelectSlotEvent extends BookingEvent {
  final String teacherName;
  final String slot;

  SelectSlotEvent({required this.teacherName, required this.slot});
}
