enum ExerciseStatus {
  pending,
  inProgress,
  completed;

  String get label => switch (this) {
        ExerciseStatus.pending => 'Pendiente',
        ExerciseStatus.inProgress => 'En progreso',
        ExerciseStatus.completed => 'Completado',
      };
}

enum MetricType {
  weight,
  distance,
  time,
  reps;

  String get unit => switch (this) {
        MetricType.weight => 'kg',
        MetricType.distance => 'km',
        MetricType.time => 'min',
        MetricType.reps => 'reps',
      };
}

class Exercise {
  const Exercise({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.currentValue,
    required this.targetValue,
    required this.metricType,
    required this.status,
  });

  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final double currentValue;
  final double targetValue;
  final MetricType metricType;
  final ExerciseStatus status;

  double get progress =>
      targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;

  String get currentFormatted => _formatValue(currentValue);
  String get targetFormatted => _formatValue(targetValue);

  String _formatValue(double value) {
    final display = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
    return '$display ${metricType.unit}';
  }

  Exercise copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    double? currentValue,
    double? targetValue,
    MetricType? metricType,
    ExerciseStatus? status,
  }) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
      metricType: metricType ?? this.metricType,
      status: status ?? this.status,
    );
  }

  static List<Exercise> sampleData = const [
    Exercise(
      id: '1',
      title: 'Running',
      description: 'Cardio matutino en cinta',
      imageUrl: '',
      currentValue: 2,
      targetValue: 5,
      metricType: MetricType.distance,
      status: ExerciseStatus.inProgress,
    ),
    Exercise(
      id: '2',
      title: 'Bench Press',
      description: 'Press de banca plano',
      imageUrl: '',
      currentValue: 60,
      targetValue: 60,
      metricType: MetricType.weight,
      status: ExerciseStatus.completed,
    ),
    Exercise(
      id: '3',
      title: 'Squats',
      description: 'Sentadillas con barra',
      imageUrl: '',
      currentValue: 0,
      targetValue: 80,
      metricType: MetricType.weight,
      status: ExerciseStatus.pending,
    ),
    Exercise(
      id: '4',
      title: 'Plank',
      description: 'Plancha abdominal',
      imageUrl: '',
      currentValue: 1,
      targetValue: 3,
      metricType: MetricType.time,
      status: ExerciseStatus.inProgress,
    ),
    Exercise(
      id: '5',
      title: 'Pull Ups',
      description: 'Dominadas con peso corporal',
      imageUrl: '',
      currentValue: 8,
      targetValue: 12,
      metricType: MetricType.reps,
      status: ExerciseStatus.inProgress,
    ),
  ];
}
