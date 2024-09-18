// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobSubmission _$JobSubmissionFromJson(Map<String, dynamic> json) =>
    JobSubmission(
      id: json['id'] as String?,
      application: json['application'] == null
          ? null
          : JobApplication.fromJson(
              json['application'] as Map<String, dynamic>),
      freelancer: json['freelancer'] == null
          ? null
          : Freelancer.fromJson(json['freelancer'] as Map<String, dynamic>),
      link: json['link'] as String?,
      file: json['file'] as String?,
    );

Map<String, dynamic> _$JobSubmissionToJson(JobSubmission instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('application', instance.application?.toJson());
  writeNotNull('freelancer', instance.freelancer?.toJson());
  writeNotNull('link', instance.link);
  writeNotNull('file', instance.file);
  return val;
}
