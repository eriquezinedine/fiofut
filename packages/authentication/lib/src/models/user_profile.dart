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
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? whatsappNumber;
  final UserType userType;
  final bool isProfileComplete;
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
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'whatsapp_number': whatsappNumber,
      'role': userType.name,
      'is_profile_complete': isProfileComplete,
    };
  }

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? avatarUrl,
    String? whatsappNumber,
    UserType? userType,
    bool? isProfileComplete,
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
          isProfileComplete == other.isProfileComplete;

  @override
  int get hashCode => Object.hash(
        id,
        fullName,
        avatarUrl,
        whatsappNumber,
        userType,
        isProfileComplete,
      );
}
