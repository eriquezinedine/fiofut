import 'package:flutter/foundation.dart';

enum ExerciseType {
  cardio,
  strength,
  reps;

  String get displayName => switch (this) {
        cardio => 'Cardio',
        strength => 'Fuerza',
        reps => 'Repeticiones',
      };
}

enum ExerciseLocation {
  gym,
  home,
  both;

  String get displayName => switch (this) {
        gym => 'Gimnasio',
        home => 'Casa',
        both => 'Ambos',
      };
}

@immutable
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.primaryMuscleId,
    this.secondaryMuscleIds = const [],
    required this.exerciseType,
    this.videoUrl,
    this.location = ExerciseLocation.both,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? primaryMuscleId;
  final List<String> secondaryMuscleIds;
  final ExerciseType exerciseType;
  final String? videoUrl;
  final ExerciseLocation location;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    // Support secondary muscles injected from junction table query
    final secondaryIds = json['_secondary_muscle_ids'] as List<String>? ?? [];

    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['url_img_exercise'] as String?,
      primaryMuscleId: json['id_muscle'] as String?,
      secondaryMuscleIds: secondaryIds,
      exerciseType:
          _parseExerciseType(json['type_exercise'] as String? ?? 'strength'),
      videoUrl: json['url_video_exercise'] as String? ??
          json['video_example'] as String?,
      location: _parseLocation(json['location'] as String?),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'url_img_exercise': imageUrl,
      'id_muscle': primaryMuscleId,
      'type_exercise': exerciseType.name,
      'url_video_exercise': videoUrl,
      'location': location.name,
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? primaryMuscleId,
    List<String>? secondaryMuscleIds,
    ExerciseType? exerciseType,
    String? videoUrl,
    ExerciseLocation? location,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      primaryMuscleId: primaryMuscleId ?? this.primaryMuscleId,
      secondaryMuscleIds: secondaryMuscleIds ?? this.secondaryMuscleIds,
      exerciseType: exerciseType ?? this.exerciseType,
      videoUrl: videoUrl ?? this.videoUrl,
      location: location ?? this.location,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static ExerciseType _parseExerciseType(String value) {
    return ExerciseType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ExerciseType.strength,
    );
  }

  static ExerciseLocation _parseLocation(String? value) {
    if (value == null) return ExerciseLocation.both;
    return ExerciseLocation.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ExerciseLocation.both,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exercise && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
