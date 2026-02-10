import 'package:fio_fut/core/providers/auth_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class LogoutState {
  const LogoutState({
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;

  LogoutState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return LogoutState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final logoutProvider = NotifierProvider<LogoutNotifier, LogoutState>(
  LogoutNotifier.new,
);

class LogoutNotifier extends Notifier<LogoutState> {
  @override
  LogoutState build() => const LogoutState();

  Future<bool> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signOut();
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cerrar sesion. Intenta de nuevo.',
      );
      return false;
    }
  }

  void reset() => state = const LogoutState();
}
