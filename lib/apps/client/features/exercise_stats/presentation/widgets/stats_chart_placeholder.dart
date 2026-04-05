import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

/// Interactive chart widget with tappable data points, smooth bezier curves,
/// gradient fill, and a glassmorphism tooltip on tap.
class StatsChartPlaceholder extends StatefulWidget {
  const StatsChartPlaceholder({
    required this.title,
    required this.points,
    this.lineColor = AppColors.primary,
    this.unit = '',
    this.useWeekdayLabels = false,
    super.key,
  });

  final String title;
  final List<ExerciseStatsData> points;
  final Color lineColor;
  final String unit;
  final bool useWeekdayLabels;

  @override
  State<StatsChartPlaceholder> createState() => _StatsChartPlaceholderState();
}

class _StatsChartPlaceholderState extends State<StatsChartPlaceholder>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  late AnimationController _animController;
  late Animation<double> _animValue;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animValue = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectPoint(int? index) {
    if (index == _selectedIndex) {
      _animController.reverse().then((_) {
        if (mounted) setState(() => _selectedIndex = null);
      });
    } else {
      setState(() => _selectedIndex = index);
      _animController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalMd,
          SizedBox(
            height: 200,
            child: widget.points.isEmpty
                ? Center(
                    child: Text(
                      'Sin datos',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTapDown: (details) =>
                            _handleTap(details, constraints),
                        child: AnimatedBuilder(
                          animation: _animValue,
                          builder: (context, _) {
                            return CustomPaint(
                              size: Size(constraints.maxWidth, 200),
                              painter: _InteractiveChartPainter(
                                points: widget.points,
                                lineColor: widget.lineColor,
                                unit: widget.unit,
                                selectedIndex: _selectedIndex,
                                tooltipOpacity: _animValue.value,
                                useWeekdayLabels: widget.useWeekdayLabels,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _handleTap(TapDownDetails details, BoxConstraints constraints) {
    if (widget.points.isEmpty) return;

    const leftPad = 36.0;
    const rightPad = 12.0;
    const topPad = 8.0;
    const bottomPad = 32.0;

    final chartW = constraints.maxWidth - leftPad - rightPad;
    final chartH = 200 - topPad - bottomPad;

    final values = widget.points.map((p) => p.value).toList();
    final rawMin = values.reduce(math.min);
    final rawMax = values.reduce(math.max);
    // Si todos los valores son iguales, eje Y va de 0 al valor+20%
    final double minY;
    final double maxY;
    if (rawMin == rawMax) {
      minY = 0;
      maxY = rawMax > 0 ? rawMax * 1.2 : 1.0;
    } else {
      minY = rawMin;
      maxY = rawMax;
    }
    final rangeY = maxY - minY;

    final offsets = <Offset>[];
    for (var i = 0; i < widget.points.length; i++) {
      final dx =
          leftPad + (i / (widget.points.length - 1).clamp(1, 999)) * chartW;
      final dy = topPad + (1 - (values[i] - minY) / rangeY) * chartH;
      offsets.add(Offset(dx, dy));
    }

    // Find closest point within 30px tap radius
    int? closest;
    double minDist = 30;
    for (var i = 0; i < offsets.length; i++) {
      final dist = (offsets[i] - details.localPosition).distance;
      if (dist < minDist) {
        minDist = dist;
        closest = i;
      }
    }

    _selectPoint(closest);
  }
}

// ---------------------------------------------------------------------------
// Chart Painter
// ---------------------------------------------------------------------------

class _InteractiveChartPainter extends CustomPainter {
  _InteractiveChartPainter({
    required this.points,
    required this.lineColor,
    required this.unit,
    required this.selectedIndex,
    required this.tooltipOpacity,
    this.useWeekdayLabels = false,
  });

  static const _weekdayLabels = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do'];

  final List<ExerciseStatsData> points;
  final Color lineColor;
  final String unit;
  final int? selectedIndex;
  final double tooltipOpacity;
  final bool useWeekdayLabels;

  static const _leftPad = 36.0;
  static const _rightPad = 12.0;
  static const _topPad = 8.0;
  static const _bottomPad = 32.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final chartW = size.width - _leftPad - _rightPad;
    final chartH = size.height - _topPad - _bottomPad;

    final values = points.map((p) => p.value).toList();
    final rawMin = values.reduce(math.min);
    final rawMax = values.reduce(math.max);
    final double minY;
    final double maxY;
    if (rawMin == rawMax) {
      minY = 0;
      maxY = rawMax > 0 ? rawMax * 1.2 : 1.0;
    } else {
      minY = rawMin;
      maxY = rawMax;
    }
    final rangeY = maxY - minY;

    // Compute canvas offsets
    final offsets = <Offset>[];
    for (var i = 0; i < points.length; i++) {
      final dx =
          _leftPad + (i / (points.length - 1).clamp(1, 999)) * chartW;
      final dy = _topPad + (1 - (values[i] - minY) / rangeY) * chartH;
      offsets.add(Offset(dx, dy));
    }

    _drawGrid(canvas, size, chartW, chartH, minY, maxY, rangeY);
    _drawGradientFill(canvas, size, offsets, chartH);
    _drawLine(canvas, offsets);
    _drawDots(canvas, offsets);
    _drawXLabels(canvas, size, chartW);

    if (selectedIndex != null && tooltipOpacity > 0) {
      _drawTooltip(canvas, size, offsets);
    }
  }

  void _drawGrid(Canvas canvas, Size size, double chartW, double chartH,
      double minY, double maxY, double rangeY) {
    final gridPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;

    const gridRows = 4;
    for (var i = 0; i <= gridRows; i++) {
      final y = _topPad + chartH * i / gridRows;
      canvas.drawLine(
        Offset(_leftPad, y),
        Offset(size.width - _rightPad, y),
        gridPaint,
      );

      final val = maxY - (rangeY * i / gridRows);
      final tp = TextPainter(
        text: TextSpan(
          text: val.toInt().toString(),
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontFamily: 'Inter',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(_leftPad - tp.width - 6, y - tp.height / 2));
    }
  }

  void _drawGradientFill(
      Canvas canvas, Size size, List<Offset> offsets, double chartH) {
    final path = _buildSmoothPath(offsets);
    final fillPath = Path.from(path)
      ..lineTo(offsets.last.dx, _topPad + chartH)
      ..lineTo(offsets.first.dx, _topPad + chartH)
      ..close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.35),
          lineColor.withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromLTWH(0, _topPad, size.width, chartH),
      );
    canvas.drawPath(fillPath, gradientPaint);
  }

  void _drawLine(Canvas canvas, List<Offset> offsets) {
    final path = _buildSmoothPath(offsets);
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  void _drawDots(Canvas canvas, List<Offset> offsets) {
    for (var i = 0; i < offsets.length; i++) {
      final o = offsets[i];
      final isSelected = i == selectedIndex;

      if (isSelected) {
        // Glow ring
        canvas.drawCircle(
          o,
          12,
          Paint()..color = lineColor.withValues(alpha: 0.2 * tooltipOpacity),
        );
        canvas.drawCircle(
          o,
          8,
          Paint()..color = lineColor.withValues(alpha: 0.3 * tooltipOpacity),
        );
      }

      // Outer ring
      canvas.drawCircle(
        o,
        isSelected ? 6 : 4,
        Paint()..color = lineColor,
      );
      // Inner dot
      canvas.drawCircle(
        o,
        isSelected ? 3.5 : 2,
        Paint()..color = AppColors.card,
      );
    }
  }

  void _drawXLabels(Canvas canvas, Size size, double chartW) {
    // Show up to 7 labels evenly spaced
    final count = points.length;
    final step = count <= 7 ? 1 : (count / 6).ceil();

    for (var i = 0; i < count; i += step) {
      final dx =
          _leftPad + (i / (count - 1).clamp(1, 999)) * chartW;
      final date = points[i].date;
      final String label;
      if (useWeekdayLabels) {
        label = _weekdayLabels[(date.weekday - 1) % 7];
      } else {
        label = points[i].label ??
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
      }

      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontFamily: 'Inter',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(dx - tp.width / 2, size.height - _bottomPad + 10),
      );
    }
  }

  void _drawTooltip(Canvas canvas, Size size, List<Offset> offsets) {
    final idx = selectedIndex!;
    if (idx < 0 || idx >= points.length) return;

    final point = points[idx];
    final offset = offsets[idx];

    final valueText =
        '${point.value.toStringAsFixed(1)}$unit';
    final dateText = point.label ??
        '${point.date.day.toString().padLeft(2, '0')}/${point.date.month.toString().padLeft(2, '0')}/${point.date.year}';

    // Measure text
    final valueTp = TextPainter(
      text: TextSpan(
        text: valueText,
        style: TextStyle(
          color: AppColors.white.withValues(alpha: tooltipOpacity),
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final dateTp = TextPainter(
      text: TextSpan(
        text: dateText,
        style: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: tooltipOpacity),
          fontSize: 10,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final tooltipW =
        math.max(valueTp.width, dateTp.width) + 24;
    final tooltipH = valueTp.height + dateTp.height + 16;

    // Position tooltip above the point
    var tooltipX = offset.dx - tooltipW / 2;
    var tooltipY = offset.dy - tooltipH - 16;

    // Clamp within bounds
    tooltipX = tooltipX.clamp(4, size.width - tooltipW - 4);
    if (tooltipY < 0) tooltipY = offset.dy + 16;

    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tooltipX, tooltipY, tooltipW, tooltipH),
      const Radius.circular(12),
    );

    // Glassmorphism background
    canvas.save();
    canvas.clipRRect(tooltipRect);
    // Dark frosted glass
    canvas.drawRRect(
      tooltipRect,
      Paint()
        ..color = const Color(0xCC1A1A2E).withValues(alpha: tooltipOpacity),
    );
    canvas.restore();

    // Border
    canvas.drawRRect(
      tooltipRect,
      Paint()
        ..color = AppColors.border.withValues(alpha: 0.5 * tooltipOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Subtle glow at the top of tooltip
    final glowRect = Rect.fromLTWH(
        tooltipX, tooltipY, tooltipW, tooltipH * 0.5);
    canvas.drawRect(
      glowRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            lineColor.withValues(alpha: 0.08 * tooltipOpacity),
            lineColor.withValues(alpha: 0.0),
          ],
        ).createShader(glowRect),
    );

    // Draw text
    valueTp.paint(
      canvas,
      Offset(tooltipX + (tooltipW - valueTp.width) / 2,
          tooltipY + 6),
    );
    dateTp.paint(
      canvas,
      Offset(tooltipX + (tooltipW - dateTp.width) / 2,
          tooltipY + 6 + valueTp.height + 2),
    );

    // Draw connecting line from tooltip to point
    final lineStart = Offset(offset.dx, tooltipY + tooltipH);
    canvas.drawLine(
      lineStart,
      Offset(offset.dx, offset.dy - 8),
      Paint()
        ..color = lineColor.withValues(alpha: 0.3 * tooltipOpacity)
        ..strokeWidth = 1,
    );
  }

  Path _buildSmoothPath(List<Offset> offsets) {
    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (var i = 1; i < offsets.length; i++) {
      final prev = offsets[i - 1];
      final curr = offsets[i];
      final cpx = (prev.dx + curr.dx) / 2;
      path.cubicTo(cpx, prev.dy, cpx, curr.dy, curr.dx, curr.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _InteractiveChartPainter oldDelegate) =>
      points != oldDelegate.points ||
      lineColor != oldDelegate.lineColor ||
      selectedIndex != oldDelegate.selectedIndex ||
      tooltipOpacity != oldDelegate.tooltipOpacity ||
      useWeekdayLabels != oldDelegate.useWeekdayLabels;
}
