import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';

sealed class SerieDetailState {
  const SerieDetailState();
}

class SerieDetailInitial extends SerieDetailState {
  const SerieDetailInitial();
}

class SerieDetailLoading extends SerieDetailState {
  const SerieDetailLoading();
}

class SerieDetailLoaded extends SerieDetailState {
  const SerieDetailLoaded({
    required this.workout,
  });

  final WorkoutExercise workout;

  List<SerieSet> get series => workout.series;
  RepiteType get repiteType => workout.repiteType;
  bool get allCompleted => workout.allSeriesCompleted;
  double get progress => workout.progress;

  SerieDetailLoaded copyWith({
    WorkoutExercise? workout,
  }) {
    return SerieDetailLoaded(
      workout: workout ?? this.workout,
    );
  }
}

class SerieDetailError extends SerieDetailState {
  const SerieDetailError({required this.message});

  final String message;
}
