import 'package:auth_account/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthBlocState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 24),
                Lottie.asset('assets/animation/login.json', height: 200),
                const SizedBox(height: 24),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final username = usernameController.text.trim();
                    final password = passwordController.text.trim();

                    final box = Hive.box('authBox');
                    final accounts = box.get(
                      'accounts',
                      defaultValue: <Map<String, String>>[],
                    );

                    final isValid = accounts.any(
                      (account) =>
                          account['username'] == username &&
                          account['password'] == password,
                    );

                    if (username.isEmpty || password.isEmpty) {
                      ErrorSnackbar.showError(
                        context,
                        "Username and password cannot be empty",
                      );
                      return;
                    }

                    if (!isValid) {
                      ErrorSnackbar.showError(
                        context,
                        "Either the username or password is incorrect",
                      );
                      return;
                    }

                    context.read<AuthBloc>().add(
                      LoginEvent(username, password),
                    );

                    await box.put('isLoggedIn', true);
                    await box.put('username', username);

                    if (context.mounted) {
                      context.go('/home', extra: username);
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    context.go('/register');
                  },
                  child: const Text('Don\'t have an account? Register'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
