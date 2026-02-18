import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RepiteType { byKg, byKm, retryOnly }

class SerieExerciseWidget extends ConsumerWidget {
  const SerieExerciseWidget({
    super.key,
    this.repiteType = RepiteType.byKm,
  });

  final RepiteType repiteType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          SireBody(repiteType: repiteType),
        ],
      ),
    );
  }
}

class SireBody extends ConsumerWidget {
  const SireBody({
    super.key,
    this.repiteType = RepiteType.byKg,
  });

  final RepiteType repiteType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(serieDetailProvider);
    final isRetryOnly = repiteType == RepiteType.retryOnly;
    final middleHeader = switch (repiteType) {
      RepiteType.byKg => 'Repeticiones',
      RepiteType.byKm => 'Mins : Segs',
      RepiteType.retryOnly => 'Repeticiones',
    };

    final series = switch (state) {
      SerieDetailLoaded(:final workout) => workout.series,
      _ => <SerieSet>[],
    };

    return Column(
      children: [
        _SerieHeaders(middleHeader: middleHeader, showKg: !isRetryOnly),
        for (final serie in series)
          switch (repiteType) {
            RepiteType.byKg => _SerieRowByKg(
                serie: serie,
                isActive: !serie.isCompleted,
              ),
            RepiteType.byKm => _SerieRowByKm(
                serie: serie,
                isActive: !serie.isCompleted,
              ),
            RepiteType.retryOnly => _SerieRowRetryOnly(
                serie: serie,
                isActive: !serie.isCompleted,
              ),
          },
        // Añadir Serie button
        _AddSerieButton(
          onTap: () => ref.read(serieDetailProvider.notifier).addSerie(),
        ),
      ],
    );
  }
}

// ── Añadir Serie button ─────────────────────────────────────────────

class _AddSerieButton extends StatelessWidget {
  const _AddSerieButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 20,
                color: AppColors.green,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Añadir Serie',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.green,
                letterSpacing: -0.28,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
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

class SerieTextField extends StatefulWidget {
  const SerieTextField({
    super.key,
    this.initialValue,
    this.hint,
    this.isActive = true,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.maxLength,
  });

  final String? initialValue;
  final String? hint;
  final bool isActive;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final int? maxLength;

  @override
  State<SerieTextField> createState() => _SerieTextFieldState();
}

class _SerieTextFieldState extends State<SerieTextField> {
  late final TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant SerieTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller with state, but only when user is NOT actively typing
    if (!_isEditing && widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        widget.isActive ? AppColors.background : AppColors.white;

    final formatters = <TextInputFormatter>[
      if (widget.inputFormatters != null) ...widget.inputFormatters!,
      if (widget.maxLength != null)
        _ClearOnOverflowFormatter(widget.maxLength!),
    ];

    return Focus(
      onFocusChange: (hasFocus) => _isEditing = hasFocus,
      child: TextField(
      controller: _controller,
      keyboardType: widget.keyboardType ?? TextInputType.number,
      inputFormatters: formatters,
      textAlign: TextAlign.center,
      onChanged: widget.onChanged,
      style: AppTextStyles.h3.copyWith(
        color: textColor,
        fontSize: 20,
        letterSpacing: -0.4,
        height: 1.25,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
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

class _SerieRowByKg extends ConsumerWidget {
  const _SerieRowByKg({
    required this.serie,
    required this.isActive,
  });

  final SerieSet serie;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(serieDetailProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20)
          .add(EdgeInsets.only(top: isActive ? 12 : 4, bottom: 8)),
      child: Row(
        children: [
          _SerieNumberCell(number: serie.number, isActive: isActive),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isActive: isActive,
              child: SerieTextField(
                key: ValueKey('${serie.id}_reps'),
                initialValue: serie.reps?.toString(),
                hint: '0',
                isActive: isActive,
                onChanged: (v) {
                  final reps = int.tryParse(v);
                  if (reps != null) notifier.updateReps(serie.id, reps);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isActive: isActive,
              child: SerieTextField(
                key: ValueKey('${serie.id}_kg'),
                initialValue: serie.kg != null
                    ? (serie.kg == serie.kg!.roundToDouble()
                        ? serie.kg!.toInt().toString()
                        : serie.kg.toString())
                    : null,
                hint: '0',
                isActive: isActive,
                onChanged: (v) {
                  final kg = double.tryParse(v);
                  if (kg != null) notifier.updateKg(serie.id, kg);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Row: byKm (Serie | [Mins : Segs] | Kg) ─────────────────────────

class _SerieRowByKm extends ConsumerWidget {
  const _SerieRowByKm({
    required this.serie,
    required this.isActive,
  });

  final SerieSet serie;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(serieDetailProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20)
          .add(EdgeInsets.only(top: isActive ? 12 : 4, bottom: 8)),
      child: Row(
        children: [
          _SerieNumberCell(number: serie.number, isActive: isActive),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isActive: isActive,
              child: Row(
                children: [
                  Expanded(
                    child: SerieTextField(
                      key: ValueKey('${serie.id}_mins'),
                      initialValue: serie.mins?.toString(),
                      hint: '00',
                      isActive: isActive,
                      maxLength: 2,
                      onChanged: (v) {
                        final mins = int.tryParse(v);
                        if (mins != null) notifier.updateMins(serie.id, mins);
                      },
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
                      key: ValueKey('${serie.id}_segs'),
                      initialValue: serie.segs?.toString(),
                      hint: '00',
                      isActive: isActive,
                      maxLength: 2,
                      onChanged: (v) {
                        final segs = int.tryParse(v);
                        if (segs != null) notifier.updateSegs(serie.id, segs);
                      },
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
              child: SerieTextField(
                key: ValueKey('${serie.id}_kg'),
                initialValue: serie.kg != null
                    ? (serie.kg == serie.kg!.roundToDouble()
                        ? serie.kg!.toInt().toString()
                        : serie.kg.toString())
                    : null,
                hint: '0',
                isActive: isActive,
                onChanged: (v) {
                  final kg = double.tryParse(v);
                  if (kg != null) notifier.updateKg(serie.id, kg);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Row: retryOnly (Serie | Repeticiones) ───────────────────────────

class _SerieRowRetryOnly extends ConsumerWidget {
  const _SerieRowRetryOnly({
    required this.serie,
    required this.isActive,
  });

  final SerieSet serie;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(serieDetailProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20)
          .add(EdgeInsets.only(top: isActive ? 12 : 4, bottom: 8)),
      child: Row(
        children: [
          _SerieNumberCell(number: serie.number, isActive: isActive),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isActive: isActive,
              child: SerieTextField(
                key: ValueKey('${serie.id}_reps'),
                initialValue: serie.reps?.toString(),
                hint: '0',
                isActive: isActive,
                onChanged: (v) {
                  final reps = int.tryParse(v);
                  if (reps != null) notifier.updateReps(serie.id, reps);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
