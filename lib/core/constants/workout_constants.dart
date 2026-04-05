/// Fatiga por repeticion para el musculo principal.
/// Cada rep reduce la recuperacion del musculo principal por este %.
const double kFatiguePerRep = 1.15;

/// Fatiga por repeticion para musculos secundarios.
/// Menor impacto que el principal.
const double kFatiguePerRepSecondary = 0.25;

/// Horas para recuperacion completa de musculos grandes.
/// (pecho, espalda, espalda baja, cuadriceps, isquiotibiales, gluteos)
const double kRecoveryHoursLarge = 48.0;

/// Horas para recuperacion completa de musculos pequeños.
const double kRecoveryHoursSmall = 24.0;

/// Musculos grandes (>= 48h de recuperacion).
const kLargeMuscleGroups = {
  'chest', 'back', 'lower_back', 'quadriceps', 'hamstrings', 'glutes',
};

/// Calcula el porcentaje de recuperacion considerando el tiempo transcurrido.
/// [storedPercentage]: el % guardado en DB cuando se registro la fatiga.
/// [updatedAt]: cuando se guardo ese valor.
/// [muscleGroup]: snake_case del grupo muscular para saber si es grande/pequeno.
int calculateRecoveredPercentage({
  required int storedPercentage,
  required DateTime updatedAt,
  required String muscleGroup,
}) {
  final hoursPassed = DateTime.now().difference(updatedAt).inMinutes / 60.0;
  final totalHours = kLargeMuscleGroups.contains(muscleGroup)
      ? kRecoveryHoursLarge
      : kRecoveryHoursSmall;

  // % que se recupero naturalmente con el tiempo
  final recoveryGained = (hoursPassed / totalHours) * 100.0;

  return (storedPercentage + recoveryGained).clamp(0, 100).round();
}
