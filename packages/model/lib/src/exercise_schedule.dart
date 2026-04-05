/// Representa un schedule de ejercicio con su rango de fechas y dias de la semana.
///
/// Reglas de negocio:
/// - Si el rango ya paso (endDate < hoy), no se puede editar ni eliminar.
/// - Al editar el rango, solo se eliminan sesiones futuras (no las ya completadas).
/// - Al eliminar, solo se eliminan sesiones del dia actual en adelante.
class ExerciseSchedule {
  const ExerciseSchedule({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    this.exerciseImageUrl,
    this.exerciseVideoUrl,
    this.exerciseType,
    this.muscleName,
    this.muscleGroup,
    required this.daysOfWeek,
    required this.startDate,
    required this.endDate,
    this.notes,
    this.createdById,
  });

  final String id;
  final String exerciseId;
  final String exerciseName;
  final String? exerciseImageUrl;
  final String? exerciseVideoUrl;
  final String? exerciseType;
  final String? muscleName;
  final String? muscleGroup;

  /// Dias de la semana (0=Lunes, 6=Domingo). Ej: {0, 2, 4}
  final Set<int> daysOfWeek;
  final DateTime startDate;
  final DateTime endDate;
  final String? notes;
  final String? createdById;

  /// El rango ya paso y no se puede editar/eliminar.
  bool get isExpired {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return endDate.isBefore(todayDate);
  }

  /// Puede editarse o eliminarse (no ha expirado).
  bool get canModify => !isExpired;

  /// Labels de los dias seleccionados.
  List<String> get dayLabels {
    const labels = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do'];
    final sorted = daysOfWeek.toList()..sort();
    return sorted.map((d) => labels[d]).toList();
  }

  /// Semanas totales del rango.
  int get totalWeeks {
    if (daysOfWeek.isEmpty) return 0;
    return (endDate.difference(startDate).inDays / 7).ceil();
  }

  /// Sesiones totales programadas.
  int get totalSessions => daysOfWeek.length * totalWeeks;

  /// Formato corto de fecha: "01 Abr - 30 Jun"
  String get dateRangeText {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    final s = '${startDate.day.toString().padLeft(2, '0')} ${months[startDate.month - 1]}';
    final e = '${endDate.day.toString().padLeft(2, '0')} ${months[endDate.month - 1]}';
    return '$s - $e';
  }

  ExerciseSchedule copyWith({
    String? id,
    String? exerciseId,
    String? exerciseName,
    String? exerciseImageUrl,
    String? exerciseVideoUrl,
    String? exerciseType,
    String? muscleName,
    String? muscleGroup,
    Set<int>? daysOfWeek,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    String? createdById,
  }) {
    return ExerciseSchedule(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      exerciseImageUrl: exerciseImageUrl ?? this.exerciseImageUrl,
      exerciseVideoUrl: exerciseVideoUrl ?? this.exerciseVideoUrl,
      exerciseType: exerciseType ?? this.exerciseType,
      muscleName: muscleName ?? this.muscleName,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      createdById: createdById ?? this.createdById,
    );
  }

  factory ExerciseSchedule.fromJson(Map<String, dynamic> json) {
    final exercise = json['exercise'] as Map<String, dynamic>?;
    final muscle = exercise?['muscle'] as Map<String, dynamic>?;
    final daysStr = json['days_of_week'] as String? ?? '';

    return ExerciseSchedule(
      id: json['id'] as String,
      exerciseId: json['id_exercise'] as String,
      exerciseName: exercise?['name'] as String? ?? 'Ejercicio',
      exerciseImageUrl: exercise?['url_img_exercise'] as String?,
      exerciseVideoUrl: exercise?['url_video_exercise'] as String?,
      exerciseType: exercise?['type_exercise'] as String?,
      muscleName: muscle?['name'] as String?,
      muscleGroup: muscle?['muscle_group'] as String?,
      daysOfWeek: daysStr.isEmpty
          ? const {}
          : daysStr.split(',').map(int.parse).toSet(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      notes: json['notes'] as String?,
      createdById: json['id_created_by'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ExerciseSchedule && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
