import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/rps_front_custom_painter.dart';
import 'package:flutter/material.dart';

class FrontBodyCustomPaint extends StatefulWidget {
  const FrontBodyCustomPaint({super.key, this.width = 200});

  final double width;

  @override
  State<FrontBodyCustomPaint> createState() => _FrontBodyCustomPaintState();
}

class _FrontBodyCustomPaintState extends State<FrontBodyCustomPaint> {
  Color _chest1Color =  AppColors.muscleDefaultColor;
  Color _chest2Color =  AppColors.muscleDefaultColor;
  Color _absColor =  AppColors.muscleDefaultColor;
  Color _bicep1Color =  AppColors.muscleDefaultColor;
  Color _bicep2Color =  AppColors.muscleDefaultColor;
  Color _obliques1Color =  AppColors.muscleDefaultColor;
  Color _obliques2Color =  AppColors.muscleDefaultColor;
  Color _forearms1Color =  AppColors.muscleDefaultColor;
  Color _forearms2Color =  AppColors.muscleDefaultColor;
  Color _quadriceps2Color =  AppColors.muscleDefaultColor;
  Color _quadriceps1Color =  AppColors.muscleDefaultColor;
  Color _adductors1Color =  AppColors.muscleDefaultColor;
  Color _adductors2Color =  AppColors.muscleDefaultColor;
  Color _abductors1Color =  AppColors.muscleDefaultColor;
  Color _abductors2Color =  AppColors.muscleDefaultColor;
  Color _lateralDeltoid1Color =  AppColors.muscleDefaultColor;
  Color _lateralDeltoid2Color =  AppColors.muscleDefaultColor;
  Color _frontDeltoid1Color =  AppColors.muscleDefaultColor;
  Color _frontDeltoid2Color =  AppColors.muscleDefaultColor;

  late RPSFrontCustomPainter _painter;

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
    } else if (muscle == 'abs') {
      _showColorPicker(
        title: 'Abdominales',
        currentColor: _absColor,
        onColorSelected: (color) => setState(() => _absColor = color),
      );
    } else if (muscle == 'bicep1') {
      _showColorPicker(
        title: 'Bícep (izquierdo)',
        currentColor: _bicep1Color,
        onColorSelected: (color) => setState(() => _bicep1Color = color),
      );
    } else if (muscle == 'bicep2') {
      _showColorPicker(
        title: 'Bícep (derecho)',
        currentColor: _bicep2Color,
        onColorSelected: (color) => setState(() => _bicep2Color = color),
      );
    } else if (muscle == 'obliques1') {
      _showColorPicker(
        title: 'Oblicuos (izquierdo)',
        currentColor: _obliques1Color,
        onColorSelected: (color) => setState(() => _obliques1Color = color),
      );
    } else if (muscle == 'obliques2') {
      _showColorPicker(
        title: 'Oblicuos (derecho)',
        currentColor: _obliques2Color,
        onColorSelected: (color) => setState(() => _obliques2Color = color),
      );
    } else if (muscle == 'forearms1') {
      _showColorPicker(
        title: 'Antebrazo (izquierdo)',
        currentColor: _forearms1Color,
        onColorSelected: (color) => setState(() => _forearms1Color = color),
      );
    } else if (muscle == 'forearms2') {
      _showColorPicker(
        title: 'Antebrazo (derecho)',
        currentColor: _forearms2Color,
        onColorSelected: (color) => setState(() => _forearms2Color = color),
      );
    } else if (muscle == 'quadriceps2') {
      _showColorPicker(
        title: 'Cuádriceps (derecho)',
        currentColor: _quadriceps2Color,
        onColorSelected: (color) => setState(() => _quadriceps2Color = color),
      );
    } else if (muscle == 'quadriceps1') {
      _showColorPicker(
        title: 'Cuádriceps (izquierdo)',
        currentColor: _quadriceps1Color,
        onColorSelected: (color) => setState(() => _quadriceps1Color = color),
      );
    } else if (muscle == 'adductors1') {
      _showColorPicker(
        title: 'Aductor (izquierdo)',
        currentColor: _adductors1Color,
        onColorSelected: (color) => setState(() => _adductors1Color = color),
      );
    } else if (muscle == 'adductors2') {
      _showColorPicker(
        title: 'Aductor (derecho)',
        currentColor: _adductors2Color,
        onColorSelected: (color) => setState(() => _adductors2Color = color),
      );
    } else if (muscle == 'abductors1') {
      _showColorPicker(
        title: 'Abductor (izquierdo)',
        currentColor: _abductors1Color,
        onColorSelected: (color) => setState(() => _abductors1Color = color),
      );
    } else if (muscle == 'abductors2') {
      _showColorPicker(
        title: 'Abductor (derecho)',
        currentColor: _abductors2Color,
        onColorSelected: (color) => setState(() => _abductors2Color = color),
      );
    } else if (muscle == 'lateralDeltoid1') {
      _showColorPicker(
        title: 'Deltoides lateral (izquierdo)',
        currentColor: _lateralDeltoid1Color,
        onColorSelected: (color) => setState(() => _lateralDeltoid1Color = color),
      );
    } else if (muscle == 'lateralDeltoid2') {
      _showColorPicker(
        title: 'Deltoides lateral (derecho)',
        currentColor: _lateralDeltoid2Color,
        onColorSelected: (color) => setState(() => _lateralDeltoid2Color = color),
      );
    } else if (muscle == 'frontDeltoid1') {
      _showColorPicker(
        title: 'Deltoides frontal (izquierdo)',
        currentColor: _frontDeltoid1Color,
        onColorSelected: (color) => setState(() => _frontDeltoid1Color = color),
      );
    } else if (muscle == 'frontDeltoid2') {
      _showColorPicker(
        title: 'Deltoides frontal (derecho)',
        currentColor: _frontDeltoid2Color,
        onColorSelected: (color) => setState(() => _frontDeltoid2Color = color),
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
    _painter = RPSFrontCustomPainter(
      chest1Color: _chest1Color,
      chest2Color: _chest2Color,
      absColor: _absColor,
      bicep1Color: _bicep1Color,
      bicep2Color: _bicep2Color,
      obliques1Color: _obliques1Color,
      obliques2Color: _obliques2Color,
      forearms1Color: _forearms1Color,
      forearms2Color: _forearms2Color,
      quadriceps2Color: _quadriceps2Color,
      quadriceps1Color: _quadriceps1Color,
      adductors1Color: _adductors1Color,
      adductors2Color: _adductors2Color,
      abductors1Color: _abductors1Color,
      abductors2Color: _abductors2Color,
      lateralDeltoid1Color: _lateralDeltoid1Color,
      lateralDeltoid2Color: _lateralDeltoid2Color,
      frontDeltoid1Color: _frontDeltoid1Color,
      frontDeltoid2Color: _frontDeltoid2Color,
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
