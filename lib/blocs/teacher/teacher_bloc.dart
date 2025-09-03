// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'teacher_event.dart';
// import 'teacher_state.dart';
// import '../../models/teacher_model.dart';

// class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
//   List<Teacher> teachers = [];

//   TeacherBloc() : super(TeacherInitial()) {
//     on<LoadTeachers>((event, emit) {
//       emit(TeacherLoading());
//       teachers = [
//         Teacher(name: "Alice Smith", language: event.language, image: "assets/image/istockphoto-1045886560-612x612.jpg", amount: 80),
//         Teacher(name: "Bob Johnson", language: event.language, image: "assets/image/istockphoto-1433427547-612x612.jpg", amount: 58),
//         Teacher(name: "Charlie Brown", language: event.language, image: "assets/image/photo-1633332755192-727a05c4013d.jpeg", amount: 34),
//       ];
//       emit(TeacherLoaded(teachers));
//     });

//     on<SelectTeacher>((event, emit) {
//       final teacher = teachers.firstWhere((t) => t.name == event.teacherName);
//       emit(TeacherSelected(teacher: teacher));
//     });

//     on<SelectDate>((event, emit) {
//       if (state is TeacherSelected) {
//         final current = state as TeacherSelected;
//         emit(TeacherSelected(
//           teacher: current.teacher,
//           selectedDate: event.date,
//           selectedTime: current.selectedTime,
//         ));
//       }
//     });

//     on<SelectTimeSlot>((event, emit) {
//       if (state is TeacherSelected) {
//         final current = state as TeacherSelected;
//         emit(TeacherSelected(
//           teacher: current.teacher,
//           selectedDate: current.selectedDate,
//           selectedTime: event.time,
//         ));
//       }
//     });
//   }
// }
