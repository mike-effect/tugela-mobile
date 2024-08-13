import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'auth.g.dart';

@JsonSerializable()
class ChangePasswordRequest extends BaseModel {
  final String? oldPassword;
  final String? newPassword;

  const ChangePasswordRequest({this.oldPassword, this.newPassword});

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordRequest extends BaseModel {
  final String? token;
  final String? code;
  final String? password;

  const ResetPasswordRequest({this.token, this.code, this.password});

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

@JsonSerializable()
class SignUpRequest extends BaseModel {
  final String? email;
  final String? username;
  final String? password;
  final String? password2;

  const SignUpRequest({
    this.email,
    this.username,
    this.password,
    this.password2,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}

@JsonSerializable()
class SignUpResponse extends BaseModel {
  final String? id;

  const SignUpResponse({this.id});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);
}
