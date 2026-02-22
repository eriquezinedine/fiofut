import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons/lucide_icons.dart';

part 'item_serie_widget.dart';
part 'sire_body.dart';
part 'serie_headers.dart';
part 'serie_number_cell.dart';
part 'serie_text_field.dart';
part 'serie_row_by_kg.dart';
part 'serie_row_by_km.dart';
part 'serie_row_retry_only.dart';

enum RepiteType { byKg, byKm, retryOnly }

class SerieExerciseWidget extends ConsumerWidget {
  const SerieExerciseWidget({
    super.key,
    this.repiteType = RepiteType.byKm,
    this.groupType = SerieGroupType.effective,
    this.isStarted = false,
    this.currentSerieId,
    this.onRegisterSerie,
  });

  final RepiteType repiteType;
  final SerieGroupType groupType;
  final bool isStarted;
  final String? currentSerieId;
  final VoidCallback? onRegisterSerie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = switch (groupType) {
      SerieGroupType.effective => 'Series efectivas',
      SerieGroupType.warmup => 'Sets de calentamiento',
    };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24)
          .add(EdgeInsets.only(bottom: 0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SireBody(
            repiteType: repiteType,
            groupType: groupType,
            isStarted: isStarted,
            currentSerieId: currentSerieId,
            onRegisterSerie: onRegisterSerie,
          ),
        ],
      ),
    );
  }
}

// ── Añadir Serie button ─────────────────────────────────────────────

class AddSerieButton extends StatelessWidget {
  const AddSerieButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 20,
                color: AppColors.green,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Añadir Serie',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.green,
                letterSpacing: -0.28,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Cell container (shared decoration) ──────────────────────────────

class _CellContainer extends StatelessWidget {
  const _CellContainer({
    required this.isActive,
    required this.child,
    this.isStarted = false,
    this.isCurrent = false,
  });

  final bool isActive;
  final bool isStarted;
  final bool isCurrent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Color bg;

    if (!isStarted) {
      bg = isActive ? AppColors.white : AppColors.backgroundSecondary;
    } else if (!isActive) {
      // completed
      bg = AppColors.primary;
    } else if (isCurrent) {
      // current — white like setup
      bg = AppColors.white;
    } else {
      // pending
      bg = AppColors.card;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
