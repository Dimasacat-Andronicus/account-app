import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../auth_bloc/auth_login_view.dart';
import '../auth_bloc/auth_register_view.dart';
import '../home_bloc/view/home_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static GoRouter getRouter(bool isLoggedIn, String username) {
    return GoRouter(
      initialLocation: isLoggedIn ? home : login,
      routes: [
        GoRoute(path: login, builder: (context, state) => const LoginPage()),
        GoRoute(
          path: register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) {
            final username =
                state.extra as String? ??
                Hive.box('authBox').get('username', defaultValue: '');
            return HomePage(username: username);
          },
        ),
      ],
    );
  }
}
