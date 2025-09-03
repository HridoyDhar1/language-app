// import 'package:equatable/equatable.dart';
// import '../../models/teacher_model.dart';

// abstract class TeacherState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// // Initial state
// class TeacherInitial extends TeacherState {}

// // Loading teachers
// class TeacherLoading extends TeacherState {}

// // Loaded teacher list
// class TeacherLoaded extends TeacherState {
//   final List<Teacher> teachers;
//   TeacherLoaded(this.teachers);
// }

// // Selected teacher
// class TeacherSelected extends TeacherState {
//   final Teacher teacher;
//   final DateTime? selectedDate;
//   final String? selectedTime;

//   TeacherSelected({required this.teacher, this.selectedDate, this.selectedTime});

//   @override
//   List<Object?> get props => [teacher, selectedDate ?? "", selectedTime ?? ""];
// }
