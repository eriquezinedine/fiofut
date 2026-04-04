import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/add_serie_button.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/exercise_detail_sliver_app_bar.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/exercise_detail/exercise_detail.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ExerciseDetailBody extends StatelessWidget {
  const ExerciseDetailBody({
    super.key,
    required this.exercise,
    required this.scheduleId,
    required this.repiteType,
    required this.isStarted,
    required this.allDone,
    required this.currentSerieId,
    required this.showDescanso,
    required this.descansoSeconds,
    required this.descansoRunning,
    required this.onStartWorkout,
    required this.onRegisterSerie,
    required this.onAddSerie,
    required this.onToggleDescanso,
    required this.onAdjustDescanso,
    required this.onStopDescanso,
  });

  final Exercise exercise;
  final String scheduleId;
  final MetricType repiteType;
  final bool isStarted;
  final bool allDone;
  final String? currentSerieId;
  final bool showDescanso;
  final int descansoSeconds;
  final bool descansoRunning;
  final VoidCallback onStartWorkout;
  final VoidCallback onRegisterSerie;
  final VoidCallback onAddSerie;
  final VoidCallback onToggleDescanso;
  final ValueChanged<int> onAdjustDescanso;
  final VoidCallback onStopDescanso;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: CustomScrollView(
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
                          duration: const Duration(seconds: 20),
                        ),
                        SerieExerciseWidget(
                          scheduleId: scheduleId,
                          repiteType: repiteType,
                          // isStarted: isStarted,
                          currentSerieId: currentSerieId,
                          onRegisterSerie: onRegisterSerie,
                        ),
                        AddSerieButton(
                          scheduleId: scheduleId,
                          onTapSerie: onAddSerie,
                        ),
                        if (!showDescanso) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: DescansoWidget(
                              seconds: descansoSeconds,
                              isRunning: descansoRunning,
                              onToggle: onToggleDescanso,
                              onAdjust: onAdjustDescanso,
                              onStop: onStopDescanso,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (allDone)
          Positioned.fill(
            top: 0,
            child: IgnorePointer(
              child: Lottie.asset(
                'assets/lottie/confeti.json',
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                repeat: false,
              ),
            ),
          ),
      ],
    );
  }
}
