import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:flutter/material.dart';

/// Resultado del modal con los valores editados según el [MetricType].
class SerieValueResult {
  const SerieValueResult({
    this.reps,
    this.weight,
    this.minutes,
    this.seconds,
    this.distance,
  });

  final int? reps;
  final double? weight;
  final int? minutes;
  final int? seconds;
  final double? distance;
}

class EditSerieValueModal extends StatefulWidget {
  const EditSerieValueModal._({
    required this.metricType,
    required this.exerciseName,
    required this.serieLabel,
    this.initialReps,
    this.initialWeight,
    this.initialMinutes,
    this.initialSeconds,
    this.initialDistance,
  });

  final MetricType metricType;
  final String exerciseName;
  final String serieLabel;
  final int? initialReps;
  final double? initialWeight;
  final int? initialMinutes;
  final int? initialSeconds;
  final double? initialDistance;

  static Future<SerieValueResult?> show(
    BuildContext context, {
    required MetricType metricType,
    required String exerciseName,
    required String serieLabel,
    int? initialReps,
    double? initialWeight,
    int? initialMinutes,
    int? initialSeconds,
    double? initialDistance,
  }) {
    return showModalBottomSheet<SerieValueResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditSerieValueModal._(
        metricType: metricType,
        exerciseName: exerciseName,
        serieLabel: serieLabel,
        initialReps: initialReps,
        initialWeight: initialWeight,
        initialMinutes: initialMinutes,
        initialSeconds: initialSeconds,
        initialDistance: initialDistance,
      ),
    );
  }

  @override
  State<EditSerieValueModal> createState() => _EditSerieValueModalState();
}

class _EditSerieValueModalState extends State<EditSerieValueModal> {
  // Reps
  late final FixedExtentScrollController _repsController;
  // Weight (entero + decimal)
  late final FixedExtentScrollController _weightIntController;
  late final FixedExtentScrollController _weightDecController;
  // Minutes / Seconds
  late final FixedExtentScrollController _minController;
  late final FixedExtentScrollController _secController;
  // Distance (entero + decimal)
  late final FixedExtentScrollController _distIntController;
  late final FixedExtentScrollController _distDecController;

  static const _maxReps = 100;
  static const _maxWeightInt = 300;
  static const _weightDecimals = [0, 25, 50, 75];
  static const _maxMin = 120;
  static const _maxSec = 59;
  static const _maxDistInt = 100;
  static const _distDecimals = [0, 25, 50, 75];

  @override
  void initState() {
    super.initState();
    _repsController = FixedExtentScrollController(
      initialItem: (widget.initialReps ?? 10).clamp(0, _maxReps),
    );

    final wInt = (widget.initialWeight ?? 0).truncate().clamp(0, _maxWeightInt);
    final wDec = ((((widget.initialWeight ?? 0) - wInt) * 100).round()).clamp(0, 75);
    _weightIntController = FixedExtentScrollController(initialItem: wInt);
    _weightDecController = FixedExtentScrollController(
      initialItem: _weightDecimals.indexOf(_closestDecimal(wDec, _weightDecimals)),
    );

    _minController = FixedExtentScrollController(
      initialItem: (widget.initialMinutes ?? 0).clamp(0, _maxMin),
    );
    _secController = FixedExtentScrollController(
      initialItem: (widget.initialSeconds ?? 0).clamp(0, _maxSec),
    );

    final dInt = (widget.initialDistance ?? 0).truncate().clamp(0, _maxDistInt);
    final dDec = ((((widget.initialDistance ?? 0) - dInt) * 100).round()).clamp(0, 75);
    _distIntController = FixedExtentScrollController(initialItem: dInt);
    _distDecController = FixedExtentScrollController(
      initialItem: _distDecimals.indexOf(_closestDecimal(dDec, _distDecimals)),
    );
  }

  int _closestDecimal(int value, List<int> options) {
    return options.reduce((a, b) => (a - value).abs() < (b - value).abs() ? a : b);
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightIntController.dispose();
    _weightDecController.dispose();
    _minController.dispose();
    _secController.dispose();
    _distIntController.dispose();
    _distDecController.dispose();
    super.dispose();
  }

