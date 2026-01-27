import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wise_app/features/auth/auth_repository.dart';
import 'package:wise_app/features/auth/login_screen.dart';
import 'package:wise_app/features/contacts/contacts_screen.dart';
import 'package:wise_app/features/profile/profile_edit_screen.dart';
import 'package:wise_app/features/profile/profile_screen.dart';
import 'package:wise_app/home_screen.dart';
import 'package:wise_app/utils/router_utils.dart';

part 'router.g.dart';

// 네비게이션 바 키
final _shellNavigatorKey = GlobalKey<NavigatorState>();

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

      // 공통 네비게이션 바를 사용하는 화면들
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // 홈 탭
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeContent(),
              ),
            ],
          ),
          // 연락처 탭
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/contacts',
                builder: (context, state) => const ContactsScreen(),
              ),
            ],
          ),
          // 프로필 탭
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) {
                  final userId = Supabase.instance.client.auth.currentUser!.id;
                  return ProfileContent(userId: userId);
                },
              ),
              GoRoute(
                path: '/profile/edit/:userId',
                builder: (context, state) {
                  final userId = state.pathParameters['userId']!;
                  return ProfileEditScreen(userId: userId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// 공통 Scaffold (네비게이션 바 포함)
class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '홈'),
          NavigationDestination(icon: Icon(Icons.contacts), label: '연락처'),
          NavigationDestination(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
    );
  }
}
