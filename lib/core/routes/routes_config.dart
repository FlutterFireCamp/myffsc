import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/announcements/announcements.dart';
import '../../features/auth/auth.dart';
import '../../features/dashboard/dashboard.dart';
import '../../features/forms/forms.dart';
import '../../features/podium/podium.dart';
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
    initialLocation: RoutePaths.checking,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;

      final isChecking = location == RoutePaths.checking;
      final isLoggingIn = location == RoutePaths.login;
      final isUnauthorized = location == RoutePaths.unauthorized;
      final isCompletingProfile = location == RoutePaths.completeProfile;

      dev.log(
        'GoRouter evaluating redirect -> Path: $location, AuthState: ${authState.runtimeType}',
        name: 'ROUTER',
      );

      if (authState is AuthInitialState) {
        if (!isChecking) {
          dev.log('Displaying access checking page for initial state', name: 'ROUTER');
          return RoutePaths.checking;
        }
        return null;
      }

      if (authState is AuthLoadingState) {
        if (isChecking || isLoggingIn) {
          return null;
        }
        // Do not kick user out to /checking if they are already inside the app
        return null;
      }

      if (authState is UnauthenticatedState || authState is AuthErrorState) {
        if (!isLoggingIn) {
          dev.log('Redirecting unauthenticated user to ${RoutePaths.login}', name: 'ROUTER');
          return RoutePaths.login;
        }
        return null;
      }

      if (authState is ProfileIncompleteState) {
        if (!isCompletingProfile) {
          dev.log('Redirecting user with incomplete profile to ${RoutePaths.completeProfile}', name: 'ROUTER');
          return RoutePaths.completeProfile;
        }
        return null;
      }

      if (authState is UnauthorizedState) {
        if (!isUnauthorized) {
          dev.log('Redirecting unauthorized user to ${RoutePaths.unauthorized}', name: 'ROUTER');
          return RoutePaths.unauthorized;
        }
        return null;
      }

      if (authState is AuthenticatedState) {
        if (isLoggingIn || isUnauthorized || isChecking || isCompletingProfile || location == '/') {
          dev.log('Redirecting authenticated user to ${RoutePaths.dashboard}', name: 'ROUTER');
          return RoutePaths.dashboard;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        name: RouteNames.checking,
        path: RoutePaths.checking,
        builder: (context, state) => const AccessCheckingPage(),
      ),
      GoRoute(
        name: RouteNames.login,
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: RouteNames.completeProfile,
        path: RoutePaths.completeProfile,
        builder: (context, state) {
          final user = authBloc.state is ProfileIncompleteState
              ? (authBloc.state as ProfileIncompleteState).user
              : null;
          return CompleteProfilePage(user: user);
        },
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
      GoRoute(
        name: RouteNames.forms,
        path: RoutePaths.forms,
        builder: (context, state) => const FormsPage(),
      ),
      GoRoute(
        name: RouteNames.editProfile,
        path: RoutePaths.editProfile,
        builder: (context, state) {
          final user = state.extra as UserEntity?;
          final currentUser = user ??
              (authBloc.state is AuthenticatedState
                  ? (authBloc.state as AuthenticatedState).user
                  : null);
          if (currentUser == null) {
            return const Scaffold(body: SizedBox.shrink());
          }
          return EditProfilePage(user: currentUser);
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
                name: RouteNames.tests,
                path: RoutePaths.tests,
                builder: (context, state) => const TestsPage(),
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
                name: RouteNames.podium,
                path: RoutePaths.podium,
                builder: (context, state) => const PodiumPage(),
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
