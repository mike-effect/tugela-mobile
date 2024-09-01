// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobApplication _$JobApplicationFromJson(Map<String, dynamic> json) =>
    JobApplication(
      id: json['id'] as String?,
      freelancer: json['freelancer'] == null
          ? null
          : Freelancer.fromJson(json['freelancer'] as Map<String, dynamic>),
      job: json['job'] == null
          ? null
          : Job.fromJson(json['job'] as Map<String, dynamic>),
      status: json['status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$JobApplicationToJson(JobApplication instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('freelancer', instance.freelancer?.toJson());
  writeNotNull('job', instance.job?.toJson());
  writeNotNull('status', instance.status);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
