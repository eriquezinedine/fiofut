
import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/training_exercise/presentation/presentation.dart';
import 'package:fio_fut/src/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class TrainingPlaceHolderScreen extends StatelessWidget {
  const TrainingPlaceHolderScreen({
    super.key,
    required this.exercises,
    required this.onStart,
  });

  final List<ExerciseScheduleItem> exercises;
  final VoidCallback onStart ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagen de fondo
        Assets.img.menGym.image(
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
    
        // Fondo blur oscuro
        const TrainingBlurOverlay(),
    
        // Contenido: header arriba, body abajo
        SafeArea(
          bottom: false,
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TrainingHeader(),
                  TrainingBody(exercises: exercises),
                ],
              ),
            ),
          ),
        ),
    
        // Botón inferior
        TrainingStartButton(onTap: onStart),
      ],
    );
  }
}
