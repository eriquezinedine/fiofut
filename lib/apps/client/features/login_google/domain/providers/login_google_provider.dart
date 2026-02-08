import 'package:authentication/authentication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/providers/auth_providers.dart';
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

  /// Sign in with Google via Supabase.
  /// Returns the user's profile if sign-in succeeds, or null on failure.
  Future<UserProfile?> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.signInWithGoogle();

      final user = response.user;
      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No se pudo obtener la informacion del usuario.',
        );
        return null;
      }

      // Fetch profile to check if it's complete
      final profile = await repo.getProfile(user.id);

      // Refresh profile provider
      ref.invalidate(userProfileProvider);

      state = state.copyWith(isLoading: false);
      return profile;
    } catch (e) {
      final message = e.toString().contains('cancelado') || e.toString().contains('canceled')
          ? 'Inicio de sesion cancelado.'
          : 'Error al iniciar sesion con Google. Intenta de nuevo.';
      state = state.copyWith(
        isLoading: false,
        errorMessage: message,
      );
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const LoginGoogleState();
  }
}
