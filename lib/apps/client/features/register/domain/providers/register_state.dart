import 'package:flutter/foundation.dart';

@immutable
class RegisterState {
  const RegisterState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.acceptedTerms = false,
    this.errorMessage,
  });

  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool acceptedTerms;
  final String? errorMessage;

  bool get isValid =>
      name.isNotEmpty &&
      email.isNotEmpty &&
      password.length >= 6 &&
      password == confirmPassword &&
      acceptedTerms;

  bool get passwordsMatch => password == confirmPassword;

  RegisterState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? acceptedTerms,
    String? errorMessage,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      errorMessage: errorMessage,
    );
  }
}
