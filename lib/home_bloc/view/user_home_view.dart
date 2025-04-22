import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../home_bloc.dart';
import '../home_state.dart';

class UserHome extends StatelessWidget {
  final String username;

  const UserHome({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadedState) {
          final accounts = state.accounts;
          final firstName =
              accounts.firstWhere(
                (account) => account['username'] == username,
                orElse: () => {'firstName': 'Guest'},
              )['firstName'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $firstName!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Here is your personalized dashboard.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Expanded(
                  child: Center(
                    child: Lottie.asset(
                      'assets/animation/dashboard.json',
                      height: 400,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is HomeLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeErrorState) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
