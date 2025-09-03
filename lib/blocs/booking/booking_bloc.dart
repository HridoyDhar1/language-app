import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:languageapp/blocs/booking/%20booking_state.dart';
import 'booking_event.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingState(bookedSlots: {})) {
    on<SelectSlotEvent>((event, emit) {
      final updatedSlots = Map<String, String>.from(state.bookedSlots);
      updatedSlots[event.teacherName] = event.slot;
      emit(state.copyWith(bookedSlots: updatedSlots));
    });
  }
}
