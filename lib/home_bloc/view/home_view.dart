import 'package:auth_account/home_bloc/view/admin_home_view.dart';
import 'package:auth_account/home_bloc/view/user_home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../../widgets/dialog.dart';
import '../home_bloc.dart';
import '../home_event.dart';

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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return ConfirmationDialog(
                      title: 'Confirm Logout',
                      content: 'Are you sure you want to log out?',
                      onConfirm: () async {
                        final box = Hive.box('authBox');
                        await box.put('isLoggedIn', false);
                        await box.delete('username');
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                    );
                  },
                );
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
