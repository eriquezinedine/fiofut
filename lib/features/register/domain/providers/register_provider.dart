import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'register_state.dart';

final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(
  RegisterNotifier.new,
);

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() {
    return const RegisterState();
  }

  void updateName(String name) {
    state = state.copyWith(name: name, errorMessage: null);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email, errorMessage: null);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password, errorMessage: null);
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword, errorMessage: null);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  void toggleAcceptedTerms() {
    state = state.copyWith(acceptedTerms: !state.acceptedTerms);
  }

  Future<bool> register() async {
    // Validaciones
    if (state.name.isEmpty) {
      state = state.copyWith(errorMessage: 'Ingresa tu nombre completo');
      return false;
    }

    if (state.email.isEmpty) {
      state = state.copyWith(errorMessage: 'Ingresa tu correo electronico');
      return false;
    }

    if (state.password.length < 6) {
      state = state.copyWith(
        errorMessage: 'La contrasena debe tener al menos 6 caracteres',
      );
      return false;
    }

    if (!state.passwordsMatch) {
      state = state.copyWith(errorMessage: 'Las contrasenas no coinciden');
      return false;
    }

    if (!state.acceptedTerms) {
      state = state.copyWith(
        errorMessage: 'Debes aceptar los terminos y condiciones',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simular llamada al API
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implementar registro real aquí
      // Ejemplo: await authRepository.register(
      //   name: state.name,
      //   email: state.email,
      //   password: state.password,
      // );

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al crear la cuenta. Intenta de nuevo.',
      );
      return false;
    }
  }

  void reset() {
    state = const RegisterState();
  }
}
