import 'package:auth_account/home_bloc/admin_home_view.dart';
import 'package:auth_account/home_bloc/user_home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'home_bloc.dart';
import 'home_event.dart';

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(FetchAccountsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final box = Hive.box('authBox');
                await box.put('isLoggedIn', false);
                await box.delete('username');

                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
        body:
            username == 'admin'
                ? const AdminHome()
                : UserHome(username: username),
      ),
    );
  }
}
