import 'package:supabase_flutter/supabase_flutter.dart';

sealed class AuthState {
  const AuthState();

  factory AuthState.unauthenticated() = Unauthenticated;
  factory AuthState.authenticated(User user) = Authenticated;
}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}
