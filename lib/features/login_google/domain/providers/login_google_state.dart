import 'package:flutter/foundation.dart';

@immutable
class LoginGoogleState {
  const LoginGoogleState({
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;

  LoginGoogleState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginGoogleState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
