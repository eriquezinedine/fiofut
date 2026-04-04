part of 'serie_exercise_widget.dart';

// ── Item Serie Widget (delegates to the correct row) ────────────────

class ItemSerieWidget extends ConsumerWidget {
  const ItemSerieWidget({
    super.key,
    required this.scheduleId,
    required this.repiteType,
    required this.serie,
    required this.index,
    this.currentSerieId,
    this.onRegisterSerie,
    this.onDelete,
    this.canDelete = false,
  });

  final String scheduleId;
  final MetricType repiteType;
  final ExerciseSetData serie;
  final int index;
  final String? currentSerieId;
  final VoidCallback? onRegisterSerie;
  final VoidCallback? onDelete;
  final bool canDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = serie.isCompleted;
    final isCurrent = serie.id == currentSerieId;

    Future<void> onNumberCellTap() async {
      final action = await SetTypeModal.show(context);
      if (action == null || !context.mounted) return;

      final notifier = ref.read(serieDetailProvider(scheduleId).notifier);
      if (action == SetTypeAction.delete) {
        notifier.removeSerie(serie.id);
      } else {
        final type = SetTypeModal.toSetType(action);
        if (type != null) notifier.updateSetType(serie.id, type);
      }
    }

    void onCheckCellTap() {
      ref.read(serieDetailProvider(scheduleId).notifier).toggleSerieCompleted(serie.id);
    }

    final child = _getItem(
      repiteType: repiteType,
      scheduleId: scheduleId,
      serie: serie,
      index: index,
      isCompleted: isCompleted,
      isCurrent: isCurrent,
      onNumberCellTap: onNumberCellTap,
      onCheckCellTap: onCheckCellTap,
    );

    if (!canDelete) return child;

    // Slidable desactivado temporalmente
    return Slidable(
      key: ValueKey(serie.id),
      enabled: false,
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.25,
        dismissible: DismissiblePane(
          onDismissed: () => onDelete?.call(),
        ),
        children: [
          CustomSlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: Colors.red,
            child: Builder(
              builder: (context) {
                final controller = Slidable.of(context);
                if (controller == null) {
                  return const Icon(
                    LucideIcons.trash2,
                    color: Colors.white,
                    size: 24,
                  );
                }
                return AnimatedBuilder(
                  animation: controller.animation,
                  builder: (context, child) {
                    final t =
                        (controller.animation.value / 0.25).clamp(0.0, 1.0);
                    return Transform.scale(scale: t, child: child);
                  },
                  child: const Icon(
                    LucideIcons.trash2,
                    color: Colors.white,
                    size: 24,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: child,
      ),
    );
  }
}

Widget _getItem({
  required MetricType repiteType,
  required String scheduleId,
  required ExerciseSetData serie,
  required int index,
  required bool isCompleted,
  required bool isCurrent,
  VoidCallback? onNumberCellTap,
  VoidCallback? onCheckCellTap,
}) {
  return switch (repiteType) {
    MetricType.strength => _SerieRowByKg(
        scheduleId: scheduleId,
        serie: serie,
        index: index,
        isCompleted: isCompleted,
        isCurrent: isCurrent,
        onNumberCellTap: onNumberCellTap,
        onCheckCellTap: onCheckCellTap,
      ),
    MetricType.cardio => _SerieRowByKm(
        scheduleId: scheduleId,
        serie: serie,
        index: index,
        isCompleted: isCompleted,
        isCurrent: isCurrent,
        onNumberCellTap: onNumberCellTap,
        onCheckCellTap: onCheckCellTap,
      ),
    MetricType.reps => _SerieRowRetryOnly(
        scheduleId: scheduleId,
        serie: serie,
        index: index,
        isCompleted: isCompleted,
        isCurrent: isCurrent,
        onNumberCellTap: onNumberCellTap,
        onCheckCellTap: onCheckCellTap,
      ),
  };
}
