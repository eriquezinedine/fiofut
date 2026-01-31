import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../spacing/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.elevation,
    this.onTap,
    this.border,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final double? elevation;
  final VoidCallback? onTap;
  final BoxBorder? border;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.card) : null,
        gradient: gradient,
        borderRadius: borderRadius ?? AppSpacing.borderRadiusMd,
        border: border,
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: elevation! * 2,
                  offset: Offset(0, elevation!),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? AppSpacing.cardPadding,
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: (borderRadius ?? AppSpacing.borderRadiusMd) as BorderRadius?,
          child: card,
        ),
      );
    }

    return card;
  }
}

class AppProductCard extends StatelessWidget {
  const AppProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.originalPrice,
    this.description,
    this.rating,
    this.badge,
    this.onTap,
    this.onAddToCart,
  });

  final String imageUrl;
  final String title;
  final String price;
  final String? originalPrice;
  final String? description;
  final double? rating;
  final String? badge;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      elevation: AppSpacing.elevationSm,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusMd),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.grey200,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.grey400,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
              if (badge != null)
                Positioned(
                  top: AppSpacing.xs,
                  left: AppSpacing.xs,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppSpacing.borderRadiusXs,
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (description != null) ...[
                  AppSpacing.verticalXxs,
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                AppSpacing.verticalSm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          price,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (originalPrice != null)
                          Text(
                            originalPrice!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    if (rating != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.warning,
                            size: 16,
                          ),
                          AppSpacing.horizontalXxs,
                          Text(
                            rating!.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
