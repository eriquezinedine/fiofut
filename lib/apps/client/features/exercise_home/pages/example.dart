
import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/exercise_detail/exercise_detail.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/exercise_images_widgets/exercise_favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

// ──────────────────────────────────────────────
// Local data model
// ──────────────────────────────────────────────

class _Serie {
  _Serie({
    this.reps = 10,
    this.weightKg = 20,
    this.time = const Duration(seconds: 0),
    this.isCompleted = false,
  });

  int reps;
  int weightKg;
  Duration time;
  bool isCompleted;
}

// ──────────────────────────────────────────────
// Page
// ──────────────────────────────────────────────

class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({required this.exercise, super.key});

  final Exercise exercise;

  static const String name = 'exercise-detail';
  static const String path = '/exercise-detail';

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  // Setup state
  final List<_Serie> _series = [_Serie()];

  // Active state
  bool _isStarted = false;
  int _currentIndex = 0;
  bool _showWarmup = true;
  bool _showDescanso = false;
  bool _descansoRunning = false;
  int _descansoSeconds = 58;
  Timer? _descansoTimer;

  // Warmup series (one default warmup set)
  final List<_Serie> _warmupSeries = [
    _Serie(reps: 10, weightKg: 20),
  ];

  MetricType get _type => widget.exercise.metricType;

  bool get _allCompleted =>
      _series.every((s) => s.isCompleted);

  @override
  void dispose() {
    _descansoTimer?.cancel();
    super.dispose();
  }

  // ── Setup actions ──────────────────────────

  void _addSerie() {
    setState(() {
      final last = _series.last;
      _series.add(_Serie(
        reps: last.reps,
        weightKg: last.weightKg,
        time: last.time,
      ));
    });
  }

  // ── Active actions ─────────────────────────

  void _startWorkout() {
    setState(() => _isStarted = true);
  }

  void _registerSerie() {
    if (_currentIndex >= _series.length) return;
    setState(() {
      _series[_currentIndex].isCompleted = true;
      _currentIndex++;
      _showDescanso = true;
      _showWarmup = false;
      _startDescanso();
    });
  }

  void _startDescanso() {
    _descansoTimer?.cancel();
    _descansoRunning = true;
    _descansoTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_descansoSeconds <= 0) {
        _descansoTimer?.cancel();
        setState(() {
          _showDescanso = false;
          _descansoRunning = false;
          _descansoSeconds = 58;
        });
        return;
      }
      setState(() => _descansoSeconds--);
    });
  }

  void _adjustDescanso(int delta) {
    setState(() {
      _descansoSeconds = (_descansoSeconds + delta).clamp(0, 599);
    });
  }

  void _toggleDescanso() {
    setState(() {
      _descansoRunning = !_descansoRunning;
      if (_descansoRunning) {
        _startDescanso();
      } else {
        _descansoTimer?.cancel();
      }
    });
  }

  void _done() => Navigator.pop(context);

  // ──────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background gradient image
          _buildBackground(),

          // Content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        _isStarted ? _buildActiveBody() : _buildSetupBody(),
                      ],
                    ),
                  ),
                ),
                _buildFooter(),
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.bottom +
                      AppSpacing.xs,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Background ─────────────────────────────

  Widget _buildBackground() {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.exercise.imageUrl != null)
            Image.network(
              widget.exercise.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const ColoredBox(color: AppColors.surface),
            )
          else
            const ColoredBox(color: AppColors.surface),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.background],
                stops: [0.3, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomGestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              LucideIcons.chevronLeft,
              color: AppColors.white,
              size: AppSpacing.iconMd,
            ),
          ),
          ExerciseFavorite(exercise: widget.exercise, initialValue: true, onChangeValue: (bool value) {  },),
        ],
      ),
    );
  }

  // ── Header (title + chips) ─────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xxl,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Text(
            widget.exercise.title,
            style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
          ),
          DetailActionChips(
            exercise: widget.exercise,
            duration: const Duration(minutes: 1, seconds: 30),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // SETUP BODY
  // ──────────────────────────────────────────

  Widget _buildSetupBody() {
    final isWeight = _type == MetricType.weight;
    return SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        _buildSectionTitle(
          isWeight ? 'Series efectivas' : 'Intervalos efectivas',
        ),

        // Table header
        _buildTableHeader(),

        // Rows
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            spacing: AppSpacing.xs,
            children: List.generate(
              _series.length,
              (i) => _SetupRow(
                index: i,
                serie: _series[i],
                metricType: _type,
                onChanged: () => setState(() {}),
              ),
            ),
          ),
        ),

        // Add button
        _buildAddButton(
          label: isWeight ? 'Añadir Serie' : 'Agregar intervalo',
          onTap: _addSerie,
        ),
      ],
    );
  }

  // ──────────────────────────────────────────
  // ACTIVE BODY
  // ──────────────────────────────────────────

  Widget _buildActiveBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Warmup toggle
        _buildWarmupToggle(),

        // Series efectivas title
        _buildSectionTitle('Series efectivas'),

        // Table header
        _buildTableHeader(),

        // Active rows
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            spacing: AppSpacing.xs,
            children: List.generate(
              _series.length,
              (i) => DetailActiveRow(
                index: i,
                reps: _series[i].reps,
                metricType: _type,
                weightKg: _series[i].weightKg,
                time: _series[i].time,
                isCurrent: i == _currentIndex,
                isCompleted: _series[i].isCompleted,
              ),
            ),
          ),
        ),

        // Add serie button
        _buildAddButton(label: 'Añadir Serie', onTap: _addSerie),

        // Descanso widget
        if (_showDescanso) ...[
          const SizedBox(height: AppSpacing.sm),
          DescansoWidget(
            seconds: _descansoSeconds,
            isRunning: _descansoRunning,
            onToggle: _toggleDescanso,
            onAdjust: _adjustDescanso,
          ),
        ],

        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  // ──────────────────────────────────────────
  // SHARED UI HELPERS
  // ──────────────────────────────────────────

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        spacing: AppSpacing.xs,
        children: [
          SizedBox(
            width: 40,
            child: _HeaderLabel('Serie'),
          ),
          if (_type != MetricType.time)
            Expanded(child: _HeaderLabel('Repeticiones')),
          if (_type == MetricType.time)
            Expanded(child: _HeaderLabel('Mins : Segs')),
          if (_type == MetricType.weight || _type == MetricType.time)
            Expanded(child: _HeaderLabel('Kg Añadidos')),
        ],
      ),
    );
  }

  Widget _buildAddButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxs),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: const Icon(
                LucideIcons.plus,
                color: AppColors.primary,
                size: 14,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: -0.28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarmupToggle() {
    return CustomGestureDetector(
      onTap: () => setState(() => _showWarmup = !_showWarmup),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_showWarmup) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Series de calentamiento',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Ocultar',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textDescription,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Warmup row (read-only, dimmed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Opacity(
                opacity: 0.5,
                child: DetailActiveRow(
                  index: 0,
                  reps: _warmupSeries.first.reps,
                  metricType: _type,
                  weightKg: _warmupSeries.first.weightKg,
                ),
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                0,
              ),
              child: Text(
                'Mostrar series de calentamiento',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // FOOTER
  // ──────────────────────────────────────────

  Widget _buildFooter() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: _isStarted ? _buildActiveFooter() : _buildSetupFooter(),
    );
  }

  Widget _buildSetupFooter() {
    // weight: single full-width "Comenzar entrenamiento" button
    if (_type == MetricType.weight) {
      return _GreenButton(
        label: 'Comenzar entrenamiento',
        onTap: _startWorkout,
      );
    }

    // reps / time: "Registrar serie" + checkmark
    return _RegisterRow(onRegister: _registerSerie);
  }

  Widget _buildActiveFooter() {
    if (_allCompleted) {
      return _GreenButton(label: 'Hecho', onTap: _done);
    }
    return _RegisterRow(onRegister: _registerSerie);
  }
}

// ──────────────────────────────────────────────
// Setup row widget (editable)
// ──────────────────────────────────────────────

class _SetupRow extends StatelessWidget {
  const _SetupRow({
    required this.index,
    required this.serie,
    required this.metricType,
    required this.onChanged,
  });

  final int index;
  final _Serie serie;
  final MetricType metricType;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.xs,
      children: [
        // Serie number badge
        Container(
          width: 40,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Text(
            '${index + 1}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        // Reps field
        if (metricType != MetricType.time)
          Expanded(
            child: _EditableCell(
              value: '${serie.reps}',
              keyboardType: TextInputType.number,
              onChanged: (v) {
                serie.reps = int.tryParse(v) ?? serie.reps;
                onChanged();
              },
            ),
          ),

        // Time field
        if (metricType == MetricType.time)
          Expanded(
            child: _EditableCell(
              value: _formatDuration(serie.time),
              hint: '00:00',
              onChanged: (v) {
                serie.time = _parseDuration(v);
                onChanged();
              },
            ),
          ),

        // Kg field
        if (metricType == MetricType.weight || metricType == MetricType.time)
          Expanded(
            child: _EditableCell(
              value: '${serie.weightKg}',
              keyboardType: TextInputType.number,
              onChanged: (v) {
                serie.weightKg = int.tryParse(v) ?? serie.weightKg;
                onChanged();
              },
            ),
          ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Duration _parseDuration(String s) {
    final parts = s.split(':');
    if (parts.length == 2) {
      final m = int.tryParse(parts[0]) ?? 0;
      final sec = int.tryParse(parts[1]) ?? 0;
      return Duration(minutes: m, seconds: sec);
    }
    return Duration.zero;
  }
}

class _EditableCell extends StatelessWidget {
  const _EditableCell({
    required this.value,
    required this.onChanged,
    this.hint = '0',
    this.keyboardType,
  });

  final String value;
  final String hint;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Center(
        child: TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.collapsed(offset: value.length),
          keyboardType: keyboardType ?? TextInputType.number,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Shared footer widgets
// ──────────────────────────────────────────────

class _GreenButton extends StatelessWidget {
  const _GreenButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RegisterRow extends StatelessWidget {
  const _RegisterRow({required this.onRegister});

  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.md,
      children: [
        Expanded(
          child: CustomGestureDetector(
            onTap: onRegister,
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                'Registrar serie',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        CustomGestureDetector(
          onTap: onRegister,
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: const Icon(
              LucideIcons.check,
              color: AppColors.black,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Minor shared widget
// ──────────────────────────────────────────────

class _HeaderLabel extends StatelessWidget {
  const _HeaderLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textDescription,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
