import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/back_body_custom_paint.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/front_body_custom_paint.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

class AnimationColorMuscle extends StatefulWidget {
  const AnimationColorMuscle({
    super.key,
    this.selectedMuscles = const {},
    this.onMuscleTap,
  });

  final Set<MuscleGroup> selectedMuscles;
  final void Function(MuscleGroup muscle)? onMuscleTap;

  @override
  State<AnimationColorMuscle> createState() => _AnimationColorMuscleState();
}

class _AnimationColorMuscleState extends State<AnimationColorMuscle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmer;
  late final Set<MuscleGroup> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...widget.selectedMuscles};
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _shimmer = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _color(MuscleGroup muscle) {
    if (_selected.contains(muscle)) {
      return AppColors.primary;
    }
    return Color.lerp(
      AppColors.muscleDefaultColor.withValues(alpha: 0.45),
      AppColors.white.withValues(alpha: 0.8),
      _shimmer.value,
    )!;
  }

  void _onTap(MuscleGroup muscle) {
    setState(() {
      if (_selected.contains(muscle)) {
        _selected.remove(muscle);
      } else {
        _selected.add(muscle);
      }
    });
    widget.onMuscleTap?.call(muscle);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        return PageView(
          children: [
            _Item(
              child: FrontBodyCustomPaint(
                colors: FrontMuscleColors(
                  chest: _color(MuscleGroup.chest),
                  abs: _color(MuscleGroup.abs),
                  biceps: _color(MuscleGroup.biceps),
                  obliques: _color(MuscleGroup.obliques),
                  forearms: _color(MuscleGroup.forearms),
                  quadriceps: _color(MuscleGroup.quadriceps),
                  adductors: _color(MuscleGroup.adductors),
                  abductors: _color(MuscleGroup.abductors),
                  lateralDeltoid: _color(MuscleGroup.lateralDeltoid),
                  frontDeltoid: _color(MuscleGroup.frontDeltoid),
                ),
                width: 200,
                onChestTap: () => _onTap(MuscleGroup.chest),
                onAbsTap: () => _onTap(MuscleGroup.abs),
                onBicepsTap: () => _onTap(MuscleGroup.biceps),
                onObliquesTap: () => _onTap(MuscleGroup.obliques),
                onForearmsTap: () => _onTap(MuscleGroup.forearms),
                onQuadricepsTap: () => _onTap(MuscleGroup.quadriceps),
                onAdductorsTap: () => _onTap(MuscleGroup.adductors),
                onAbductorsTap: () => _onTap(MuscleGroup.abductors),
                onLateralDeltoidTap: () => _onTap(MuscleGroup.lateralDeltoid),
                onFrontDeltoidTap: () => _onTap(MuscleGroup.frontDeltoid),
              ),
            ),
            _Item(
              child: BackBodyCustomPaint(
                colors: BackMuscleColors(
                  back: _color(MuscleGroup.back),
                  traps: _color(MuscleGroup.traps),
                  lowerBack: _color(MuscleGroup.lowerBack),
                  glutes: _color(MuscleGroup.glutes),
                  triceps: _color(MuscleGroup.triceps),
                  rearDeltoid: _color(MuscleGroup.rearDeltoid),
                  hamstrings: _color(MuscleGroup.hamstrings),
                  calves: _color(MuscleGroup.calves),
                ),
                width: 200,
                onBackTap: () => _onTap(MuscleGroup.back),
                onTrapsTap: () => _onTap(MuscleGroup.traps),
                onLowerBackTap: () => _onTap(MuscleGroup.lowerBack),
                onGlutesTap: () => _onTap(MuscleGroup.glutes),
                onTricepsTap: () => _onTap(MuscleGroup.triceps),
                onRearDeltoidTap: () => _onTap(MuscleGroup.rearDeltoid),
                onHamstringsTap: () => _onTap(MuscleGroup.hamstrings),
                onCalvesTap: () => _onTap(MuscleGroup.calves),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: child,
      ),
    );
  }
}
