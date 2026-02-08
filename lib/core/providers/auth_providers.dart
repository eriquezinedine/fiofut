import 'dart:async';

import 'package:authentication/authentication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for the AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Provider that streams auth state changes
final authStateProvider = StreamProvider<AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.onAuthStateChange;
});

/// Provider for the current user's profile
final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(
  UserProfileNotifier.new,
);

class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final authState = ref.watch(authStateProvider);
    final user = authState.whenOrNull(data: (state) {
      if (state.session != null) return state.session!.user;
      return null;
    });

    if (user == null) return null;

    final repo = ref.read(authRepositoryProvider);
    return repo.getProfile(user.id);
  }

  /// Refresh profile from database
  Future<void> refreshProfile() async {
    final repo = ref.read(authRepositoryProvider);
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      state = const AsyncData(null);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.getProfile(user.id));
  }

  /// Complete profile with WhatsApp number
  Future<UserProfile> completeProfile(String whatsappNumber) async {
    final repo = ref.read(authRepositoryProvider);
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final profile = await repo.completeProfile(
      userId: userId,
      whatsappNumber: whatsappNumber,
    );
    state = AsyncData(profile);
    return profile;
  }
}
