part of 'serie_exercise_widget.dart';

class SerieTextField extends StatefulWidget {
  const SerieTextField({
    super.key,
    this.initialValue,
    this.hint,
    this.isCompleted = false,
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
  final bool isCompleted;
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
      return !widget.isCompleted ? AppColors.background : AppColors.white;
    }
    // Started: completed = black, current = dark (white bg), pending = white
    if (widget.isCompleted) return AppColors.black;
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
