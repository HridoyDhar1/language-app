import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginUser extends AuthEvent {
  final String email;
  final String password;
  final String role; // "Student" or "Teacher"

  LoginUser({required this.email, required this.password, required this.role});

  @override
  List<Object?> get props => [email, password, role];
}
