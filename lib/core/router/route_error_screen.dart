import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/app_content/presentation/pages/app_content_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteErrorScreen extends StatelessWidget {
  final Exception? error;

  const RouteErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Error',
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Pagina no encontrada',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            CustomGestureDetector(
              onTap: () => context.go(AppContentPage.path),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Text(
                  'Ir al inicio',
                  style: AppTextStyles.button.copyWith(color: AppColors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
