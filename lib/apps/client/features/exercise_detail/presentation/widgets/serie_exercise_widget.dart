import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider/serie_detail_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider/serie_detail_state.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/training_exercise/presentation/widgets/modal/edit_serie_value_modal.dart';
import 'package:fio_fut/core/widgets/modal/set_type_modal.dart';
import 'package:model/model.dart' show MuscleGroup;
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

class SerieExerciseWidget extends ConsumerWidget {
  const SerieExerciseWidget({
    super.key,
    required this.scheduleId,
    this.repiteType = MetricType.strength,
    this.currentSerieId,
    this.onRegisterSerie,
  });

  final String scheduleId;
  final MetricType repiteType;
  final String? currentSerieId;
  final VoidCallback? onRegisterSerie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8)
          .add(EdgeInsets.only(bottom: 0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registra tu entramiento',
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SireBody(
            scheduleId: scheduleId,
            repiteType: repiteType,
            currentSerieId: currentSerieId,
            onRegisterSerie: onRegisterSerie,
          ),
        ],
      ),
    );
  }
}

// ── Serie cell style helper ─────────────────────────────────────────

class SerieCellStyle {
  const SerieCellStyle._({
    required this.bg,
    required this.textColor,
  });

  final Color bg;
  final Color textColor;

  factory SerieCellStyle.resolve({
    required bool isCompleted,
    required bool isCurrent,
  }) {
    if (isCompleted) {
      return const SerieCellStyle._(bg: AppColors.primary, textColor: AppColors.black);
    }
    if (isCurrent) {
      return const SerieCellStyle._(bg: AppColors.white, textColor: AppColors.background);
    }
    return const SerieCellStyle._(bg: AppColors.card, textColor: AppColors.white);
  }

  BoxDecoration get decoration => BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      );

  TextStyle get valueTextStyle => AppTextStyles.caption.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      );

  TextStyle numberTextStyle(SetType setType) {
    final base = AppTextStyles.caption.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.32,
      height: 1.25,
    );
    return switch (setType) {
      SetType.normal => base.copyWith(color: textColor),
      SetType.warmup => base.copyWith(color: AppColors.orange),
      SetType.dropset => base.copyWith(color: AppColors.error),
    };
  }

  /// Decoration para la celda de número, respetando el color del tipo
  /// cuando está completada (warmup=orange, dropset=error).
  BoxDecoration numberDecoration(SetType setType) {
    if (setType == SetType.normal) return decoration;
    final typeColor = switch (setType) {
      SetType.warmup => AppColors.orange,
      SetType.dropset => AppColors.error,
      SetType.normal => bg,
    };
    return BoxDecoration(
      color: typeColor,
      borderRadius: BorderRadius.circular(8),
    );
  }
}

// ── Check cell for completing serie ─────────────────────────────────

class _SerieCheckCell extends StatelessWidget {
  const _SerieCheckCell({
    required this.isCompleted,
    required this.isCurrent,
    this.onTap,
  });

  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = SerieCellStyle.resolve(
      isCompleted: isCompleted,
      isCurrent: isCurrent,
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 35,
        height: 35,
        decoration: style.decoration,
        alignment: Alignment.center,
        child: Icon(
          LucideIcons.check,
          color: style.textColor,
          size: 16,
        ),
      ),
    );
  }
}

// ── Cell container (shared decoration) ──────────────────────────────

class _CellContainer extends StatelessWidget {
  const _CellContainer({
    required this.isCompleted,
    required this.child,
    this.isCurrent = false,
  });

  final bool isCompleted;
  final bool isCurrent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = SerieCellStyle.resolve(
      isCompleted: isCompleted,
      isCurrent: isCurrent,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 35,
      decoration: style.decoration,
      alignment: Alignment.center,
      child: child,
    );
  }
}
