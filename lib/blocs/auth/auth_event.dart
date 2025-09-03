import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String userType;
  LoginEvent(this.userType);
}

class LogoutEvent extends AuthEvent {}
