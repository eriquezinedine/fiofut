import 'package:isar/isar.dart';

part 'pending_schedule.g.dart';

@collection
class PendingSchedule {
  Id isarId = Isar.autoIncrement;

  /// Temporary ID used in the UI state (e.g. 'pending_abc123').
  @Index(unique: true, replace: true)
  late String tempId;

  late String exerciseId;
  late String exerciseName;
  String? exerciseDescription;
  String? exerciseImageUrl;
  String? exerciseVideoUrl;

  /// 'cardio', 'strength', 'reps'
  late String exerciseType;

  late String userId;

  /// ISO date string (yyyy-MM-dd)
  late String dateStr;

  /// 'custom' or 'weekly'
  late String scheduleType;

  /// Comma-separated day numbers (e.g. '0,2,4') for weekly, null for custom.
  String? daysOfWeek;

  /// ISO date strings for weekly scheduling.
  String? startDateStr;
  String? endDateStr;

  /// Number of retry attempts.
  int retryCount = 0;

  late DateTime createdAt;
}
