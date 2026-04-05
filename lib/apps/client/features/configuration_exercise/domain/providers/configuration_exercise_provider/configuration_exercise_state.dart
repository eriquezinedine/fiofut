import 'package:model/model.dart';

sealed class ConfigurationExerciseState {
  const ConfigurationExerciseState();
}

class ConfigurationExerciseInitial extends ConfigurationExerciseState {
  const ConfigurationExerciseInitial();
}

class ConfigurationExerciseLoading extends ConfigurationExerciseState {
  const ConfigurationExerciseLoading();
}

class ConfigurationExerciseLoaded extends ConfigurationExerciseState {
  const ConfigurationExerciseLoaded({
    required this.schedules,
    this.isOperating = false,
    this.operationError,
  });

  final List<ExerciseSchedule> schedules;

  /// True mientras se ejecuta una operacion (editar/eliminar).
  final bool isOperating;

  /// Mensaje de error de la ultima operacion fallida.
  final String? operationError;

  ConfigurationExerciseLoaded copyWith({
    List<ExerciseSchedule>? schedules,
    bool? isOperating,
    String? operationError,
  }) {
    return ConfigurationExerciseLoaded(
      schedules: schedules ?? this.schedules,
      isOperating: isOperating ?? this.isOperating,
      operationError: operationError,
    );
  }
}

class ConfigurationExerciseError extends ConfigurationExerciseState {
  const ConfigurationExerciseError({required this.message});

  final String message;
}
