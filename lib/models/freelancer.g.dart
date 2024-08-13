// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freelancer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Freelancer _$FreelancerFromJson(Map<String, dynamic> json) => Freelancer(
      id: json['id'] as String?,
      user: json['user'] as String?,
      howYouFoundUs: json['how_you_found_us'] as String?,
    );

Map<String, dynamic> _$FreelancerToJson(Freelancer instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('user', instance.user);
  writeNotNull('how_you_found_us', instance.howYouFoundUs);
  return val;
}
