import 'package:fio_fut/apps/client/features/login_google/login_google.dart';
import 'package:fio_fut/apps/client/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'route_error_screen.dart';
import 'routes.dart';

/// Routes that don't require authentication
const _publicRoutes = [
  SplashScreen.path,
  LoginGoogleScreen.path,
];

/// Provider del router
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: SplashScreen.path,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final currentPath = state.matchedLocation;
      final isPublicRoute = _publicRoutes.contains(currentPath);

      // Not logged in → only allow public routes
      if (!isLoggedIn && !isPublicRoute) {
        return LoginGoogleScreen.path;
      }

      return null;
    },
    routes: buildRoutes(),
    errorBuilder: (context, state) => RouteErrorScreen(error: state.error),
  );
});
