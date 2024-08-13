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
  // final bool useStagingApi;
  const RemotePlatformConfig({
    this.storeUrl = "",
    this.stagingUrl = "",
    this.productionUrl = "",
    this.environment = "",
    // this.useStagingApi = false,
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
        // useStagingApi,
      ];
}
