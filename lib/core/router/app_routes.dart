/// Definicion de rutas de la aplicacion
abstract class AppRoutes {
  // Onboarding
  static const String onboarding = '/onboarding';

  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Main
  static const String home = '/';
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  // Profile
  static const String profile = '/profile';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String settings = '/settings';
}
