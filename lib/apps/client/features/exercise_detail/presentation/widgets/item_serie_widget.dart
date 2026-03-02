part of 'serie_exercise_widget.dart';

// ── Item Serie Widget (delegates to the correct row) ────────────────

class ItemSerieWidget extends StatelessWidget {
  const ItemSerieWidget({
    super.key,
    required this.repiteType,
    required this.serie,
    required this.isStarted,
    this.currentSerieId,
    this.lastCompletedId,
    this.onRegisterSerie,
    this.onDelete,
    this.canDelete = false,
  });

  final RepiteType repiteType;
  final SerieSet serie;
  final bool isStarted;
  final String? currentSerieId;
  final String? lastCompletedId;
  final VoidCallback? onRegisterSerie;
  final VoidCallback? onDelete;
  final bool canDelete;

  @override
  Widget build(BuildContext context) {
    final isActive = !serie.isCompleted;
    final isCurrent = serie.id == currentSerieId;
    final isLastCompleted = serie.id == lastCompletedId;
    final child = switch (repiteType) {
      RepiteType.byKg => _SerieRowByKg(
          serie: serie,
          isActive: isActive,
          isStarted: isStarted,
          isCurrent: isCurrent,
          isLastCompleted: isLastCompleted,
          onRegisterSerie: onRegisterSerie,
        ),
      RepiteType.byKm => _SerieRowByKm(
          serie: serie,
          isActive: isActive,
          isStarted: isStarted,
          isCurrent: isCurrent,
          isLastCompleted: isLastCompleted,
          onRegisterSerie: onRegisterSerie,
        ),
      RepiteType.retryOnly => _SerieRowRetryOnly(
          serie: serie,
          isActive: isActive,
          isStarted: isStarted,
          isCurrent: isCurrent,
          isLastCompleted: isLastCompleted,
          onRegisterSerie: onRegisterSerie,
        ),
    };

    if (!canDelete) return child;

    return Slidable(
      key: ValueKey(serie.id),
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
        color: AppColors.background,
        child: child,
      ),
    );
  }
}
