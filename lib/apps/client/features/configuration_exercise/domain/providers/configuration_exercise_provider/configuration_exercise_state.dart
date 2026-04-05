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
  const ConfigurationExerciseLoaded();
}

class ConfigurationExerciseError extends ConfigurationExerciseState {
  const ConfigurationExerciseError({required this.message});

  final String message;
}
