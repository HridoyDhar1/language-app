// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:languageapp/blocs/booking/%20booking_state.dart';
// import 'booking_event.dart';

// class BookingBloc extends Bloc<BookingEvent, BookingState> {
//   BookingBloc() : super(BookingState(bookedSlots: {})) {
//     on<SelectSlotEvent>((event, emit) {
//       final updatedSlots = Map<String, String>.from(state.bookedSlots);
//       updatedSlots[event.teacherName] = event.slot;
//       emit(state.copyWith(bookedSlots: updatedSlots));
//     });
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:languageapp/blocs/booking/%20booking_state.dart';
import 'package:languageapp/feature/booking/data/models/booking_model.dart';
import 'package:languageapp/feature/booking/presentation/controller/booking_controller.dart';
import 'booking_event.dart';



class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingController bookingController;
  BookingBloc({required this.bookingController})
      : super(BookingState(selectedDate: DateTime.now())) {
    on<SelectDateEvent>((event, emit) {
      emit(state.copyWith(selectedDate: event.date, selectedTime: null));
    });

    on<SelectTimeEvent>((event, emit) {
      emit(state.copyWith(selectedTime: event.time));
    });

    on<ConfirmBookingEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));

      try {
        final day = event.day;
        final booking = Booking(
          teacherId: '', // You can pass teacherId via constructor
          teacherName: '', // Pass teacher name via constructor
          language: '',
          date: day,
          time: state.selectedTime!,
          price: 0,
          meetingId: '',
          meetingLink: '',
        );

        await bookingController.addBooking(booking);

        await FirebaseFirestore.instance.collection('payments').add({
          'teacherName': booking.teacherName,
          'amount': booking.price,
          'date': Timestamp.now(),
          'status': 'Paid',
        });

        await FirebaseFirestore.instance.collection('notifications').add({
          'title': 'Booking Confirmed',
          'message': 'You booked ${booking.teacherName} on $day at ${state.selectedTime}',
          'timestamp': Timestamp.now(),
        });

        emit(state.copyWith(isLoading: false, isBookingConfirmed: true));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}
