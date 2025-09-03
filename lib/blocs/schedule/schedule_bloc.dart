import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial()) {
    on<LoadSchedules>((event, emit) async {
      emit(ScheduleLoading());
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('schedules')
            .orderBy('date')
            .get();
        emit(ScheduleLoaded(schedules: snapshot.docs));
      } catch (e) {
        emit(ScheduleError(message: e.toString()));
      }
    });
  }
}
