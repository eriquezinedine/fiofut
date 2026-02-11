/// Definicion de rutas de la aplicacion
abstract class AppRoutes {
  // Onboarding
  static const String onboarding = '/onboarding';

  // Auth
  static const String login = '/login';
  static const String loginGoogle = '/login-google';
  static const String register = '/register';
  static const String completeProfile = '/complete-profile';

  // Main
  static const String home = '/';
  static const String hydration = '/hydration';
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  // Profile
  static const String profile = '/profile';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String settings = '/settings';

  // Admin
  static const String admin = '/admin';
  static const String adminExercises = '/admin/exercises';
  static const String adminExerciseNew = '/admin/exercises/new';
  static const String adminExerciseEdit = '/admin/exercises/:id';
  static const String adminMeals = '/admin/meals';
  static const String adminMealNew = '/admin/meals/new';
  static const String adminMealEdit = '/admin/meals/:id';

  // Admin - Food
  static const String adminFoods = '/admin/food';
  static const String adminFoodNew = '/admin/food/new';
  static const String adminFoodEdit = '/admin/food/:id';

  // Admin - Ingredients
  static const String adminIngredients = '/admin/ingredients';
  static const String adminIngredientNew = '/admin/ingredients/new';
  static const String adminIngredientEdit = '/admin/ingredients/:id';

  // Trainer (placeholder)
  static const String trainer = '/trainer';
}
