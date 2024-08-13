// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      id: json['id'] as String?,
      user: json['user'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      tagline: json['tagline'] as String?,
      companySize: $enumDecodeNullable(
          _$CompanySizeEnumMap, json['company_size'],
          unknownValue: CompanySize.unknown),
      organizationType: $enumDecodeNullable(
          _$OrganizationTypeEnumMap, json['organization_type'],
          unknownValue: OrganizationType.unknown),
      website: json['website'] as String?,
      logo: json['logo'] as String?,
      howYouFoundUs: $enumDecodeNullable(
          _$HowYouFoundUsEnumMap, json['how_you_found_us'],
          unknownValue: HowYouFoundUs.unknown),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CompanyToJson(Company instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('user', instance.user);
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
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}

const _$CompanySizeEnumMap = {
  CompanySize.small: 'small',
  CompanySize.medium: 'medium',
  CompanySize.big: 'big',
  CompanySize.unknown: 'unknown',
};

const _$OrganizationTypeEnumMap = {
  OrganizationType.publicCompany: 'public_company',
  OrganizationType.selfEmployed: 'self_employed',
  OrganizationType.governmentAgency: 'government_agency',
  OrganizationType.nonprofit: 'nonprofit',
  OrganizationType.soleProprietorship: 'sole_proprietorship',
  OrganizationType.privatelyHeld: 'privately_held',
  OrganizationType.partnership: 'partnership',
  OrganizationType.unknown: 'unknown',
};

const _$HowYouFoundUsEnumMap = {
  HowYouFoundUs.facebook: 'facebook',
  HowYouFoundUs.twitter: 'twitter',
  HowYouFoundUs.instagram: 'instagram',
  HowYouFoundUs.youtube: 'youtube',
  HowYouFoundUs.techEvent: 'techEvent',
  HowYouFoundUs.afriblockMember: 'afriblockMember',
  HowYouFoundUs.afriblockEmployee: 'afriblockEmployee',
  HowYouFoundUs.unknown: 'unknown',
};
