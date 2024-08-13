// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyManager _$CompanyManagerFromJson(Map<String, dynamic> json) =>
    CompanyManager(
      id: json['id'] as String?,
      user: json['user'] as String?,
      company: json['company'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CompanyManagerToJson(CompanyManager instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('user', instance.user);
  writeNotNull('company', instance.company);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
