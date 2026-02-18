import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors/app_colors.dart';
import '../spacing/app_spacing.dart';
import '../typography/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.expands = false,
    this.textAlignVertical,
    this.isRequired = false,
    this.fillColor,
    this.borderRadius,
    this.borderColor,
    this.contentPadding,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final bool isRequired;
  final Color? fillColor;
  final double? borderRadius;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          if (isRequired)
            Text.rich(
              TextSpan(
                text: label!,
                style: AppTextStyles.labelMedium,
                children: const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.error),
                  ),
                ],
              ),
            )
          else
            Text(
              label!,
              style: AppTextStyles.labelMedium,
            ),
          AppSpacing.verticalXs,
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: expands ? null : maxLines,
          minLines: minLines,
          maxLength: maxLength,
          expands: expands,
          textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          validator: validator,
          autofocus: autofocus,
          textCapitalization: textCapitalization,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
            errorText: errorText,
            helperText: helperText,
            filled: true,
            fillColor: fillColor ?? AppColors.backgroundSecondary,
            contentPadding: contentPadding,
            border: borderRadius != null
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: borderColor != null
                        ? BorderSide(color: borderColor!)
                        : BorderSide.none,
                  )
                : null,
            enabledBorder: borderRadius != null
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: borderColor != null
                        ? BorderSide(color: borderColor!)
                        : BorderSide.none,
                  )
                : null,
            focusedBorder: borderRadius != null
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: borderColor != null
                        ? BorderSide(color: borderColor!)
                        : BorderSide.none,
                  )
                : null,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textSecondary)
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixIconTap,
                    child: Icon(suffixIcon, color: AppColors.textSecondary),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.hint = 'Buscar...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.fillColor,
    this.borderRadius,
    this.borderColor,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final Color? fillColor;
  final double? borderRadius;
  final Color? borderColor;

  OutlineInputBorder _border(double radius) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: borderColor != null
            ? BorderSide(color: borderColor!)
            : BorderSide.none,
      );

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 12;
    final hasText = controller?.text.isNotEmpty == true;

    return TextField(
      controller: controller,
      autofocus: autofocus,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w400,
        ),
        filled: fillColor != null,
        fillColor: fillColor,
        border: _border(radius),
        enabledBorder: _border(radius),
        focusedBorder: _border(radius),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textMuted,
        ),
        suffixIcon: hasText
            ? GestureDetector(
                onTap: () {
                  controller?.clear();
                  onClear?.call();
                },
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.textMuted,
                  child: const Icon(
                    Icons.close,
                    color: AppColors.background,
                    size: 12,
                  ),
                ),
              )
            : null,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}

/// Text area widget for multiline input
/// Matches the textArea frame from the design system
class AppTextArea extends StatelessWidget {
  const AppTextArea({
    super.key,
    this.controller,
    this.focusNode,
    this.hint = 'Escribe aquí...',
    this.height = 180,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hint;
  final double height;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool readOnly;
  final int? maxLength;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: null,
        expands: true,
        enabled: enabled,
        readOnly: readOnly,
        maxLength: maxLength,
        autofocus: autofocus,
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.multiline,
        style: AppTextStyles.input,
        decoration: InputDecoration(
          fillColor: AppColors.backgroundSecondary,
          hintText: hint,
          hintStyle: AppTextStyles.inputHint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          counterText: '',
        ),
        onChanged: onChanged,
      ),
    );
  }
}

/// Input field with action button
/// Matches the search-send frame from the design system
class AppInputWithAction extends StatelessWidget {
  const AppInputWithAction({
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
    return Container(
      height: 56,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.input,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.inputHint,
                border: InputBorder.none,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: isActionEnabled ? onAction : null,
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
        ],
      ),
    );
  }
}
