import 'package:flutter/foundation.dart';

@immutable
class AdminStats {
  const AdminStats({
    required this.totalUsers,
    required this.newUsersToday,
    required this.activeUsersToday,
    required this.usersByRole,
    required this.totalExercises,
    required this.totalMeals,
    required this.exercisesThisWeek,
    required this.mealsThisWeek,
  });

  final int totalUsers;
  final int newUsersToday;
  final int activeUsersToday;
  final Map<String, int> usersByRole;
  final int totalExercises;
  final int totalMeals;
  final int exercisesThisWeek;
  final int mealsThisWeek;

  factory AdminStats.empty() {
    return const AdminStats(
      totalUsers: 0,
      newUsersToday: 0,
      activeUsersToday: 0,
      usersByRole: {},
      totalExercises: 0,
      totalMeals: 0,
      exercisesThisWeek: 0,
      mealsThisWeek: 0,
    );
  }
}
