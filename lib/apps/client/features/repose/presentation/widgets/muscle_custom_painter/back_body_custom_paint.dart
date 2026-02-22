import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/rps_back_custom_paint.dart';
import 'package:flutter/material.dart';

class BackBodyCustomPaint extends StatefulWidget {
  const BackBodyCustomPaint({super.key, this.width = 200});

  final double width;

  @override
  State<BackBodyCustomPaint> createState() => _BackBodyCustomPaintState();
}

class _BackBodyCustomPaintState extends State<BackBodyCustomPaint> {
  Color _back1Color = AppColors.muscleDefaultColor;
  Color _trapsColor = AppColors.muscleDefaultColor;
  Color _lowerBack1Color = AppColors.muscleDefaultColor;
  Color _glutes1Color = AppColors.muscleDefaultColor;
  Color _tricepsColor = AppColors.muscleDefaultColor;
  Color _rearDeltoidColor = AppColors.muscleDefaultColor;
  Color _hamstringsColor = AppColors.muscleDefaultColor;
  Color _calvesColor = AppColors.muscleDefaultColor;

  late RPSBackCustomPainter _painter;

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

    if (muscle == 'back1') {
      _showColorPicker(
        title: 'Espalda (completa)',
        currentColor: _back1Color,
        onColorSelected: (color) => setState(() => _back1Color = color),
      );
    } else if (muscle == 'traps') {
      _showColorPicker(
        title: 'Trapecios',
        currentColor: _trapsColor,
        onColorSelected: (color) => setState(() => _trapsColor = color),
      );
    } else if (muscle == 'lowerBack1') {
      _showColorPicker(
        title: 'Espalda baja',
        currentColor: _lowerBack1Color,
        onColorSelected: (color) => setState(() => _lowerBack1Color = color),
      );
    } else if (muscle == 'glutes1') {
      _showColorPicker(
        title: 'Glúteos',
        currentColor: _glutes1Color,
        onColorSelected: (color) => setState(() => _glutes1Color = color),
      );
    } else if (muscle == 'triceps') {
      _showColorPicker(
        title: 'Tríceps',
        currentColor: _tricepsColor,
        onColorSelected: (color) => setState(() => _tricepsColor = color),
      );
    } else if (muscle == 'rearDeltoid') {
      _showColorPicker(
        title: 'Deltoides posterior',
        currentColor: _rearDeltoidColor,
        onColorSelected: (color) => setState(() => _rearDeltoidColor = color),
      );
    } else if (muscle == 'hamstrings') {
      _showColorPicker(
        title: 'Isquiotibiales',
        currentColor: _hamstringsColor,
        onColorSelected: (color) => setState(() => _hamstringsColor = color),
      );
    } else if (muscle == 'calves') {
      _showColorPicker(
        title: 'Pantorrillas',
        currentColor: _calvesColor,
        onColorSelected: (color) => setState(() => _calvesColor = color),
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
    _painter = RPSBackCustomPainter(
      back1Color: _back1Color,
      trapsColor: _trapsColor,
      lowerBack1Color: _lowerBack1Color,
      glutes1Color: _glutes1Color,
      tricepsColor: _tricepsColor,
      rearDeltoidColor: _rearDeltoidColor,
      hamstringsColor: _hamstringsColor,
      calvesColor: _calvesColor,
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
