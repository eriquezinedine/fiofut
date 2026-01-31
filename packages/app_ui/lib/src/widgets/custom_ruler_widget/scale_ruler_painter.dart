import 'package:flutter/material.dart';

import 'enums.dart';

/// Custom painter that draws the ruler scale lines and labels.
class ScaleRulerPainter extends CustomPainter {
  /// Creates a [ScaleRulerPainter].
  ScaleRulerPainter({
    required this.minRange,
    required this.maxRange,
    required this.lineSpacing,
    required this.pixelSpacing,
    required this.rulerHeight,
    required this.alignmentPosition,
    required this.majorBarColor,
    required this.mediumBarColor,
    required this.minorBarColor,
    required this.labelColor,
    required this.decimalPlaces,
    required this.orientation,
    required this.barAlignment,
    required this.viewportExtent,
    required this.leadingPadding,
    required this.scrollController,
    this.majorInterval,
    this.mediumInterval,
    this.labelStyle,
    Listenable? repaintListenable,
  }) : super(repaint: repaintListenable);

  /// Minimum value of the ruler range.
  final double minRange;

  /// Maximum value of the ruler range.
  final double maxRange;

  /// The value increment between each tick mark.
  final double lineSpacing;

  /// The pixel distance between each tick mark.
  final double pixelSpacing;

  /// The height (or width for vertical) of the ruler.
  final double rulerHeight;

  /// Position alignment for labels.
  final AlignmentPosition alignmentPosition;

  /// Color of major tick marks.
  final Color majorBarColor;

  /// Color of medium tick marks.
  final Color mediumBarColor;

  /// Color of minor tick marks.
  final Color minorBarColor;

  /// Color of the labels.
  final Color labelColor;

  /// Number of decimal places for labels.
  final int decimalPlaces;

  /// Orientation of the ruler.
  final RulerOrientation orientation;

  /// Alignment of the bars.
  final BarAlignment barAlignment;

  /// The visible viewport extent.
  final double viewportExtent;

  /// Padding at the leading edge.
  final double leadingPadding;

  /// The scroll controller to track scroll position.
  final ScrollController? scrollController;

  /// Interval for major tick marks (e.g., every 10th tick).
  final int? majorInterval;

  /// Interval for medium tick marks (e.g., every 5th tick).
  final int? mediumInterval;

  /// Optional custom text style for labels.
  final TextStyle? labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final isHorizontal = orientation == RulerOrientation.horizontal;
    final center = isHorizontal ? size.height / 2 : size.width / 2;
    final scrollOffset = scrollController?.hasClients ?? false
        ? scrollController!.offset
        : 0.0;

    final Paint major = Paint()
      ..color = majorBarColor
      ..strokeWidth = 2
      ..isAntiAlias = false;
    final Paint medium = Paint()
      ..color = mediumBarColor
      ..strokeWidth = 1.5
      ..isAntiAlias = false;
    final Paint minor = Paint()
      ..color = minorBarColor
      ..strokeWidth = 1
      ..isAntiAlias = false;

    final longLine = rulerHeight * 0.35;
    final mediumLine = rulerHeight * 0.25;
    final shortLine = rulerHeight * 0.15;

    final range = maxRange - minRange;
    final numLines = (range / lineSpacing).round();

    final startPx = (scrollOffset - leadingPadding).clamp(0.0, double.infinity);
    final endPx = (startPx + viewportExtent).clamp(
      0.0,
      isHorizontal ? size.width : size.height,
    );

    int startIndex = (startPx / pixelSpacing).floor() - 20;
    int endIndex = (endPx / pixelSpacing).ceil() + 20;
    startIndex = startIndex.clamp(0, numLines);
    endIndex = endIndex.clamp(0, numLines);

    final majInterval = majorInterval ?? 10;
    final medInterval = mediumInterval ?? 5;

