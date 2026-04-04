import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/core/services/sync_orchestrator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Indica al usuario el estado de sincronización con el backend.
///
/// - Synced (verde): todo subido.
/// - Pending N (naranja): N cambios esperando conexión.
/// - Syncing... (azul): subiendo ahora.
/// - Error (rojo): falló el último intento.
class SyncStatusIndicator extends ConsumerWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncOrchestratorProvider);

    final (Color color, IconData icon, String label) = switch (syncState.status) {
      SyncStatus.syncing => (
          AppColors.info,
          LucideIcons.cloudCog,
          'Syncing...',
        ),
      SyncStatus.error => (
          AppColors.error,
          LucideIcons.cloudOff,
          'Error (${syncState.pendingCount})',
        ),
      SyncStatus.idle when syncState.hasPending => (
          AppColors.orange,
          LucideIcons.cloudOff,
          'Pending ${syncState.pendingCount}',
        ),
      SyncStatus.idle => (
          AppColors.primary,
          LucideIcons.cloud,
          'Synced',
        ),
    };

    return GestureDetector(
      onTap: syncState.hasPending
          ? () => ref.read(syncOrchestratorProvider.notifier).flushQueue()
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
