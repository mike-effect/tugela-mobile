// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_experience.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkExperience _$WorkExperienceFromJson(Map<String, dynamic> json) =>
    WorkExperience(
      id: json['id'] as String?,
      freelancer: json['freelancer'] as String?,
      jobTitle: json['job_title'] as String?,
      jobDescription: json['job_description'] as String?,
      companyName: json['company_name'] as String?,
      currentlyWorkingHere: json['currently_working_here'] as bool?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$WorkExperienceToJson(WorkExperience instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('freelancer', instance.freelancer);
  writeNotNull('job_title', instance.jobTitle);
  writeNotNull('job_description', instance.jobDescription);
  writeNotNull('company_name', instance.companyName);
  writeNotNull('currently_working_here', instance.currentlyWorkingHere);
  writeNotNull('start_date', instance.startDate?.toIso8601String());
  writeNotNull('end_date', instance.endDate?.toIso8601String());
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
