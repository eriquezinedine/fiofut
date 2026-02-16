import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExcerciseCardHeader extends StatelessWidget {
  const ExcerciseCardHeader({super.key, required this.exercise,});
  final Exercise exercise;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Stack(
            children: [
              _label(exercise.title + 'hola como estas todo bien'),
              _ghostText(),
            ],
          ),
        ),
        Icon(LucideIcons.moreVertical)
        // _StatusBadge(status: exercise.status),
      ],
    );
  }

  Opacity _ghostText() {
    return Opacity(
              opacity: 0,
              child: _label('Texto grande para que se separe en dos lineas siempre y sea automatico'));
  }

  Text _label(String text) {
    return Text(
          text,
          style: AppTextStyles.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
  }
}



// class _StatusBadge extends StatelessWidget {
//   const _StatusBadge({required this.status});

//   final ExerciseStatus status;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           _icon,
//           color: _color,
//           size: 16,
//         ),
//         const SizedBox(width: 4),
//         Text(
//           status.label,
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 11,
//             fontWeight: FontWeight.w500,
//             color: _color,
//           ),
//         ),
//       ],
//     );
//   }

//   IconData get _icon => switch (status) {
//         ExerciseStatus.pending => LucideIcons.clock4,
//         ExerciseStatus.inProgress => LucideIcons.activity,
//         ExerciseStatus.completed => LucideIcons.checkCircle,
//       };

//   Color get _color => switch (status) {
//         ExerciseStatus.pending => AppColors.textMuted,
//         ExerciseStatus.inProgress => AppColors.warning,
//         ExerciseStatus.completed => AppColors.primary,
//       };
// }
