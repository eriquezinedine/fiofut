import 'package:model/model.dart';

extension MuscleGroupExtension on MuscleGroup {
  String get getIcon => switch (this) {
    MuscleGroup.abductors => 'assets/svg/abductores.svg',
    MuscleGroup.adductors => 'assets/svg/aductores.svg',
    MuscleGroup.forearms => 'assets/svg/antebrazos.svg',
    MuscleGroup.biceps => 'assets/svg/biceps.svg',
    MuscleGroup.quadriceps => 'assets/svg/cuadriceps.svg',
    MuscleGroup.frontDeltoid => 'assets/svg/deltoides_frontal.svg',
    MuscleGroup.lateralDeltoid => 'assets/svg/deltoides_lateral.svg',
    MuscleGroup.rearDeltoid => 'assets/svg/deltoides_posterior.svg',
    MuscleGroup.back => 'assets/svg/espalda.svg',
    MuscleGroup.calves => 'assets/svg/gemelos.svg',
    MuscleGroup.glutes => 'assets/svg/gluteos.svg',
    MuscleGroup.hamstrings => 'assets/svg/isquiotibiales.svg',
    MuscleGroup.lowerBack => 'assets/svg/lumbares.svg',
    MuscleGroup.obliques => 'assets/svg/oblicuos.svg',
    MuscleGroup.chest => 'assets/svg/pectorales.svg',
    MuscleGroup.abs => 'assets/svg/recto_abdominal.svg',
    MuscleGroup.traps => 'assets/svg/trapecio.svg',
    MuscleGroup.triceps => 'assets/svg/triceps.svg',
  };

  String get getLabel => switch (this) {
    MuscleGroup.abductors => 'Abductores',
    MuscleGroup.adductors => 'Aductores',
    MuscleGroup.forearms => 'Antebrazos',
    MuscleGroup.biceps => 'Bíceps',
    MuscleGroup.quadriceps => 'Cuádriceps',
    MuscleGroup.frontDeltoid => 'Deltoides Frontal',
    MuscleGroup.lateralDeltoid => 'Deltoides Lateral',
    MuscleGroup.rearDeltoid => 'Deltoides Posterior',
    MuscleGroup.back => 'Espalda',
    MuscleGroup.calves => 'Gemelos',
    MuscleGroup.glutes => 'Glúteos',
    MuscleGroup.hamstrings => 'Isquiotibiales',
    MuscleGroup.lowerBack => 'Lumbares',
    MuscleGroup.obliques => 'Oblicuos',
    MuscleGroup.chest => 'Pectorales',
    MuscleGroup.abs => 'Recto Abdominal',
    MuscleGroup.traps => 'Trapecio',
    MuscleGroup.triceps => 'Tríceps',
  };
}
