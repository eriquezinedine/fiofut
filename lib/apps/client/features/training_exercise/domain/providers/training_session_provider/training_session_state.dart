import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';

class TrainingSessionState {
  const TrainingSessionState({
    this.exercises = const [],
    this.isStarted = false,
    this.isFinished = false,
  });

  final List<ExerciseScheduleItem> exercises;
  final bool isStarted;
  final bool isFinished;

  TrainingSessionState copyWith({
    List<ExerciseScheduleItem>? exercises,
    bool? isStarted,
    bool? isFinished,
  }) {
    return TrainingSessionState(
      exercises: exercises ?? this.exercises,
      isStarted: isStarted ?? this.isStarted,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}
