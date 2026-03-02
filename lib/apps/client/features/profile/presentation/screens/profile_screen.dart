import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/profile/domain/providers/logout_provider.dart';
import 'package:fio_fut/core/providers/auth_providers.dart';
import 'package:fio_fut/apps/client/features/login_google/presentation/screens/login_google_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final logoutState = ref.watch(logoutProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Error cargando perfil: $e',
              style: AppTextStyles.body.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (profile) {
          final supabaseUser = Supabase.instance.client.auth.currentUser;
          final name = profile?.fullName ??
              supabaseUser?.userMetadata?['full_name'] as String? ??
              'Usuario';
          final email = supabaseUser?.email ?? '';
          final avatarUrl = profile?.avatarUrl ??
              supabaseUser?.userMetadata?['avatar_url'] as String?;

          return SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 8),

                // Header
                Text(
                  'Perfil',
                  style: AppTextStyles.h2.copyWith(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(height: 28),

                // Avatar
                AppAvatar(
                  imageUrl: avatarUrl,
                  name: name,
                  size: AppSpacing.avatarXXl,
                ),

                const SizedBox(height: 16),

                // Name
                Center(
                  child: Text(
                    name,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Email
                Center(
                  child: Text(
                    email,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Role badge
                if (profile != null)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getRoleLabel(profile.userType.name),
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 32),

                // Info section
                _SectionTitle(title: 'Informacion'),
                const SizedBox(height: 12),

                _ProfileInfoTile(
                  icon: LucideIcons.user,
                  label: 'Nombre',
                  value: name,
                ),
                _ProfileInfoTile(
                  icon: LucideIcons.mail,
                  label: 'Email',
                  value: email.isNotEmpty ? email : 'Sin email',
                ),
                if (profile?.whatsappNumber != null &&
                    profile!.whatsappNumber!.isNotEmpty)
                  _ProfileInfoTile(
                    icon: LucideIcons.phone,
                    label: 'WhatsApp',
                    value: profile.whatsappNumber!,
                  ),
                _ProfileInfoTile(
                  icon: LucideIcons.calendar,
                  label: 'Miembro desde',
                  value: profile?.createdAt != null
                      ? _formatDate(profile!.createdAt!)
                      : 'Desconocido',
                ),

                const SizedBox(height: 32),

                // Logout button - white outlined with loading state
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: logoutState.isLoading
                        ? null
                        : () => _handleLogout(context, ref),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: logoutState.isLoading
                            ? AppColors.textMuted
                            : AppColors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                    ),
                    child: logoutState.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Cerrar Sesion',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),

                // Error message
                if (logoutState.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      logoutState.errorMessage!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 140),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(logoutProvider.notifier).signOut();
    if (success && context.mounted) {
      GoRouter.of(context).go(LoginGoogleScreen.path);
    }
  }

  String _getRoleLabel(String role) {
    return switch (role) {
      'admin' => 'Administrador',
      'trainer' => 'Entrenador',
      _ => 'Usuario',
    };
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textMuted,
        fontWeight: FontWeight.w600,
        fontSize: 13,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