    for (int i = startIndex; i <= endIndex; i++) {
      final positionPx = i * pixelSpacing;
      final value = minRange + i * lineSpacing;

      if (value > maxRange + 0.0001) continue;

      Paint linePaint;
      double lineLen;
      final isMajor = i % majInterval == 0;
      final isMedium = i % medInterval == 0 && !isMajor;

      if (isMajor) {
        linePaint = major;
        lineLen = longLine;
      } else if (isMedium) {
        linePaint = medium;
        lineLen = mediumLine;
      } else {
        linePaint = minor;
        lineLen = shortLine;
      }

      if (isHorizontal) {
        final (lineStart, lineEnd) = _getLinePositions(
          size.height,
          lineLen,
          center,
        );
        canvas.drawLine(
          Offset(positionPx, lineStart),
          Offset(positionPx, lineEnd),
          linePaint,
        );
      } else {
        final (lineStart, lineEnd) = _getLinePositions(
          size.width,
          lineLen,
          center,
        );
        canvas.drawLine(
          Offset(lineStart, positionPx),
          Offset(lineEnd, positionPx),
          linePaint,
        );
      }

      if (isMajor) {
        final label = value.toStringAsFixed(decimalPlaces);
        _drawLabel(canvas, size, label, positionPx, longLine, center);
      }
    }
  }

  (double, double) _getLinePositions(
    double dimension,
    double lineLen,
    double center,
  ) {
    switch (barAlignment) {
      case BarAlignment.start:
        return (0, lineLen);
      case BarAlignment.end:
        return (dimension - lineLen, dimension);
      case BarAlignment.center:
        return (center - lineLen / 2, center + lineLen / 2);
    }
  }

  void _drawLabel(
    Canvas canvas,
    Size size,
    String label,
    double positionPx,
    double longLine,
    double center,
  ) {
    final isHorizontal = orientation == RulerOrientation.horizontal;

    if (isHorizontal) {
      double y;
      switch (barAlignment) {
        case BarAlignment.start:
          y = longLine + 10;
          break;
        case BarAlignment.end:
          y = size.height - longLine - 20;
          break;
        case BarAlignment.center:
          y = alignmentPosition == AlignmentPosition.bottom
              ? center + longLine / 2 + 10
              : center - longLine / 2 - 20;
          break;
      }
      _drawText(canvas, label, Offset(positionPx, y), isHorizontal);
    } else {
      double x;
      switch (barAlignment) {
        case BarAlignment.start:
          x = longLine + 10;
          break;
        case BarAlignment.end:
          x = size.width - longLine - 30;
          break;
        case BarAlignment.center:
          x = alignmentPosition == AlignmentPosition.right
              ? center + longLine / 2 + 10
              : center - longLine / 2 - 30;
          break;
      }
      _drawText(canvas, label, Offset(x, positionPx), isHorizontal);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, bool isHorizontal) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style:
            labelStyle ??
            TextStyle(
              color: labelColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 0, maxWidth: 100);

    double adjustedX = offset.dx;
    double adjustedY = offset.dy;
    if (isHorizontal) {
      adjustedX -= textPainter.width / 2;
    } else {
      adjustedY -= textPainter.height / 2;
    }
    textPainter.paint(canvas, Offset(adjustedX, adjustedY));
  }

  @override
  bool shouldRepaint(covariant ScaleRulerPainter old) {
    return minRange != old.minRange ||
        maxRange != old.maxRange ||
        lineSpacing != old.lineSpacing ||
        pixelSpacing != old.pixelSpacing ||
        rulerHeight != old.rulerHeight ||
        alignmentPosition != old.alignmentPosition ||
        majorBarColor != old.majorBarColor ||
        mediumBarColor != old.mediumBarColor ||
        minorBarColor != old.minorBarColor ||
        labelColor != old.labelColor ||
        decimalPlaces != old.decimalPlaces ||
        orientation != old.orientation ||
        barAlignment != old.barAlignment ||
        viewportExtent != old.viewportExtent ||
        leadingPadding != old.leadingPadding ||
        majorInterval != old.majorInterval ||
        mediumInterval != old.mediumInterval ||
        labelStyle != old.labelStyle;
  }
}