import 'dart:async';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';

class AuthRepository {
  AuthRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// Stream of auth state changes
  Stream<AuthState> get onAuthStateChange =>
      _client.auth.onAuthStateChange;

  /// Current session
  Session? get currentSession => _client.auth.currentSession;

  /// Current user
  User? get currentUser => _client.auth.currentUser;

  /// Sign in with Google using native Google Sign-In + Supabase
  Future<AuthResponse> signInWithGoogle() async {
    const webClientId =
        '797869240439-v81ulpoc23i2934dqtvmbipkclnus594.apps.googleusercontent.com';
    const iosClientId =
        '797869240439-siub5v720i6qck2u94o15v7j09dt3jup.apps.googleusercontent.com';

    final googleSignIn = GoogleSignIn(
      clientId: Platform.isIOS ? iosClientId : null,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthException('Inicio de sesion cancelado por el usuario.');
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw const AuthException(
        'No se pudo obtener el token de Google. Intenta de nuevo.',
      );
    }

    final response = await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    return response;
  }

  /// Get user profile from public.profiles table
  Future<UserProfile?> getProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) return null;
    return UserProfile.fromJson(data);
  }

  /// Complete profile with WhatsApp number
  Future<UserProfile> completeProfile({
    required String userId,
    required String whatsappNumber,
  }) async {
    final data = await _client
        .from('profiles')
        .update({
          'whatsapp_number': whatsappNumber,
          'is_profile_complete': true,
        })
        .eq('id', userId)
        .select()
        .single();

    return UserProfile.fromJson(data);
  }

  /// Update user profile
  Future<UserProfile> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
    String? whatsappNumber,
  }) async {
    final updates = <String, dynamic>{};
    if (fullName != null) updates['full_name'] = fullName;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    if (whatsappNumber != null) updates['whatsapp_number'] = whatsappNumber;

    final data = await _client
        .from('profiles')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();

    return UserProfile.fromJson(data);
  }

  /// Sign out
  Future<void> signOut() async {
    // Sign out from Google
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}
    }
    await _client.auth.signOut();
  }
}
