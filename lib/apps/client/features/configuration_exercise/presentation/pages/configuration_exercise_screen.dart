import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/configuration_exercise/domain/providers/configuration_exercise_provider/configuration_exercise_provider.dart';
import 'package:fio_fut/apps/client/features/configuration_exercise/domain/providers/configuration_exercise_provider/configuration_exercise_state.dart';
import 'package:fio_fut/apps/client/features/configuration_exercise/presentation/widgets/schedule_card.dart';
import 'package:fio_fut/core/widgets/modal/schedule_date_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:model/model.dart';

class ConfigurationExerciseScreen extends ConsumerWidget {
  const ConfigurationExerciseScreen({super.key});

  static const String path = '/configuration-exercise';
  static const String name = 'configuration-exercise';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(configurationExerciseProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Mis rutinas',
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: switch (state) {
        ConfigurationExerciseLoading() => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ConfigurationExerciseError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.alertTriangle,
                    color: AppColors.error, size: 32),
                const SizedBox(height: 12),
                Text(message,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => ref
                      .read(configurationExerciseProvider.notifier)
                      .loadSchedules(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ConfigurationExerciseLoaded(
          :final schedules,
          :final isOperating,
          :final operationError,
        ) =>
          Stack(
            children: [
              _ScheduleList(schedules: schedules),

              // Loading overlay durante operaciones
              if (isOperating)
                Positioned.fill(
                  child: ColoredBox(
                    color: AppColors.background.withValues(alpha: 0.6),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                ),

              // Error banner de operacion
              if (operationError != null)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _OperationErrorBanner(
                    message: operationError,
                    onDismiss: () => ref
                        .read(configurationExerciseProvider.notifier)
                        .clearOperationError(),
                  ),
                ),
            ],
          ),
        ConfigurationExerciseInitial() => const SizedBox.shrink(),
      },
    );
  }
}

class _ScheduleList extends ConsumerWidget {
  const _ScheduleList({required this.schedules});

  final List<ExerciseSchedule> schedules;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (schedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.calendar,
                  color: AppColors.textMuted, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes rutinas programadas',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Agrega ejercicios desde el home para crear rutinas',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: AppSpacing.paddingHorizontalMd
          .add(const EdgeInsets.only(top: 8, bottom: 80)),
      children: [
        Text(
          'Rutinas (${schedules.length})',
          style: AppTextStyles.bodyMedium
              .copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...schedules.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ScheduleCard(
                schedule: s,
                onTapEdit: () => _onEdit(context, ref, s),
                onTapDelete: s.canModify ? () => _onDelete(context, ref, s) : null,
              ),
            )),
      ],
    );
  }

  Future<void> _onEdit(
    BuildContext context,
    WidgetRef ref,
    ExerciseSchedule schedule,
  ) async {
    final initial = ScheduleDateResult(
      selectedDays: schedule.daysOfWeek,
      startDate: schedule.startDate,
      endDate: schedule.endDate,
    );

    final result = await ScheduleDateModal.show(
      context,
      initialResult: initial,
    );
    if (result == null) return;

    // Solo editar si cambio algo
    if (result.selectedDays == initial.selectedDays &&
        result.startDate == initial.startDate &&
        result.endDate == initial.endDate) return;

    if (!context.mounted) return;

    final success = await ref
        .read(configurationExerciseProvider.notifier)
        .updateScheduleRange(
          scheduleId: schedule.id,
          newDays: result.selectedDays,
          newStartDate: result.startDate,
          newEndDate: result.endDate,
        );

    if (context.mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rutina actualizada'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Future<void> _onDelete(
    BuildContext context,
    WidgetRef ref,
    ExerciseSchedule schedule,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        title: Text(
          'Eliminar rutina',
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Se eliminarán las sesiones futuras de "${schedule.exerciseName}". '
          'Las sesiones pasadas se mantienen.',
          style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Eliminar',
                style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    final success = await ref
        .read(configurationExerciseProvider.notifier)
        .deleteSchedule(schedule.id);

    if (context.mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rutina eliminada'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }
}

class _OperationErrorBanner extends StatelessWidget {
  const _OperationErrorBanner({
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(LucideIcons.alertCircle,
                color: AppColors.error, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(LucideIcons.x,
                  color: AppColors.error, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
