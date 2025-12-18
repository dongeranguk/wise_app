import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wise_app/features/auth/application/auth_service.dart';
import 'package:wise_app/features/auth/domain/auth_state.dart';
import 'package:wise_app/features/auth/presentation/home_page.dart';
import 'package:wise_app/features/auth/presentation/login_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authState.asData?.value is Authenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoggingIn) {
        return '/login'; // 로그인 안됐으면 로그인 페이지로
      }
      if (isAuthenticated && isLoggingIn) {
        return '/home'; // 로그인 됐는데 로그인 페이지에 있으면 홈으로
      }
      return null; // 그 외에는 리디렉션 없음
    },
  );
});
