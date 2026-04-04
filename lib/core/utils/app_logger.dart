import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Simple logger for debugging Supabase and other operations.
class AppLogger {
  AppLogger._();

  static bool _enabled = kDebugMode;

  static void enable() => _enabled = true;
  static void disable() => _enabled = false;

  static void supabase(String operation, [dynamic data]) {
    if (!_enabled) return;
    final timestamp = DateTime.now().toIso8601String().split('T').last;
    final message = '[$timestamp] SUPABASE: $operation';

    developer.log(message, name: 'Supabase');
    // ignore: avoid_print
    print('\x1B[36m$message\x1B[0m'); // Cyan color

    if (data != null) {
      developer.log('Data: $data', name: 'Supabase');
      // ignore: avoid_print
      print('\x1B[33m  → $data\x1B[0m'); // Yellow color
    }
  }

  static void provider(String provider, String action, [dynamic data]) {
    if (!_enabled) return;
    final timestamp = DateTime.now().toIso8601String().split('T').last;
    final message = '[$timestamp] PROVIDER: $provider.$action';

    developer.log(message, name: 'Provider');
    // ignore: avoid_print
    print('\x1B[35m$message\x1B[0m'); // Magenta color

    if (data != null) {
      // ignore: avoid_print
      print('\x1B[33m  → $data\x1B[0m');
    }
  }

  static void info(String message) {
    if (!_enabled) return;
    // ignore: avoid_print
    print('\x1B[32m[INFO] $message\x1B[0m'); // Green color
  }

  static void error(String message, [dynamic error]) {
    if (!_enabled) return;
    // ignore: avoid_print
    print('\x1B[31m[ERROR] $message\x1B[0m'); // Red color
    if (error != null) {
      // ignore: avoid_print
      print('\x1B[31m  → $error\x1B[0m');
    }
  }
}
