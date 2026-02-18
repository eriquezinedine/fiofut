import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum RepiteType { byKg, byKm, retryOnly }

class SerieExerciseWidget extends ConsumerWidget {
  const SerieExerciseWidget({
    super.key,
    this.repiteType = RepiteType.byKm,
    this.groupType = SerieGroupType.effective,
    this.isStarted = false,
    this.currentSerieId,
  });

  final RepiteType repiteType;
  final SerieGroupType groupType;
  final bool isStarted;
  final String? currentSerieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = switch (groupType) {
      SerieGroupType.effective => 'Series efectivas',
      SerieGroupType.warmup => 'Sets de calentamiento',
    };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24)
          .add(EdgeInsets.only(bottom: 0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SireBody(
            repiteType: repiteType,
            groupType: groupType,
            isStarted: isStarted,
            currentSerieId: currentSerieId,
          ),
        ],
      ),
    );
  }
}

class SireBody extends ConsumerWidget {
  const SireBody({
    super.key,
    this.repiteType = RepiteType.byKg,
    this.groupType = SerieGroupType.effective,
    this.isStarted = false,
    this.currentSerieId,
  });

  final RepiteType repiteType;
  final SerieGroupType groupType;
  final bool isStarted;
  final String? currentSerieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(serieDetailProvider(groupType));
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

    // Find the last completed serie id (only that one can be untoggled)
    String? lastCompletedId;
    if (isStarted) {
      for (var i = series.length - 1; i >= 0; i--) {
        if (series[i].isCompleted) {
          lastCompletedId = series[i].id;
          break;
        }
      }
    }

    return Column(
      children: [
        _SerieHeaders(middleHeader: middleHeader, showKg: !isRetryOnly),
        for (final serie in series)
          switch (repiteType) {
            RepiteType.byKg => _SerieRowByKg(
                serie: serie,
                isActive: !serie.isCompleted,
                groupType: groupType,
                isStarted: isStarted,
                isCurrent: serie.id == currentSerieId,
                isLastCompleted: serie.id == lastCompletedId,
              ),
            RepiteType.byKm => _SerieRowByKm(
                serie: serie,
                isActive: !serie.isCompleted,
                groupType: groupType,
                isStarted: isStarted,
                isCurrent: serie.id == currentSerieId,
                isLastCompleted: serie.id == lastCompletedId,
              ),
            RepiteType.retryOnly => _SerieRowRetryOnly(
                serie: serie,
                isActive: !serie.isCompleted,
                groupType: groupType,
                isStarted: isStarted,
                isCurrent: serie.id == currentSerieId,
                isLastCompleted: serie.id == lastCompletedId,
              ),
          },
      ],
    );
  }
}

// ── Añadir Serie button ─────────────────────────────────────────────

class AddSerieButton extends StatelessWidget {
  const AddSerieButton({super.key, required this.onTap});

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
    this.isStarted = false,
    this.isCurrent = false,
  });

  final int number;
  final bool isActive;
  final bool isStarted;
  final bool isCurrent;

  bool get _isCompleted => !isActive;

  @override
  Widget build(BuildContext context) {
    // When started: current/completed = green bg, pending = card bg
    // When not started: same as before (white bg for active, secondary for completed)
    final Color bg;
    final Color textColor;

    if (!isStarted) {
      bg = isActive ? AppColors.white : AppColors.backgroundSecondary;
      textColor = isActive ? AppColors.background : AppColors.white;
    } else if (_isCompleted) {
      bg = AppColors.primary;
      textColor = AppColors.black;
    } else if (isCurrent) {
      bg = AppColors.white;
      textColor = AppColors.background;
    } else {
      bg = AppColors.card;
      textColor = AppColors.white;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: isStarted && _isCompleted
          ? Icon(LucideIcons.check, color: AppColors.black, size: 18)
          : Text(
              '$number',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
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
    this.isStarted = false,
    this.isCurrent = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.maxLength,
    this.focusNode,
    this.nextFocusNode,
    this.autoAdvanceMs,
  });

  final String? initialValue;
  final String? hint;
  final bool isActive;
  final bool isStarted;
  final bool isCurrent;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final int? autoAdvanceMs;

  @override
  State<SerieTextField> createState() => _SerieTextFieldState();
}

