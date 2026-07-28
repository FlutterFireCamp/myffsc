import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/announcements/announcements.dart';
import '../../features/auth/auth.dart';
import '../../features/dashboard/dashboard.dart';
import '../../features/forms/forms.dart';
import '../../features/profile/profile.dart';
import '../../features/programs/programs.dart';
import '../../features/shared/presentation/pages/main_navigation_scaffold.dart';
import '../../features/tests/tests.dart';
import 'route_names.dart';
import 'route_paths.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class RoutesConfig {
  final AuthBloc authBloc;

  RoutesConfig({required this.authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: RoutePaths.dashboard,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;

      final isLoggingIn = location == RoutePaths.login;
      final isUnauthorized = location == RoutePaths.unauthorized;

      if (authState is UnauthenticatedState || authState is AuthErrorState) {
        return isLoggingIn ? null : RoutePaths.login;
      }

      if (authState is UnauthorizedState) {
        return isUnauthorized ? null : RoutePaths.unauthorized;
      }

      if (authState is AuthenticatedState) {
        if (isLoggingIn || isUnauthorized || location == '/') {
          return RoutePaths.dashboard;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        name: RouteNames.login,
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: RouteNames.unauthorized,
        path: RoutePaths.unauthorized,
        builder: (context, state) {
          final user = authBloc.state is UnauthorizedState
              ? (authBloc.state as UnauthorizedState).user
              : null;
          return UnauthorizedPage(user: user);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.dashboard,
                path: RoutePaths.dashboard,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.programs,
                path: RoutePaths.programs,
                builder: (context, state) => const ProgramsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.announcements,
                path: RoutePaths.announcements,
                builder: (context, state) => const AnnouncementsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.forms,
                path: RoutePaths.forms,
                builder: (context, state) => const FormsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.tests,
                path: RoutePaths.tests,
                builder: (context, state) => const TestsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteNames.profile,
                path: RoutePaths.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
