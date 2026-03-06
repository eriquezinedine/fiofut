import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/workout_session_provider.dart';
import 'package:fio_fut/core/services/photo_storage/supabase_photo_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkoutCompleteModal extends ConsumerStatefulWidget {
  const WorkoutCompleteModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const WorkoutCompleteModal(),
    );
  }

  @override
  ConsumerState<WorkoutCompleteModal> createState() =>
      _WorkoutCompleteModalState();
}

class _WorkoutCompleteModalState extends ConsumerState<WorkoutCompleteModal> {
  File? _photoFile;
  bool _isUploading = false;

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1080,
      imageQuality: 85,
    );
    if (image == null) return;

    setState(() {
      _photoFile = File(image.path);
      _isUploading = true;
    });

    // Upload photo
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      final fileName =
          'workout_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storage = ref.read(workoutPhotoStorageProvider);
      final url = await storage.uploadPhoto(
        userId: userId,
        fileName: fileName,
        file: _photoFile!,
      );
      await ref.read(workoutSessionProvider.notifier).setPhoto(url);
    }

    if (mounted) {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(workoutSessionProvider);
    final minutes = session.elapsedSeconds ~/ 60;
    final seconds = session.elapsedSeconds % 60;

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
          // Drag handle
          Padding(
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
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg - 4,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Entrenamiento completado',
                    style: AppTextStyles.h2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(workoutSessionProvider.notifier).reset();
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    LucideIcons.x,
                    color: AppColors.textPrimary,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ],
            ),
          ),
          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg - 4,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: AppSpacing.borderRadiusXl,
              ),
              child: Row(
                children: [
                  _StatItem(
                    icon: LucideIcons.clock,
                    label: 'Duración',
                    value: '${minutes}m ${seconds.toString().padLeft(2, '0')}s',
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _StatItem(
                    icon: LucideIcons.dumbbell,
                    label: 'Ejercicios',
                    value: '${session.completedExercises}',
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _StatItem(
                    icon: LucideIcons.layers,
                    label: 'Series',
                    value: '${session.totalExercises}',
                  ),
                ],
              ),
            ),
          ),
          // Photo section
          if (_photoFile != null) ...[
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg - 4,
              ),
              child: ClipRRect(
                borderRadius: AppSpacing.borderRadiusXl,
                child: Stack(
                  children: [
                    Image.file(
                      _photoFile!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    if (_isUploading)
                      Positioned.fill(
                        child: Container(
                          color: AppColors.black.withValues(alpha: 0.4),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg - 4,
              AppSpacing.md,
              AppSpacing.lg - 4,
              AppSpacing.lg,
            ),
            child: Column(
              children: [
                if (_photoFile == null)
                  GestureDetector(
                    onTap: _takePhoto,
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                        border: Border.all(
                          color: AppColors.surface,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            LucideIcons.camera,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Tomar foto',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  text: 'Cerrar',
                  onPressed: () {
                    ref.read(workoutSessionProvider.notifier).reset();
                    Navigator.pop(context);
                  },
                  fullWidth: true,
                ),
              ],
            ),
          ),
          SizedBox(
            height:
                MediaQuery.of(context).viewPadding.bottom + AppSpacing.xs,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
