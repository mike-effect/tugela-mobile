import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tugela/services/contracts/local_auth.contract.dart';

class LocalAuthService implements LocalAuthServiceContract {
  final LocalAuthentication auth;
  BiometricType? _biometricType;
  bool _overrideCanCheckBiometrics = false;
  TargetPlatform _operatingSystem;

  LocalAuthService(this.auth) : _operatingSystem = defaultTargetPlatform;

  @override
  BiometricType? get biometricType => _biometricType;

  @override
  void overrideBiometricType(BiometricType type) => _biometricType = type;

  @override
  void overrideCanCheckBiometrics(bool state) =>
      _overrideCanCheckBiometrics = state;

  @override
  void overrideOS(TargetPlatform os) => _operatingSystem = os;

  @override
  Future<BiometricType?> getBiometricType() async {
    if (!_overrideCanCheckBiometrics) {
      if (!(await auth.canCheckBiometrics && await auth.isDeviceSupported())) {
        return null;
      }
    }
    final availableBiometrics = await auth.getAvailableBiometrics();
    BiometricType? type;
    if (_operatingSystem == TargetPlatform.iOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        type = BiometricType.face;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        type = BiometricType.fingerprint;
      }
    } else if (_operatingSystem == TargetPlatform.android) {
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        type = BiometricType.fingerprint;
      }
    }
    _biometricType = type;
    return type;
  }

  @override
  Future<bool> authenticate() async {
    final didAuthenticate = await auth.authenticate(
      localizedReason: 'Please authenticate to log in to the app',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
    return didAuthenticate;
  }
}
