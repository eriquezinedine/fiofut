import 'package:flutter/foundation.dart';

@immutable
class Muscle {
  const Muscle({
    required this.id,
    required this.name,
    required this.isMain,
    this.description,
    this.parentMuscleId,
  });

  final String id;
  final String name;
  final bool isMain;
  final String? description;
  final String? parentMuscleId;

  factory Muscle.fromJson(Map<String, dynamic> json) {
    return Muscle(
      id: json['id'] as String,
      name: json['name'] as String,
      isMain: json['is_main'] as bool? ?? false,
      description: json['description'] as String?,
      parentMuscleId: json['id_muscle'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Muscle && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
