import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wise_app/features/auth/auth_repository.dart';
import 'package:wise_app/features/auth/login_screen.dart';
import 'package:wise_app/utils/router_utils.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final authStateStream = authRepository.authStateChanges;

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authStateStream),
    redirect: (context, state) {
      final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) => Scaffold(appBar: AppBar(title: Text('홈'))),
      ),
    ],
  );
}
