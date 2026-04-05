import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HydrationGlassSection extends StatelessWidget {
  const HydrationGlassSection({
    super.key,
    required this.enabled,
    required this.onPreset,
  });

  final bool enabled;
  final ValueChanged<int> onPreset;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Añadir agua',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _GlassButton(
                    icon: LucideIcons.glassWater,
                    label: '250 ml',
                    onTap: () => onPreset(250),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GlassButton(
                    icon: LucideIcons.glassWater,
                    label: '500 ml',
                    onTap: () => onPreset(500),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GlassButton(
                    icon: LucideIcons.cupSoda,
                    label: '1 Litro',
                    onTap: () => onPreset(1000),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.blue, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
