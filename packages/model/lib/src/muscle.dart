import 'muscle_group.dart';

class Muscle {
  final String id;
  final String name;
  final bool isMain;
  final String? description;
  final String? idMuscle;
  final MuscleGroup muscleGroup;

  const Muscle({
    required this.id,
    required this.name,
    required this.isMain,
    this.description,
    this.idMuscle,
    required this.muscleGroup,
  });

  factory Muscle.fromJson(Map<String, dynamic> json) {
    return Muscle(
      id: json['id'] as String,
      name: json['name'] as String,
      isMain: json['is_main'] as bool,
      description: json['description'] as String?,
      idMuscle: json['id_muscle'] as String?,
      muscleGroup: MuscleGroup.fromJson(json['muscle_group'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_main': isMain,
      'description': description,
      'id_muscle': idMuscle,
      'muscle_group': muscleGroup.toJson(),
    };
  }

  Muscle copyWith({
    String? id,
    String? name,
    bool? isMain,
    String? description,
    String? idMuscle,
    MuscleGroup? muscleGroup,
  }) {
    return Muscle(
      id: id ?? this.id,
      name: name ?? this.name,
      isMain: isMain ?? this.isMain,
      description: description ?? this.description,
      idMuscle: idMuscle ?? this.idMuscle,
      muscleGroup: muscleGroup ?? this.muscleGroup,
    );
  }

  @override
  String toString() =>
      'Muscle(name: $name, muscleGroup: ${muscleGroup.toJson()})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Muscle && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
