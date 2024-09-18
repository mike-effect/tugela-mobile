// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freelancer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Freelancer _$FreelancerFromJson(Map<String, dynamic> json) => Freelancer(
      id: json['id'] as String?,
      title: json['title'] as String?,
      fullname: json['fullname'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      contact: json['contact'] as String?,
      website: json['website'] as String?,
      phoneNumber: json['phone_number'] as String?,
      profileImage: json['profile_image'] as String?,
      xrpAddress: json['xrp_address'] as String?,
      xrpSeed: json['xrp_seed'] as String?,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      workExperiences: (json['work_experiences'] as List<dynamic>?)
              ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      portfolioItem: (json['portfolio_item'] as List<dynamic>?)
              ?.map((e) => PortfolioItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      services: (json['services'] as List<dynamic>?)
              ?.map(
                  (e) => FreelancerService.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      howYouFoundUs: json['how_you_found_us'] as String?,
      totalApplications: (json['total_applications'] as num?)?.toInt() ?? 0,
      acceptedApplications:
          (json['accepted_applications'] as num?)?.toInt() ?? 0,
      rejectedApplications:
          (json['rejected_applications'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FreelancerToJson(Freelancer instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('title', instance.title);
  writeNotNull('fullname', instance.fullname);
  writeNotNull('bio', instance.bio);
  writeNotNull('location', instance.location);
  writeNotNull('contact', instance.contact);
  writeNotNull('website', instance.website);
  writeNotNull('phone_number', instance.phoneNumber);
  writeNotNull('profile_image', instance.profileImage);
  writeNotNull('xrp_address', instance.xrpAddress);
  writeNotNull('xrp_seed', instance.xrpSeed);
  val['skills'] = instance.skills.map((e) => e.toJson()).toList();
  writeNotNull('how_you_found_us', instance.howYouFoundUs);
  val['work_experiences'] =
      instance.workExperiences.map((e) => e.toJson()).toList();
  val['portfolio_item'] =
      instance.portfolioItem.map((e) => e.toJson()).toList();
  val['services'] = instance.services.map((e) => e.toJson()).toList();
  return val;
}
