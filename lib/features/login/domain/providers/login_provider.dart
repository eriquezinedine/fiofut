import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_state.dart';

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email, errorMessage: null);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password, errorMessage: null);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  Future<bool> login() async {
    if (!state.isValid) {
      state = state.copyWith(
        errorMessage: 'Por favor, completa todos los campos correctamente',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simular llamada al API
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implementar autenticación real aquí
      // Ejemplo: await authRepository.login(state.email, state.password);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al iniciar sesión. Intenta de nuevo.',
      );
      return false;
    }
  }

  void reset() {
    state = const LoginState();
  }
}
