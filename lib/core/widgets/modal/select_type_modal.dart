import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum ScheduleType { today, weekly }

class SelectTypeModal extends StatefulWidget {
  const SelectTypeModal._({required this.title});

  final String title;

  /// Muestra el modal para seleccionar tipo de programación.
  ///
  /// [title] se muestra como encabezado, ej: "Programar ejercicio" o "Programar comida".
  /// Retorna [ScheduleType.today] o [ScheduleType.weekly], o `null` si se cierra.
  static Future<ScheduleType?> show(
    BuildContext context, {
    required String title,
  }) {
    return showModalBottomSheet<ScheduleType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectTypeModal._(title: title),
    );
  }

  @override
  State<SelectTypeModal> createState() => _SelectTypeModalState();
}

class _SelectTypeModalState extends State<SelectTypeModal> {
  ScheduleType _selected = ScheduleType.today;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg - 4,
              vertical: AppSpacing.xs,
            ),
            child: Column(
              children: [
                _buildOption(
                  type: ScheduleType.today,
                  icon: LucideIcons.calendarCheck,
                  title: 'Solo por hoy',
                  subtitle: 'Agregar a tu rutina de hoy',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildOption(
                  type: ScheduleType.weekly,
                  icon: LucideIcons.calendarDays,
                  title: 'Rutina semanal',
                  subtitle: 'Programar días específicos',
                ),
              ],
            ),
          ),
          _buildButton(),
          SizedBox(
            height: MediaQuery.of(context).viewPadding.bottom + AppSpacing.xs,
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg - 4,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: AppTextStyles.h2,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              LucideIcons.x,
              color: AppColors.textPrimary,
              size: AppSpacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required ScheduleType type,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selected == type;

    return GestureDetector(
      onTap: () => setState(() => _selected = type),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppSpacing.borderRadiusXl,
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.textPrimary.withValues(alpha: 0.2),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                size: AppSpacing.iconMd,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxs),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _buildRadio(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : AppColors.card,
        border: isSelected
            ? null
            : Border.all(color: AppColors.surface, width: 1),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 12, color: AppColors.white)
          : null,
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg - 4,
        AppSpacing.md,
        AppSpacing.lg - 4,
        AppSpacing.lg,
      ),
      child: AppButton(
        text: 'Continuar',
        onPressed: () => Navigator.pop(context, _selected),
        fullWidth: true,
      ),
    );
  }
}
