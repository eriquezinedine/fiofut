import 'package:flutter/foundation.dart';

@immutable
class CompleteProfileState {
  const CompleteProfileState({
    this.whatsappNumber = '',
    this.isLoading = false,
    this.errorMessage,
  });

  final String whatsappNumber;
  final bool isLoading;
  final String? errorMessage;

  bool get isValid => whatsappNumber.length >= 10;

  CompleteProfileState copyWith({
    String? whatsappNumber,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CompleteProfileState(
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