class _SerieTextFieldState extends State<SerieTextField> {
  late final TextEditingController _controller;
  bool _isEditing = false;
  Timer? _advanceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant SerieTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _advanceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    _scheduleAutoAdvance();
  }

  void _scheduleAutoAdvance() {
    if (widget.nextFocusNode == null || widget.autoAdvanceMs == null) return;
    _advanceTimer?.cancel();
    _advanceTimer = Timer(
      Duration(milliseconds: widget.autoAdvanceMs!),
      () {
        if (_isEditing && mounted) {
          widget.nextFocusNode!.requestFocus();
        }
      },
    );
  }

  Color get _textColor {
    if (!widget.isStarted) {
      return widget.isActive ? AppColors.background : AppColors.white;
    }
    // Started: completed = black, current = dark (white bg), pending = white
    if (!widget.isActive) return AppColors.black;
    if (widget.isCurrent) return AppColors.background;
    return AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _textColor;

    final formatters = <TextInputFormatter>[
      if (widget.inputFormatters != null) ...widget.inputFormatters!,
      if (widget.maxLength != null)
        _ClearOnOverflowFormatter(widget.maxLength!),
    ];

    return Focus(
      onFocusChange: (hasFocus) {
        _isEditing = hasFocus;
        if (!hasFocus) _advanceTimer?.cancel();
      },
      child: TextField(
        controller: _controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType ?? TextInputType.number,
        inputFormatters: formatters,
        textAlign: TextAlign.center,
        onChanged: _onChanged,
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
    this.isStarted = false,
    this.isCurrent = false,
  });

  final bool isActive;
  final bool isStarted;
  final bool isCurrent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Color bg;

    if (!isStarted) {
      bg = isActive ? AppColors.white : AppColors.backgroundSecondary;
    } else if (!isActive) {
      // completed
      bg = AppColors.primary;
    } else if (isCurrent) {
      // current — white like setup
      bg = AppColors.white;
    } else {
      // pending
      bg = AppColors.card;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ── Row: byKg (Serie | Repeticiones | Kg) ───────────────────────────

class _SerieRowByKg extends ConsumerStatefulWidget {
  const _SerieRowByKg({
    required this.serie,
    required this.isActive,
    required this.groupType,
    this.isStarted = false,
    this.isCurrent = false,
    this.isLastCompleted = false,
  });

  final SerieSet serie;
  final bool isActive;
  final SerieGroupType groupType;
  final bool isStarted;
  final bool isCurrent;
  final bool isLastCompleted;

  @override
  ConsumerState<_SerieRowByKg> createState() => _SerieRowByKgState();
}

class _SerieRowByKgState extends ConsumerState<_SerieRowByKg> {
  final _kgFocusNode = FocusNode();

  @override
  void dispose() {
    _kgFocusNode.dispose();
    super.dispose();
  }

  String? _formatKg(double? kg) {
    if (kg == null) return null;
    return kg == kg.roundToDouble() ? kg.toInt().toString() : kg.toString();
  }

  @override
  Widget build(BuildContext context) {
    final serie = widget.serie;
    final isActive = widget.isActive;
    final isStarted = widget.isStarted;
    final isCurrent = widget.isCurrent;
    final notifier =
        ref.read(serieDetailProvider(widget.groupType).notifier);

    return GestureDetector(
      onTap: widget.isLastCompleted
          ? () => notifier.toggleSerieCompleted(serie.id)
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20)
            .add(EdgeInsets.only(top: isActive ? 12 : 4, bottom: 8)),
        child: Row(
          children: [
            _SerieNumberCell(
              number: serie.number,
              isActive: isActive,
              isStarted: isStarted,
              isCurrent: isCurrent,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _CellContainer(
                isActive: isActive,
                isStarted: isStarted,
                isCurrent: isCurrent,
                child: SerieTextField(
                  key: ValueKey('${serie.id}_reps'),
                  initialValue: serie.reps?.toString(),
                  hint: '0',
                  isActive: isActive,
                  isStarted: isStarted,
                  isCurrent: isCurrent,
                  nextFocusNode: _kgFocusNode,
                  autoAdvanceMs: 300,
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
                isStarted: isStarted,
                isCurrent: isCurrent,
                child: SerieTextField(
                  key: ValueKey('${serie.id}_kg'),
                  initialValue: _formatKg(serie.kg),
                  hint: '0',
                  isActive: isActive,
                  isStarted: isStarted,
                  isCurrent: isCurrent,
                  focusNode: _kgFocusNode,
                  onChanged: (v) {
                    final kg = double.tryParse(v);
                    if (kg != null) notifier.updateKg(serie.id, kg);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Row: byKm (Serie | [Mins : Segs] | Kg) ─────────────────────────

class _SerieRowByKm extends ConsumerWidget {
  const _SerieRowByKm({
    required this.serie,
    required this.isActive,
    required this.groupType,
    this.isStarted = false,
    this.isCurrent = false,
    this.isLastCompleted = false,
  });

  final SerieSet serie;
  final bool isActive;
  final SerieGroupType groupType;
  final bool isStarted;
  final bool isCurrent;
  final bool isLastCompleted;

  Color get _separatorColor {
    if (!isStarted) {
      return isActive ? AppColors.background : AppColors.white;
    }
    if (!isActive) return AppColors.black;
    if (isCurrent) return AppColors.background;
    return AppColors.white;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(serieDetailProvider(groupType).notifier);

    return GestureDetector(
      onTap: isLastCompleted
          ? () => notifier.toggleSerieCompleted(serie.id)
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20)
            .add(EdgeInsets.only(top: isActive ? 12 : 4, bottom: 8)),
        child: Row(
          children: [
            _SerieNumberCell(
              number: serie.number,
              isActive: isActive,
              isStarted: isStarted,
              isCurrent: isCurrent,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _CellContainer(
                isActive: isActive,
                isStarted: isStarted,
                isCurrent: isCurrent,
                child: Row(
                  children: [
                    Expanded(
                      child: SerieTextField(
                        key: ValueKey('${serie.id}_mins'),
                        initialValue: serie.mins?.toString(),
                        hint: '00',
                        isActive: isActive,
                        isStarted: isStarted,
                        isCurrent: isCurrent,
                        maxLength: 2,
                        onChanged: (v) {
                          final mins = int.tryParse(v);
                          if (mins != null) {
                            notifier.updateMins(serie.id, mins);
                          }
                        },
                      ),
                    ),
                    Text(
                      ':',
                      style: AppTextStyles.h3.copyWith(
                        color: _separatorColor,
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
                        isStarted: isStarted,
                        isCurrent: isCurrent,
                        maxLength: 2,
                        onChanged: (v) {
                          final segs = int.tryParse(v);
                          if (segs != null) {
                            notifier.updateSegs(serie.id, segs);
                          }
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
                isStarted: isStarted,
                isCurrent: isCurrent,
                child: SerieTextField(
                  key: ValueKey('${serie.id}_kg'),
                  initialValue: serie.kg != null
                      ? (serie.kg == serie.kg!.roundToDouble()
                          ? serie.kg!.toInt().toString()
                          : serie.kg.toString())
                      : null,
                  hint: '0',
                  isActive: isActive,
                  isStarted: isStarted,
                  isCurrent: isCurrent,
                  onChanged: (v) {
                    final kg = double.tryParse(v);
                    if (kg != null) notifier.updateKg(serie.id, kg);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Row: retryOnly (Serie | Repeticiones) ───────────────────────────

class _SerieRowRetryOnly extends ConsumerWidget {
  const _SerieRowRetryOnly({
    required this.serie,
    required this.isActive,
    required this.groupType,
    this.isStarted = false,
    this.isCurrent = false,
    this.isLastCompleted = false,
  });

  final SerieSet serie;
  final bool isActive;
  final SerieGroupType groupType;
  final bool isStarted;
  final bool isCurrent;
  final bool isLastCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(serieDetailProvider(groupType).notifier);

    return GestureDetector(
      onTap: isLastCompleted
          ? () => notifier.toggleSerieCompleted(serie.id)
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20)
            .add(EdgeInsets.only(top: isActive ? 12 : 4, bottom: 8)),
        child: Row(
          children: [
            _SerieNumberCell(
              number: serie.number,
              isActive: isActive,
              isStarted: isStarted,
              isCurrent: isCurrent,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _CellContainer(
                isActive: isActive,
                isStarted: isStarted,
                isCurrent: isCurrent,
                child: SerieTextField(
                  key: ValueKey('${serie.id}_reps'),
                  initialValue: serie.reps?.toString(),
                  hint: '0',
                  isActive: isActive,
                  isStarted: isStarted,
                  isCurrent: isCurrent,
                  onChanged: (v) {
                    final reps = int.tryParse(v);
                    if (reps != null) notifier.updateReps(serie.id, reps);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
