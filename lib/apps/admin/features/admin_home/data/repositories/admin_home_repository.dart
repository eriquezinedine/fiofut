import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/admin_stats.dart';

final adminHomeRepositoryProvider = Provider<AdminHomeRepository>((ref) {
  return AdminHomeRepository();
});

class AdminHomeRepository {
  AdminHomeRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<AdminStats> getAdminStats() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(Duration(days: todayStart.weekday - 1));

    // Total users
    final usersResponse =
        await _client.from('profiles').select('id').count(CountOption.exact);
    final totalUsers = usersResponse.count;

    // New users today
    final newTodayResponse = await _client
        .from('profiles')
        .select('id')
        .gte('created_at', todayStart.toIso8601String())
        .count(CountOption.exact);
    final newUsersToday = newTodayResponse.count;

    // Users by role
    final rolesData = await _client.from('profiles').select('role');
    final usersByRole = <String, int>{};
    for (final row in rolesData) {
      final role = row['role'] as String? ?? 'user';
      usersByRole[role] = (usersByRole[role] ?? 0) + 1;
    }

    // Total exercises
    final exercisesResponse =
        await _client.from('exercise').select('id').count(CountOption.exact);
    final totalExercises = exercisesResponse.count;

    // Total meals
    final mealsResponse =
        await _client.from('meals').select('id').count(CountOption.exact);
    final totalMeals = mealsResponse.count;

    // Exercises this week
    final exercisesWeekResponse = await _client
        .from('exercise')
        .select('id')
        .gte('created_at', weekStart.toIso8601String())
        .count(CountOption.exact);
    final exercisesThisWeek = exercisesWeekResponse.count;

    // Meals this week
    final mealsWeekResponse = await _client
        .from('meals')
        .select('id')
        .gte('created_at', weekStart.toIso8601String())
        .count(CountOption.exact);
    final mealsThisWeek = mealsWeekResponse.count;

    return AdminStats(
      totalUsers: totalUsers,
      newUsersToday: newUsersToday,
      activeUsersToday: 0, // Requires activity tracking table
      usersByRole: usersByRole,
      totalExercises: totalExercises,
      totalMeals: totalMeals,
      exercisesThisWeek: exercisesThisWeek,
      mealsThisWeek: mealsThisWeek,
    );
  }
}
