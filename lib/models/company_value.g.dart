// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyValue _$CompanyValueFromJson(Map<String, dynamic> json) => CompanyValue(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CompanyValueToJson(CompanyValue instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  return val;
}
