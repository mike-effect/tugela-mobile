import 'dart:convert' as convert;

import 'package:encrypt/encrypt.dart' as e;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tugela/services/contracts/hive_service.contract.dart';

class HiveService extends HiveServiceContract {
  HiveService({this.boxNameSuffix = ""});

  Box? box;

  final String boxNameSuffix;

  static final _eKey = e.Key.fromUtf8("MTcyMjcxNjEyMzQyMS9zdXBl");
  final _iv = e.IV.fromLength(16);
  final _encrypter = e.Encrypter(e.AES(_eKey));

  e.Encrypted _encrypt(String value) {
    return _encrypter.encrypt(value, iv: _iv);
  }

  String _decrypt(e.Encrypted value) {
    return _encrypter.decrypt(value, iv: _iv);
  }

  Future<void> set<T>(String key, T? value) async {
    await assertBox();
    final encryptedKey = _encrypt(key).base16;
    final encryptedValue = (value == "" || value == null)
        ? value
        : _encrypt(value.toString()).base16;
    await box?.put(encryptedKey, encryptedValue);
  }

  Future<dynamic> get<T>(String key, {dynamic defaultValue}) async {
    await assertBox();
    final encryptedKey = _encrypt(key);
    final encryptedValue = box?.get(
      encryptedKey.base16,
      defaultValue: defaultValue != null
          ? _encrypt(defaultValue.toString()).base16
          : null,
    );
    if (encryptedValue == null) return null;
    if (encryptedValue == "") return "";
    final decrypted = _decrypt(e.Encrypted.fromBase16(encryptedValue));
    try {
      return convert.jsonDecode(decrypted.toString()) as T?;
    } catch (e) {
      return decrypted as T?;
    }
  }

  Future<void> delete<T>(String key) async {
    await assertBox();
    final encryptedKey = _encrypt(key).base16;
    await box?.delete(encryptedKey);
  }

  @override
  Future<void> assertBox() async {
    if (box != null && (box?.isOpen ?? false)) return;
    return await init();
  }

  Stream<BoxEvent> watch(String key) {
    return box!.watch(key: key);
  }

  @override
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.openBox(boxNameSuffix).then((b) => box = b);
  }

  @override
  Future<bool> getBioAuth() async {
    await assertBox();
    return await get<bool>(HiveKeys.AUTH_BIOMETRIC, defaultValue: false);
  }

  @override
  Future<bool> getBioAuthReminder() async {
    await assertBox();
    return await get<bool>(HiveKeys.AUTH_ASK_BIOMETRIC, defaultValue: true);
  }

  @override
  Future<String?> getEmail() async {
    await assertBox();
    return await get<String?>(HiveKeys.AUTH_EMAIL);
  }

  @override
  Future<String?> getPassword() async {
    await assertBox();
    return await get<String?>(HiveKeys.AUTH_PASSWORD);
  }

  @override
  Future<String?> getAccessToken() async {
    await assertBox();
    return await get<String?>(HiveKeys.ACCESS_TOKEN);
  }

  @override
  Future<String?> getRefreshToken() async {
    await assertBox();
    return await get<String?>(HiveKeys.REFRESH_TOKEN);
  }

  @override
  Future<void> logout({bool reset = false}) async {
    await assertBox();
    await delete(HiveKeys.ACCESS_TOKEN);
    await delete(HiveKeys.REFRESH_TOKEN);
    if (reset) {
      await delete(HiveKeys.AUTH_BIOMETRIC);
      await delete(HiveKeys.AUTH_ASK_BIOMETRIC);
      await delete(HiveKeys.AUTH_PASSWORD);
      await delete(HiveKeys.AUTH_EMAIL);
      await delete(HiveKeys.ANNOUNCEMENTS);
    }
  }

  @override
  Future<void> setBioAuth(bool status) async {
    await assertBox();
    return await set(HiveKeys.AUTH_BIOMETRIC, status);
  }

  @override
  Future<void> setBioAuthReminder(bool ask) async {
    await assertBox();
    return await set(HiveKeys.AUTH_ASK_BIOMETRIC, ask);
  }

  @override
  Future<void> setEmail(String email) async {
    await assertBox();
    return await set(HiveKeys.AUTH_EMAIL, email);
  }

  @override
  Future<void> setLoginCredentials(String email, {String? password}) async {
    await assertBox();
    if (password != null && !kIsWeb) {
      await set(HiveKeys.AUTH_PASSWORD, password);
    }
    return await set(HiveKeys.AUTH_EMAIL, email);
  }

  @override
  Future<void> setAccessToken(String token) async {
    await assertBox();
    return await set(HiveKeys.ACCESS_TOKEN, token);
  }

  @override
  Future<void> setRefreshToken(String token) async {
    await assertBox();
    return await set(HiveKeys.REFRESH_TOKEN, token);
  }

  @override
  Future<void> readAlerts(List<int> ids) async {
    await assertBox();
    await set(HiveKeys.ANNOUNCEMENTS, (ids).join(','));
  }

  @override
  Future<List<int>> getReadAlerts() async {
    await assertBox();
    final res = (await get<String>(HiveKeys.ANNOUNCEMENTS) ?? "").toString();
    final list = res.split(',');
    list.removeWhere((e) => e.isEmpty);
    return list.map((e) => int.parse(e)).toList();
  }

  @override
  Future<void> completeWalkthrough() async {
    await assertBox();
    return await set(HiveKeys.WALKTHROUGH, true);
  }

  @override
  Future<bool> getWalkthroughState() async {
    await assertBox();
    return await get<bool>(HiveKeys.WALKTHROUGH, defaultValue: false);
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    final res = await get(HiveKeys.themeMode);
    return {
          "light": ThemeMode.light,
          "dark": ThemeMode.dark,
          "system": ThemeMode.system,
        }[res] ??
        ThemeMode.system;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await set(HiveKeys.themeMode, mode.name);
  }
}
