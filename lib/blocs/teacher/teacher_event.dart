import 'package:equatable/equatable.dart';

abstract class TeacherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTeachers extends TeacherEvent {
  final String language;
  LoadTeachers(this.language);
}

class SelectTeacher extends TeacherEvent {
  final String teacherName;
  SelectTeacher(this.teacherName);
}

class SelectDate extends TeacherEvent {
  final DateTime date;
  SelectDate(this.date);
}

class SelectTimeSlot extends TeacherEvent {
  final String time;
  SelectTimeSlot(this.time);
}
