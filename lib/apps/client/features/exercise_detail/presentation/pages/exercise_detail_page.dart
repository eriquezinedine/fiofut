import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/exercise_detail_sliver_app_bar.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/detail_action_chips.dart';
import 'package:fio_fut/core/widgets/modal/add_serie_group_modal.dart';
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
      ref
          .read(serieDetailProvider(SerieGroupType.effective).notifier)
          .init(exercise: widget.exercise, repiteType: _repiteType);

      if (widget.exercise.hasWarmup) {
        ref
            .read(serieDetailProvider(SerieGroupType.warmup).notifier)
            .init(exercise: widget.exercise, repiteType: _repiteType);
      }
    });
  }

  Future<void> _onAddSerie() async {
    if (widget.exercise.hasWarmup) {
      final group = await AddSerieGroupModal.show(context);
      if (group == null) return;
      ref.read(serieDetailProvider(group).notifier).addSerie();
    } else {
      ref
          .read(serieDetailProvider(SerieGroupType.effective).notifier)
          .addSerie();
    }
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
                  if (widget.exercise.hasWarmup)
                    SerieExerciseWidget(
                      repiteType: _repiteType,
                      groupType: SerieGroupType.warmup,
                    ),
                  SerieExerciseWidget(
                    repiteType: _repiteType,
                    groupType: SerieGroupType.effective,
                  ),
                  AddSerieButton(onTap: _onAddSerie),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
