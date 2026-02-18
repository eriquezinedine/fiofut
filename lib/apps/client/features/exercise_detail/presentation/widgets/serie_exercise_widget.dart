import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum RepiteType { byKg, byKm, retryOnly }

class SerieExerciseWidget extends StatelessWidget {
  const SerieExerciseWidget({
    super.key,
    this.repiteType = RepiteType.byKm,
  });

  final RepiteType repiteType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24)
          .add(EdgeInsets.only(bottom: 12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Series efectivas',
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SireBody(repiteType: repiteType)
        ],
      ),
    );
  }
}

class SireBody extends StatelessWidget {
  const SireBody({
    super.key,
    this.repiteType = RepiteType.byKg,
  });

  final RepiteType repiteType;

  @override
  Widget build(BuildContext context) {
    final isRetryOnly = repiteType == RepiteType.retryOnly;
    final middleHeader = switch (repiteType) {
      RepiteType.byKg => 'Repeticiones',
      RepiteType.byKm => 'Mins : Segs',
      RepiteType.retryOnly => 'Repeticiones',
    };

    return Column(
      children: [
        _SerieHeaders(middleHeader: middleHeader, showKg: !isRetryOnly),
        if (repiteType == RepiteType.byKg) ...[
          _SerieRowByKg(serieNumber: 1, isActive: true),
          _SerieRowByKg(serieNumber: 2, isActive: false),
          _SerieRowByKg(serieNumber: 3, isActive: false),
          _SerieRowByKg(serieNumber: 4, isActive: false),
        ] else if (repiteType == RepiteType.byKm) ...[
          _SerieRowByKm(serieNumber: 1, isActive: true),
        ] else ...[
          _SerieRowRetryOnly(serieNumber: 1, isActive: true),
        ],
      ],
    );
  }
}

// ── Headers ─────────────────────────────────────────────────────────

class _SerieHeaders extends StatelessWidget {
  const _SerieHeaders({
    required this.middleHeader,
    this.showKg = true,
  });

  final String middleHeader;
  final bool showKg;

  @override
  Widget build(BuildContext context) {
    final headerStyle = AppTextStyles.caption.copyWith(
      fontWeight: FontWeight.w500,
      color: AppColors.textDescription,
      letterSpacing: -0.28,
      height: 1.25,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20)
          .add(const EdgeInsets.only(top: 8, bottom: 4)),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              'Serie',
              textAlign: TextAlign.center,
              style: headerStyle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              middleHeader,
              textAlign: TextAlign.center,
              style: headerStyle,
            ),
          ),
          if (showKg) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Kg Añadidos',
                textAlign: TextAlign.center,
                style: headerStyle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Serie number cell (plain Text, not editable) ────────────────────

class _SerieNumberCell extends StatelessWidget {
  const _SerieNumberCell({
    required this.number,
    required this.isActive,
  });

  final int number;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isActive ? AppColors.white : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isActive ? AppColors.background : AppColors.white,
          letterSpacing: -0.32,
          height: 1.25,
        ),
      ),
    );
  }
}

// ── Transparent TextField for serie cells ───────────────────────────

class SerieTextField extends StatelessWidget {
  const SerieTextField({
    super.key,
    this.controller,
    this.hint,
    this.isActive = true,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.maxLength,
  });

  final TextEditingController? controller;
  final String? hint;
  final bool isActive;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final textColor = isActive ? AppColors.background : AppColors.white;

    final formatters = <TextInputFormatter>[
      if (inputFormatters != null) ...inputFormatters!,
      if (maxLength != null) _ClearOnOverflowFormatter(maxLength!),
    ];

    return TextField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.number,
      inputFormatters: formatters,
      textAlign: TextAlign.center,
      onChanged: onChanged,
      style: AppTextStyles.h3.copyWith(
        color: textColor,
        fontSize: 20,
        letterSpacing: -0.4,
        height: 1.25,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.h3.copyWith(
          color: AppColors.textDescription,
          fontSize: 20,
          letterSpacing: -0.4,
          height: 1.25,
        ),
        filled: true,
        fillColor: AppColors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        isDense: true,
        counterText: '',
      ),
    );
  }
}

class _ClearOnOverflowFormatter extends TextInputFormatter {
  _ClearOnOverflowFormatter(this.maxLength);

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > maxLength) {
      return const TextEditingValue();
    }
    return newValue;
  }
}

// ── Cell container (shared decoration) ──────────────────────────────

class _CellContainer extends StatelessWidget {
  const _CellContainer({
    required this.isActive,
    required this.child,
  });

  final bool isActive;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isActive ? AppColors.white : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ── Row: byKg (Serie | Repeticiones | Kg) ───────────────────────────

class _SerieRowByKg extends StatelessWidget {
  const _SerieRowByKg({
    required this.serieNumber,
    required this.isActive,
  });

  final int serieNumber;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20)
          .add(EdgeInsets.only(top: isActive ? 12 : 4, bottom: 8)),
      child: Row(
        children: [
          _SerieNumberCell(number: serieNumber, isActive: isActive),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isActive: isActive,
              child: SerieTextField(hint: '0', isActive: isActive),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isActive: isActive,
              child: SerieTextField(hint: '0', isActive: isActive),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Row: byKm (Serie | [Mins : Segs] | Kg) ─────────────────────────

class _SerieRowByKm extends StatelessWidget {
  const _SerieRowByKm({
    required this.serieNumber,
    required this.isActive,
  });

  final int serieNumber;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20)
          .add(EdgeInsets.only(top: isActive ? 12 : 4, bottom: 8)),
      child: Row(
        children: [
          _SerieNumberCell(number: serieNumber, isActive: isActive),
          const SizedBox(width: 16),
          // Mins : Segs — two TextFields inside one container
          Expanded(
            child: _CellContainer(
              isActive: isActive,
              child: Row(
                children: [
                  Expanded(
                    child: SerieTextField(
                      hint: '00',
                      isActive: isActive,
                      maxLength: 2,
                    ),
                  ),
                  Text(
                    ':',
                    style: AppTextStyles.h3.copyWith(
                      color: isActive
                          ? AppColors.background
                          : AppColors.white,
                      fontSize: 20,
                      letterSpacing: -0.4,
                      height: 1.25,
                    ),
                  ),
                  Expanded(
                    child: SerieTextField(
                      hint: '00',
                      isActive: isActive,
                      maxLength: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isActive: isActive,
              child: SerieTextField(hint: '0', isActive: isActive),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Row: retryOnly (Serie | Repeticiones) ───────────────────────────

class _SerieRowRetryOnly extends StatelessWidget {
  const _SerieRowRetryOnly({
    required this.serieNumber,
    required this.isActive,
  });

  final int serieNumber;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20)
          .add(EdgeInsets.only(top: isActive ? 12 : 4, bottom: 8)),
      child: Row(
        children: [
          _SerieNumberCell(number: serieNumber, isActive: isActive),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isActive: isActive,
              child: SerieTextField(hint: '0', isActive: isActive),
            ),
          ),
        ],
      ),
    );
  }
}
