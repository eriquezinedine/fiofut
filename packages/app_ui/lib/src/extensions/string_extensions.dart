extension StringExtensions on String {
  // ============== Validation ==============
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s\-()]{10,}$');
    return phoneRegex.hasMatch(this);
  }

  bool get isValidPassword {
    // Al menos 8 caracteres, una mayúscula, una minúscula y un número
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(this);
  }

  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  bool get isYouTubeUrl {
    final regex = RegExp(
      r'^https?://(www\.)?(youtube\.com|youtu\.be)/',
    );
    return regex.hasMatch(trim());
  }

  bool get isYouTubeShort {
    final regex = RegExp(
      r'^https?://(www\.)?youtube\.com/shorts/[a-zA-Z0-9_-]+',
    );
    return regex.hasMatch(trim());
  }

  // ============== Transformation ==============
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  // ============== Parsing ==============
  int? toInt() => int.tryParse(this);
  double? toDouble() => double.tryParse(this);

  // ============== Null Safety ==============
  String? get nullIfEmpty => isEmpty ? null : this;
  String get orEmpty => this;
}

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  String get orEmpty => this ?? '';
}
