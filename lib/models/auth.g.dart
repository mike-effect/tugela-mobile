// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordRequest _$ChangePasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ChangePasswordRequest(
      oldPassword: json['old_password'] as String?,
      newPassword: json['new_password'] as String?,
    );

Map<String, dynamic> _$ChangePasswordRequestToJson(
    ChangePasswordRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('old_password', instance.oldPassword);
  writeNotNull('new_password', instance.newPassword);
  return val;
}

ResetPasswordRequest _$ResetPasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordRequest(
      token: json['token'] as String?,
      code: json['code'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$ResetPasswordRequestToJson(
    ResetPasswordRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('token', instance.token);
  writeNotNull('code', instance.code);
  writeNotNull('password', instance.password);
  return val;
}

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      email: json['email'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      password2: json['password2'] as String?,
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  writeNotNull('username', instance.username);
  writeNotNull('password', instance.password);
  writeNotNull('password2', instance.password2);
  return val;
}

SignUpResponse _$SignUpResponseFromJson(Map<String, dynamic> json) =>
    SignUpResponse(
      id: json['id'] as String?,
    );

Map<String, dynamic> _$SignUpResponseToJson(SignUpResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  return val;
}
