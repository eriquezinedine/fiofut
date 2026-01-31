import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'enums.dart';
import 'scale_ruler_painter.dart';

/// A highly customizable ruler widget for selecting numeric values.
///
/// The [CustomRuler] widget displays a scrollable ruler that allows users
/// to select a value by scrolling. It supports both horizontal and vertical
/// orientations, customizable tick marks, snapping behavior, and more.
///
/// ## Example
///
/// ```dart
/// CustomRuler(
///   minRange: 0,
///   maxRange: 100,
///   initialValue: 50,
///   orientation: RulerOrientation.horizontal,
///   onChange: (value) {
///     print('Selected value: $value');
///   },
/// )
/// ```
class CustomRuler extends StatefulWidget {
  /// Creates a [CustomRuler].
  ///
  /// The [minRange] must be less than [maxRange].
  const CustomRuler({
    super.key,
    this.minRange = 0,
    this.maxRange = 10,
    this.lineSpacing = 0.05,
    this.pixelSpacing = 10.0,
    this.rulerHeight = 120,
    this.decimalPlaces = 0,
    this.pointerColor = Colors.blue,
    this.alignmentPosition = AlignmentPosition.top,
    this.onChange,
    this.initialValue = 0,
    this.majorBarColor = Colors.black,
    this.mediumBarColor = Colors.black,
    this.minorBarColor = Colors.black,
    this.labelColor = Colors.black,
    this.enableSnapping = true,
    this.orientation = RulerOrientation.horizontal,
    this.barAlignment = BarAlignment.end,
    this.pointerLength = 0,
    this.pointerThickness = 2,
    this.selectionMin,
    this.selectionMax,
    this.majorInterval,
    this.mediumInterval,
    this.pointerWidget,
    this.labelStyle,
    this.physics,
    this.verticalPointerPositionFactor = 3.5,
  }) : assert(minRange < maxRange, 'minRange must be less than maxRange');

  /// The minimum value of the ruler range.
  ///
  /// Defaults to `0`.
  final double minRange;

  /// The maximum value of the ruler range.
  ///
  /// Defaults to `10`.
  final double maxRange;

  /// The value increment between each tick mark.
  ///
  /// For example, a [lineSpacing] of `0.1` means there will be a tick
  /// mark at 0.0, 0.1, 0.2, etc.
  ///
  /// Defaults to `0.05`.
  final double lineSpacing;

  /// The pixel distance between each tick mark.
  ///
  /// Larger values spread the tick marks further apart.
  ///
  /// Defaults to `10.0`.
  final double pixelSpacing;

  /// The height of the ruler (or width for vertical orientation).
  ///
  /// Defaults to `120`.
  final double rulerHeight;

  /// The color of the pointer/indicator line.
  ///
  /// Defaults to [Colors.blue].
  final Color pointerColor;

  /// The number of decimal places to display in labels.
  ///
  /// Defaults to `0`.
  final int decimalPlaces;

  /// The position alignment for labels and tick marks.
  ///
  /// Defaults to [AlignmentPosition.top].
  final AlignmentPosition alignmentPosition;

  /// Called whenever the selected value changes.
  ///
  /// The callback receives the new value as a [double].
  final ValueChanged<double>? onChange;

  /// The initial value to display when the ruler is first shown.
  ///
  /// Defaults to `0`.
  final double initialValue;

  /// The color of major tick marks.
  ///
  /// Major tick marks appear at intervals defined by [majorInterval].
  ///
  /// Defaults to [Colors.black].
  final Color majorBarColor;

  /// The color of medium tick marks.
  ///
  /// Medium tick marks appear at intervals defined by [mediumInterval].
  ///
  /// Defaults to [Colors.black].
  final Color mediumBarColor;

  /// The color of minor tick marks.
  ///
  /// Minor tick marks appear at all other positions.
  ///
  /// Defaults to [Colors.black].
  final Color minorBarColor;

  /// The color of the numeric labels.
  ///
  /// Defaults to [Colors.black].
  final Color labelColor;

  /// Whether to snap to the nearest tick mark when scrolling ends.
  ///
  /// Defaults to `true`.
  final bool enableSnapping;

  /// The orientation of the ruler.
  ///
  /// Defaults to [RulerOrientation.horizontal].
  final RulerOrientation orientation;

  /// The alignment of tick marks within the ruler height.
  ///
  /// Defaults to [BarAlignment.end].
  final BarAlignment barAlignment;

  /// The length of the pointer line.
  ///
  /// If set to `0` or less, the pointer will span the full ruler height.
  ///
  /// Defaults to `0`.
  final double pointerLength;

  /// The thickness of the pointer line.
  ///
  /// Defaults to `2`.
  final double pointerThickness;

  /// The minimum selectable value.
  ///
  /// If `null`, defaults to [minRange].
  final double? selectionMin;

  /// The maximum selectable value.
  ///
  /// If `null`, defaults to [maxRange].
  final double? selectionMax;

  /// The interval for major tick marks.
  ///
  /// For example, a value of `10` means every 10th tick is a major tick.
  ///
  /// If `null`, defaults to `10`.
  final int? majorInterval;

