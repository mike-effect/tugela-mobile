import 'package:local_auth/local_auth.dart';
import 'package:tugela/models.dart';
import 'package:tugela/providers/base_provider.dart';

abstract class UserProviderContract extends BaseProvider {
  Future<ApiResponse<TokenObtainPairResponse>?> login(
    TokenObtainPairRequest data,
  );

  Future<ApiResponse<TokenRefreshResponse>?> refreshToken(String refresh);

  Future<ApiResponse<SignUpResponse>?> signUp(SignUpRequest data);

  Future<ApiResponse<User>?> getUserMe();

  Future<bool> getBioAuth();

  Future<bool> getBioAuthReminder();

  Future<void> setBioAuth(bool status);

  Future<void> setBioAuthReminder(bool ask);

  String biometricTypeString(BiometricType? type);

  Future<BiometricType?> getBiometricType();

  Future<bool> authenticateBio();

  Future<bool> canAutoLogin();

  Future<String?> getEmail();

  Future<String?> getPassword();

  Future<ApiResponse?> autoLogin();

  Future<bool> logout({String? token});
}
