import 'package:flutter/foundation.dart';

@immutable
class LoginState {
  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool isLoading;
  final bool isPasswordVisible;
  final String? errorMessage;

  bool get isValid => email.isNotEmpty && password.length >= 6;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? isPasswordVisible,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage,
    );
  }
}
