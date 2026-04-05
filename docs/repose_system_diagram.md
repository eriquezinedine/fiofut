```
┌─────────────────────────────────────────────────────────────────────────┐
│              SISTEMA DE REPOSO MUSCULAR - FIOFUT                        │
│              Estado actual + Plan de implementacion                      │
└─────────────────────────────────────────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════
 1. ORIGEN DE DATOS: De donde salen los musculos del dia?
═══════════════════════════════════════════════════════════════════════════

  ┌──────────────────────────────┐
  │  exerciseHomeProvider        │
  │  (ejercicios del dia)        │
  │                              │
  │  List<ExerciseScheduleItem>  │
  │  ┌────────────────────────┐  │
  │  │ Press banca  (chest)   │  │
  │  │ Curl biceps  (biceps)  │  │
  │  │ Press banca  (chest)   │  │  <- chest repetido
  │  │ Sentadilla   (quads)   │  │
  │  └────────────────────────┘  │
  └──────────────┬───────────────┘
                 |
                 v
  ┌──────────────────────────────────────────────┐
  │  FILTRAR + AGRUPAR por muscleGroup           │
  │                                              │
  │  exerciseScheduleItem.muscleGroup            │
  │                                              │
  │  chest  -> [Press banca, Press banca]        │
  │  biceps -> [Curl biceps]                     │
  │  quads  -> [Sentadilla]                      │
  │                                              │
  │  Resultado: 3 musculos unicos del dia        │
  │  (no 4, porque chest se agrupa)              │
  └──────────────┬───────────────────────────────┘
                 |
                 v
  ┌──────────────────────────────────────────────┐
  │  muscle_reset.dart (exercise_home)           │
  │  "Musculos a entrenar"                       │
  │                                              │
  │  SingleChildScrollView horizontal            │
  │  ┌────────┐ ┌────────┐ ┌────────┐           │
  │  │ Pecho  │ │ Biceps │ │ Quads  │           │
  │  │  40%   │ │  85%   │ │ 100%   │           │
  │  │NARANJA │ │ VERDE  │ │ VERDE  │           │
  │  └────────┘ └────────┘ └────────┘           │
  │                                              │
  │  ACTUAL: usa MuscleRepose.data (FAKE)        │
  │  PLAN:   filtrar de exerciseHomeProvider      │
  └──────────────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════
 2. COMO SE REDUCE EL PORCENTAJE? (ya implementado)
═══════════════════════════════════════════════════════════════════════════

  ┌──────────────┐
  │ Usuario      │
  │ completa     │
  │ serie        │
  └──────┬───────┘
         |
         v
  ┌──────────────────────────────────────────────┐
  │  serieDetailProvider.toggleSerieCompleted()   │
  │                                              │
  │  totalFatigue = sum(reps) x kFatiguePerRep   │
  │                                              │
  │  kFatiguePerRep = 1.25                       │
  │  (lib/core/constants/workout_constants.dart)  │
  │                                              │
  │  Ejemplo: 3 series x 10 reps                 │
  │  = 30 x 1.25 = 37.5% de fatiga              │
  └──────────────┬───────────────────────────────┘
                 |
                 v
  ┌──────────────────────────────────────────────┐
  │  allMusclesReposeProvider                    │
  │  .reduceMuscleProgress(chest, 37.5)          │
  │                                              │
  │  new% = (current - fatigue).clamp(0, 100)    │
  │  85% - 37.5% = 47.5% -> 48%                 │
  └──────────────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════
 3. PANTALLA DE EDICION (slider) + DEBOUNCER
═══════════════════════════════════════════════════════════════════════════

  ┌─────────────────────────────────────────────────────────┐
  │  ReposeSliderScreen                                     │
  │  "Editar recuperacion"                                  │
  │                                                         │
  │  ┌─────────────────────────────────────────────────┐    │
  │  │  Pecho          ████████░░░░ 48%  [──●──────]   │    │
  │  │  Biceps         ██████████░░ 85%  [────────●]   │    │
  │  │  Cuadriceps     ████████████ 100% [─────────●]  │    │
  │  └─────────────────────────────────────────────────┘    │
  │                                                         │
  │  Al arrastrar slider:                                   │
  │                                                         │
  │  muscleReposeProvider(muscle)                            │
  │       |                                                 │
  │       v                                                 │
  │  updateProgress(0.65)  <- UI INMEDIATA                  │
  │       |                                                 │
  │       v                                                 │
  │  allMusclesReposeProvider.updateMuscleProgress()         │
  │       |                                                 │
  │       v                                                 │
  │  DEBOUNCER (300ms)  <- evita spam al arrastrar          │
  │       |                                                 │
  │       v                                                 │
  │  OfflineAwareReposeRepo.syncMuscleProgress()             │
  │       |                                                 │
  │  ┌────┴────┐                                            │
  │  |         |                                            │
  │ OK      ERROR -> Isar (PendingReposeSync)               │
  └─────────────────────────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════
 4. FLUJO OFFLINE (NUEVO - separado del de ejercicios)
═══════════════════════════════════════════════════════════════════════════

  ┌─────────────────────────────────────────────────────────┐
  │  OFFLINE REPOSE SYNC                                    │
  │  (mismo patron que exercise, flujo independiente)       │
  │                                                         │
  │  ┌─────────────────────────────────────────────────┐    │
  │  │  Cambio de slider / fatiga por ejercicio        │    │
  │  └──────────────────────┬──────────────────────────┘    │
  │                         |                               │
  │                         v                               │
  │  ┌─────────────────────────────────────────────────┐    │
  │  │  OfflineAwareReposeRepository                   │    │
  │  │  try: Supabase                                  │    │
  │  │  catch: Isar (PendingReposeSync)                │    │
  │  │                                                 │    │
  │  │  Collection separada de PendingSyncOperation    │    │
  │  │  para no mezclar con ejercicios                 │    │
  │  └──────────────────────┬──────────────────────────┘    │
  │                         |                               │
  │                         v                               │
  │  ┌─────────────────────────────────────────────────┐    │
  │  │  ReposeSyncOrchestrator                         │    │
  │  │  (o reutilizar SyncOrchestrator con tipo)       │    │
  │  │                                                 │    │
  │  │  Triggers:                                      │    │
  │  │  - Connectivity restored                        │    │
  │  │  - App resumed                                  │    │
  │  │  - Home load                                    │    │
  │  │                                                 │    │
  │  │  flushReposeQueue()                             │    │
  │  └─────────────────────────────────────────────────┘    │
  └─────────────────────────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════
 5. TABLA SUPABASE (propuesta)
═══════════════════════════════════════════════════════════════════════════

  ┌─────────────────────────────────────────────────────────┐
  │  muscle_repose (tabla)                                  │
  │                                                         │
  │  id            UUID (PK)                                │
  │  user_id       UUID (FK -> auth.users)                  │
  │  muscle_group  TEXT ('chest', 'biceps', 'quads'...)     │
  │  percentage    INT (0-100)                              │
  │  updated_at    TIMESTAMPTZ                              │
  │                                                         │
  │  UNIQUE(user_id, muscle_group)                          │
  │  -> 1 fila por musculo por usuario                      │
  │  -> UPSERT al sincronizar                               │
  └─────────────────────────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════
 6. CONEXION COMPLETA (de ejercicio a reposo)
═══════════════════════════════════════════════════════════════════════════

  ┌──────────┐    ┌──────────────┐    ┌─────────────────┐
  │ Ejercicio│    │ Serie        │    │ Fatiga          │
  │ del dia  │───>│ completada   │───>│ calculada       │
  │ (chest)  │    │ 10 reps      │    │ 10 x 1.25=12.5 │
  └──────────┘    └──────────────┘    └────────┬────────┘
                                               |
                                               v
  ┌────────────────────────────────────────────────────────┐
  │  allMusclesReposeProvider                              │
  │  reduceMuscleProgress(chest, 12.5)                     │
  │                                                        │
  │  chest: 85% -> 72.5% -> 73%                            │
  │                                                        │
  │  UI se actualiza:                                      │
  │  - muscle_reset.dart (home)       -> barra naranja     │
  │  - repose_screen.dart             -> body diagram      │
  │  - repose_slider_screen.dart      -> slider position   │
  │  - SyncStatusIndicator            -> pending/synced    │
  └────────────────────────────────────────────────────────┘
       |                        |
       v                        v
  ┌──────────┐           ┌───────────┐
  │ Debouncer│           │ Offline   │
  │ (300ms)  │           │ Aware Repo│
  └────┬─────┘           └─────┬─────┘
       |                       |
       v                       v
  ┌──────────┐           ┌───────────┐
  │ Supabase │           │ Isar      │
  │ UPSERT   │           │ (si falla)│
  └──────────┘           └───────────┘


═══════════════════════════════════════════════════════════════════════════
 7. ESTADO ACTUAL vs PLAN
═══════════════════════════════════════════════════════════════════════════

  HECHO:
  ┌─────────────────────────────────────────────────────────┐
  │  [x] UI: sliders, body diagram, stats cards             │
  │  [x] State: allMusclesReposeProvider                    │
  │  [x] State: muscleReposeProvider (per-muscle slider)    │
  │  [x] Fatiga: reduceMuscleProgress desde series          │
  │  [x] Constante: kFatiguePerRep = 1.25                  │
  │  [x] Colores: rojo/naranja/verde                        │
  └─────────────────────────────────────────────────────────┘

  POR HACER:
  ┌─────────────────────────────────────────────────────────┐
  │  [ ] Filtrar musculos del dia desde exerciseHomeProvider │
  │  [ ] Reemplazar MuscleRepose.data (fake) por datos reales│
  │  [ ] Conectar repository a Supabase                      │
  │  [ ] Crear tabla muscle_repose en Supabase               │
  │  [ ] Debouncer en slider (300ms)                         │
  │  [ ] Offline: PendingReposeSync (Isar collection)        │
  │  [ ] Offline: OfflineAwareReposeRepository               │
  │  [ ] Stats reales: promedio, musculos en recuperacion    │
  │  [ ] Sync bidireccional: cargar % desde backend al abrir │
  └─────────────────────────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════
 8. ARCHIVOS INVOLUCRADOS
═══════════════════════════════════════════════════════════════════════════

  FEATURE: exercise_home (origen de datos)
  ├── widgets/muscle_reset.dart          <- widget horizontal de musculos
  ├── widgets/muscle_item.dart           <- item individual
  └── domain/model/muscle_repose.dart    <- modelo MuscleRepose

  FEATURE: repose (sistema de reposo)
  ├── data/
  │   └── repositories/
  │       ├── repose_repository.dart          <- abstract (interface)
  │       └── repose_repository_impl.dart     <- STUB (por implementar)
  ├── domain/
  │   ├── models/repose_item.dart             <- sesion de descanso
  │   └── providers/
  │       ├── all_muscles_repose_provider.dart <- estado global musculos
  │       ├── all_muscles_repose_state.dart    <- Map<MuscleGroup, MuscleRepose>
  │       ├── repose_provider.dart            <- timer de descanso
  │       └── repose_state.dart               <- estados del timer
  └── presentation/
      ├── screens/
      │   ├── repose_screen.dart              <- vista principal
      │   └── repose_slider_screen.dart       <- edicion con sliders
      └── widgets/
          ├── muscle_back_front_view.dart      <- diagrama anatomico
          ├── repose_list_sliders/
          │   ├── repose_list_sliders.dart     <- lista de sliders
          │   ├── muscle_repose_group_card.dart <- card con slider
          │   ├── muscle_progress_bar.dart     <- barra interactiva
          │   ├── progress_badge.dart          <- badge de %
          │   └── provider/
          │       ├── muscle_repose_provider.dart  <- estado per-slider
          │       └── muscle_repose_state.dart
          └── repose_screen_widgets/
              ├── repose_stats_section.dart     <- seccion de stats
              ├── repose_stat_card.dart         <- card individual
              └── most_used_muscles_section.dart <- top musculos

  CORE (compartido)
  └── constants/workout_constants.dart    <- kFatiguePerRep = 1.25
```
