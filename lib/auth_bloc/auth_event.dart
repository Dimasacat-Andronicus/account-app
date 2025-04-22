import 'package:flutter/cupertino.dart';

abstract class AuthBlocEvent {}

class LoginEvent extends AuthBlocEvent {
  final String username;
  final String password;

  LoginEvent(this.username, this.password);
}

class RegisterEvent extends AuthBlocEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final String email;
  final BuildContext context;

  RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.email,
    required this.context,
  });
}