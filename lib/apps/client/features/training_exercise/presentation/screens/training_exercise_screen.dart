import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/training_exercise/training_exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingExerciseScreen extends ConsumerStatefulWidget {
  const TrainingExerciseScreen({
    super.key,
    required this.exercises,
    required this.initialIndex,
  });

  final List<ExerciseScheduleItem> exercises;
  final int initialIndex;

  static const String name = 'training_exercise';
  static const String path = '/training-exercise';

  @override
  ConsumerState<TrainingExerciseScreen> createState() => _TrainingExerciseScreenState();
}

class _TrainingExerciseScreenState extends ConsumerState<TrainingExerciseScreen> {
  late final PageController _pageController;
  late final PageController _bgPageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1,
      initialPage: 0,
    );
    _bgPageController = PageController(initialPage: 0);

    _pageController.addListener(_onPageScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedExerciseProvider.notifier).selectFirstPending(widget.exercises);
    });
  }

  void _onPageScroll() {
    final page = _pageController.page;
    if (page == null) return;

    final rounded = page.round();
    final progress = (page - rounded).abs().clamp(0.0, 1.0);

    ref.read(pageScrollProgressProvider.notifier).state = progress;
    ref.read(currentPageIndexProvider.notifier).state = rounded;

    if (_bgPageController.hasClients && rounded != _bgPageController.page?.round()) {
      _bgPageController.animateToPage(
        rounded,
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    _bgPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReady = ref.watch(trainingSessionProvider).isStarted;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildTrainingAppBar(context),
      body: isReady? AllExerciseBySerie(pageController: _pageController, bgPageController: _bgPageController) : TrainingPlaceHolderScreen(exercises: widget.exercises, onStart: () {
        ref.read(trainingSessionProvider.notifier).startTraining();
      },),
    );
  }
}
