// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      id: json['id'] as String?,
      title: json['title'] as String?,
      company: json['company'] == null
          ? null
          : Company.fromJson(json['company'] as Map<String, dynamic>),
      description: json['description'] as String?,
      experience: json['experience'] as String?,
      responsibilities: json['responsibilities'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      location: $enumDecodeNullable(_$JobLocationEnumMap, json['location'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      address: json['address'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      priceType: $enumDecodeNullable(_$PriceTypeEnumMap, json['price_type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      price: json['price'] as String?,
      currency: json['currency'] as String?,
      applicationType: $enumDecodeNullable(
          _$JobApplicationTypeEnumMap, json['application_type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      status: $enumDecodeNullable(_$JobStatusEnumMap, json['status'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      externalApplyLink: json['external_apply_link'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      roleType: $enumDecodeNullable(_$JobRoleTypeEnumMap, json['role_type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$JobToJson(Job instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('company', instance.company?.toJson());
  writeNotNull('description', instance.description);
  writeNotNull('experience', instance.experience);
  writeNotNull('responsibilities', instance.responsibilities);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('location', _$JobLocationEnumMap[instance.location]);
  writeNotNull('address', instance.address);
  val['tags'] = instance.tags;
  writeNotNull('price_type', _$PriceTypeEnumMap[instance.priceType]);
  writeNotNull('price', instance.price);
  writeNotNull('currency', instance.currency);
  writeNotNull('application_type',
      _$JobApplicationTypeEnumMap[instance.applicationType]);
  writeNotNull('status', _$JobStatusEnumMap[instance.status]);
  writeNotNull('role_type', _$JobRoleTypeEnumMap[instance.roleType]);
  writeNotNull('external_apply_link', instance.externalApplyLink);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  val['skills'] = instance.skills.map((e) => e.toJson()).toList();
  return val;
}

const _$JobLocationEnumMap = {
  JobLocation.onsite: 'on-site',
  JobLocation.remote: 'remote',
  JobLocation.hybrid: 'hybrid',
};

const _$PriceTypeEnumMap = {
  PriceType.perProject: 'per_project',
  PriceType.daily: 'per_day',
  PriceType.hourly: 'per_hour',
  PriceType.weekly: 'per_week',
  PriceType.monthly: 'per_month',
  PriceType.yearly: 'per_year',
};

const _$JobApplicationTypeEnumMap = {
  JobApplicationType.internal: 'internal',
  JobApplicationType.external: 'external',
};

const _$JobStatusEnumMap = {
  JobStatus.active: 'active',
  JobStatus.inactive: 'inactive',
  JobStatus.assigned: 'assigned',
  JobStatus.completed: 'completed',
};

const _$JobRoleTypeEnumMap = {
  JobRoleType.partTime: 'part_time',
  JobRoleType.contract: 'contract',
  JobRoleType.fullTime: 'full_time',
  JobRoleType.internship: 'internship',
};
