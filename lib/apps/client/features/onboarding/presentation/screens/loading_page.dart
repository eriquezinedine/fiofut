import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fio_fut/apps/client/features/app_content/presentation/pages/app_content_page.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 12: Pantalla de carga completada
class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  bool _isComplete = false;

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isComplete = true;
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(onboardingProvider.notifier);

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
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return SizedBox(
                        width: 180,
                        height: 180,
                        child: CustomPaint(
                          painter: _ProgressCirclePainter(
                            
                            progress: _progressAnimation.value / 100,
                          ),
                          child: Center(
                            child: Text(
                              '${_progressAnimation.value.toInt()}%',
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
                    '¡Todo listo!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tu plan personalizado está preparado',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
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
                              (_progressAnimation.value / 100) >
                                  ((index + 1) / _checklistItems.length);
                          return _ChecklistRow(item: item, isChecked: isChecked);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Start button
                  OnboardingContinueButton(
                    onPressed: _isComplete
                        ? () async {
                            final success =
                                await notifier.completeOnboarding();
                            if (success && context.mounted) {
                              context.go(AppContentPage.path);
                            }
                          }
                        : null,
                    text: 'Comenzar',
                    isEnabled: _isComplete,
                  ),
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

  _ProgressCirclePainter({required this.progress});

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
      ..color = AppColors.green
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
    return oldDelegate.progress != progress;
  }
}
