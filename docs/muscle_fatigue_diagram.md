```
┌─────────────────────────────────────────────────────────────────────────┐
│              SISTEMA DE FATIGA MUSCULAR - FIOFUT                        │
└─────────────────────────────────────────────────────────────────────────┘


  CONSTANTE CONFIGURABLE (un solo lugar):
  ┌──────────────────────────────────────────────────────────┐
  │  lib/core/constants/workout_constants.dart                │
  │                                                          │
  │  const double kFatiguePerRep = 1.25;                     │
  │                                                          │
  │  Cada repeticion reduce 1.25% de recuperacion del musculo│
  │  Cambiar este valor afecta todo el sistema               │
  └──────────────────────────────────────────────────────────┘


  EJEMPLO: Usuario completa serie 4 (grupo: pecho)
  Series 1,2,3 estaban pendientes, serie 4 es el tap

  ┌─────────────────────────────────────────────────────────┐
  │  toggleSerieCompleted(serieId)                          │
  │                                                         │
  │  Recorre series del 0 hasta targetIndex (4):            │
  │  Solo suma las que NO estaban completadas antes.        │
  │                                                         │
  │  Serie 1: 10 reps  ->  10 x 1.25 = 12.5                │
  │  Serie 2:  8 reps  ->   8 x 1.25 = 10.0                │
  │  Serie 3: 12 reps  ->  12 x 1.25 = 15.0                │
  │  Serie 4:  6 reps  ->   6 x 1.25 =  7.5                │
  │                                     ─────               │
  │  totalFatigue                      = 45.0               │
  └───────────────────────────┬─────────────────────────────┘
                              |
                              v
  ┌─────────────────────────────────────────────────────────┐
  │  reduceMuscleProgress(MuscleGroup.chest, 45.0)          │
  │                                                         │
  │  FORMULA:                                               │
  │  ┌───────────────────────────────────────────────────┐  │
  │  │                                                   │  │
  │  │  newPercentage = (current - amount).clamp(0, 100) │  │
  │  │                                                   │  │
  │  │  Ejemplo:                                         │  │
  │  │  current = 85%  (pecho tenia 85% recuperacion)    │  │
  │  │  amount  = 45.0 (fatiga calculada)                │  │
  │  │                                                   │  │
  │  │  85 - 45 = 40                                     │  │
  │  │  clamp(0, 100) = 40                               │  │
  │  │  .round() = 40                                    │  │
  │  │                                                   │  │
  │  │  newPercentage = 40%                              │  │
  │  └───────────────────────────────────────────────────┘  │
  └───────────────────────────┬─────────────────────────────┘
                              |
                              v
  ┌─────────────────────────────────────────────────────────┐
  │  AllMusclesReposeState.muscles (Map):                   │
  │                                                         │
  │  MuscleGroup.chest   -> MuscleRepose(pecho,   40%)      │
  │  MuscleGroup.back    -> MuscleRepose(espalda, 90%)      │
  │  MuscleGroup.biceps  -> MuscleRepose(biceps, 100%)      │
  │  MuscleGroup.triceps -> MuscleRepose(triceps, 75%)      │
  └───────────────────────────┬─────────────────────────────┘
                              |
                              v
  ┌─────────────────────────────────────────────────────────┐
  │  COLOR POR PORCENTAJE (percentageColor)                 │
  │                                                         │
  │   0%          33%          66%          100%             │
  │   |───ROJO────|───NARANJA──|───VERDE─────|              │
  │                                                         │
  │   0-33%  = AppColors.error   (muy fatigado)             │
  │   34-66% = AppColors.warning (recuperandose)            │
  │   67-100%= AppColors.success (recuperado)               │
  │                                                         │
  │   Ejemplo: 40% = NARANJA                                │
  └─────────────────────────────────────────────────────────┘


  ┌─────────────────────────────────────────────────────────┐
  │  TABLA DE IMPACTO POR REPETICIONES                      │
  │                                                         │
  │  Reps  x  kFatiguePerRep  =  Fatiga por serie          │
  │  ─────────────────────────────────────────────────      │
  │    5   x  1.25  =   6.25%                               │
  │    8   x  1.25  =  10.00%                               │
  │   10   x  1.25  =  12.50%                               │
  │   12   x  1.25  =  15.00%                               │
  │   15   x  1.25  =  18.75%                               │
  │   20   x  1.25  =  25.00%                               │
  │                                                         │
  │  3 series de 10 reps = 3 x 12.5 = 37.5% de fatiga      │
  │  5 series de 12 reps = 5 x 15.0 = 75.0% de fatiga      │
  └─────────────────────────────────────────────────────────┘


  ┌─────────────────────────────────────────────────────────┐
  │  FLUJO VISUAL EN LA APP                                 │
  │                                                         │
  │  Antes del ejercicio:                                   │
  │  ┌──────────────────────────┐                           │
  │  │  Pecho: ████████░░ 85%   │  VERDE                    │
  │  └──────────────────────────┘                           │
  │                                                         │
  │  Despues de completar 4 series (36 reps total):         │
  │  ┌──────────────────────────┐                           │
  │  │  Pecho: ████░░░░░░ 40%   │  NARANJA                  │
  │  └──────────────────────────┘                           │
  │                                                         │
  │  Si sigue entrenando (20 reps mas = 25% fatiga):        │
  │  ┌──────────────────────────┐                           │
  │  │  Pecho: ██░░░░░░░░ 15%   │  ROJO                     │
  │  └──────────────────────────┘                           │
  └─────────────────────────────────────────────────────────┘


  ┌─────────────────────────────────────────────────────────┐
  │  ARCHIVOS INVOLUCRADOS                                  │
  │                                                         │
  │  lib/core/constants/workout_constants.dart               │
  │  -> kFatiguePerRep = 1.25 (CONFIGURABLE)                │
  │                                                         │
  │  lib/.../serie_detail_provider.dart                      │
  │  -> toggleSerieCompleted() calcula totalFatigue          │
  │  -> llama reduceMuscleProgress()                         │
  │                                                         │
  │  lib/.../repose/domain/providers/                        │
  │     all_muscles_repose_provider.dart                     │
  │  -> reduceMuscleProgress(group, amount)                  │
  │  -> updateMuscleProgress(group, percentage)              │
  │                                                         │
  │  lib/.../repose/domain/providers/                        │
  │     all_muscles_repose_state.dart                        │
  │  -> Map<MuscleGroup, MuscleRepose>                       │
  │                                                         │
  │  packages/model/lib/src/muscle_repose.dart               │
  │  -> MuscleRepose { muscle, percentage, percentageColor } │
  └─────────────────────────────────────────────────────────┘
```
