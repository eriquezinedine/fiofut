import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/add_serie_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:fio_fut/apps/admin/features/exercises/domain/models/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/serie_set.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';

import '../../domain/providers/trainer_serie_config_provider.dart';

/// Maps admin ExerciseType → client RepiteType.
RepiteType repiteTypeFor(ExerciseType type) => switch (type) {
      ExerciseType.strength => RepiteType.byKg,
      ExerciseType.cardio => RepiteType.byKm,
      ExerciseType.reps => RepiteType.retryOnly,
    };

// ── Main card: exercise header + serie table + add button ────────────

class TrainerExerciseConfig extends ConsumerWidget {
  const TrainerExerciseConfig({super.key, required this.exercise});

  final Exercise exercise;

  RepiteType get _repiteType => repiteTypeFor(exercise.exerciseType);
  bool get _showKg => _repiteType != RepiteType.retryOnly;
  String get _middleHeader => switch (_repiteType) {
        RepiteType.byKg => 'Repeticiones',
        RepiteType.byKm => 'Tiempo',
        RepiteType.retryOnly => 'Repeticiones',
      };

  SerieConfigKey get _configKey =>
      (exerciseId: exercise.id, repiteType: _repiteType);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final series = ref.watch(trainerSerieConfigProvider(_configKey));
    final notifier =
        ref.read(trainerSerieConfigProvider(_configKey).notifier);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Exercise header ──
          _ExerciseHeader(exercise: exercise),
          const SizedBox(height: 14),

          // ── Column headers ──
          _ConfigHeaders(middleHeader: _middleHeader, showKg: _showKg),
          const SizedBox(height: 4),

          // ── Serie rows ──
          for (final serie in series)
            _ConfigSerieItem(
              key: ValueKey(serie.id),
              serie: serie,
              configKey: _configKey,
              repiteType: _repiteType,
              showKg: _showKg,
              canDelete: series.length > 1,
            ),

          // ── Add serie ──
          const SizedBox(height: 8),
          AddSerieButton(
            scheduleId: exercise.id,
            onTapSerie: () => notifier.addSerie(),
            onCompleteAll: () => notifier.completeAll(),
          ),
        ],
      ),
    );
  }
}

// ── Exercise header ──────────────────────────────────────────────────

class _ExerciseHeader extends StatelessWidget {
  const _ExerciseHeader({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: exercise.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    exercise.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      LucideIcons.dumbbell,
                      color: AppColors.textMuted,
                      size: 18,
                    ),
                  ),
                )
              : const Icon(
                  LucideIcons.dumbbell,
                  color: AppColors.textMuted,
                  size: 18,
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                exercise.exerciseType.displayName,
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Column headers (matches client _SerieHeaders) ────────────────────

class _ConfigHeaders extends StatelessWidget {
  const _ConfigHeaders({required this.middleHeader, this.showKg = true});

  final String middleHeader;
  final bool showKg;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.caption.copyWith(
      fontWeight: FontWeight.w500,
      color: AppColors.textDescription,
      letterSpacing: -0.28,
      height: 1.25,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text('Serie', textAlign: TextAlign.center, style: style),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(middleHeader,
                textAlign: TextAlign.center, style: style),
          ),
          if (showKg) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Text('Kg Añadidos',
                  textAlign: TextAlign.center, style: style),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Slidable serie item ──────────────────────────────────────────────

class _ConfigSerieItem extends ConsumerWidget {
  const _ConfigSerieItem({
    super.key,
    required this.serie,
    required this.configKey,
    required this.repiteType,
    required this.showKg,
    this.canDelete = false,
  });

  final SerieSet serie;
  final SerieConfigKey configKey;
  final RepiteType repiteType;
  final bool showKg;
  final bool canDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier =
        ref.read(trainerSerieConfigProvider(configKey).notifier);

    final row = switch (repiteType) {
      RepiteType.byKg => _ConfigRowByKg(
          serie: serie,
          onRepsChanged: (v) => notifier.updateReps(serie.id, v),
          onKgChanged: (v) => notifier.updateKg(serie.id, v),
        ),
      RepiteType.byKm => _ConfigRowByKm(
          serie: serie,
          onMinsChanged: (v) => notifier.updateMins(serie.id, v),
          onSegsChanged: (v) => notifier.updateSegs(serie.id, v),
          onKgChanged: (v) => notifier.updateKg(serie.id, v),
        ),
      RepiteType.retryOnly => _ConfigRowRetryOnly(
          serie: serie,
          onRepsChanged: (v) => notifier.updateReps(serie.id, v),
        ),
    };

    if (!canDelete) {
      return Padding(padding: const EdgeInsets.only(bottom: 8), child: row);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Slidable(
        key: ValueKey(serie.id),
        closeOnScroll: true,
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.25,
          dismissible: DismissiblePane(
            onDismissed: () => notifier.removeSerie(serie.id),
          ),
          children: [
            CustomSlidableAction(
              onPressed: (_) => notifier.removeSerie(serie.id),
              backgroundColor: Colors.red,
              child: Builder(
                builder: (context) {
                  final controller = Slidable.of(context);
                  if (controller == null) {
                    return const Icon(LucideIcons.trash2,
                        color: Colors.white, size: 24);
                  }
                  return AnimatedBuilder(
                    animation: controller.animation,
                    builder: (context, child) {
                      final t = (controller.animation.value / 0.25)
                          .clamp(0.0, 1.0);
                      return Transform.scale(scale: t, child: child);
                    },
                    child: const Icon(LucideIcons.trash2,
                        color: Colors.white, size: 24),
                  );
                },
              ),
            ),
          ],
        ),
        child: Material(color: Colors.transparent, child: row),
      ),
    );
  }
}

