import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String role;
  AuthSuccess({required this.role});

  @override
  List<Object?> get props => [role];
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
