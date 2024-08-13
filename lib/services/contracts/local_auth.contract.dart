import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

abstract class LocalAuthServiceContract {
  Future<BiometricType?> getBiometricType();

  BiometricType? get biometricType;

  void overrideBiometricType(BiometricType type);

  void overrideCanCheckBiometrics(bool state);

  void overrideOS(TargetPlatform operatingSystem);

  Future<bool> authenticate();
}
