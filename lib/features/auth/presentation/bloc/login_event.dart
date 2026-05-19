// login_event.dart

part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({
    required this.email,
    required this.password,
  });
}

class SignupButtonPressed extends LoginEvent {
  final String name;
  final String email;
  final String password;

  SignupButtonPressed({
    required this.name,
    required this.email,
    required this.password,
  });
}