  /// The interval for medium tick marks.
  ///
  /// For example, a value of `5` means every 5th tick is a medium tick
  /// (unless it's also a major tick).
  ///
  /// If `null`, defaults to `5`.
  final int? mediumInterval;

  /// A custom widget to use as the pointer/indicator.
  ///
  /// If provided, this replaces the default colored line pointer.
  final Widget? pointerWidget;

  /// Custom text style for the labels.
  ///
  /// If `null`, a default style is used with [labelColor].
  final TextStyle? labelStyle;

  /// Custom scroll physics for the ruler.
  ///
  /// If `null`, [ClampingScrollPhysics] is used.
  final ScrollPhysics? physics;

  /// Factor to divide the available height for vertical pointer position.
  ///
  /// Lower values move the pointer higher. Defaults to `3.5`.
  final double verticalPointerPositionFactor;

  @override
  CustomRulerState createState() => CustomRulerState();
}

/// State for [CustomRuler].
///
/// Exposes [scrollToValue] for programmatic control.
class CustomRulerState extends State<CustomRuler> {
  final ScrollController _scrollController = ScrollController();
  double _selectedPosition = 0.0;
  bool _isScrolling = false;
  bool _isSnapping = false;
  bool _isAdjustingOffset = false;

  Timer? _throttleTimer;
  double? _pendingOnChangeValue;

  double get _selMin => (widget.selectionMin ?? widget.minRange).clamp(
    widget.minRange,
    widget.maxRange,
  );

  double get _selMax => (widget.selectionMax ?? widget.maxRange).clamp(
    widget.minRange,
    widget.maxRange,
  );

  bool get _isHorizontal => widget.orientation == RulerOrientation.horizontal;

  /// The currently selected value.
  double get currentValue => _selectedPosition;

  double _snapToTick(double value) {
    if (widget.lineSpacing <= 0) return value;

    final units = (value - widget.minRange) / widget.lineSpacing;
    final nearestUnits = units.roundToDouble();
    var snapped = widget.minRange + nearestUnits * widget.lineSpacing;

    final factor = math.pow(10, 6);
    snapped = (snapped * factor).round() / factor;

    return snapped.clamp(_selMin, _selMax);
  }

  double _valueToOffset(double value) {
    return ((value - widget.minRange) / widget.lineSpacing) *
        widget.pixelSpacing;
  }

  double _offsetToValue(double offset) {
    return (offset / widget.pixelSpacing) * widget.lineSpacing +
        widget.minRange;
  }

  /// Animates the ruler to display the specified [value].
  ///
  /// The [value] will be clamped to the valid selection range and
  /// snapped to the nearest tick mark.
  ///
  /// ```dart
  /// final rulerKey = GlobalKey<CustomRulerState>();
  ///
  /// // Later...
  /// rulerKey.currentState?.scrollToValue(50);
  /// ```
  void scrollToValue(double value) {
    if (!_scrollController.hasClients) return;
    final clamped = _snapToTick(value);
    final targetOffset = _valueToOffset(clamped);

    _scrollController
        .animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
        .then((_) {
          _selectedPosition = clamped;
          widget.onChange?.call(clamped);
        });
  }

