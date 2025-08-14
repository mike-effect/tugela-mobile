import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tugela/models.dart';
import 'package:tugela/utils.dart';

enum ApiEnvironment { staging, production }

class ApiConfig {
  final String baseUrl, paymentsUrl;
  const ApiConfig({required this.baseUrl, required this.paymentsUrl});
}

class AppConfig {
  static final AppConfig instance = AppConfig._internal();
  AppConfig._internal();

  ApiEnvironment apiEnvironment = ApiEnvironment.production;
  int currencyFactor = 1;
  int currencyPrecision = 2;
  String currencyCode = "";
  String userUuid = "";
  RemotePlatformConfig? remotePlatformConfig;

  static const _apiConfigs = {
    ApiEnvironment.staging: ApiConfig(
      baseUrl: "https://articulate-ego-429522-d4.uc.r.appspot.com/api",
      paymentsUrl: "https://dev-tugela-payments.netlify.app",
    ),
    ApiEnvironment.production: ApiConfig(
      baseUrl: "https://prod-dot-articulate-ego-429522-d4.uc.r.appspot.com/api",
      paymentsUrl: "https://tugela-payments.netlify.app",
    ),
  };

  String get remoteApiUrl {
    return apiEnvironment == ApiEnvironment.staging
        ? remotePlatformConfig?.stagingUrl ?? ""
        : remotePlatformConfig?.productionUrl ?? "";
  }

  String get apiHost {
    if (kReleaseMode && remoteApiUrl.isNotEmpty) {
      return remoteApiUrl;
    }
    return _apiConfigs[apiEnvironment]!.baseUrl;
  }

  String get paymentsService => _apiConfigs[apiEnvironment]!.paymentsUrl;

  static const siteUrl = "https://tugela.co";
  static const webAppUrl = siteUrl;
  static const supportUrl = "$siteUrl/contact";
  static const termsUrl = "$siteUrl/terms";
  static const privacyUrl = "$siteUrl/privacy-policy";
  static const faqUrl = "$siteUrl/contact";
  static const appStoreId = "6444046206";

  // static void ensureInitialized() {
  //   sl.registerLazySingleton<AppConfig>(() => AppConfig.instance);
  // }

  // static e.Encrypted _encrypt(String value) {
  //   final eKey = e.Key.fromUtf8("kXp2s5v8x/A?D(G+7w!z%C*F-JaNdRgU");
  //   return e.Encrypter(e.AES(eKey)).encrypt(value, iv: e.IV.fromLength(16));
  // }

  // static String _decrypt(e.Encrypted value) {
  //   final eKey = e.Key.fromUtf8("kXp2s5v8x/A?D(G+7w!z%C*F-JaNdRgU");
  //   return e.Encrypter(e.AES(eKey)).decrypt(value, iv: e.IV.fromLength(16));
  // }

  String transakUrl({
    required String action,
    required String walletAddress,
    required String email,
    required Map<String, dynamic> userData,
  }) {
    final user = Uri.encodeComponent(jsonEncode(userData));
    final api = (apiEnvironment == ApiEnvironment.staging
        ? remotePlatformConfig?.transak?.staging
        : remotePlatformConfig?.transak?.production);
    final url = (action == "topup" ? api?.topup : api?.withdrawal)
        ?.replaceAll('{address}', walletAddress)
        .replaceAll('{email}', email)
        .replaceAll('{userData}', user);
    return url ?? "";
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
