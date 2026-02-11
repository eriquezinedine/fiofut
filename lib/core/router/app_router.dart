import 'package:app_ui/app_ui.dart';
import 'package:authentication/authentication.dart';
import 'package:fio_fut/apps/admin/features/admin_content/presentation/screens/admin_content_page.dart';
import 'package:fio_fut/apps/admin/features/exercises/presentation/screens/exercise_form_screen.dart';
import 'package:fio_fut/apps/admin/features/ingredients/presentation/screens/ingredient_form_screen.dart';
import 'package:fio_fut/apps/admin/features/meals/presentation/screens/food_form_screen.dart';
import 'package:fio_fut/apps/client/features/app_content/presentation/pages/app_content_page.dart';
import 'package:fio_fut/apps/client/features/complete_profile/complete_profile.dart';
import 'package:fio_fut/apps/client/features/home/presentation/screens/hydration_screen.dart';
import 'package:fio_fut/apps/client/features/login/login.dart';
import 'package:fio_fut/apps/client/features/login_google/login_google.dart';
import 'package:fio_fut/apps/client/features/register/register.dart';
import 'package:fio_fut/core/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_routes.dart';
import '../../apps/client/features/onboarding/onboarding.dart';

/// Auth routes that don't require authentication
const _publicRoutes = [
  AppRoutes.login,
  AppRoutes.loginGoogle,
  AppRoutes.register,
];

/// Provider del router
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.loginGoogle,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final currentPath = state.matchedLocation;
      final isPublicRoute = _publicRoutes.contains(currentPath);

      // If not logged in and trying to access a protected route, go to login
      if (!isLoggedIn && !isPublicRoute) {
        return AppRoutes.loginGoogle;
      }

      // If logged in and on a public route, redirect based on role
      if (isLoggedIn && isPublicRoute) {
        // Try provider first (fast path)
        var userProfile = ref.read(userProfileProvider).valueOrNull;

        // If provider hasn't loaded yet, query Supabase directly
        if (userProfile == null) {
          final userId = session.user.id;
          final data = await Supabase.instance.client
              .from('profiles')
              .select()
              .eq('id', userId)
              .maybeSingle();
          if (data != null) {
            userProfile = UserProfile.fromJson(data);
          }
        }

        if (userProfile != null) {
          if (!userProfile.isProfileComplete) {
            return AppRoutes.completeProfile;
          }
          return switch (userProfile.userType) {
            UserType.admin => AppRoutes.admin,
            UserType.trainer => AppRoutes.trainer,
            UserType.student => AppRoutes.home,
          };
        }
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingWizard(),
      ),

      // Complete Profile (WhatsApp)
      GoRoute(
        path: AppRoutes.completeProfile,
        name: 'completeProfile',
        builder: (context, state) => const CompleteProfileScreen(),
      ),

      // Client Home
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const AppContentPage(),
      ),

      // Hydration
      GoRoute(
        path: AppRoutes.hydration,
        name: 'hydration',
        builder: (context, state) => const HydrationScreen(),
      ),

      // === ADMIN ROUTES ===
      GoRoute(
        path: AppRoutes.admin,
        name: 'admin',
        builder: (context, state) => const AdminContentPage(),
      ),
      GoRoute(
        path: AppRoutes.adminExerciseNew,
        name: 'adminExerciseNew',
        builder: (context, state) => const ExerciseFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminExerciseEdit,
        name: 'adminExerciseEdit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ExerciseFormScreen(exerciseId: id);
        },
      ),
      // Food routes
      GoRoute(
        path: AppRoutes.adminFoodNew,
        name: 'adminFoodNew',
        builder: (context, state) => const FoodFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminFoodEdit,
        name: 'adminFoodEdit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return FoodFormScreen(foodId: id);
        },
      ),

      // Ingredient routes
      GoRoute(
        path: AppRoutes.adminIngredientNew,
        name: 'adminIngredientNew',
        builder: (context, state) => const IngredientFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminIngredientEdit,
        name: 'adminIngredientEdit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return IngredientFormScreen(ingredientId: id);
        },
      ),

      // Trainer (placeholder)
      GoRoute(
        path: AppRoutes.trainer,
        name: 'trainer',
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Trainer'),
      ),

      // Products
      GoRoute(
        path: AppRoutes.products,
        name: 'products',
        builder: (context, state) => const _PlaceholderScreen(title: 'Products'),
        routes: [
          GoRoute(
            path: ':id',
            name: 'productDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return _PlaceholderScreen(title: 'Product $id');
            },
          ),
        ],
      ),

      // Cart
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        builder: (context, state) => const _PlaceholderScreen(title: 'Cart'),
      ),

      // Checkout
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (context, state) => const _PlaceholderScreen(title: 'Checkout'),
      ),

      // Profile
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
      ),

      // Orders
      GoRoute(
        path: AppRoutes.orders,
        name: 'orders',
        builder: (context, state) => const _PlaceholderScreen(title: 'Orders'),
        routes: [
          GoRoute(
            path: ':id',
            name: 'orderDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return _PlaceholderScreen(title: 'Order $id');
            },
          ),
        ],
      ),

      // Settings
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const _PlaceholderScreen(title: 'Settings'),
      ),

      // Auth
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginGoogle,
        name: 'loginGoogle',
        builder: (context, state) => const LoginGoogleScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
});

/// Pantalla placeholder temporal
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          title,
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Center(
        child: Text(
          title,
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

/// Pantalla de error
class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Error',
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Pagina no encontrada',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            CustomGestureDetector(
              onTap: () => context.go(AppRoutes.home),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Text(
                  'Ir al inicio',
                  style: AppTextStyles.button.copyWith(color: AppColors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
