import 'package:app_ui/app_ui.dart';
import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fio_fut/core/widgets/modal/schedule_info_modal.dart';

import '../../domain/models/trainer_schedule.dart';
import '../widgets/widgets.dart';

class TrainerDetailPage extends StatelessWidget {
  const TrainerDetailPage({
    required this.trainer,
    super.key,
  });

  static const String name = 'trainer-detail';
  static const String path = '/trainer-detail';

  final UserProfile trainer;

  // Horario demo - En produccion vendria de la base de datos
  TrainerSchedule get _schedule => const TrainerSchedule(
        days: [
          DaySchedule(dayOfWeek: 1, slots: [
            ScheduleSlot(startHour: 6, startMinute: 0, endHour: 9, endMinute: 0),
            ScheduleSlot(startHour: 17, startMinute: 0, endHour: 20, endMinute: 0),
          ]),
          DaySchedule(dayOfWeek: 2, slots: [
            ScheduleSlot(startHour: 7, startMinute: 0, endHour: 11, endMinute: 0),
          ]),
          DaySchedule(dayOfWeek: 3, slots: [
            ScheduleSlot(startHour: 6, startMinute: 0, endHour: 9, endMinute: 0),
            ScheduleSlot(startHour: 17, startMinute: 0, endHour: 20, endMinute: 0),
          ]),
          DaySchedule(dayOfWeek: 4, slots: [
            ScheduleSlot(startHour: 7, startMinute: 0, endHour: 11, endMinute: 0),
          ]),
          DaySchedule(dayOfWeek: 5, slots: [
            ScheduleSlot(startHour: 6, startMinute: 0, endHour: 9, endMinute: 0),
            ScheduleSlot(startHour: 15, startMinute: 0, endHour: 18, endMinute: 0),
          ]),
        ],
      );

