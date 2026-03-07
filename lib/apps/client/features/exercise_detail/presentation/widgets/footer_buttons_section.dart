import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FooterButtonsSection extends StatelessWidget {
  const FooterButtonsSection({
    super.key,
    required this.isStarted,
    required this.allDone,
    required this.onStartWorkout,
    required this.onRegisterSerie,
    required this.onCompleteAll,
  });

  final bool isStarted;
  final bool allDone;
  final VoidCallback onStartWorkout;
  final VoidCallback onRegisterSerie;
  final VoidCallback onCompleteAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        MediaQuery.of(context).viewPadding.bottom + AppSpacing.md,
      ),
      child: !isStarted
          ? _StartButton(onTap: onStartWorkout)
          : allDone
              ? const _DoneIndicator()
              : _RegisterRow(
                  onRegister: onRegisterSerie,
                  onCompleteAll: onCompleteAll,
                ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          'Comenzar entrenamiento',
          style: AppTextStyles.button.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _DoneIndicator extends StatelessWidget {
  const _DoneIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            LucideIcons.checkCircle,
            color: AppColors.black,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Ejercicio completado',
            style: AppTextStyles.button.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterRow extends StatelessWidget {
  const _RegisterRow({
    required this.onRegister,
    required this.onCompleteAll,
  });

  final VoidCallback onRegister;
  final VoidCallback onCompleteAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onRegister,
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                'Registrar serie',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        GestureDetector(
          onTap: onCompleteAll,
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: const Icon(
              LucideIcons.check,
              color: AppColors.black,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
