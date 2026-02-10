import 'package:flutter/foundation.dart';

enum MuscleGroup {
  pecho,
  espalda,
  piernas,
  brazos,
  hombros,
  core,
  fullBody;

  String get displayName => switch (this) {
        pecho => 'Pecho',
        espalda => 'Espalda',
        piernas => 'Piernas',
        brazos => 'Brazos',
        hombros => 'Hombros',
        core => 'Core',
        fullBody => 'Full Body',
      };
}

enum ExerciseType {
  cardio,
  fuerza,
  flexibilidad;

  String get displayName => switch (this) {
        cardio => 'Cardio',
        fuerza => 'Fuerza',
        flexibilidad => 'Flexibilidad',
      };
}

@immutable
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.muscleGroup,
    required this.exerciseType,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final MuscleGroup muscleGroup;
  final ExerciseType exerciseType;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      muscleGroup: _parseMuscleGroup(json['muscle_group'] as String),
      exerciseType: _parseExerciseType(json['exercise_type'] as String),
      createdBy: json['created_by'] as String?,
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
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'muscle_group': muscleGroup.name,
      'exercise_type': exerciseType.name,
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    MuscleGroup? muscleGroup,
    ExerciseType? exerciseType,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      exerciseType: exerciseType ?? this.exerciseType,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static MuscleGroup _parseMuscleGroup(String value) {
    return MuscleGroup.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MuscleGroup.fullBody,
    );
  }

  static ExerciseType _parseExerciseType(String value) {
    return ExerciseType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ExerciseType.fuerza,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exercise && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
