// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class HiveKeys {
  HiveKeys._();
  static const BOX = "tugela";
  static const ACCESS_TOKEN = "access_token";
  static const REFRESH_TOKEN = "refresh_token";
  static const AUTH_EMAIL = "auth_email";
  static const AUTH_PASSWORD = "auth_password";
  static const AUTH_BIOMETRIC = "auth_biometric";
  static const AUTH_ASK_BIOMETRIC = "auth_ask_biometric";
  static const WALKTHROUGH = "walkthrough";
  static const ANNOUNCEMENTS = "announcements";
  static const themeMode = "theme_mode";
}

abstract class HiveServiceContract {
  Future<void> init();

  Future<void> assertBox();

  Future<bool> getBioAuth();

  Future<bool> getBioAuthReminder();

  Future<String?> getEmail();

  Future<String?> getPassword();

  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();

  Future<void> logout({bool reset = false});

  Future<void> setBioAuth(bool status);

  Future<void> setBioAuthReminder(bool ask);

  Future<void> setEmail(String email);

  Future<void> setLoginCredentials(String email, {String password});

  Future<void> setAccessToken(String token);
  Future<void> setRefreshToken(String token);

  Future<void> readAlerts(List<int> ids);

  Future<List<int>> getReadAlerts();

  Future<void> completeWalkthrough();

  Future<bool> getWalkthroughState();

  Future<void> setThemeMode(ThemeMode mode);

  Future<ThemeMode> getThemeMode();
}
