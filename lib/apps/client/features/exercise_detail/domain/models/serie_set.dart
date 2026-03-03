import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';

enum SerieStatus { pending, completed }

enum SetType { normal, warmup, dropset }

class SerieSet {
  const SerieSet({
    required this.id,
    required this.number,
    this.reps,
    this.kg,
    this.mins,
    this.segs,
    this.status = SerieStatus.pending,
    this.setType = SetType.normal,
  });

  final String id;
  final int number;
  final int? reps;
  final double? kg;
  final int? mins;
  final int? segs;
  final SerieStatus status;
  final SetType setType;

  bool get isCompleted => status == SerieStatus.completed;

  /// Checks if the serie has enough data to be marked as completed
  bool canComplete(RepiteType type) {
    return switch (type) {
      RepiteType.byKg => (reps != null && reps! > 0) && kg != null,
      RepiteType.byKm =>
        (mins != null || segs != null) &&
            ((mins ?? 0) > 0 || (segs ?? 0) > 0) &&
            kg != null,
      RepiteType.retryOnly => reps != null && reps! > 0,
    };
  }

  SerieSet copyWith({
    String? id,
    int? number,
    int? reps,
    double? kg,
    int? mins,
    int? segs,
    SerieStatus? status,
    SetType? setType,
  }) {
    return SerieSet(
      id: id ?? this.id,
      number: number ?? this.number,
      reps: reps ?? this.reps,
      kg: kg ?? this.kg,
      mins: mins ?? this.mins,
      segs: segs ?? this.segs,
      status: status ?? this.status,
      setType: setType ?? this.setType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SerieSet &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          number == other.number &&
          reps == other.reps &&
          kg == other.kg &&
          mins == other.mins &&
          segs == other.segs &&
          status == other.status &&
          setType == other.setType;

  @override
  int get hashCode => Object.hash(id, number, reps, kg, mins, segs, status, setType);

  @override
  String toString() =>
      'SerieSet(id: $id, #$number, reps: $reps, kg: $kg, mins: $mins, segs: $segs, status: $status, setType: $setType)';
}
