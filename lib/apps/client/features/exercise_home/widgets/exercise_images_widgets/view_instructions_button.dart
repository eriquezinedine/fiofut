import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// A prominent button to view exercise instructions.
///
/// Full-width button with book icon and text, using the primary brand color.
/// Used to trigger the display of detailed exercise instructions modal.

class ViewInstructionsButton extends StatelessWidget {
  const ViewInstructionsButton({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: ColoredBox(color: Colors.transparent,
      child:  Column(
        spacing: 7,
        children: [
          Icon(LucideIcons.info,size: 24,),
          Text('Instrucciones', style: AppTextStyles.small.copyWith(color: AppColors.white),)
        ],
      ),
      ),
    );
  }
}
