enum MuscleGroup {
  abductors,
  adductors,
  forearms,
  biceps,
  quadriceps,
  frontDeltoid,
  lateralDeltoid,
  rearDeltoid,
  back,
  calves,
  glutes,
  hamstrings,
  lowerBack,
  obliques,
  chest,
  abs,
  traps,
  triceps;

  /// snake_case (DB) → camelCase (Dart)
  static MuscleGroup fromJson(String value) {
    return switch (value) {
      'abductors' => MuscleGroup.abductors,
      'adductors' => MuscleGroup.adductors,
      'forearms' => MuscleGroup.forearms,
      'biceps' => MuscleGroup.biceps,
      'quadriceps' => MuscleGroup.quadriceps,
      'front_deltoid' => MuscleGroup.frontDeltoid,
      'lateral_deltoid' => MuscleGroup.lateralDeltoid,
      'rear_deltoid' => MuscleGroup.rearDeltoid,
      'back' => MuscleGroup.back,
      'calves' => MuscleGroup.calves,
      'glutes' => MuscleGroup.glutes,
      'hamstrings' => MuscleGroup.hamstrings,
      'lower_back' => MuscleGroup.lowerBack,
      'obliques' => MuscleGroup.obliques,
      'chest' => MuscleGroup.chest,
      'abs' => MuscleGroup.abs,
      'traps' => MuscleGroup.traps,
      'triceps' => MuscleGroup.triceps,
      _ => throw ArgumentError('Unknown MuscleGroup: $value'),
    };
  }

  /// camelCase (Dart) → snake_case (DB)
  String toJson() {
    return switch (this) {
      MuscleGroup.abductors => 'abductors',
      MuscleGroup.adductors => 'adductors',
      MuscleGroup.forearms => 'forearms',
      MuscleGroup.biceps => 'biceps',
      MuscleGroup.quadriceps => 'quadriceps',
      MuscleGroup.frontDeltoid => 'front_deltoid',
      MuscleGroup.lateralDeltoid => 'lateral_deltoid',
      MuscleGroup.rearDeltoid => 'rear_deltoid',
      MuscleGroup.back => 'back',
      MuscleGroup.calves => 'calves',
      MuscleGroup.glutes => 'glutes',
      MuscleGroup.hamstrings => 'hamstrings',
      MuscleGroup.lowerBack => 'lower_back',
      MuscleGroup.obliques => 'obliques',
      MuscleGroup.chest => 'chest',
      MuscleGroup.abs => 'abs',
      MuscleGroup.traps => 'traps',
      MuscleGroup.triceps => 'triceps',
    };
  }
}
