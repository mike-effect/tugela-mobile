// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_remote_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppRemoteConfig _$AppRemoteConfigFromJson(Map<String, dynamic> json) =>
    AppRemoteConfig(
      android: json['android'] == null
          ? null
          : RemotePlatformConfig.fromJson(
              json['android'] as Map<String, dynamic>),
      ios: json['ios'] == null
          ? null
          : RemotePlatformConfig.fromJson(json['ios'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppRemoteConfigToJson(AppRemoteConfig instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('android', instance.android?.toJson());
  writeNotNull('ios', instance.ios?.toJson());
  return val;
}

RemotePlatformConfig _$RemotePlatformConfigFromJson(
        Map<String, dynamic> json) =>
    RemotePlatformConfig(
      storeUrl: json['store_url'] as String? ?? "",
      stagingUrl: json['staging_url'] as String? ?? "",
      productionUrl: json['production_url'] as String? ?? "",
      environment: json['environment'] as String? ?? "",
    );

Map<String, dynamic> _$RemotePlatformConfigToJson(
        RemotePlatformConfig instance) =>
    <String, dynamic>{
      'store_url': instance.storeUrl,
      'staging_url': instance.stagingUrl,
      'production_url': instance.productionUrl,
      'environment': instance.environment,
    };
