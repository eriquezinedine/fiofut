import 'package:fio_fut/apps/client/features/configuration_exercise/domain/providers/configuration_exercise_provider/configuration_exercise_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final configurationExerciseProvider = NotifierProvider.autoDispose<
    ConfigurationExerciseNotifier, ConfigurationExerciseState>(
  ConfigurationExerciseNotifier.new,
);

class ConfigurationExerciseNotifier
    extends AutoDisposeNotifier<ConfigurationExerciseState> {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  ConfigurationExerciseState build() {
    Future.microtask(loadSchedules);
    return const ConfigurationExerciseLoading();
  }

  Future<void> loadSchedules() async {
    state = const ConfigurationExerciseLoading();

    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        state = const ConfigurationExerciseError(message: 'No autenticado');
        return;
      }

      final rows = await _client
          .from('exercise_schedule')
          .select('''
            id, id_exercise, id_user_profile, id_created_by,
            schedule_type, start_date, end_date, days_of_week, notes,
            exercise:id_exercise (
              id, name, description, url_img_exercise, url_video_exercise, type_exercise,
              muscle:id_muscle (id, name, muscle_group)
            )
          ''')
          .eq('id_user_profile', userId)
          .not('days_of_week', 'is', null)
          .order('start_date', ascending: false);

      final schedules = (rows as List)
          .where((r) =>
              r['start_date'] != null &&
              r['end_date'] != null &&
              r['days_of_week'] != null)
          .map((r) => ExerciseSchedule.fromJson(r as Map<String, dynamic>))
          .toList();

      state = ConfigurationExerciseLoaded(schedules: schedules);
    } catch (e) {
      state = ConfigurationExerciseError(message: e.toString());
    }
  }

  ConfigurationExerciseLoaded? get _loaded =>
      state is ConfigurationExerciseLoaded
          ? state as ConfigurationExerciseLoaded
          : null;

  void _setOperating() {
    final current = _loaded;
    if (current != null) {
      state = current.copyWith(isOperating: true, operationError: null);
    }
  }

  void _setOperationError(String message) {
    final current = _loaded;
    if (current != null) {
      state = current.copyWith(isOperating: false, operationError: message);
    }
  }

  void clearOperationError() {
    final current = _loaded;
    if (current != null) {
      state = current.copyWith(operationError: null);
    }
  }

  /// Edita el rango de fechas y dias de un schedule.
  ///
  /// Actualiza days_of_week, start_date y end_date directamente.
  /// Los sets pasados (completados o no) quedan intactos en exercise_set.
  /// Solo se eliminan sets futuros no completados.
  Future<bool> updateScheduleRange({
    required String scheduleId,
    required Set<int> newDays,
    required DateTime newStartDate,
    required DateTime newEndDate,
  }) async {
    _setOperating();

    try {
      final today = DateTime.now();
      final todayStr = DateTime(today.year, today.month, today.day)
          .toIso8601String()
          .split('T')
          .first;

      // 1. Actualizar el schedule directamente
      await _client.from('exercise_schedule').update({
        'days_of_week': newDays.toList().join(','),
        'start_date': newStartDate.toIso8601String().split('T').first,
        'end_date': newEndDate.toIso8601String().split('T').first,
      }).eq('id', scheduleId);

      // 2. Eliminar sets futuros no completados
      await _client
          .from('exercise_set')
          .delete()
          .eq('id_exercise_schedule', scheduleId)
          .gte('session_date', todayStr)
          .eq('is_completed', false);

      await loadSchedules();
      return true;
    } catch (e) {
      _setOperationError('Error al actualizar la rutina');
      return false;
    }
  }

  /// Elimina un schedule. Solo borra sesiones del dia actual en adelante.
  /// Las sesiones pasadas (completadas o no) se mantienen.
  Future<bool> deleteSchedule(String scheduleId) async {
    _setOperating();

    try {
      final today = DateTime.now();
      final todayStr = DateTime(today.year, today.month, today.day)
          .toIso8601String()
          .split('T')
          .first;

      await _client
          .from('exercise_set')
          .delete()
          .eq('id_exercise_schedule', scheduleId)
          .gte('session_date', todayStr);

      await _client
          .from('exercise_schedule')
          .delete()
          .eq('id', scheduleId);

      await loadSchedules();
      return true;
    } catch (e) {
      _setOperationError('Error al eliminar la rutina');
      return false;
    }
  }
}