// ── Number cell (setup mode: white bg, dark text) ────────────────────

class _ConfigNumberCell extends StatelessWidget {
  const _ConfigNumberCell({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.background,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.32,
          height: 1.25,
        ),
      ),
    );
  }
}

// ── Cell container (setup mode: white bg) ────────────────────────────

class _ConfigCell extends StatelessWidget {
  const _ConfigCell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ── Row: strength (reps + kg) ────────────────────────────────────────

class _ConfigRowByKg extends StatefulWidget {
  const _ConfigRowByKg({
    required this.serie,
    required this.onRepsChanged,
    required this.onKgChanged,
  });

  final SerieSet serie;
  final ValueChanged<int> onRepsChanged;
  final ValueChanged<double> onKgChanged;

  @override
  State<_ConfigRowByKg> createState() => _ConfigRowByKgState();
}

class _ConfigRowByKgState extends State<_ConfigRowByKg> {
  final _kgFocusNode = FocusNode();

  @override
  void dispose() {
    _kgFocusNode.dispose();
    super.dispose();
  }

  String? _formatKg(double? kg) {
    if (kg == null) return null;
    return kg == kg.roundToDouble() ? kg.toInt().toString() : kg.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ConfigNumberCell(number: widget.serie.number),
        const SizedBox(width: 16),
        Expanded(
          child: _ConfigCell(
            child: SerieTextField(
              key: ValueKey('${widget.serie.id}_reps'),
              initialValue: widget.serie.reps?.toString(),
              hint: '0',
              // isActive: true,
              nextFocusNode: _kgFocusNode,
              autoAdvanceMs: 300,
              onChanged: (v) {
                final reps = int.tryParse(v);
                if (reps != null) widget.onRepsChanged(reps);
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ConfigCell(
            child: SerieTextField(
              key: ValueKey('${widget.serie.id}_kg'),
              initialValue: _formatKg(widget.serie.kg),
              hint: '0',
              // isActive: true,
              focusNode: _kgFocusNode,
              onChanged: (v) {
                final kg = double.tryParse(v);
                if (kg != null) widget.onKgChanged(kg);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ── Row: cardio (mins:segs + kg) ─────────────────────────────────────

class _ConfigRowByKm extends StatelessWidget {
  const _ConfigRowByKm({
    required this.serie,
    required this.onMinsChanged,
    required this.onSegsChanged,
    required this.onKgChanged,
  });

  final SerieSet serie;
  final ValueChanged<int> onMinsChanged;
  final ValueChanged<int> onSegsChanged;
  final ValueChanged<double> onKgChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ConfigNumberCell(number: serie.number),
        const SizedBox(width: 16),
        Expanded(
          child: _ConfigCell(
            child: Row(
              children: [
                Expanded(
                  child: SerieTextField(
                    key: ValueKey('${serie.id}_mins'),
                    initialValue: serie.mins?.toString().padLeft(2, '0'),
                    hint: '00',
                    // isActive: true,
                    maxLength: 2,
                    onChanged: (v) {
                      final mins = int.tryParse(v);
                      if (mins != null) onMinsChanged(mins);
                    },
                  ),
                ),
                Text(
                  ':',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.background,
                    fontSize: 20,
                    letterSpacing: -0.4,
                    height: 1.25,
                  ),
                ),
                Expanded(
                  child: SerieTextField(
                    key: ValueKey('${serie.id}_segs'),
                    initialValue: serie.segs?.toString().padLeft(2, '0'),
                    hint: '00',
                    // isActive: true,
                    maxLength: 2,
                    onChanged: (v) {
                      final segs = int.tryParse(v);
                      if (segs != null) onSegsChanged(segs);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ConfigCell(
            child: SerieTextField(
              key: ValueKey('${serie.id}_kg'),
              initialValue: serie.kg != null
                  ? (serie.kg == serie.kg!.roundToDouble()
                      ? serie.kg!.toInt().toString()
                      : serie.kg.toString())
                  : null,
              hint: '0',
              // isActive: true,
              onChanged: (v) {
                final kg = double.tryParse(v);
                if (kg != null) onKgChanged(kg);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ── Row: reps only ───────────────────────────────────────────────────

class _ConfigRowRetryOnly extends StatelessWidget {
  const _ConfigRowRetryOnly({
    required this.serie,
    required this.onRepsChanged,
  });

  final SerieSet serie;
  final ValueChanged<int> onRepsChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ConfigNumberCell(number: serie.number),
        const SizedBox(width: 16),
        Expanded(
          child: _ConfigCell(
            child: SerieTextField(
              key: ValueKey('${serie.id}_reps'),
              initialValue: serie.reps?.toString(),
              hint: '0',
              // isActive: true,
              onChanged: (v) {
                final reps = int.tryParse(v);
                if (reps != null) onRepsChanged(reps);
              },
            ),
          ),
        ),
      ],
    );
  }
}
