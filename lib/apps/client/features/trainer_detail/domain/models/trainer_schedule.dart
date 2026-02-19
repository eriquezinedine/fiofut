import 'package:flutter/foundation.dart';

/// Representa un bloque de horario individual del entrenador.
@immutable
class ScheduleSlot {
  const ScheduleSlot({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
  });

  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  String get formattedStart => _formatTime(startHour, startMinute);
  String get formattedEnd => _formatTime(endHour, endMinute);

  /// Verifica si la hora actual cae dentro de este slot.
  bool isActiveNow() {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;
    return currentMinutes >= startMinutes && currentMinutes < endMinutes;
  }

  static String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12
        ? hour - 12
        : hour == 0
            ? 12
            : hour;
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }
}

/// Horario de un dia especifico con multiples slots.
@immutable
class DaySchedule {
  const DaySchedule({
    required this.dayOfWeek,
    required this.slots,
  });

  /// 1 = Lunes, 7 = Domingo
  final int dayOfWeek;
  final List<ScheduleSlot> slots;

  String get dayName => switch (dayOfWeek) {
        1 => 'Lunes',
        2 => 'Martes',
        3 => 'Miercoles',
        4 => 'Jueves',
        5 => 'Viernes',
        6 => 'Sabado',
        7 => 'Domingo',
        _ => '',
      };

  String get shortDayName => switch (dayOfWeek) {
        1 => 'Lun',
        2 => 'Mar',
        3 => 'Mie',
        4 => 'Jue',
        5 => 'Vie',
        6 => 'Sab',
        7 => 'Dom',
        _ => '',
      };

  /// Verifica si hoy es este dia y si algun slot esta activo.
  bool isActiveNow() {
    final now = DateTime.now();
    final today = now.weekday; // 1 = Monday, 7 = Sunday
    if (today != dayOfWeek) return false;
    return slots.any((slot) => slot.isActiveNow());
  }
}

/// Modelo completo del horario del entrenador.
@immutable
class TrainerSchedule {
  const TrainerSchedule({
    required this.days,
  });

  final List<DaySchedule> days;

  /// Verifica si el entrenador esta disponible ahora mismo.
  bool get isAvailableNow => days.any((day) => day.isActiveNow());

  /// Retorna el horario de hoy (si existe).
  DaySchedule? get todaySchedule {
    final today = DateTime.now().weekday;
    try {
      return days.firstWhere((d) => d.dayOfWeek == today);
    } catch (_) {
      return null;
    }
  }
}
