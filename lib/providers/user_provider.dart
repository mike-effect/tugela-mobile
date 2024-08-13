import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tugela/models/api_response.dart';
import 'package:tugela/models/auth.dart';
import 'package:tugela/models/token.dart';
import 'package:tugela/models/user.dart';
import 'package:tugela/providers/contracts/user_provider.contract.dart';
import 'package:tugela/services/contracts/api_service.contract.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/routes.dart';

class UserProvider extends UserProviderContract {
  @override
  void initialize() {
    // getUserMe();
  }

  @override
  void reset() {
    apiService.setUser(null);
  }

  @override
  Future<bool> getBioAuth() async {
    try {
      final res = await hiveService.getBioAuth();
      return res && (await getBiometricType()) != null;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<bool> getBioAuthReminder() async {
    try {
      if (await getBioAuth()) return false;
      final ask = await hiveService.getBioAuthReminder();
      final type = await localAuthService.getBiometricType();
      if (ask && type != null) return true;
      return false;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<void> setBioAuth(bool status) async {
    try {
      return await hiveService.setBioAuth(status);
    } catch (e, s) {
      handleError(e, stackTrace: s);
    }
  }

  @override
  Future<void> setBioAuthReminder(bool ask) async {
    try {
      return await hiveService.setBioAuthReminder(ask);
    } catch (e, s) {
      handleError(e, stackTrace: s);
    }
  }

  @override
  Future<BiometricType?> getBiometricType() async {
    try {
      return await localAuthService.getBiometricType();
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  String biometricTypeString(BiometricType? type) {
    switch (type) {
      case BiometricType.face:
        return "Face ID";
      case BiometricType.fingerprint:
        if (defaultTargetPlatform == TargetPlatform.iOS) return "Touch ID";
        return "Fingerprint";
      default:
        return "Biometric Authentication";
    }
  }

  @override
  Future<bool> authenticateBio() async {
    try {
      return await localAuthService.authenticate();
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<String?> getEmail() async {
    try {
      return await hiveService.getEmail();
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<String?> getPassword() async {
    try {
      return await hiveService.getPassword();
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<bool> canAutoLogin() async {
    try {
      final email = await hiveService.getEmail();
      final password = await hiveService.getPassword();
      return (email ?? "").isNotEmpty && (password ?? "").isNotEmpty;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<ApiResponse?> autoLogin() async {
    try {
      if (!await getBioAuth() || !await canAutoLogin()) return null;
      final email = await hiveService.getEmail();
      final password = await hiveService.getPassword();
      if (email != null && password != null) {
        return await login(TokenObtainPairRequest(
          email: email,
          password: password,
        ));
      } else {
        return null;
      }
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<TokenObtainPairResponse>?> login(
    TokenObtainPairRequest data,
  ) async {
    try {
      final res = await apiService.login(data);
      if (res.data?.access != null) {
        await hiveService.setAccessToken(res.data!.access!);
        await hiveService.setLoginCredentials(
          data.email!,
          password: data.password!,
        );
      }
      if (res.data?.refresh != null) {
        await hiveService.setRefreshToken(res.data!.refresh!);
      }
      await getUserMe();
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<TokenRefreshResponse>?> refreshToken(
    String refresh,
  ) async {
    try {
      final res = await apiService.refreshToken(refresh);
      if (res.data?.access != null) {
        await hiveService.setAccessToken(res.data!.access!);
      }
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<SignUpResponse>?> signUp(SignUpRequest data) async {
    try {
      final res = await apiService.signUp(data);
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  @override
  Future<ApiResponse<User>?> getUserMe() async {
    try {
      final res = await apiService.getUserMe();
      if (res.data != null) {
        apiService.setUser(res.data);
        notifyListeners();
      }
      return res;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }

  String getRouteForUser([User? u]) {
    u ??= user;
    if (u?.accountType == null) return Routes.onboard;
    return Routes.appIndex;
  }

  @override
  Future<bool> logout({String? token}) async {
    try {
      apiService.sink.add(SessionState.hardLogout);
      hiveService.logout(reset: true);
      return true;
      // return await apiService.logout(token: token);
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return false;
    }
  }
}
