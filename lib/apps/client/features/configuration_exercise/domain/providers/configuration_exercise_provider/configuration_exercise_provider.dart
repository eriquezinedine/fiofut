import 'package:fio_fut/apps/client/features/configuration_exercise/domain/providers/configuration_exercise_provider/configuration_exercise_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final configurationExerciseProvider = NotifierProvider.autoDispose<
    ConfigurationExerciseNotifier, ConfigurationExerciseState>(
  ConfigurationExerciseNotifier.new,
);

class ConfigurationExerciseNotifier
    extends AutoDisposeNotifier<ConfigurationExerciseState> {
  @override
  ConfigurationExerciseState build() => const ConfigurationExerciseInitial();
}
