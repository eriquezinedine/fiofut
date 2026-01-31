/// Position alignment for ruler labels and bars.
enum AlignmentPosition {
  /// Align to the top (horizontal) or left (vertical).
  top,

  /// Align to the bottom (horizontal) or right (vertical).
  bottom,

  /// Align to the left side.
  left,

  /// Align to the right side.
  right,
}

/// Orientation of the ruler.
enum RulerOrientation {
  /// Horizontal ruler (scrolls left-right).
  horizontal,

  /// Vertical ruler (scrolls up-down).
  vertical,
}

/// Alignment of the ruler bars within the ruler height.
enum BarAlignment {
  /// Bars start from the beginning edge.
  start,

  /// Bars are centered.
  center,

  /// Bars extend from the end edge.
  end,
}