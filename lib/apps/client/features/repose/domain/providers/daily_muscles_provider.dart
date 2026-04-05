import 'package:fio_fut/apps/client/features/exercise_home/domain/model/muscle_repose.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/providers/exercise_home/exercise_home_provider.dart';
import 'package:fio_fut/apps/client/features/repose/domain/providers/all_muscles_repose_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart' hide MuscleRepose;

/// Musculos unicos del dia actual, con su porcentaje de recuperacion.
///
/// Extrae musculos principales de cada ejercicio del dia,
/// los agrupa sin repetidos, y cruza con [allMusclesReposeProvider]
/// para obtener el % de recuperacion.
///
/// Orden: principales primero, secundarios despues.
final dailyMusclesProvider = Provider<List<MuscleRepose>>((ref) {
  final exercises = ref.watch(exerciseHomeProvider).exercises;
  final reposeState = ref.watch(allMusclesReposeProvider);

  final mainGroups = <MuscleGroup>{};
  final secondaryGroups = <MuscleGroup>{};

  for (final item in exercises) {
    // Principal
    final groupStr = item.muscleGroup;
    if (groupStr != null) {
      try {
        mainGroups.add(MuscleGroup.fromJson(groupStr));
      } catch (_) {}
    }

    // Secundarios: extraer del Exercise model
    final exercise = item.toExercise();
    for (final sec in exercise.muscleSecundaries) {
      secondaryGroups.add(sec.muscleGroup);
    }
  }

  // Secundarios que no sean tambien principales
  secondaryGroups.removeAll(mainGroups);

  MuscleRepose buildRepose(MuscleGroup group, bool isMain) {
    final repose = reposeState.muscles[group];
    return MuscleRepose(
      muscle: Muscle(
        id: repose?.muscle.id ?? group.toJson(),
        name: repose?.muscle.name ?? _groupDisplayName(group),
        isMain: isMain,
        muscleGroup: group,
      ),
      percentage: repose?.percentage ?? 100,
    );
  }

  return [
    ...mainGroups.map((g) => buildRepose(g, true)),
    ...secondaryGroups.map((g) => buildRepose(g, false)),
  ];
});

String _groupDisplayName(MuscleGroup group) => switch (group) {
      MuscleGroup.chest => 'Pecho',
      MuscleGroup.back => 'Espalda',
      MuscleGroup.biceps => 'Bíceps',
      MuscleGroup.triceps => 'Tríceps',
      MuscleGroup.forearms => 'Antebrazos',
      MuscleGroup.abs => 'Abdominales',
      MuscleGroup.quadriceps => 'Cuádriceps',
      MuscleGroup.hamstrings => 'Isquiotibiales',
      MuscleGroup.glutes => 'Glúteos',
      MuscleGroup.calves => 'Pantorrillas',
      MuscleGroup.traps => 'Trapecios',
      MuscleGroup.obliques => 'Oblicuos',
      MuscleGroup.adductors => 'Aductores',
      MuscleGroup.abductors => 'Abductores',
      MuscleGroup.lowerBack => 'Lumbar',
      MuscleGroup.frontDeltoid => 'Deltoides frontal',
      MuscleGroup.lateralDeltoid => 'Deltoides lateral',
      MuscleGroup.rearDeltoid => 'Deltoides posterior',
    };
