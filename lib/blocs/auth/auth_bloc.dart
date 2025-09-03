import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginUser>((event, emit) async {
      emit(AuthLoading());

      try {
        // Sign in with Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: event.email, password: event.password);

        // Check user role in Firestore
        final roleCollection =
            event.role == "Teacher" ? "teachers" : "students";

        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection(roleCollection)
            .doc(userCredential.user!.uid)
            .get();

        if (doc.exists) {
          emit(AuthSuccess(role: event.role));
        } else {
          emit(AuthFailure(message: "Role mismatch or user not found"));
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthFailure(message: e.message ?? "Login failed"));
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });
  }
}
