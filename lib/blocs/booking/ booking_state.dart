// class BookingState {
//   final Map<String, String> bookedSlots;

//   BookingState({required this.bookedSlots});

//   BookingState copyWith({Map<String, String>? bookedSlots}) {
//     return BookingState(bookedSlots: bookedSlots ?? this.bookedSlots);
//   }
// }
import 'package:equatable/equatable.dart';

class BookingState extends Equatable {
  final DateTime selectedDate;
  final String? selectedTime;
  final bool isBookingConfirmed;
  final bool isLoading;
  final String? error;

  const BookingState({
    required this.selectedDate,
    this.selectedTime,
    this.isBookingConfirmed = false,
    this.isLoading = false,
    this.error,
  });

  BookingState copyWith({
    DateTime? selectedDate,
    String? selectedTime,
    bool? isBookingConfirmed,
    bool? isLoading,
    String? error,
  }) {
    return BookingState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      isBookingConfirmed: isBookingConfirmed ?? this.isBookingConfirmed,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedDate, selectedTime, isBookingConfirmed, isLoading, error];
}
