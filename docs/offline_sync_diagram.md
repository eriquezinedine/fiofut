```
┌─────────────────────────────────────────────────────────────────────────┐
│                        OFFLINE-FIRST SYNC - FIOFUT                      │
└─────────────────────────────────────────────────────────────────────────┘

    ┌──────────┐
    │ USUARIO  │
    │ edita    │
    │ serie    │
    └────┬─────┘
         │
         ▼
┌─────────────────────┐
│  serieDetailProvider │
│  ┌───────────────┐  │
│  │ UI INMEDIATA  │  │  ← state.copyWith() + _syncToHomeProvider()
│  │ (0ms)         │  │
│  └───────┬───────┘  │
│          │          │
│  ┌───────▼───────┐  │
│  │  DEBOUNCER    │  │  ← cancela si hay nuevo cambio en <300ms
│  │  (300ms)      │  │
│  └───────┬───────┘  │
└──────────┼──────────┘
           │
           ▼
┌──────────────────────────────┐
│  OfflineAwareExerciseRepo    │
│                              │
│  ┌────────────────────────┐  │
│  │  try: Supabase         │  │
│  └───────────┬────────────┘  │
│              │               │
│      ┌───────┴───────┐       │
│      │               │       │
│  ┌───▼───┐     ┌─────▼────┐  │
│  │  OK   │     │  ERROR   │  │
│  │       │     │ (no net, │  │
│  │       │     │ timeout) │  │
│  └───┬───┘     └─────┬────┘  │
│      │               │       │
│      │         ┌─────▼─────────────────────────────┐
│      │         │  Isar: PendingSyncOperation        │
│      │         │                                    │
│      │         │  setId (unique + replace)           │
│      │         │  ┌──────────────────────────────┐  │
│      │         │  │ 5 edits al mismo set =       │  │
│      │         │  │ solo el ULTIMO se guarda      │  │
│      │         │  │ (auto-dedup)                  │  │
│      │         │  └──────────────────────────────┘  │
│      │         │                                    │
│      │         │  operationType:                    │
│      │         │  - sync_set (reps, kg, mins, secs) │
│      │         │  - batch_toggle_true/false          │
│      │         │  - batch_values (propagar weight)   │
│      │         │  - add_set / delete_set             │
│      │         │                                    │
│      │         │  updatedAt: DateTime               │
│      │         └──────────┬────────────────────────┘
│      │                    │
│  ┌───▼───┐                │
│  │ DONE  │                │
│  └───────┘                │
│                           │
└───────────────────────────┼──────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────┐
│                  SYNC ORCHESTRATOR                    │
│                                                      │
│  ┌────────────────────────────────────────────────┐  │
│  │  TRIGGERS (cualquiera activa flushQueue)       │  │
│  │                                                │  │
│  │  1. Connectivity restored                      │  │
│  │     connectivityProvider -> stream -> true      │  │
│  │                                                │  │
│  │  2. App resumed                                │  │
│  │     WidgetsBindingObserver -> didChangeLifecycle│  │
│  │                                                │  │
│  │  3. Home screen load                           │  │
│  │     exerciseHomeProvider.build()                │  │
│  │                                                │  │
│  │  4. Tap manual en SyncStatusIndicator          │  │
│  └────────────────────┬───────────────────────────┘  │
│                       │                              │
│                       ▼                              │
│  ┌────────────────────────────────────────────────┐  │
│  │  flushQueue() [lock: _isSyncing]               │  │
│  │                                                │  │
│  │  1. Leer PendingSyncOps de Isar                │  │
│  │     |                                          │  │
│  │  2. Ordenar por prioridad:                     │  │
│  │     ┌──────────┬──────────┬──────────┐         │  │
│  │     │ add_set  │ sync_set │ delete   │         │  │
│  │     │ PRIMERO  │ batch_*  │ ULTIMO   │         │  │
│  │     └──────────┴──────────┴──────────┘         │  │
│  │     |                                          │  │
│  │  3. Por cada op -> Supabase (1 batch query)    │  │
│  │     |                                          │  │
│  │  ┌─────────┐        ┌──────────┐               │  │
│  │  │ SUCCESS │        │  FAIL    │               │  │
│  │  │ remove  │        │ retry++ │               │  │
│  │  │ de Isar │        │ queda    │               │  │
│  │  └─────────┘        └──────────┘               │  │
│  │     |                                          │  │
│  │  4. Si todo OK -> reload datos frescos         │  │
│  │     exerciseHomeProvider.reload()               │  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
│  Estado expuesto -> SyncOrchestratorState              │
│  { SyncStatus status, int pendingCount }              │
│                                                      │
└──────────────────────┬───────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────┐
│               SYNC STATUS INDICATOR                   │
│               (home_header widget)                    │
│                                                      │
│  ┌──────────────────────────────────────────────┐    │
│  │                                              │    │
│  │  Synced        -> verde  (pendingCount=0)    │    │
│  │  Pending 3     -> naranja (hay pendientes)   │    │
│  │  Syncing...    -> azul   (subiendo)          │    │
│  │  Error (3)     -> rojo   (fallo)             │    │
│  │                                              │    │
│  │  [tap] -> flushQueue() manual                │    │
│  │                                              │    │
│  └──────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────────┐
│  EJEMPLO: Usuario edita 3 series offline, luego vuelve internet        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  t=0s   Edita reps serie 1     -> UI ok -> Isar: {S1: reps=12}        │
│  t=0.2s Edita reps serie 1     -> UI ok -> Isar: {S1: reps=15}(replace)│
│  t=0.5s Completa series 1,2,3  -> UI ok -> Isar: {S1, batch_toggle}   │
│  t=1s   Edita kg serie 2       -> UI ok -> Isar: {S1, batch, S2:kg=65}│
│                                                                         │
│  Indicator: [Pending 3]                                                 │
│                                                                         │
│  t=30s  Internet vuelve                                                 │
│         -> connectivityProvider emite true                               │
│         -> SyncOrchestrator.flushQueue()                                │
│         -> 3 queries batch a Supabase (no 5)                            │
│         -> Isar vacio                                                   │
│         -> reload() datos frescos                                       │
│                                                                         │
│  Indicator: [Synced]                                                    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```
