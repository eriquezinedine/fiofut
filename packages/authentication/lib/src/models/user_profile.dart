import 'package:flutter/foundation.dart';

enum UserType { student, trainer, admin }

@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.whatsappNumber,
    this.userType = UserType.student,
    this.isProfileComplete = false,
    this.onboardingStep,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? whatsappNumber;
  final UserType userType;
  final bool isProfileComplete;
  final int? onboardingStep;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      userType: _parseUserType(json['role'] as String?),
      isProfileComplete: json['is_profile_complete'] as bool? ?? false,
      onboardingStep: json['onboarding_step'] as int?,
      createdAt: _tryParseDate(json['created_at']),
      updatedAt: _tryParseDate(json['updated_at']),
    );
  }

  static DateTime? _tryParseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'whatsapp_number': whatsappNumber,
      'role': userType.name,
      'is_profile_complete': isProfileComplete,
      'onboarding_step': onboardingStep,
    };
  }

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? avatarUrl,
    String? whatsappNumber,
    UserType? userType,
    bool? isProfileComplete,
    int? onboardingStep,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      userType: userType ?? this.userType,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      onboardingStep: onboardingStep ?? this.onboardingStep,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static UserType _parseUserType(String? value) {
    return switch (value) {
      'trainer' => UserType.trainer,
      'admin' => UserType.admin,
      'student' => UserType.student,
      _ => UserType.student,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          avatarUrl == other.avatarUrl &&
          whatsappNumber == other.whatsappNumber &&
          userType == other.userType &&
          isProfileComplete == other.isProfileComplete &&
          onboardingStep == other.onboardingStep;

  @override
  int get hashCode => Object.hash(
        id,
        fullName,
        avatarUrl,
        whatsappNumber,
        userType,
        isProfileComplete,
        onboardingStep,
      );
}
