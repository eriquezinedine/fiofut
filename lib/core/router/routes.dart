import 'package:app_ui/app_ui.dart';
import 'package:authentication/authentication.dart';
import 'package:fio_fut/apps/admin/features/admin_content/presentation/screens/admin_content_page.dart';
import 'package:fio_fut/apps/admin/features/exercises/presentation/screens/exercise_form_screen.dart';
import 'package:fio_fut/apps/admin/features/ingredients/presentation/screens/ingredient_form_screen.dart';
import 'package:fio_fut/apps/admin/features/meals/presentation/screens/food_form_screen.dart';
import 'package:fio_fut/apps/client/features/app_content/presentation/pages/app_content_page.dart';
import 'package:fio_fut/apps/client/features/complete_profile/complete_profile.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/pages/exercise_detail_page.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/pages/workout_flow_page.dart';
import 'package:fio_fut/apps/client/features/exercise_home/presentation/pages/exercise_image_page.dart';
import 'package:fio_fut/apps/client/features/home/presentation/screens/hydration_screen.dart';
import 'package:fio_fut/apps/client/features/login/login.dart';
import 'package:fio_fut/apps/client/features/login_google/login_google.dart';
import 'package:fio_fut/apps/client/features/onboarding/presentation/screens/onboarding_wizard.dart';
import 'package:fio_fut/apps/client/features/register/register.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/screens/repose_screen.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/screens/repose_slider_screen.dart';
import 'package:fio_fut/apps/client/features/splash/presentation/screens/splash_screen.dart';
import 'package:fio_fut/apps/client/features/configuration_exercise/presentation/pages/configuration_exercise_screen.dart';
import 'package:fio_fut/apps/client/features/trainer_detail/presentation/screens/trainer_detail_page.dart';
import 'package:fio_fut/apps/client/features/training_exercise/presentation/screens/training_exercise_screen.dart';
import 'package:fio_fut/apps/trainer/trainer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

List<RouteBase> buildRoutes() => [
      // Splash
      GoRoute(
        path: SplashScreen.path,
        name: SplashScreen.name,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: OnboardingWizard.path,
        name: OnboardingWizard.name,
        builder: (context, state) {
          final initialStep = state.extra as int?;
          return OnboardingWizard(initialStep: initialStep);
        },
      ),

      // Complete Profile (WhatsApp)
      GoRoute(
        path: CompleteProfileScreen.path,
        name: CompleteProfileScreen.name,
        builder: (context, state) => const CompleteProfileScreen(),
      ),

      // Client Home
      GoRoute(
        path: AppContentPage.path,
        name: AppContentPage.name,
        builder: (context, state) => const AppContentPage(),
      ),

      // Hydration
      GoRoute(
        path: HydrationScreen.path,
        name: HydrationScreen.name,
        builder: (context, state) => const HydrationScreen(),
      ),

      // Trainer Detail
      GoRoute(
        path: TrainerDetailPage.path,
        name: TrainerDetailPage.name,
        builder: (context, state) {
          final trainer = state.extra as UserProfile;
          return TrainerDetailPage(trainer: trainer);
        },
      ),

      // Exercise Image
      GoRoute(
        path: ExerciseImagePage.path,
        name: ExerciseImagePage.name,
        builder: (context, state) {
          final exercise = state.extra as Exercise;
          return ExerciseImagePage(exercise: exercise);
        },
      ),

      // Exercise Detail (standalone)
      GoRoute(
        path: ExerciseDetailPage.path,
        name: ExerciseDetailPage.name,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final exercise = data['exercise'] as Exercise;
          final scheduleId = data['scheduleId'] as String;
          return ExerciseDetailPage(
            exercise: exercise,
            scheduleId: scheduleId,
          );
        },
      ),

      // Workout Flow (PageView with all exercises)
      GoRoute(
        path: WorkoutFlowPage.path,
        name: WorkoutFlowPage.name,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return WorkoutFlowPage(
            exercises:
                data['exercises'] as List<ExerciseScheduleItem>,
            initialIndex: data['initialIndex'] as int,
          );
        },
      ),

      // Configuration Exercise
      GoRoute(
        path: ConfigurationExerciseScreen.path,
        name: ConfigurationExerciseScreen.name,
        builder: (context, state) => const ConfigurationExerciseScreen(),
      ),

      // Repose
      GoRoute(
        path: ReposeScreen.path,
        name: ReposeScreen.name,
        builder: (context, state) => const ReposeScreen(),
      ),

      // Repose Slider
      GoRoute(
        path: ReposeSliderScreen.path,
        name: ReposeSliderScreen.name,
        builder: (context, state) => const ReposeSliderScreen(),
      ),

      // === ADMIN ROUTES ===
      GoRoute(
        path: AdminContentPage.path,
        name: AdminContentPage.name,
        builder: (context, state) => const AdminContentPage(),
      ),
      GoRoute(
        path: ExerciseFormScreen.pathNew,
        name: '${ExerciseFormScreen.name}-new',
        builder: (context, state) => const ExerciseFormScreen(),
      ),
      GoRoute(
        path: ExerciseFormScreen.pathEdit,
        name: '${ExerciseFormScreen.name}-edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ExerciseFormScreen(exerciseId: id);
        },
      ),
      GoRoute(
        path: FoodFormScreen.pathNew,
        name: '${FoodFormScreen.name}-new',
        builder: (context, state) => const FoodFormScreen(),
      ),
      GoRoute(
        path: FoodFormScreen.pathEdit,
        name: '${FoodFormScreen.name}-edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return FoodFormScreen(foodId: id);
        },
      ),
      GoRoute(
        path: IngredientFormScreen.pathNew,
        name: '${IngredientFormScreen.name}-new',
        builder: (context, state) => const IngredientFormScreen(),
      ),
      GoRoute(
        path: IngredientFormScreen.pathEdit,
        name: '${IngredientFormScreen.name}-edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return IngredientFormScreen(ingredientId: id);
        },
      ),

      // Trainer
      GoRoute(
        path: TrainerContentPage.path,
        name: TrainerContentPage.name,
        builder: (context, state) => const TrainerContentPage(),
      ),

      // Products
      GoRoute(
        path: AppRoutes.products,
        name: 'products',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Products'),
        routes: [
          GoRoute(
            path: ':id',
            name: 'product-detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PlaceholderScreen(title: 'Product $id');
            },
          ),
        ],
      ),

      // Cart
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Cart'),
      ),

      // Checkout
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Checkout'),
      ),

      // Profile
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Profile'),
      ),

      // Orders
      GoRoute(
        path: AppRoutes.orders,
        name: 'orders',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Orders'),
        routes: [
          GoRoute(
            path: ':id',
            name: 'order-detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PlaceholderScreen(title: 'Order $id');
            },
          ),
        ],
      ),

      // Settings
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Settings'),
      ),

      // Auth
      GoRoute(
        path: LoginScreen.path,
        name: LoginScreen.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: LoginGoogleScreen.path,
        name: LoginGoogleScreen.name,
        builder: (context, state) => const LoginGoogleScreen(),
      ),
      GoRoute(
        path: RegisterScreen.path,
        name: RegisterScreen.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: TrainingExerciseScreen.path,
        name: TrainingExerciseScreen.name,
        builder: (context, state) {
           final data = state.extra as Map<String, dynamic>;
          return TrainingExerciseScreen(
            exercises:
                data['exercises'] as List<ExerciseScheduleItem>,
            initialIndex: data['initialIndex'] as int,
          );

        },
      ),
    ];

/// Pantalla placeholder temporal
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

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
