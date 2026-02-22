import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/rps_front_custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:model/src/muscle_group.dart';

class FrontMuscleColors {
  const FrontMuscleColors({
    this.chest = AppColors.muscleDefaultColor,
    this.abs = AppColors.muscleDefaultColor,
    this.biceps = AppColors.muscleDefaultColor,
    this.obliques = AppColors.muscleDefaultColor,
    this.forearms = AppColors.muscleDefaultColor,
    this.quadriceps = AppColors.muscleDefaultColor,
    this.adductors = AppColors.muscleDefaultColor,
    this.abductors = AppColors.muscleDefaultColor,
    this.lateralDeltoid = AppColors.muscleDefaultColor,
    this.frontDeltoid = AppColors.muscleDefaultColor,
  });

  final Color chest;
  final Color abs;
  final Color biceps;
  final Color obliques;
  final Color forearms;
  final Color quadriceps;
  final Color adductors;
  final Color abductors;
  final Color lateralDeltoid;
  final Color frontDeltoid;
}

class FrontBodyCustomPaint extends StatefulWidget {
  const FrontBodyCustomPaint({
    super.key,
    this.width = 200,
    this.colors = const FrontMuscleColors(),
    this.onChestTap,
    this.onAbsTap,
    this.onBicepsTap,
    this.onObliquesTap,
    this.onForearmsTap,
    this.onQuadricepsTap,
    this.onAdductorsTap,
    this.onAbductorsTap,
    this.onLateralDeltoidTap,
    this.onFrontDeltoidTap,
  });

  final double width;
  final FrontMuscleColors colors;
  final VoidCallback? onChestTap;
  final VoidCallback? onAbsTap;
  final VoidCallback? onBicepsTap;
  final VoidCallback? onObliquesTap;
  final VoidCallback? onForearmsTap;
  final VoidCallback? onQuadricepsTap;
  final VoidCallback? onAdductorsTap;
  final VoidCallback? onAbductorsTap;
  final VoidCallback? onLateralDeltoidTap;
  final VoidCallback? onFrontDeltoidTap;

  @override
  State<FrontBodyCustomPaint> createState() => _FrontBodyCustomPaintState();
}

class _FrontBodyCustomPaintState extends State<FrontBodyCustomPaint> {
  late RPSFrontCustomPainter _painter;

  void _onTapDown(TapDownDetails details) {
    final muscle = _painter.hitTestMuscle(details.localPosition);

    final onFunction = switch (muscle) {
      // Front-visible muscles
      MuscleGroup.chest => widget.onChestTap,
      MuscleGroup.abs => widget.onAbsTap,
      MuscleGroup.biceps => widget.onBicepsTap,
      MuscleGroup.obliques => widget.onObliquesTap,
      MuscleGroup.forearms => widget.onForearmsTap,
      MuscleGroup.quadriceps => widget.onQuadricepsTap,
      MuscleGroup.adductors => widget.onAdductorsTap,
      MuscleGroup.abductors => widget.onAbductorsTap,
      MuscleGroup.lateralDeltoid => widget.onLateralDeltoidTap,
      MuscleGroup.frontDeltoid => widget.onFrontDeltoidTap,
      // Not visible from front
      _ => null
    };

    onFunction?.call();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    _painter = RPSFrontCustomPainter(
      chest1Color: c.chest,
      chest2Color: c.chest,
      absColor: c.abs,
      bicep1Color: c.biceps,
      bicep2Color: c.biceps,
      obliques1Color: c.obliques,
      obliques2Color: c.obliques,
      forearms1Color: c.forearms,
      forearms2Color: c.forearms,
      quadriceps1Color: c.quadriceps,
      quadriceps2Color: c.quadriceps,
      adductors1Color: c.adductors,
      adductors2Color: c.adductors,
      abductors1Color: c.abductors,
      abductors2Color: c.abductors,
      lateralDeltoid1Color: c.lateralDeltoid,
      lateralDeltoid2Color: c.lateralDeltoid,
      frontDeltoid1Color: c.frontDeltoid,
      frontDeltoid2Color: c.frontDeltoid,
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
