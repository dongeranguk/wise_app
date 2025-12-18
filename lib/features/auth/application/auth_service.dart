import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:wise_app/features/auth/data/auth_repository.dart';
import 'package:wise_app/features/auth/domain/auth_state.dart';

final authServiceProvider = AsyncNotifierProvider<AuthService, AuthState>(
  AuthService.new,
);

class AuthService extends AsyncNotifier<AuthState> {
  late final AuthRepository _authRepository;

  @override
  FutureOr<AuthState> build() {
    _authRepository = ref.watch(authRepositoryProvider);

    // Supabase 인증 상태 스트림을 구독합니다.
    final authSubscription = _authRepository.authStateChanges().listen((user) {
      state = AsyncData(
        user != null
            ? AuthState.authenticated(user)
            : AuthState.unauthenticated(),
      );
    });

    // Notifier가 폐기될 때 스트림 구독을 취소합니다.
    ref.onDispose(() => authSubscription.cancel());

    final currentUser = _authRepository.currentUser;
    return currentUser != null
        ? AuthState.authenticated(currentUser)
        : AuthState.unauthenticated();
  }

  Future<void> signUp(String email, String password) async {
    await _authRepository.signUp(email, password);
  }

  Future<void> signIn(String email, String password) async {
    await _authRepository.signIn(email, password);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
