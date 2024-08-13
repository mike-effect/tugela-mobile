import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'token.g.dart';

@JsonSerializable()
class TokenObtainPairRequest extends BaseModel {
  final String? email;
  final String? password;

  const TokenObtainPairRequest({this.email, this.password});

  factory TokenObtainPairRequest.fromJson(Map<String, dynamic> json) =>
      _$TokenObtainPairRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TokenObtainPairRequestToJson(this);
}

@JsonSerializable()
class TokenObtainPairResponse extends BaseModel {
  final String? access;
  final String? refresh;

  const TokenObtainPairResponse({this.access, this.refresh});

  factory TokenObtainPairResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenObtainPairResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenObtainPairResponseToJson(this);
}

@JsonSerializable()
class TokenRefreshRequest extends BaseModel {
  final String? refresh;

  const TokenRefreshRequest({this.refresh});

  factory TokenRefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TokenRefreshRequestToJson(this);
}

@JsonSerializable()
class TokenRefreshResponse extends BaseModel {
  final String? access;

  const TokenRefreshResponse({this.access});

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenRefreshResponseToJson(this);
}
