import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/rps_back_custom_paint.dart';
import 'package:flutter/material.dart';
import 'package:model/src/muscle_group.dart';

class BackMuscleColors {
  const BackMuscleColors({
    this.back = AppColors.muscleDefaultColor,
    this.traps = AppColors.muscleDefaultColor,
    this.lowerBack = AppColors.muscleDefaultColor,
    this.glutes = AppColors.muscleDefaultColor,
    this.triceps = AppColors.muscleDefaultColor,
    this.rearDeltoid = AppColors.muscleDefaultColor,
    this.hamstrings = AppColors.muscleDefaultColor,
    this.calves = AppColors.muscleDefaultColor,
  });

  final Color back;
  final Color traps;
  final Color lowerBack;
  final Color glutes;
  final Color triceps;
  final Color rearDeltoid;
  final Color hamstrings;
  final Color calves;
}

class BackBodyCustomPaint extends StatefulWidget {
  const BackBodyCustomPaint({
    super.key,
    this.width = 200,
    this.colors = const BackMuscleColors(),
    this.onBackTap,
    this.onTrapsTap,
    this.onLowerBackTap,
    this.onGlutesTap,
    this.onTricepsTap,
    this.onRearDeltoidTap,
    this.onHamstringsTap,
    this.onCalvesTap,
  });

  final double width;
  final BackMuscleColors colors;
  final VoidCallback? onBackTap;
  final VoidCallback? onTrapsTap;
  final VoidCallback? onLowerBackTap;
  final VoidCallback? onGlutesTap;
  final VoidCallback? onTricepsTap;
  final VoidCallback? onRearDeltoidTap;
  final VoidCallback? onHamstringsTap;
  final VoidCallback? onCalvesTap;

  @override
  State<BackBodyCustomPaint> createState() => _BackBodyCustomPaintState();
}

class _BackBodyCustomPaintState extends State<BackBodyCustomPaint> {
  late RPSBackCustomPainter _painter;

  void _onTapDown(TapDownDetails details) {
    final muscle = _painter.hitTestMuscle(details.localPosition);

    final onFunction = switch (muscle) {
      // Back-visible muscles
      MuscleGroup.back => widget.onBackTap,
      MuscleGroup.traps => widget.onTrapsTap,
      MuscleGroup.lowerBack => widget.onLowerBackTap,
      MuscleGroup.glutes => widget.onGlutesTap,
      MuscleGroup.triceps => widget.onTricepsTap,
      MuscleGroup.rearDeltoid => widget.onRearDeltoidTap,
      MuscleGroup.hamstrings => widget.onHamstringsTap,
      MuscleGroup.calves => widget.onCalvesTap,
      _=> null,

      // Not visible from back
      // MuscleGroup.chest => null,
      // MuscleGroup.abs => null,
      // MuscleGroup.biceps => null,
      // MuscleGroup.obliques => null,
      // MuscleGroup.forearms => null,
      // MuscleGroup.quadriceps => null,
      // MuscleGroup.adductors => null,
      // MuscleGroup.abductors => null,
      // MuscleGroup.lateralDeltoid => null,
      // MuscleGroup.frontDeltoid => null,
    };

    onFunction?.call();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    _painter = RPSBackCustomPainter(
      backColor: c.back,
      trapsColor: c.traps,
      lowerBackColor: c.lowerBack,
      glutesColor: c.glutes,
      tricepsColor: c.triceps,
      rearDeltoidColor: c.rearDeltoid,
      hamstringsColor: c.hamstrings,
      calvesColor: c.calves,
    );
    return GestureDetector(
      onTapDown: _onTapDown,
      child: CustomPaint(
        size: Size(widget.width, (widget.width * 2.975)),
        painter: _painter,
      ),
    );
  }
}
