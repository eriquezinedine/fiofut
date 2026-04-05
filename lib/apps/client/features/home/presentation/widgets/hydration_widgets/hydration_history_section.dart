import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../domain/models/hydration_record.dart';

class HydrationHistorySection extends StatelessWidget {
  const HydrationHistorySection({
    super.key,
    required this.records,
    required this.enabled,
    required this.onDelete,
  });

  final List<HydrationRecord> records;
  final bool enabled;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historial',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (records.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(
                  LucideIcons.glassWater,
                  color: AppColors.textMuted,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'No has consumido agua todavía',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Añade tu primer vaso de agua',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textDimmed,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: records.map((record) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _HistoryRecord(
                  record: record,
                  onDelete: enabled ? () => onDelete(record.id) : null,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _HistoryRecord extends StatelessWidget {
  const _HistoryRecord({
    required this.record,
    this.onDelete,
  });

  final HydrationRecord record;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.glassWater,
                color: AppColors.blue,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                '${record.amount} ml',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                record.time,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    LucideIcons.trash2,
                    color: AppColors.redBright,
                    size: 18,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
