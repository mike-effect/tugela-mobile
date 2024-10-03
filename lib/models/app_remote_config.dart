import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'app_remote_config.g.dart';

@JsonSerializable()
class AppRemoteConfig extends BaseModel {
  final RemotePlatformConfig? android;
  final RemotePlatformConfig? ios;

  const AppRemoteConfig({this.android, this.ios});

  factory AppRemoteConfig.fromJson(Map<String, dynamic> json) =>
      _$AppRemoteConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppRemoteConfigToJson(this);

  @override
  List<Object?> get props => [android, ios];

  RemotePlatformConfig? forPlatform() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return null;
    }
  }
}

@JsonSerializable()
class RemotePlatformConfig extends BaseModel {
  final String storeUrl;
  final String stagingUrl;
  final String productionUrl;
  final String environment;
  final TransakConfig? transak;

  const RemotePlatformConfig({
    this.storeUrl = "",
    this.stagingUrl = "",
    this.productionUrl = "",
    this.environment = "",
    this.transak,
  });

  factory RemotePlatformConfig.fromJson(Map<String, dynamic> json) =>
      _$RemotePlatformConfigFromJson(json);

  Map<String, dynamic> toJson() => _$RemotePlatformConfigToJson(this);

  @override
  List<Object?> get props => [
        storeUrl,
        stagingUrl,
        productionUrl,
        environment,
        transak,
      ];
}

@JsonSerializable()
class TransakConfig extends BaseModel {
  final TransakEnvConfig? staging;
  final TransakEnvConfig? production;

  const TransakConfig({this.staging, this.production});

  factory TransakConfig.fromJson(Map<String, dynamic> json) =>
      _$TransakConfigFromJson(json);

  Map<String, dynamic> toJson() => _$TransakConfigToJson(this);

  @override
  List<Object?> get props => [staging, production];
}

@JsonSerializable()
class TransakEnvConfig extends BaseModel {
  final String withdrawal;
  final String topup;

  const TransakEnvConfig({
    this.withdrawal = "",
    this.topup = "",
  });

  factory TransakEnvConfig.fromJson(Map<String, dynamic> json) =>
      _$TransakEnvConfigFromJson(json);

  Map<String, dynamic> toJson() => _$TransakEnvConfigToJson(this);

  @override
  List<Object?> get props => [withdrawal, topup];
}
