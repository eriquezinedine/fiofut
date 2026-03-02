import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Represents how the user discovered the app.
enum ReferralSource {
  instagram,
  tiktok,
  youtube,
  facebook,
  x,
  friendFamily,
  internetSearch,
  other;

  String get label => switch (this) {
        ReferralSource.instagram => 'Instagram',
        ReferralSource.tiktok => 'TikTok',
        ReferralSource.youtube => 'YouTube',
        ReferralSource.facebook => 'Facebook',
        ReferralSource.x => 'X (Twitter)',
        ReferralSource.friendFamily => 'Amigo o familiar',
        ReferralSource.internetSearch => 'Búsqueda en internet',
        ReferralSource.other => 'Otro',
      };

  String get subtitle => switch (this) {
        ReferralSource.instagram =>
          'Reels, historias o publicaciones',
        ReferralSource.tiktok =>
          'Videos o recomendaciones en TikTok',
        ReferralSource.youtube =>
          'Videos o anuncios en YouTube',
        ReferralSource.facebook =>
          'Publicaciones o grupos en Facebook',
        ReferralSource.x =>
          'Posts o tendencias en X',
        ReferralSource.friendFamily =>
          'Me lo recomendó alguien cercano',
        ReferralSource.internetSearch =>
          'Google, App Store, Play Store...',
        ReferralSource.other =>
          'Otra forma de descubrimiento',
      };

  Color getColor() => switch (this) {
        ReferralSource.instagram => AppColors.pink,
        ReferralSource.tiktok => AppColors.teal,
        ReferralSource.youtube => AppColors.red,
        ReferralSource.facebook => AppColors.blue,
        ReferralSource.x => AppColors.purple,
        ReferralSource.friendFamily => AppColors.green,
        ReferralSource.internetSearch => AppColors.orange,
        ReferralSource.other => AppColors.teal,
      };

  IconData getIcon() => switch (this) {
        ReferralSource.instagram => LucideIcons.instagram,
        ReferralSource.tiktok => LucideIcons.music2,
        ReferralSource.youtube => LucideIcons.youtube,
        ReferralSource.facebook => LucideIcons.facebook,
        ReferralSource.x => LucideIcons.twitter,
        ReferralSource.friendFamily => LucideIcons.users,
        ReferralSource.internetSearch => LucideIcons.search,
        ReferralSource.other => LucideIcons.moreHorizontal,
      };
}
