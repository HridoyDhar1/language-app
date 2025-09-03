class BookingState {
  final Map<String, String> bookedSlots;

  BookingState({required this.bookedSlots});

  BookingState copyWith({Map<String, String>? bookedSlots}) {
    return BookingState(bookedSlots: bookedSlots ?? this.bookedSlots);
  }
}