  void _confirm() {
    final result = switch (widget.metricType) {
      MetricType.strength => SerieValueResult(
          reps: _repsController.selectedItem,
          weight: _weightIntController.selectedItem +
              _weightDecimals[_weightDecController.selectedItem] / 100,
        ),
      MetricType.cardio => SerieValueResult(
          minutes: _minController.selectedItem,
          seconds: _secController.selectedItem,
          distance: _distIntController.selectedItem +
              _distDecimals[_distDecController.selectedItem] / 100,
        ),
      MetricType.reps => SerieValueResult(
          reps: _repsController.selectedItem,
        ),
    };
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: AppSpacing.sm),
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          // Header
          Padding(
            padding: AppSpacing.paddingHorizontalMd,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${widget.exerciseName.toUpperCase()} (${widget.serieLabel})',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          const Divider(color: AppColors.surface, height: 1),
          // Pickers
          SizedBox(
            height: 260,
            child: _buildPickers(),
          ),
          // Confirm button
          Padding(
            padding: AppSpacing.paddingHorizontalMd.add(
              EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + AppSpacing.md),
            ),
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: _confirm,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Padding(
                    padding: AppSpacing.paddingAllSm,
                    child: Text(
                      'Confirmar',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickers() {
    return switch (widget.metricType) {
      MetricType.strength => Row(
          children: [
            Expanded(
              child: _buildWheelGroup(
                controller: _repsController,
                maxValue: _maxReps,
                label: 'REPS',
              ),
            ),
            Expanded(
              child: _buildDecimalWheelGroup(
                intController: _weightIntController,
                decController: _weightDecController,
                maxInt: _maxWeightInt,
                decimals: _weightDecimals,
                label: 'KG',
              ),
            ),
          ],
        ),
      MetricType.cardio => Row(
          children: [
            Expanded(
              child: _buildTimeWheelGroup(
                minController: _minController,
                secController: _secController,
                maxMin: _maxMin,
                maxSec: _maxSec,
              ),
            ),
            Expanded(
              child: _buildDecimalWheelGroup(
                intController: _distIntController,
                decController: _distDecController,
                maxInt: _maxDistInt,
                decimals: _distDecimals,
                label: 'KM',
              ),
            ),
          ],
        ),
      MetricType.reps => Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 2,
              child: _buildWheelGroup(
                controller: _repsController,
                maxValue: _maxReps,
                label: 'REPS',
              ),
            ),
            const Spacer(),
          ],
        ),
    };
  }

  /// Wheel simple: un solo valor entero con label.
  Widget _buildWheelGroup({
    required FixedExtentScrollController controller,
    required int maxValue,
    required String label,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Highlight bar
        _HighlightBar(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 260,
              child: _Wheel(controller: controller, itemCount: maxValue + 1),
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Wheel con parte entera + parte decimal (0, 25, 50, 75) + label.
  Widget _buildDecimalWheelGroup({
    required FixedExtentScrollController intController,
    required FixedExtentScrollController decController,
    required int maxInt,
    required List<int> decimals,
    required String label,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _HighlightBar(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 260,
              child: _Wheel(controller: intController, itemCount: maxInt + 1),
            ),
            Text(
              '.',
              style: AppTextStyles.h2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 50,
              height: 260,
              child: _DecimalWheel(controller: decController, decimals: decimals),
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Wheel de tiempo: min : sec
  Widget _buildTimeWheelGroup({
    required FixedExtentScrollController minController,
    required FixedExtentScrollController secController,
    required int maxMin,
    required int maxSec,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _HighlightBar(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 260,
              child: _Wheel(controller: minController, itemCount: maxMin + 1, padZero: true),
            ),
            Text(
              ':',
              style: AppTextStyles.h2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 50,
              height: 260,
              child: _Wheel(controller: secController, itemCount: maxSec + 1, padZero: true),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Highlight bar behind selected item ──────────────────────────────

class _HighlightBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: AppSpacing.paddingHorizontalSm,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
    );
  }
}

// ── Wheel for integer values ────────────────────────────────────────

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.controller,
    required this.itemCount,
    this.padZero = false,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final bool padZero;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 44,
      perspective: 0.003,
      diameterRatio: 1.5,
      physics: const FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          return Center(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final selected = controller.selectedItem == index;
                return Text(
                  padZero ? index.toString().padLeft(2, '0') : '$index',
                  style: AppTextStyles.h2.copyWith(
                    color: selected ? AppColors.textPrimary : AppColors.textMuted,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w400,
                    fontSize: selected ? 24 : 18,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ── Wheel for decimal values (0, 25, 50, 75) ───────────────────────

class _DecimalWheel extends StatelessWidget {
  const _DecimalWheel({
    required this.controller,
    required this.decimals,
  });

  final FixedExtentScrollController controller;
  final List<int> decimals;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 44,
      perspective: 0.003,
      diameterRatio: 1.5,
      physics: const FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: decimals.length,
        builder: (context, index) {
          return Center(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final selected = controller.selectedItem == index;
                return Text(
                  decimals[index].toString().padLeft(2, '0'),
                  style: AppTextStyles.h2.copyWith(
                    color: selected ? AppColors.textPrimary : AppColors.textMuted,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w400,
                    fontSize: selected ? 24 : 18,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
