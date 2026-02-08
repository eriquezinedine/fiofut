import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nation_code_picker/nation_code_picker.dart';

/// Widget de input de teléfono con selector de país.
/// Incluye un picker de código de país y un campo de texto para el número.
class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    required this.selectedCountry,
    required this.onCountryChanged,
    required this.onPhoneChanged,
    this.hintText = '10 1234 5678',
    this.countryPickerTitle = 'Selecciona tu pais',
    this.maxLength = 15,
  });

  /// Controller del campo de texto
  final TextEditingController controller;

  /// País seleccionado actualmente
  final NationCodes selectedCountry;

  /// Callback cuando cambia el país
  final ValueChanged<NationCodes> onCountryChanged;

  /// Callback cuando cambia el número de teléfono
  final ValueChanged<String> onPhoneChanged;

  /// Texto de placeholder (default: '10 1234 5678')
  final String hintText;

  /// Título del picker de país
  final String countryPickerTitle;

  /// Longitud máxima del número (default: 15)
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          // Country code picker
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppColors.border,
                ),
              ),
            ),
            child: NationCodePicker(
              defaultNationCode: selectedCountry,
              flagScale: 0.6,
              dialCodeTextStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
              title: countryPickerTitle,
              onNationSelected: onCountryChanged,
            ),
          ),

          // Phone number input
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: AppTextStyles.input.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.inputHint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(maxLength),
              ],
              onChanged: onPhoneChanged,
            ),
          ),
        ],
      ),
    );
  }
}
