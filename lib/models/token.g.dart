// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenObtainPairRequest _$TokenObtainPairRequestFromJson(
        Map<String, dynamic> json) =>
    TokenObtainPairRequest(
      email: json['email'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$TokenObtainPairRequestToJson(
    TokenObtainPairRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  return val;
}

TokenObtainPairResponse _$TokenObtainPairResponseFromJson(
        Map<String, dynamic> json) =>
    TokenObtainPairResponse(
      access: json['access'] as String?,
      refresh: json['refresh'] as String?,
    );

Map<String, dynamic> _$TokenObtainPairResponseToJson(
    TokenObtainPairResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('access', instance.access);
  writeNotNull('refresh', instance.refresh);
  return val;
}

TokenRefreshRequest _$TokenRefreshRequestFromJson(Map<String, dynamic> json) =>
    TokenRefreshRequest(
      refresh: json['refresh'] as String?,
    );

Map<String, dynamic> _$TokenRefreshRequestToJson(TokenRefreshRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('refresh', instance.refresh);
  return val;
}

TokenRefreshResponse _$TokenRefreshResponseFromJson(
        Map<String, dynamic> json) =>
    TokenRefreshResponse(
      access: json['access'] as String?,
    );

Map<String, dynamic> _$TokenRefreshResponseToJson(
    TokenRefreshResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('access', instance.access);
  return val;
}
