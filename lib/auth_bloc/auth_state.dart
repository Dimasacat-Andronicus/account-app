class AuthBlocState {
  final bool isLoggedIn;
  final String? username;

  AuthBlocState({required this.isLoggedIn, this.username});

  factory AuthBlocState.initial() {
    return AuthBlocState(isLoggedIn: false);
  }
}
