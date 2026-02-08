import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/providers/auth_providers.dart';
import 'complete_profile_state.dart';

final completeProfileProvider =
    NotifierProvider<CompleteProfileNotifier, CompleteProfileState>(
  CompleteProfileNotifier.new,
);

class CompleteProfileNotifier extends Notifier<CompleteProfileState> {
  @override
  CompleteProfileState build() {
    return const CompleteProfileState();
  }

  void updateWhatsappNumber(String value) {
    state = state.copyWith(whatsappNumber: value);
  }

  Future<bool> submitProfile() async {
    if (!state.isValid) {
      state = state.copyWith(
        errorMessage: 'Ingresa un numero de WhatsApp valido (minimo 10 digitos).',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await ref.read(userProfileProvider.notifier).completeProfile(
            state.whatsappNumber,
          );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al completar el perfil. Intenta de nuevo.',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const CompleteProfileState();
  }
}
