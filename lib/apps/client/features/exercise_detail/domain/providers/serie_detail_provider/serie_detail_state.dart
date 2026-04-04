import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';

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
    required this.series,
  });

  final List<ExerciseSetData> series;

  bool get allCompleted => series.isNotEmpty && series.every((s) => s.isCompleted);
  double get progress => series.isEmpty ? 0.0 : series.where((s) => s.isCompleted).length / series.length;

  SerieDetailLoaded copyWith({
    List<ExerciseSetData>? series,
  }) {
    return SerieDetailLoaded(
      series: series ?? this.series,
    );
  }
}

class SerieDetailError extends SerieDetailState {
  const SerieDetailError({required this.message});

  final String message;
}
