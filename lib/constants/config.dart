import 'dart:convert';

import 'package:encrypt/encrypt.dart' as e;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tugela/models.dart';
import 'package:tugela/services/sl.dart';
import 'package:tugela/utils.dart';

enum ApiEnvironment { staging, production }

class AppConfig {
  static AppConfig? _instance;

  int currencyFactor = 100;
  int currencyPrecision = 2;
  String currencyCode = " ";
  String userUuid = "";
  RemotePlatformConfig? remotePlatformConfig;

  static ApiEnvironment apiEnvironment = ApiEnvironment.staging;

  static final _apiHostMap = {
    ApiEnvironment.staging: _stagingAPI,
    ApiEnvironment.production: _productionAPI,
  };

  static String get apiHost {
    return _apiHostMap[apiEnvironment]!;
  }

  static const _stagingAPI =
      "https://articulate-ego-429522-d4.uc.r.appspot.com/api";
  static const _productionAPI =
      "https://articulate-ego-429522-d4.uc.r.appspot.com/api";

  static const siteUrl = "https://tugela.org";
  static const webAppUrl = siteUrl;
  static const supportUrl = "$siteUrl/contact";
  static const termsUrl = "$siteUrl/terms";
  static const privacyUrl = "$siteUrl/privacy-policy";
  static const faqUrl = "$siteUrl/contact";
  static const appStoreId = "6444046206";

  static String get monoKey {
    final encryptedValue = apiEnvironment == ApiEnvironment.production
        ? "7c826b632ee6385187b91be16215fab27ed3696198079c62340bdeb81571025d"
        : "7c826b632ee6385187b91be16215fab27ed3696198079c62340bdeb81571025d";
    return _decrypt(e.Encrypted.fromBase16(encryptedValue));
  }

  AppConfig._internal() {
    _instance = this;
  }

  factory AppConfig() => _instance ?? AppConfig._internal();

  static void ensureInitialized() {
    sl.registerLazySingleton<AppConfig>(() => AppConfig());
  }

  // static e.Encrypted _encrypt(String value) {
  //   final eKey = e.Key.fromUtf8("kXp2s5v8x/A?D(G+7w!z%C*F-JaNdRgU");
  //   return e.Encrypter(e.AES(eKey)).encrypt(value, iv: e.IV.fromLength(16));
  // }

  static String _decrypt(e.Encrypted value) {
    final eKey = e.Key.fromUtf8("kXp2s5v8x/A?D(G+7w!z%C*F-JaNdRgU");
    return e.Encrypter(e.AES(eKey)).decrypt(value, iv: e.IV.fromLength(16));
  }
}

Future<AppRemoteConfig?> getRemoteAppConfig() async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.ensureInitialized();
    await remoteConfig.fetchAndActivate();
    final v = (await PackageInfo.fromPlatform()).version;
    final versions = jsonDecode(remoteConfig.getValue('versions').asString());
    if (versions != null && (versions[v] ??= versions['all']) != null) {
      return AppRemoteConfig.fromJson(versions[v] ?? {});
    } else {
      return null;
    }
  } catch (e, s) {
    handleError(e, stackTrace: s);
    return null;
  }
}
