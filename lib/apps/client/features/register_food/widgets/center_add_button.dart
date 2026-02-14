import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../pages/take_photo_page.dart';

class CenterAddButton extends StatelessWidget {
  const CenterAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: () {
            RegisterFoodModal.show(
              context,
              onTakePhoto: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const TakePhotoPage(),
                  ),
                );
              },
            );
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Center(
              child: Icon(
                LucideIcons.plus,
                color: AppColors.black,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
