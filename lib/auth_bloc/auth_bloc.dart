import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  AuthBloc() : super(AuthBlocState.initial()) {
    on<LoginEvent>((event, emit) async {
      final box = Hive.box('authBox');
      final accounts = box.get(
        'accounts',
        defaultValue: <Map<String, String>>[],
      );

      final user = accounts.firstWhere(
        (account) =>
            account['username'] == event.username &&
            account['password'] == event.password,
        orElse: () => <String, String>{},
      );

      if (user.isNotEmpty) {
        await box.put('isLoggedIn', true);
        await box.put('username', event.username);
        emit(AuthBlocState(isLoggedIn: true, username: event.username));
      } else {
        emit(AuthBlocState(isLoggedIn: false));
      }
    });

    on<RegisterEvent>((event, emit) async {
      final box = Hive.box('authBox');
      final accounts = box.get(
        'accounts',
        defaultValue: <Map<String, String>>[],
      );

      final usernameExists = accounts.any(
        (account) => account['username'] == event.username,
      );
      if (usernameExists) {
        emit(AuthBlocState(isLoggedIn: false));
        showDialog(
          context: event.context,
          builder:
              (context) => AlertDialog(
                title: Text('Registration Failed'),
                content: Text(
                  'Username already exists. Please try a different one.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
        return;
      }

      accounts.add({
        'firstName': event.firstName,
        'lastName': event.lastName,
        'username': event.username,
        'password': event.password,
        'email': event.email,
      });

      await box.put('accounts', accounts);

      emit(AuthBlocState(isLoggedIn: false));

      if (event.context.mounted) {
        showDialog(
          context: event.context,
          builder:
              (context) => AlertDialog(
                title: Text('Registration Successful'),
                content: Text('Your account has been created successfully.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(event.context);
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    });
  }
}
