import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/providers/trainer_food_creation_provider.dart';

class YouTubeFoodScreen extends ConsumerStatefulWidget {
  const YouTubeFoodScreen({super.key});

  @override
  ConsumerState<YouTubeFoodScreen> createState() => _YouTubeFoodScreenState();
}

class _YouTubeFoodScreenState extends ConsumerState<YouTubeFoodScreen> {
  final _urlController = TextEditingController();
  bool _isValidUrl = false;
  String? _urlError;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _onUrlChanged(String value) {
    final text = value.trim();
    setState(() {
      if (text.isEmpty) {
        _isValidUrl = false;
        _urlError = null;
      } else if (!text.isYouTubeUrl) {
        _isValidUrl = false;
        _urlError = 'Ingresa una URL valida de YouTube';
      } else if (!text.isYouTubeShort) {
        _isValidUrl = false;
        _urlError = 'Solo se aceptan YouTube Shorts';
      } else {
        _isValidUrl = true;
        _urlError = null;
      }
    });
  }

  void _submit() {
    if (!_isValidUrl) return;
    ref
        .read(trainerFoodCreationProvider.notifier)
        .createFromYouTube(_urlController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final creationState = ref.watch(trainerFoodCreationProvider);
    final isProcessing = creationState is TrainerFoodCreationUploading ||
        creationState is TrainerFoodCreationAnalyzing;

    ref.listen(trainerFoodCreationProvider, (prev, next) {
      if (next is TrainerFoodCreationSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${next.foodTitle} registrada'),
            backgroundColor: AppColors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: isProcessing ? null : () => Navigator.pop(context),
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
        ),
        title: Text(
          'YouTube Short',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.youtube,
                    color: AppColors.error,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pega el enlace de un YouTube Short de cocina '
                      'y la IA analizara la receta.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'URL del video',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _urlController,
              onChanged: _onUrlChanged,
              enabled: !isProcessing,
              style: AppTextStyles.body.copyWith(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'https://youtube.com/shorts/...',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.card,
                prefixIcon: const Icon(
                  LucideIcons.link,
                  color: AppColors.textMuted,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            if (_urlError != null) ...[
              const SizedBox(height: 8),
              Text(
                _urlError!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ],
            if (creationState is TrainerFoodCreationError) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.alertCircle,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        creationState.message,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            if (isProcessing)
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Analizando short...',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Esto puede tomar unos segundos',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Analizar Short',
                  onPressed: _isValidUrl ? _submit : null,
                ),
              ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }
}
