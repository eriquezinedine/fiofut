import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/training_exercise/presentation/widgets/action_detail_exercise.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'training_top_bar.dart';

AppBar buildTrainingAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 50,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Padding(
      padding: EdgeInsets.only(left: AppSpacing.md),
      child: TapScaleAnimation(
        onTap: () => Navigator.pop(context),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.chevronLeft,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: AppSpacing.md),
        child: ActionDetailExercise(),
      ),
    ],
  );
}
