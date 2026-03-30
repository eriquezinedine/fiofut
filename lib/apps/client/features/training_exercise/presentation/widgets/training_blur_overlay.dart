import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TrainingBlurOverlay extends StatelessWidget {
  const TrainingBlurOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
        child: Container(
          color: AppColors.backgroundSecondary.o(0.85),
        ),
      ),
    );
  }
}
