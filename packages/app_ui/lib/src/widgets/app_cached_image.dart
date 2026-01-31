import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../spacing/app_spacing.dart';

class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    Widget image = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? _defaultPlaceholder(context);
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _defaultErrorWidget(context);
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  Widget _defaultPlaceholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      color: isDark ? AppColors.grey800 : AppColors.grey200,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _defaultErrorWidget(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      color: isDark ? AppColors.grey800 : AppColors.grey200,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: isDark ? AppColors.grey600 : AppColors.grey400,
        size: 32,
      ),
    );
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppSpacing.avatarMd,
    this.backgroundColor,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: AppCachedImage(
          imageUrl: imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: _buildFallback(context),
        ),
      );
    }

    return _buildFallback(context);
  }

  Widget _buildFallback(BuildContext context) {
    final initials = _getInitials();
    final bgColor = backgroundColor ?? _getColorFromName();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: AppColors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';
    final words = name!.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  Color _getColorFromName() {
    if (name == null || name!.isEmpty) return AppColors.grey500;
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.blue,
      AppColors.green,
      AppColors.purple,
      AppColors.orange,
    ];
    final hash = name!.hashCode;
    return colors[hash.abs() % colors.length];
  }
}
