import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../spacing/app_spacing.dart';
import 'app_button.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.iconSize = 80,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? AppColors.grey400,
            ),
            AppSpacing.verticalLg,
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              AppSpacing.verticalSm,
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.verticalXl,
              AppButton(
                text: actionLabel!,
                onPressed: onAction,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppNoResultsState extends StatelessWidget {
  const AppNoResultsState({
    super.key,
    this.searchQuery,
    this.onClear,
  });

  final String? searchQuery;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.search_off_outlined,
      title: 'Sin resultados',
      description: searchQuery != null
          ? 'No se encontraron resultados para "$searchQuery"'
          : 'No se encontraron resultados',
      actionLabel: onClear != null ? 'Limpiar búsqueda' : null,
      onAction: onClear,
    );
  }
}

class AppNoConnectionState extends StatelessWidget {
  const AppNoConnectionState({
    super.key,
    this.onRetry,
  });

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.wifi_off_outlined,
      title: 'Sin conexión',
      description: 'Verifica tu conexión a internet e intenta de nuevo',
      actionLabel: onRetry != null ? 'Reintentar' : null,
      onAction: onRetry,
    );
  }
}

class AppEmptyCartState extends StatelessWidget {
  const AppEmptyCartState({
    super.key,
    this.onBrowse,
  });

  final VoidCallback? onBrowse;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.shopping_cart_outlined,
      title: 'Tu carrito está vacío',
      description: 'Agrega productos para comenzar tu pedido',
      actionLabel: onBrowse != null ? 'Ver productos' : null,
      onAction: onBrowse,
    );
  }
}
