import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    this.controller,
    this.hint = 'Código de referencia',
    this.actionText = 'Enviar',
    this.onAction,
    this.onChanged,
    this.isActionEnabled = true,
  });

  final TextEditingController? controller;
  final String hint;
  final String actionText;
  final VoidCallback? onAction;
  final ValueChanged<String>? onChanged;
  final bool isActionEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 56,
      width: double.infinity,
      // padding: const EdgeInsets.only(left: 16, right: 4),
      // decoration: BoxDecoration(
      //   color: AppColors.backgroundSecondary,
      //   borderRadius: BorderRadius.circular(12),
      // ),
      child:  TextField(
                controller: controller,
                style: AppTextStyles.input,
                onChanged: onChanged,
                
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: AppTextStyles.inputHint,
                  border: InputBorder.none,
                  fillColor: AppColors.backgroundSecondary,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                  suffixIcon: GestureDetector(
              onTap: isActionEnabled ? onAction : null,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    actionText,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: isActionEnabled
                          ? AppColors.white
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
                ),
                
              ),
              ),

  
    // return SizedBox(
    //   height: 56,
    //   width: double.infinity,
    //   // padding: const EdgeInsets.only(left: 16, right: 4),
    //   // decoration: BoxDecoration(
    //   //   color: AppColors.backgroundSecondary,
    //   //   borderRadius: BorderRadius.circular(12),
    //   // ),
    //   child: DecoratedBox(
    //     decoration: BoxDecoration(
    //       color: AppColors.backgroundSecondary,
    //     ),
    //     child: Row(
    //       children: [
    //         Expanded(
    //           child: TextField(
    //             controller: controller,
    //             style: AppTextStyles.input,
    //             onChanged: onChanged,
    //             decoration: InputDecoration(
    //               hintText: hint,
    //               hintStyle: AppTextStyles.inputHint,
    //               border: InputBorder.none,
    //               fillColor: Colors.transparent,
    //               contentPadding: EdgeInsets.zero,
    //             ),
    //           ),
    //         ),
    //         const SizedBox(width: 12),
    //         GestureDetector(
    //           onTap: isActionEnabled ? onAction : null,
    //           child: Container(
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 20,
    //               vertical: 12,
    //             ),
    //             decoration: BoxDecoration(
    //               color: AppColors.surface,
    //               borderRadius: BorderRadius.circular(10),
    //             ),
    //             child: Text(
    //               actionText,
    //               style: AppTextStyles.titleSmall.copyWith(
    //                 color: isActionEnabled
    //                     ? AppColors.white
    //                     : AppColors.textMuted,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    );
  }
}
