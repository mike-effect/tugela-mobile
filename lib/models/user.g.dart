// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      email: json['email'] as String?,
      username: json['username'] as String?,
      accountType: $enumDecodeNullable(
          _$AccountTypeEnumMap, json['account_type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      role: json['role'] as String?,
      id: json['id'] as String?,
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      company: json['company'] == null
          ? null
          : Company.fromJson(json['company'] as Map<String, dynamic>),
      freelancer: json['freelancer'] == null
          ? null
          : Freelancer.fromJson(json['freelancer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  writeNotNull('username', instance.username);
  writeNotNull('account_type', _$AccountTypeEnumMap[instance.accountType]);
  writeNotNull('role', instance.role);
  writeNotNull('id', instance.id);
  writeNotNull('profile', instance.profile?.toJson());
  writeNotNull('freelancer', instance.freelancer?.toJson());
  writeNotNull('company', instance.company?.toJson());
  return val;
}

const _$AccountTypeEnumMap = {
  AccountType.company: 'company',
  AccountType.freelancer: 'freelancer',
  AccountType.unknown: 'unknown',
};
