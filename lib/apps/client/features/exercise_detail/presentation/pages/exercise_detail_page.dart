import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/exercise_detail_sliver_app_bar.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/detail_action_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseDetailPage extends ConsumerStatefulWidget {
  const ExerciseDetailPage({super.key, required this.exercise});
  final Exercise exercise;

  static const String name = 'exercise-detail';
  static const String path = '/exercise-detail';

  @override
  ConsumerState<ExerciseDetailPage> createState() =>
      _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends ConsumerState<ExerciseDetailPage> {
  static const _repiteType = RepiteType.byKg;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(serieDetailProvider.notifier).init(
            exercise: widget.exercise,
            repiteType: _repiteType,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            ExerciseDetailSliverAppBar(
              title: widget.exercise.title,
              imageUrl: widget.exercise.imageUrl,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailActionChips(
                    exercise: widget.exercise,
                    duration: Duration(seconds: 20),
                  ),
                  SerieExerciseWidget(
                    repiteType: _repiteType,
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
