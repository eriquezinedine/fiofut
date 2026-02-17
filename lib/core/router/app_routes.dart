/// Definicion de rutas de la aplicacion
///
/// NOTA: Las rutas principales ahora están definidas como constantes
/// estáticas en cada página/screen respectiva. Este archivo mantiene
/// solo las rutas que no tienen una página específica asociada.
abstract class AppRoutes {
  // Placeholder routes (no tienen página específica aún)
  static const String products = '/products';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String profile = '/profile';
  static const String orders = '/orders';
  static const String settings = '/settings';
  static const String trainer = '/trainer';

  // Admin routes (sin página específica)
  static const String adminMeals = '/admin/meals';
  static const String adminMealNew = '/admin/meals/new';
  static const String adminMealEdit = '/admin/meals/:id';
}