  /// Immediately jumps to the specified [value] without animation.
  void jumpToValue(double value) {
    if (!_scrollController.hasClients) return;
    final clamped = _snapToTick(value);
    final targetOffset = _valueToOffset(clamped);
    _scrollController.jumpTo(targetOffset);
    _selectedPosition = clamped;
    widget.onChange?.call(clamped);
  }

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialValue.clamp(_selMin, _selMax);

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final targetOffset = _valueToOffset(_selectedPosition);
        _scrollController.jumpTo(targetOffset);
        widget.onChange?.call(_selectedPosition);
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isAdjustingOffset || _isSnapping) {
      return;
    }

    if (!_isHorizontal) {
      final minOffset = _valueToOffset(_selMin);
      final maxOffset = _valueToOffset(_selMax);

      final rawOffset = _scrollController.offset;
      final clampedOffset = rawOffset.clamp(minOffset, maxOffset);

      if ((clampedOffset - rawOffset).abs() > 0.5) {
        _isAdjustingOffset = true;
        Future.microtask(() {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(clampedOffset);
          }
          _isAdjustingOffset = false;
        });
        return;
      }
    }

    if (!_isScrolling) return;

    final scrollOffset = _scrollController.offset;
    final position = _offsetToValue(scrollOffset);

    if (_isHorizontal) {
      _selectedPosition = position;
    } else {
      _selectedPosition = position.clamp(_selMin, _selMax);
    }

    if (widget.onChange != null) {
      _emitOnChangeThrottled(_selectedPosition);
    }
  }

  void _emitOnChangeThrottled(double value) {
    const throttle = Duration(milliseconds: 16);
    _pendingOnChangeValue = value;

    if (_throttleTimer == null) {
      widget.onChange?.call(value);
      _throttleTimer = Timer(throttle, () {
        _throttleTimer = null;
        if (_pendingOnChangeValue != null) {
          widget.onChange?.call(_pendingOnChangeValue!);
          _pendingOnChangeValue = null;
        }
      });
    }
  }

  void _snapToNearestTick() {
    if (!_scrollController.hasClients ||
        !widget.enableSnapping ||
        _isSnapping) {
      return;
    }

    if (widget.lineSpacing <= 0) return;

    final nearestValue = _snapToTick(_selectedPosition);
    final targetOffset = _valueToOffset(nearestValue);

    _isSnapping = true;
    _scrollController
        .animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        )
        .then((_) {
          _isSnapping = false;
          _selectedPosition = nearestValue;
          widget.onChange?.call(nearestValue);
        });
  }

  @override
  void dispose() {
    _throttleTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        double pointerWidth, pointerHeight;
        if (_isHorizontal) {
          pointerWidth = widget.pointerThickness;
          pointerHeight = widget.pointerLength > 0
              ? widget.pointerLength
              : widget.rulerHeight;
        } else {
          pointerWidth = widget.pointerLength > 0
              ? widget.pointerLength
              : widget.rulerHeight;
          pointerHeight = widget.pointerThickness;
        }

        final scaleLength =
            ((widget.maxRange - widget.minRange) / widget.lineSpacing) *
            widget.pixelSpacing;

        final viewportExtent = _isHorizontal ? availableWidth : availableHeight;
        final leadingPadding = _isHorizontal
            ? availableWidth / 2
            : availableHeight / widget.verticalPointerPositionFactor;

        return Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollStartNotification) {
                  _isScrolling = true;
                } else if (notification is ScrollEndNotification) {
                  _isScrolling = false;
                  if (widget.enableSnapping && !_isSnapping) {
                    _snapToNearestTick();
                  }
                }
                return false;
              },
              child: SingleChildScrollView(
                scrollDirection: _isHorizontal
                    ? Axis.horizontal
                    : Axis.vertical,
                controller: _scrollController,
                physics: widget.physics ?? const ClampingScrollPhysics(),
                child: Padding(
                  padding: _isHorizontal
                      ? EdgeInsets.only(
                          left: availableWidth / 2,
                          right: availableWidth / 2,
                        )
                      : EdgeInsets.only(
                          top: availableHeight / widget.verticalPointerPositionFactor,
                          left: widget.barAlignment == BarAlignment.end
                              ? availableWidth / 1.43
                              : 0,
                          bottom: availableHeight / 1.4,
                        ),
                  child: RepaintBoundary(
                    child: CustomPaint(
                      size: _isHorizontal
                          ? Size(scaleLength, widget.rulerHeight)
                          : Size(widget.rulerHeight, scaleLength),
                      painter: ScaleRulerPainter(
                        scrollController: _scrollController,
                        minRange: widget.minRange,
                        maxRange: widget.maxRange,
                        lineSpacing: widget.lineSpacing,
                        pixelSpacing: widget.pixelSpacing,
                        rulerHeight: widget.rulerHeight,
                        alignmentPosition: widget.alignmentPosition,
                        majorBarColor: widget.majorBarColor,
                        mediumBarColor: widget.mediumBarColor,
                        minorBarColor: widget.minorBarColor,
                        labelColor: widget.labelColor,
                        decimalPlaces: widget.decimalPlaces,
                        orientation: widget.orientation,
                        barAlignment: widget.barAlignment,
                        viewportExtent: viewportExtent,
                        leadingPadding: leadingPadding,
                        repaintListenable: _scrollController,
                        majorInterval: widget.majorInterval,
                        mediumInterval: widget.mediumInterval,
                        labelStyle: widget.labelStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildPointer(
              constraints,
              pointerWidth,
              pointerHeight,
              leadingPadding,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPointer(
    BoxConstraints constraints,
    double pointerWidth,
    double pointerHeight,
    double leadingPadding,
  ) {
    double pointerLeft;
    double pointerTop;

    if (_isHorizontal) {
      if (widget.barAlignment == BarAlignment.end) {
        pointerTop = constraints.maxHeight - pointerHeight;
      } else if (widget.barAlignment == BarAlignment.start) {
        pointerTop = 0;
      } else {
        pointerTop = (constraints.maxHeight - pointerHeight) / 2;
      }
      pointerLeft = (constraints.maxWidth - pointerWidth) / 2;
    } else {
      if (widget.barAlignment == BarAlignment.end) {
        pointerLeft = constraints.maxWidth - pointerWidth;
      } else if (widget.barAlignment == BarAlignment.start) {
        pointerLeft = 0;
      } else {
        pointerLeft = (constraints.maxWidth - pointerWidth) / 2;
      }
      pointerTop = leadingPadding - pointerHeight / 2;
    }

    return Positioned(
      left: pointerLeft,
      top: pointerTop,
      child: IgnorePointer(
        child:
            widget.pointerWidget ??
            Container(
              width: pointerWidth,
              height: pointerHeight,
              color: widget.pointerColor,
            ),
      ),
    );
  }
}