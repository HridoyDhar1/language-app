// abstract class BookingEvent {}

// class SelectSlotEvent extends BookingEvent {
//   final String teacherName;
//   final String slot;

//   SelectSlotEvent({required this.teacherName, required this.slot});
// }
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class SelectDateEvent extends BookingEvent {
  final DateTime date;
  const SelectDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class SelectTimeEvent extends BookingEvent {
  final String time;
  const SelectTimeEvent(this.time);

  @override
  List<Object?> get props => [time];
}

class ConfirmBookingEvent extends BookingEvent {
  final String day;
  const ConfirmBookingEvent(this.day);

  @override
  List<Object?> get props => [day];
}
