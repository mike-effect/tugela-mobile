// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      id: json['id'] as String?,
      address: json['address'] as String?,
      xrpAddress: json['xrp_address'] as String?,
      xrpSeed: json['xrp_seed'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      tagline: json['tagline'] as String?,
      companySize: $enumDecodeNullable(
          _$CompanySizeEnumMap, json['company_size'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      organizationType: $enumDecodeNullable(
          _$OrganizationTypeEnumMap, json['organization_type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      website: json['website'] as String?,
      logo: json['logo'] as String?,
      howYouFoundUs: $enumDecodeNullable(
          _$HowYouFoundUsEnumMap, json['how_you_found_us'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      founded: json['founded'] as String?,
      location: json['location'] as String?,
      totalJobs: (json['total_jobs'] as num?)?.toInt() ?? 0,
      activeJobs: (json['active_jobs'] as num?)?.toInt() ?? 0,
      assignedJobs: (json['assigned_jobs'] as num?)?.toInt() ?? 0,
      completedJobs: (json['completed_jobs'] as num?)?.toInt() ?? 0,
      totalApplications: (json['total_applications'] as num?)?.toInt() ?? 0,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      managers: (json['managers'] as List<dynamic>?)
              ?.map((e) => CompanyManager.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      industry: json['industry'] == null
          ? null
          : Industry.fromJson(json['industry'] as Map<String, dynamic>),
      values: (json['values'] as List<dynamic>?)
              ?.map((e) => CompanyValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CompanyToJson(Company instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('xrp_address', instance.xrpAddress);
  writeNotNull('xrp_seed', instance.xrpSeed);
  writeNotNull('address', instance.address);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('email', instance.email);
  writeNotNull('phone_number', instance.phoneNumber);
  writeNotNull('tagline', instance.tagline);
  writeNotNull('company_size', _$CompanySizeEnumMap[instance.companySize]);
  writeNotNull('organization_type',
      _$OrganizationTypeEnumMap[instance.organizationType]);
  writeNotNull('website', instance.website);
  writeNotNull('logo', instance.logo);
  writeNotNull(
      'how_you_found_us', _$HowYouFoundUsEnumMap[instance.howYouFoundUs]);
  writeNotNull('founded', instance.founded);
  writeNotNull('location', instance.location);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  val['managers'] = instance.managers.map((e) => e.toJson()).toList();
  writeNotNull('industry', instance.industry?.toJson());
  val['values'] = instance.values.map((e) => e.toJson()).toList();
  return val;
}

const _$CompanySizeEnumMap = {
  CompanySize.small: 'small',
  CompanySize.medium: 'medium',
  CompanySize.big: 'big',
};

const _$OrganizationTypeEnumMap = {
  OrganizationType.publicCompany: 'public_company',
  OrganizationType.selfEmployed: 'self_employed',
  OrganizationType.governmentAgency: 'government_agency',
  OrganizationType.nonprofit: 'nonprofit',
  OrganizationType.soleProprietorship: 'sole_proprietorship',
  OrganizationType.privatelyHeld: 'privately_held',
  OrganizationType.partnership: 'partnership',
};

const _$HowYouFoundUsEnumMap = {
  HowYouFoundUs.facebook: 'facebook',
  HowYouFoundUs.twitter: 'twitter',
  HowYouFoundUs.instagram: 'instagram',
  HowYouFoundUs.youtube: 'youtube',
  HowYouFoundUs.techEvent: 'techEvent',
  HowYouFoundUs.afriblockMember: 'afriblockMember',
  HowYouFoundUs.afriblockEmployee: 'afriblockEmployee',
};
