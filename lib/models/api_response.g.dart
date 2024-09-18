// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => ApiError(
      details: _errorFromJson(json['details']),
      message: json['message'] as String?,
      statusCode: (json['status_code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status_code', instance.statusCode);
  writeNotNull('message', instance.message);
  writeNotNull('details', instance.details);
  return val;
}
