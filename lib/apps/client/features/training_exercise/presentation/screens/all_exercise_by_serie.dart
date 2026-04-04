import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider/serie_detail_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/add_serie_button.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/workout_flow_progress_bar.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/training_exercise/presentation/widgets/training_exercise_detail.dart';
import 'package:fio_fut/apps/client/features/training_exercise/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllExerciseBySerie extends ConsumerWidget {
  const AllExerciseBySerie({
    super.key,
    required this.pageController,
    required this.bgPageController,
  });

  final PageController pageController;
  final PageController bgPageController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(trainingSessionProvider).exercises;
    return Stack(
      children: [
        PageView(
          controller: bgPageController,
          physics: const NeverScrollableScrollPhysics(),
          children: exercises
              .map(
                (e) => Image.network(
                  e.exerciseImageUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: Colors.white24,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background,
                AppColors.background.o(0.6),
                Colors.transparent,
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
          child: const SizedBox.expand(),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TrainingExerciseDetail(),
                AppSpacing.xxs.gap,
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.md),
                      topRight: Radius.circular(AppSpacing.md),
                    ),

                    child: ListView(
                      padding: EdgeInsets.zero,
                      reverse: true,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(AppSpacing.md),
                                    topRight: Radius.circular(AppSpacing.md),
                                  ),
                                ),
                                child: Padding(
                                  padding: AppSpacing.md.top.add(
                                    (MediaQuery.paddingOf(context).bottom +
                                            AppSpacing.xs)
                                        .bottom,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: AppSpacing.xs.bottom,
                                        child: Column(
                                          children: [
                                            WorkoutFlowProgressBar(
                                              completedExercises: 2,
                                              totalExercises: exercises.length,
                                              isSessionStarted: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                      ExpandablePageView(
                                        controller: pageController,
                                        children: exercises.map((e) {
                                          return Padding(
                                            padding: AppSpacing.xxs.horizontal,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Color(0xff141414).o(0),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppSpacing.md,
                                                    ),
                                              ),
                                              child: Padding(
                                                padding: AppSpacing.xs.all,
                                                child: Column(
                                                  children: [
                                                    // ExerciseScheduleItem(scheduleId: scheduleId, exerciseId: exerciseId, exerciseName: exerciseName, sets: sets)
                                                    // Text(e.exerciseName),
                                                    SireBody(
                                                      scheduleId: e.scheduleId,
                                                      name: e.exerciseName,
                                                      repiteType: e.metricType,
                                                      series: e.sets,
                                                    ),
                                                    AddSerieButton(
                                                      scheduleId: e.scheduleId,

                                                      onTapSerie: () {
                                                        ref
                                                            .read(
                                                              serieDetailProvider(
                                                                e.scheduleId,
                                                              ).notifier,
                                                            )
                                                            .addSerie();
                                                      },
                                                      onCompleteAll: () {
                                                        ref
                                                            .read(
                                                              serieDetailProvider(
                                                                e.scheduleId,
                                                              ).notifier,
                                                            )
                                                            .completeAll();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
