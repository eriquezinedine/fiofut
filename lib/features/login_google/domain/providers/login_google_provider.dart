import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_google_state.dart';

final loginGoogleProvider =
    NotifierProvider<LoginGoogleNotifier, LoginGoogleState>(
  LoginGoogleNotifier.new,
);

class LoginGoogleNotifier extends Notifier<LoginGoogleState> {
  @override
  LoginGoogleState build() {
    return const LoginGoogleState();
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simular llamada al API de Google
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implementar autenticación con Google real
      // Ejemplo:
      // final googleUser = await GoogleSignIn().signIn();
      // if (googleUser == null) {
      //   state = state.copyWith(isLoading: false);
      //   return false;
      // }
      // final googleAuth = await googleUser.authentication;
      // await authRepository.signInWithGoogle(googleAuth.idToken);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al iniciar sesion con Google. Intenta de nuevo.',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const LoginGoogleState();
  }
}
