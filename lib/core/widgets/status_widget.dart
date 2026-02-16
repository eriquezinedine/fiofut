import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, this.isCompleted = false,});
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final color = isCompleted? AppColors.primary : AppColors.orange;
    final icon = isCompleted? LucideIcons.check : LucideIcons.clock;
    return Row(
      spacing: 6,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        Text(isCompleted? 'Completado': 'Pendiente',style: AppTextStyles.labelLarge.copyWith(color: color),),
      ],
    );
  }
}
