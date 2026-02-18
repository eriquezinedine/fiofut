import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/exercise_detail_sliver_app_bar.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/detail_action_chips.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExerciseDetailPage extends StatelessWidget {
  const ExerciseDetailPage({super.key, required this.exercise});
  final Exercise exercise;

  static const String name = 'exercise-detail';
  static const String path = '/exercise-detail';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: CustomScrollView(
        slivers: [
          ExerciseDetailSliverAppBar(
            title: exercise.title,
            imageUrl: exercise.imageUrl,
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailActionChips(
                  exercise: exercise,
                  duration: Duration(seconds: 20),
                ),
                SerieExerciseWidget(
                  repiteType: RepiteType.byKm,
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
