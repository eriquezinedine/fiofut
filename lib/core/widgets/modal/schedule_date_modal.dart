import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ScheduleDateResult {
  const ScheduleDateResult({
    required this.selectedDays,
    required this.startDate,
    required this.endDate,
  });

  final Set<int> selectedDays;
  final DateTime startDate;
  final DateTime endDate;
}

class ScheduleDateModal extends StatefulWidget {
  const ScheduleDateModal._();

  /// Muestra el modal para programar fechas de rutina semanal.
  ///
  /// Retorna [ScheduleDateResult] con los días seleccionados y el periodo,
  /// o `null` si se cierra sin confirmar.
  static Future<ScheduleDateResult?> show(BuildContext context) {
    return showModalBottomSheet<ScheduleDateResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ScheduleDateModal._(),
    );
  }

  @override
  State<ScheduleDateModal> createState() => _ScheduleDateModalState();
}

class _ScheduleDateModalState extends State<ScheduleDateModal> {
  final Set<int> _selectedDays = {};
  late DateTime _startDate;
  late DateTime _endDate;

  static const _dayLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
  static const _months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    return '$day ${_months[date.month - 1]} ${date.year}';
  }

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 60));
  }

  int get _totalWeeks {
    if (_selectedDays.isEmpty) return 0;
    return (_endDate.difference(_startDate).inDays / 7).ceil();
  }

  int get _totalSessions => _selectedDays.length * _totalWeeks;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildHeader(),
          _buildContent(),
          _buildButton(),
          SizedBox(
            height: MediaQuery.of(context).viewPadding.bottom + AppSpacing.xs,
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg - 4,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('Rutina semanal', style: AppTextStyles.h2),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              LucideIcons.x,
              color: AppColors.textPrimary,
              size: AppSpacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg - 4,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDaySelector(),
          const SizedBox(height: AppSpacing.lg),
          _buildDateRange(),
          const SizedBox(height: AppSpacing.lg),
          _buildSummary(),
        ],
      ),
    );
  }

  // ── Day Selector ──────────────────────────────────────────────

  Widget _buildDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona los días',
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(_dayLabels.length, (index) {
            final isSelected = _selectedDays.contains(index);
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < _dayLabels.length - 1 ? AppSpacing.xs : 0,
                ),
                child: _DayChip(
                  label: _dayLabels[index],
                  isSelected: isSelected,
                  onTap: () => setState(() {
                    isSelected
                        ? _selectedDays.remove(index)
                        : _selectedDays.add(index);
                  }),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Date Range ────────────────────────────────────────────────

  Widget _buildDateRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Periodo de la rutina',
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _DateField(
                label: 'Fecha inicio',
                date: _startDate,
                onTap: () => _pickDate(isStart: true),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _DateField(
                label: 'Fecha fin',
                date: _endDate,
                onTap: () => _pickDate(isStart: false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;
    final firstDate = isStart ? DateTime.now() : _startDate;
    final lastDate = DateTime.now().add(const Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 30));
        }
      } else {
        _endDate = picked;
      }
    });
  }

  // ── Summary ───────────────────────────────────────────────────

  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.info,
                color: AppColors.textPrimary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Resumen de rutina',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${_selectedDays.length} días por semana: $_totalWeeks semanas',
            style: AppTextStyles.small.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Total: $_totalSessions sesiones programadas',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Button ────────────────────────────────────────────────────

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg - 4,
        AppSpacing.md,
        AppSpacing.lg - 4,
        AppSpacing.lg,
      ),
      child: AppButton(
        text: 'Crear rutina',
        icon: Icons.check,
        onPressed: _selectedDays.isEmpty
            ? null
            : () => Navigator.pop(
                  context,
                  ScheduleDateResult(
                    selectedDays: _selectedDays,
                    startDate: _startDate,
                    endDate: _endDate,
                  ),
                ),
        fullWidth: true,
      ),
    );
  }
}

// ── Private Widgets ─────────────────────────────────────────────

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppSpacing.borderRadiusXl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.small.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(
                  LucideIcons.calendarDays,
                  color: AppColors.primary,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _ScheduleDateModalState._formatDate(date),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
