import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/add_exercise/add_exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/list-exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/muscle_reset.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExerciseHomePage extends StatelessWidget {
  const ExerciseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        const MuscleReset(),
        const SizedBox(height: 16),
        ExerciseTitleCard(),
        ListExercise(
          exercises: Exercise.sampleData,
          onExerciseTap: (exercise) {
            // TODO: navigate to exercise detail
          },
        ),
      ],
    );
  }
}

class ExerciseTitleCard extends StatelessWidget {
  const ExerciseTitleCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 16),
      child: GestureDetector(
        onTap: () => AddExerciseModal.show(
          context,
          exercises: Exercise.sampleData,
          recentExercises: Exercise.sampleData.take(2).toList(),
          onConfirm: (selected) {
            // TODO: agregar ejercicios seleccionados
          },
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.all(4).add(EdgeInsets.only(right: 0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ejercicios', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),),
              Row(
                spacing: 6,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.plus,color: AppColors.textDescription,size: 20,),
                  Text('Agregar ejercicios'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