  Future<void> _openWhatsApp(BuildContext context) async {
    final phone = trainer.whatsappNumber;
    if (phone == null || phone.isEmpty) return;

    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se pudo abrir WhatsApp',
              style: AppTextStyles.caption.copyWith(color: AppColors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final schedule = _schedule;
    final isAvailable = schedule.isAvailableNow;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar con gradient
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.arrowLeft,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _TrainerHeader(
                trainer: trainer,
                isAvailable: isAvailable,
              ),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),

                  // Info cards
                  _TrainerInfoCards(trainer: trainer),

                  const SizedBox(height: AppSpacing.lg),

                  // Alcance de consultas
                  const _ConsultationScopeCard(),

                  const SizedBox(height: AppSpacing.lg),

                  // Horario section
                  const _ScheduleHeader(),
                  const SizedBox(height: AppSpacing.md),

                  // Schedule list
                  ScheduleList(schedule: schedule),

                  const SizedBox(height: AppSpacing.lg),

                  // Estado actual
                  _AvailabilityBadge(
                    isAvailable: isAvailable,
                    todaySchedule: schedule.todaySchedule,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Boton WhatsApp
                  _WhatsAppButton(
                    isAvailable: isAvailable,
                    hasPhone: trainer.whatsappNumber != null &&
                        trainer.whatsappNumber!.isNotEmpty,
                    onTap: () => _openWhatsApp(context),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header de la seccion horario con icono de info animado.
class _ScheduleHeader extends StatefulWidget {
  const _ScheduleHeader();

  @override
  State<_ScheduleHeader> createState() => _ScheduleHeaderState();
}

class _ScheduleHeaderState extends State<_ScheduleHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Horario Disponible',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.white,
              ),
            ),
            GestureDetector(
              onTap: () => ScheduleInfoModal.show(context),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.info,
                    color: AppColors.info,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'Dias y horas en los que tu entrenador esta disponible',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

/// Header con gradient y avatar del entrenador.
class _TrainerHeader extends StatelessWidget {
  const _TrainerHeader({
    required this.trainer,
    required this.isAvailable,
  });

  final UserProfile trainer;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8B5CF6),
                Color(0xFF3B82F6),
                Color(0xFF06B6D4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Mesh overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.6, -0.6),
                radius: 1.2,
                colors: [
                  const Color(0xFFCDFF00).withValues(alpha: 0.2),
                  const Color(0xFFCDFF00).withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),

        // Bottom gradient fade
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 120,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0),
                  AppColors.background,
                ],
              ),
            ),
          ),
        ),

        // Content
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Row(
            children: [
              // Avatar
              Container(
                width: AppSpacing.avatarXl,
                height: AppSpacing.avatarXl,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: trainer.avatarUrl != null
                    ? ClipOval(
                        child: AppCachedImage(
                          imageUrl: trainer.avatarUrl!,
                          width: AppSpacing.avatarXl,
                          height: AppSpacing.avatarXl,
                        ),
                      )
                    : const Icon(
                        LucideIcons.user,
                        color: AppColors.white,
                        size: 36,
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Name & role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trainer.fullName ?? 'Entrenador',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.roleTrainer.withValues(alpha: 0.2),
                            borderRadius: AppSpacing.borderRadiusFull,
                            border: Border.all(
                              color:
                                  AppColors.roleTrainer.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                LucideIcons.dumbbell,
                                color: AppColors.roleTrainer,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Entrenador',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.roleTrainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? AppColors.success
                                : AppColors.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isAvailable ? 'Disponible' : 'No disponible',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isAvailable
                                ? AppColors.success
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Cards con info del entrenador.
class _TrainerInfoCards extends StatelessWidget {
  const _TrainerInfoCards({required this.trainer});

  final UserProfile trainer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: LucideIcons.calendarDays,
            label: 'Miembro desde',
            value: trainer.createdAt != null
                ? _formatDate(trainer.createdAt!)
                : '--',
            color: AppColors.purple,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _InfoCard(
            icon: LucideIcons.phone,
            label: 'WhatsApp',
            value: trainer.whatsappNumber != null
                ? _maskPhone(trainer.whatsappNumber!)
                : 'No disponible',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _maskPhone(String phone) {
    if (phone.length < 4) return phone;
    return '***${phone.substring(phone.length - 4)}';
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Icon(icon, color: color, size: AppSpacing.iconSm),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxs),
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Badge indicador de disponibilidad actual.
class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({
    required this.isAvailable,
    this.todaySchedule,
  });

  final bool isAvailable;
  final DaySchedule? todaySchedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.success.withValues(alpha: 0.08)
            : AppColors.card,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: isAvailable
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isAvailable
                  ? AppColors.success.withValues(alpha: 0.15)
                  : AppColors.surface,
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Icon(
              isAvailable ? LucideIcons.checkCircle2 : LucideIcons.clock,
              color: isAvailable ? AppColors.success : AppColors.textMuted,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAvailable
                      ? 'Disponible ahora'
                      : 'Fuera de horario',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: isAvailable
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getSubtitle(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSubtitle() {
    if (isAvailable) {
      return 'Puedes contactarlo por WhatsApp';
    }
    if (todaySchedule != null) {
      final nextSlot = todaySchedule!.slots
          .where((s) {
            final now = DateTime.now();
            final currentMin = now.hour * 60 + now.minute;
            return s.startHour * 60 + s.startMinute > currentMin;
          })
          .toList();
      if (nextSlot.isNotEmpty) {
        return 'Proxima disponibilidad: ${nextSlot.first.formattedStart}';
      }
    }
    return 'Revisa el horario para contactar';
  }
}

/// Boton de WhatsApp con estado habilitado/deshabilitado.
class _WhatsAppButton extends StatelessWidget {
  const _WhatsAppButton({
    required this.isAvailable,
    required this.hasPhone,
    required this.onTap,
  });

  final bool isAvailable;
  final bool hasPhone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = isAvailable && hasPhone;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: AppSpacing.buttonHeightLg,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF25D366)
              : AppColors.surface,
          borderRadius: AppSpacing.borderRadiusLg,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xFF25D366).withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.messageCircle,
              color: enabled ? AppColors.white : AppColors.textDimmed,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              enabled
                  ? 'Contactar por WhatsApp'
                  : 'Disponible solo en horario',
              style: AppTextStyles.button.copyWith(
                color: enabled ? AppColors.white : AppColors.textDimmed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card informativa sobre el alcance de consultas del entrenador.
class _ConsultationScopeCard extends StatelessWidget {
  const _ConsultationScopeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.06),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.messageSquare,
              color: AppColors.info,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Alcance de consultas',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tu entrenador esta disponible para resolver dudas '
            'sobre tu plan de entrenamiento, alimentacion, '
            'tecnica de ejercicios y bienestar fisico.\n\n'
            'Para consultas medicas o tratamientos especializados, '
            'te recomendamos acudir con un profesional de la salud.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
