import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum FoodCreationOption { photo, youtube, manual }

class FoodCreationOptionsSheet extends StatelessWidget {
  const FoodCreationOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Registrar Comida',
            style: AppTextStyles.h3.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'Elige como quieres agregar la comida',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),
          _OptionTile(
            icon: LucideIcons.camera,
            title: 'Foto con IA',
            subtitle: 'Toma una foto y la IA detecta los ingredientes',
            color: AppColors.primary,
            onTap: () => Navigator.pop(context, FoodCreationOption.photo),
          ),
          const SizedBox(height: 12),
          _OptionTile(
            icon: LucideIcons.youtube,
            title: 'YouTube Short',
            subtitle: 'Pega un link de un Short y la IA analiza la receta',
            color: AppColors.error,
            onTap: () => Navigator.pop(context, FoodCreationOption.youtube),
          ),
          const SizedBox(height: 12),
          _OptionTile(
            icon: LucideIcons.penTool,
            title: 'Registro Manual',
            subtitle: 'Crea la comida seleccionando ingredientes',
            color: AppColors.info,
            onTap: () => Navigator.pop(context, FoodCreationOption.manual),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
