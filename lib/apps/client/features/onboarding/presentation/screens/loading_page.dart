import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fio_fut/apps/client/features/app_content/presentation/pages/app_content_page.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/providers/providers.dart';

/// Pantalla 12: Pantalla de carga completada
class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isComplete = false;
  bool _hasError = false;

  final List<_ChecklistItem> _checklistItems = [
    _ChecklistItem(
      icon: LucideIcons.flame,
      iconColor: AppColors.redBright,
      title: 'Calorías diarias',
      subtitle: '2,150 kcal objetivo',
    ),
    _ChecklistItem(
      icon: LucideIcons.wheat,
      iconColor: AppColors.orange,
      title: 'Carbohidratos',
      subtitle: '268g diarios',
    ),
    _ChecklistItem(
      icon: LucideIcons.beef,
      iconColor: AppColors.redBright,
      title: 'Proteína',
      subtitle: '161g diarios',
    ),
    _ChecklistItem(
      icon: LucideIcons.droplet,
      iconColor: AppColors.orange,
      title: 'Grasas',
      subtitle: '72g diarios',
    ),
    _ChecklistItem(
      icon: LucideIcons.heart,
      iconColor: AppColors.pink,
      title: 'Puntuación de salud',
      subtitle: '85 puntos',
    ),
    _ChecklistItem(
      icon: LucideIcons.dumbbell,
      iconColor: AppColors.purple,
      title: 'Ejercicios',
      subtitle: 'Plan de 4 días/semana',
    ),
  ];

  double get _progress => _controller.value * 100;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) => _saveAndNavigate());
  }

  Future<void> _saveAndNavigate() async {
    // Fase 1: animacion lenta hasta 90% mientras guarda en Supabase
    final saveFuture =
        ref.read(onboardingProvider.notifier).completeOnboarding();

    _controller.animateTo(
      0.9,
      duration: const Duration(seconds: 8),
      curve: Curves.decelerate,
    );

    final success = await saveFuture;

    if (!mounted) return;

    if (!success) {
      _controller.stop();
      setState(() => _hasError = true);
      return;
    }

    // Fase 2: save exitoso → acelera al 100%
    await _controller.animateTo(
      1.0,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
    );

    if (!mounted) return;

    setState(() => _isComplete = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) context.go(AppContentPage.path);
  }

  void _retry() {
    setState(() => _hasError = false);
    _controller.reset();
    _saveAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  // Progress circle
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return SizedBox(
                        width: 180,
                        height: 180,
                        child: CustomPaint(
                          painter: _ProgressCirclePainter(
                            progress: _controller.value,
                            color: _hasError ? AppColors.error : AppColors.green,
                          ),
                          child: Center(
                            child: Text(
                              '${_progress.toInt()}%',
                              style: AppTextStyles.h1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Title
                  Text(
                    _hasError
                        ? 'Error al guardar'
                        : '¡Todo listo!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _hasError
                        ? 'No se pudo guardar tu información. Intenta de nuevo.'
                        : 'Tu plan personalizado está preparado',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: _hasError
                          ? AppColors.error
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Checklist card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView.separated(
                        itemCount: _checklistItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = _checklistItems[index];
                          final isChecked = _isComplete ||
                              _controller.value >
                                  ((index + 1) / _checklistItems.length);
                          return _ChecklistRow(item: item, isChecked: isChecked);
                        },
                      ),
                    ),
                  ),
                  if (_hasError) ...[
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _retry,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: Text(
                            'Reintentar',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Confetti animation when complete
          if (_isComplete)
            Positioned.fill(
              top: 0,
              child: IgnorePointer(
                child: Lottie.asset(
                  'assets/lottie/confeti.json',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                  repeat: false,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChecklistItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  _ChecklistItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({
    required this.item,
    required this.isChecked,
  });

  final _ChecklistItem item;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: item.iconColor,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.white,
                ),
              ),
              Text(
                item.subtitle,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Icon(
          LucideIcons.checkCircle2,
          color: isChecked ? AppColors.green : AppColors.textMuted,
          size: 24,
        ),
      ],
    );
  }
}

class _ProgressCirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ProgressCirclePainter({required this.progress, this.color = AppColors.green});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 12.0;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.card
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressCirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
