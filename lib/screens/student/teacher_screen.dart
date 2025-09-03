// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../blocs/teacher/teacher_bloc.dart';
// import '../../blocs/teacher/teacher_event.dart';
// import '../../blocs/teacher/teacher_state.dart';
// import '../../widgets/teacher_card.dart';


// class TeacherScreen extends StatelessWidget {
//   final String selectedLanguage;
//   const TeacherScreen({super.key, required this.selectedLanguage});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => TeacherBloc()..add(LoadTeachers(language: selectedLanguage)),
//       child: Scaffold(
//         appBar: AppBar(title: Text('Teachers for $selectedLanguage')),
//         body: BlocBuilder<TeacherBloc, TeacherState>(
//           builder: (context, state) {
//             if (state is TeacherLoaded) {
//               return ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: state.teachers.length,
//                 itemBuilder: (context, index) {
//                   return TeacherCard(teacher: state.teachers[index], onTap: () {  },);
//                 },
//               );
//             }
//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }
