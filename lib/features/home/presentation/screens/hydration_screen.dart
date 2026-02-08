import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/models/models.dart';
import '../../domain/providers/providers.dart';

/// Hydration modal screen for tracking water intake.
class HydrationScreen extends ConsumerStatefulWidget {
  const HydrationScreen({super.key});

  @override
  ConsumerState<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends ConsumerState<HydrationScreen> {
  final _customAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize hydration state from home
    Future.microtask(() {
      ref.read(hydrationProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  /// Exit without saving - just reset and go back.
  void _cancelAndGoBack() {
    ref.read(hydrationProvider.notifier).reset();
    Navigator.of(context).pop();
  }

  /// Save to home and exit.
  void _saveAndGoBack() {
    ref.read(hydrationProvider.notifier).saveToHome();
    ref.read(hydrationProvider.notifier).reset();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final hydrationState = ref.watch(hydrationProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _cancelAndGoBack();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
        child: switch (hydrationState) {
          HydrationInitial() || HydrationLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            ),
          HydrationError(:final message) => Center(
              child: Text(
                'Error: $message',
                style: AppTextStyles.body.copyWith(color: AppColors.error),
              ),
            ),
          HydrationLoaded(
            :final consumed,
            :final goal,
            :final progress,
            :final progressPercent,
            :final records,
          ) =>
            Column(
              children: [
                // Header
                _buildHeader(context),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Circle section
                        _buildCircleSection(
                          consumed: consumed,
                          goal: goal,
                          progress: progress,
                          progressPercent: progressPercent,
                        ),

                        const SizedBox(height: 24),

                        // Glass section
                        _buildGlassSection(),

                        const SizedBox(height: 24),

                        // Custom amount section
                        _buildCustomSection(),

                        const SizedBox(height: 24),

                        // History section
                        _buildHistorySection(records),

                        const SizedBox(height: 24),

                        // Save button
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _cancelAndGoBack,
            child: const Icon(
              LucideIcons.arrowLeft,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const Text(
            'Hidratación',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildCircleSection({
    required int consumed,
    required int goal,
    required double progress,
    required int progressPercent,
  }) {
    return Center(
      child: Column(
        children: [
          // Big progress circle
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(
              painter: _HydrationCirclePainter(progress: progress),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.droplets,
                      color: AppColors.blue,
                      size: 32,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$consumed ml',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'de $goal ml',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$progressPercent% completado',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Añadir agua',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _GlassButton(
                icon: LucideIcons.glassWater,
                label: '250 ml',
                onTap: () =>
                    ref.read(hydrationProvider.notifier).addPresetWater(250),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GlassButton(
                icon: LucideIcons.glassWater,
                label: '500 ml',
                onTap: () =>
                    ref.read(hydrationProvider.notifier).addPresetWater(500),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GlassButton(
                icon: LucideIcons.cupSoda,
                label: '1 Litro',
                onTap: () =>
                    ref.read(hydrationProvider.notifier).addPresetWater(1000),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cantidad personalizada',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.droplet,
                color: AppColors.textMuted,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _customAmountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ingresa cantidad en ml',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    final amount = int.tryParse(value);
                    ref.read(hydrationProvider.notifier).setCustomAmount(amount);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(List<HydrationRecord> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hoy',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 12),
        if (records.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  LucideIcons.glassWater,
                  color: AppColors.textMuted,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'No has consumido agua todavía',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Añade tu primer vaso de agua',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textDimmed,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: records.map((record) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _HistoryRecord(
                  record: record,
                  onDelete: () {
                    ref
                        .read(hydrationProvider.notifier)
                        .deleteRecord(record.id);
                  },
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        // First add custom amount if any
        ref.read(hydrationProvider.notifier).addCustomAmount();
        _customAmountController.clear();
        // Then save to home and exit
        _saveAndGoBack();
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.plus,
              color: AppColors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Guardar cantidad',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Glass button widget for preset amounts.
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
            Icon(
              icon,
              color: AppColors.blue,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// History record widget.
class _HistoryRecord extends StatelessWidget {
  const _HistoryRecord({
    required this.record,
    required this.onDelete,
  });

  final HydrationRecord record;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.glassWater,
                color: AppColors.blue,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                '${record.amount} ml',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                record.time,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  LucideIcons.trash2,
                  color: AppColors.redBright,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the hydration progress circle.
class _HydrationCirclePainter extends CustomPainter {
  final double progress;

  _HydrationCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 12.0;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.surfaceAlt
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Progress arc (blue)
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = AppColors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HydrationCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
