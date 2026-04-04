import 'package:model/model.dart';

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
  cardio,
  reps,
  strength;

  String get unit => switch (this) {
        MetricType.cardio => 'km',
        MetricType.reps => 'reps',
        MetricType.strength => 'kg',
      };
}

class Exercise {
  const Exercise({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    required this.muscleMain,
    required this.muscleSecundaries,
    required this.instruccion,
    required this.currentValue,
    required this.targetValue,
    required this.metricType,
    required this.status,
    this.hasWarmup = false,
  });

  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final Muscle muscleMain;
  final List<Muscle> muscleSecundaries;
  final String instruccion;
  final double currentValue;
  final double targetValue;
  final MetricType metricType;
  final ExerciseStatus status;
  final bool hasWarmup;

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
    String? videoUrl,
    Muscle? muscleMain,
    List<Muscle>? muscleSecundaries,
    String? instruccion,
    double? currentValue,
    double? targetValue,
    MetricType? metricType,
    ExerciseStatus? status,
    bool? hasWarmup,
  }) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      muscleMain: muscleMain ?? this.muscleMain,
      muscleSecundaries: muscleSecundaries ?? this.muscleSecundaries,
      instruccion: instruccion ?? this.instruccion,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
      metricType: metricType ?? this.metricType,
      status: status ?? this.status,
      hasWarmup: hasWarmup ?? this.hasWarmup,
    );
  }

  static List<Exercise> sampleData = const [
    Exercise(
      id: '1',
      title: 'Running',
      description: 'Cardio matutino en cinta',
      imageUrl: 'https://wxiehggemcmlpidweplk.supabase.co/storage/v1/object/public/excersice/placholder.png',
      videoUrl: 'https://wxiehggemcmlpidweplk.supabase.co/storage/v1/object/public/excersice/apdomen.mov',
      muscleMain: Muscle(
        id: '1',
        name: 'Cuádriceps',
        isMain: true,
        muscleGroup: MuscleGroup.quadriceps,
      ),
      muscleSecundaries: [
        Muscle(
          id: '2',
          name: 'Pantorrillas',
          isMain: false,
          muscleGroup: MuscleGroup.calves,
        ),
        Muscle(
          id: '3',
          name: 'Glúteos',
          isMain: false,
          muscleGroup: MuscleGroup.glutes,
        ),
        Muscle(
          id: '16',
          name: 'Isquiotibiales',
          isMain: false,
          muscleGroup: MuscleGroup.hamstrings,
        ),
        Muscle(
          id: '17',
          name: 'Tríceps',
          isMain: false,
          muscleGroup: MuscleGroup.triceps,
        ),
        Muscle(
          id: '18',
          name: 'Bíceps',
          isMain: false,
          muscleGroup: MuscleGroup.biceps,
        ),
      ],
      instruccion: '''Acuéstate de espaldas en una colchoneta o en el suelo, con las piernas extendidas y los brazos a los lados
Activa tu núcleo y levanta los brazos rectos por encima de tu cabeza, alineados con tus orejas.
Manteniendo las piernas y los brazos rectos, levanta simultáneamente las piernas y el torso del suelo y trata de alcanzar tus dedos de los pies con las manos.
Acuéstate de espaldas en una colchoneta o en el suelo, con las piernas extendidas y los brazos a los lados
Activa tu núcleo y levanta los brazos rectos por encima de tu cabeza, alineados con tus orejas.
Manteniendo las piernas y los brazos rectos, levanta simultáneamente las piernas y el torso del suelo y trata de alcanzar tus dedos de los pies con las manos.''',
      currentValue: 2,
      targetValue: 5,
      metricType: MetricType.cardio,
      status: ExerciseStatus.inProgress,
    ),
    Exercise(
      id: '2',
      title: 'Bench Press',
      description: 'Press de banca plano',
      imageUrl: 'https://wxiehggemcmlpidweplk.supabase.co/storage/v1/object/public/excersice/placholder.png',
      videoUrl: 'https://wxiehggemcmlpidweplk.supabase.co/storage/v1/object/public/excersice/apdomen.mov',
      muscleMain: Muscle(
        id: '4',
        name: 'Pecho',
        isMain: true,
        muscleGroup: MuscleGroup.chest,
      ),
      muscleSecundaries: [],
      instruccion: '''Acuéstate de espaldas en una colchoneta o en el suelo, con las piernas extendidas y los brazos a los lados
Activa tu núcleo y levanta los brazos rectos por encima de tu cabeza, alineados con tus orejas.
Manteniendo las piernas y los brazos rectos, levanta simultáneamente las piernas y el torso del suelo y trata de alcanzar tus dedos de los pies con las manos.''',
      currentValue: 60,
      targetValue: 60,
      metricType: MetricType.strength,
      status: ExerciseStatus.completed,
      hasWarmup: true,
    ),
    Exercise(
      id: '3',
      title: 'Squats',
      description: 'Sentadillas con barra',
      imageUrl: 'https://wxiehggemcmlpidweplk.supabase.co/storage/v1/object/public/excersice/placholder.png',
      videoUrl: 'https://wxiehggemcmlpidweplk.supabase.co/storage/v1/object/public/excersice/apdomen.mov',
      muscleMain: Muscle(
        id: '7',
        name: 'Cuádriceps',
        isMain: true,
        muscleGroup: MuscleGroup.quadriceps,
      ),
      muscleSecundaries: [],
      instruccion: '''Acuéstate de espaldas en una colchoneta o en el suelo, con las piernas extendidas y los brazos a los lados
Activa tu núcleo y levanta los brazos rectos por encima de tu cabeza, alineados con tus orejas.
Manteniendo las piernas y los brazos rectos, levanta simultáneamente las piernas y el torso del suelo y trata de alcanzar tus dedos de los pies con las manos.''',
      currentValue: 0,
      targetValue: 80,
      metricType: MetricType.strength,
      status: ExerciseStatus.pending,
    ),
    Exercise(
      id: '4',
      title: 'Plank',
      description: 'Plancha abdominal',
      imageUrl: 'https://wxiehggemcmlpidweplk.supabase.co/storage/v1/object/public/excersice/placholder.png',
      videoUrl: 'https://wxiehggemcmlpidweplk.supabase.co/storage/v1/object/public/excersice/apdomen.mov',
      muscleMain: Muscle(
        id: '10',
        name: 'Abdominales',
        isMain: true,
        muscleGroup: MuscleGroup.abs,
      ),
      muscleSecundaries: [],
      instruccion: '''Acuéstate de espaldas en una colchoneta o en el suelo, con las piernas extendidas y los brazos a los lados
Activa tu núcleo y levanta los brazos rectos por encima de tu cabeza, alineados con tus orejas.
Manteniendo las piernas y los brazos rectos, levanta simultáneamente las piernas y el torso del suelo y trata de alcanzar tus dedos de los pies con las manos.''',
      currentValue: 1,
      targetValue: 3,
      metricType: MetricType.reps,
      status: ExerciseStatus.inProgress,
    ),
    Exercise(
      id: '5',
      title: 'Pull Ups',
      description: 'Dominadas con peso corporal',
      imageUrl: 'https://wxiehggemcmlpidweplk.supabase.co/storage/v1/object/public/excersice/placholder.png',
      videoUrl: 'https://wxiehggemcmlpidweplk.supabase.co/storage/v1/object/public/excersice/apdomen.mov',
      muscleMain: Muscle(
        id: '13',
        name: 'Espalda',
        isMain: true,
        muscleGroup: MuscleGroup.back,
      ),
      muscleSecundaries: [],
      instruccion: '''Acuéstate de espaldas en una colchoneta o en el suelo, con las piernas extendidas y los brazos a los lados
Activa tu núcleo y levanta los brazos rectos por encima de tu cabeza, alineados con tus orejas.
Manteniendo las piernas y los brazos rectos, levanta simultáneamente las piernas y el torso del suelo y trata de alcanzar tus dedos de los pies con las manos.''',
      currentValue: 8,
      targetValue: 12,
      metricType: MetricType.reps,
      status: ExerciseStatus.inProgress,
    ),
  ];
}
