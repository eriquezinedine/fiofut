import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/models/admin_stats.dart';
import '../../domain/providers/admin_home_provider.dart';
import '../widgets/stats_card.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminHomeProvider.notifier).loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(adminHomeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: switch (homeState) {
          AdminHomeInitial() || AdminHomeLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          AdminHomeError(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.alertTriangle,
                        color: AppColors.error, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Error: $message',
                      style: AppTextStyles.body
                          .copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Reintentar',
                      onPressed: () =>
                          ref.read(adminHomeProvider.notifier).refresh(),
                    ),
                  ],
                ),
              ),
            ),
          AdminHomeLoaded(:final stats) => RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.card,
              onRefresh: () =>
                  ref.read(adminHomeProvider.notifier).refresh(),
              child: _AdminDashboard(stats: stats),
            ),
        },
      ),
    );
  }
}

class _AdminDashboard extends StatelessWidget {
  const _AdminDashboard({required this.stats});

  final AdminStats stats;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 8),

        // Header
        Row(
          children: [
            Text(
              'Admin Panel',
              style: AppTextStyles.h2.copyWith(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.roleAdmin.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.shield,
                      color: AppColors.roleAdmin, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Admin',
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.roleAdmin,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Section: Usuarios
        Text(
          'Usuarios',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Total Usuarios',
                value: '${stats.totalUsers}',
                icon: LucideIcons.users,
                iconColor: AppColors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'Nuevos Hoy',
                value: '${stats.newUsersToday}',
                icon: LucideIcons.userPlus,
                iconColor: AppColors.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Roles breakdown
        if (stats.usersByRole.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distribucion por Rol',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ...stats.usersByRole.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getRoleColor(entry.key),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _getRoleDisplayName(entry.key),
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${entry.value}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 24),

        // Section: Contenido
        Text(
          'Contenido',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Ejercicios',
                value: '${stats.totalExercises}',
                icon: LucideIcons.dumbbell,
                iconColor: AppColors.orange,
                subtitle: '+${stats.exercisesThisWeek} esta semana',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                title: 'Comidas',
                value: '${stats.totalMeals}',
                icon: LucideIcons.utensilsCrossed,
                iconColor: AppColors.primary,
                subtitle: '+${stats.mealsThisWeek} esta semana',
              ),
            ),
          ],
        ),

        const SizedBox(height: 100),
      ],
    );
  }

  Color _getRoleColor(String role) {
    return switch (role) {
      'admin' => AppColors.roleAdmin,
      'trainer' => AppColors.blue,
      _ => AppColors.secondary,
    };
  }

  String _getRoleDisplayName(String role) {
    return switch (role) {
      'admin' => 'Administradores',
      'trainer' => 'Entrenadores',
      'user' => 'Usuarios',
      _ => role,
    };
  }
}
