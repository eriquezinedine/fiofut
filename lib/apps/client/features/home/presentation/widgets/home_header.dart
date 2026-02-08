import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Height for the home header.
const double _kHomeHeaderHeight = 56;

/// Sliver header widget with Cal AI logo and streak badge.
/// Uses [SliverPersistentHeader] to pin during scroll.
class SliverHomeHeader extends StatelessWidget {
  const SliverHomeHeader({
    required this.streak,
    this.pinned = true,
    super.key,
  });

  final int streak;
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      delegate: _HomeHeaderDelegate(streak: streak),
    );
  }
}

/// Delegate for the home header.
class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HomeHeaderDelegate({required this.streak});

  final int streak;

  @override
  double get minExtent => _kHomeHeaderHeight;

  @override
  double get maxExtent => _kHomeHeaderHeight;

  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) {
    return streak != oldDelegate.streak;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: _kHomeHeaderHeight,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo row with apple icon and "Cal AI"
          Row(
            children: [
              const Icon(
                LucideIcons.apple,
                color: AppColors.white,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'Cal AI',
                style: AppTextStyles.h2.copyWith(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),

          // Streak badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.flame,
                  color: AppColors.orange,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  '$streak',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
