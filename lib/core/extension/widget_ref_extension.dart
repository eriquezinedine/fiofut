import 'package:authentication/authentication.dart';
import 'package:fio_fut/apps/admin/features/admin_content/presentation/screens/admin_content_page.dart';
import 'package:fio_fut/apps/client/features/app_content/presentation/pages/app_content_page.dart';
import 'package:fio_fut/apps/client/features/complete_profile/complete_profile.dart';
import 'package:fio_fut/apps/client/features/onboarding/presentation/screens/onboarding_wizard.dart';
import 'package:fio_fut/core/providers/auth_providers.dart';
import 'package:fio_fut/core/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension WidgetRefRouting on WidgetRef {
  Future<UserProfile?> fetchProfile(Session session) async {
    final cached = read(userProfileProvider).valueOrNull;
    if (cached != null) return cached;

    final data = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', session.user.id)
        .maybeSingle();

    if (data == null) return null;
    return UserProfile.fromJson(data);
  }

  String getRoute(UserProfile profile) {
    return switch (profile.userType) {
      UserType.admin => AdminContentPage.path,
      UserType.trainer => AppRoutes.trainer,
      UserType.student => _resolveStudentRoute(profile),
    };
  }

  String _resolveStudentRoute(UserProfile profile) {
    if (profile.whatsappNumber == null) return CompleteProfileScreen.path;
    if (!profile.isProfileComplete) return OnboardingWizard.path;
    return AppContentPage.path;
  }
}
