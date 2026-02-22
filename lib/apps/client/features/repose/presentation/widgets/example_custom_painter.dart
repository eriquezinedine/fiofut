import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/rps_custom_painter.dart';
import 'package:flutter/material.dart';

class BodyCustomPaint extends StatefulWidget {
  const BodyCustomPaint({super.key, this.width = 200});

  final double width;

  @override
  State<BodyCustomPaint> createState() => _BodyCustomPaintState();
}

class _BodyCustomPaintState extends State<BodyCustomPaint> {
  Color _chest1Color = const Color(0xffE53A36);
  Color _chest2Color = const Color(0xffE53A36);

  late final RPSCustomPainter _painter;

  static const _colors = [
    Color(0xffE53A36),
    Color(0xff4CAF50),
    Color(0xff2196F3),
    Color(0xffFF9800),
    Color(0xff9C27B0),
    Color(0xffFFEB3B),
    Color(0xff00BCD4),
    Color(0xffFF5722),
    Color(0xff607D8B),
    Color(0xffE91E63),
    Color(0xff8BC34A),
    Color(0xff3F51B5),
  ];

  void _onTapDown(TapDownDetails details) {
    final muscle = _painter.hitTestMuscle(details.localPosition);

    if (muscle == 'chest1') {
      _showColorPicker(
        title: 'Chest 1 (izquierda)',
        currentColor: _chest1Color,
        onColorSelected: (color) => setState(() => _chest1Color = color),
      );
    } else if (muscle == 'chest2') {
      _showColorPicker(
        title: 'Chest 2 (derecha)',
        currentColor: _chest2Color,
        onColorSelected: (color) => setState(() => _chest2Color = color),
      );
    }
  }

  void _showColorPicker({
    required String title,
    required Color currentColor,
    required ValueChanged<Color> onColorSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colors.map((color) {
                  final isSelected = currentColor == color;
                  return GestureDetector(
                    onTap: () {
                      onColorSelected(color);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: color.withValues(alpha: 0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _painter = RPSCustomPainter(
      chest1Color: _chest1Color,
      chest2Color: _chest2Color,
    );
    return GestureDetector(
      onTapDown: _onTapDown,
      child: CustomPaint(
        size: Size(widget.width, (widget.width * 2.975)),
        painter: _painter,
      ),
    );
  }
}
