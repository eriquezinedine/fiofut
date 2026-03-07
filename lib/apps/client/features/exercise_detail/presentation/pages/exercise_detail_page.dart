import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/exercise_detail_content.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';
import 'package:flutter/material.dart';

class ExerciseDetailPage extends StatelessWidget {
  const ExerciseDetailPage({
    super.key,
    required this.exercise,
    required this.scheduleId,
  });

  final Exercise exercise;
  final String scheduleId;

  static const String name = 'exercise-detail';
  static const String path = '/exercise-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExerciseDetailContent(
        exercise: exercise,
        scheduleId: scheduleId,
        showAppBar: true,
      ),
    );
  }
}
