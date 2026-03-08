import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/workout_flow_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddSerieButton extends ConsumerWidget {
  const AddSerieButton({
    super.key,
    required this.scheduleId,
    required this.onTapSerie,
    this.onCompleteAll,
  });

  final String scheduleId;
  final VoidCallback onTapSerie;
  final VoidCallback? onCompleteAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _AddSerieAction(onTap: onTapSerie),
          _CompleteSerieAction(
            scheduleId: scheduleId,
            onCompleteAll: onCompleteAll,
          ),
        ],
      ),
    );
  }
}

class _AddSerieAction extends StatelessWidget {
  const _AddSerieAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: ColoredBox(
        color: Colors.transparent,
        child: Row(
          spacing: 6,
          mainAxisSize: MainAxisSize.min,
          children: [
            _DecoratedIcon(icon: LucideIcons.plus),
            const _ActionLabel(text: 'Añadir Serie'),
          ],
        ),
      ),
    );
  }
}

class _CompleteSerieAction extends ConsumerWidget {
  const _CompleteSerieAction({
    required this.scheduleId,
    this.onCompleteAll,
  });

  final String scheduleId;
  final VoidCallback? onCompleteAll;

  Future<void> _handleCompleteAll(BuildContext context, WidgetRef ref) async {
    ref.read(workoutFlowProvider(scheduleId).notifier).completeAll();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomGestureDetector(
      onTap: () => _handleCompleteAll(context, ref),
      child: ColoredBox(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            const _ActionLabel(text: 'Marcar todas las series'),
            _DecoratedIcon(icon: LucideIcons.checkCheck),
          ],
        ),
      ),
    );
  }
}

class _DecoratedIcon extends StatelessWidget {
  const _DecoratedIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Padding(
    padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.green,
        ),
      ),
    );
  }
}

class _ActionLabel extends StatelessWidget {
  const _ActionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.labelMedium.copyWith(
        color: AppColors.green,
        letterSpacing: -0.28,
        height: 1.25,
      ),
    );
  }
}
