import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'work_experience.g.dart';

@JsonSerializable()
class WorkExperience extends BaseModel {
  final String? id;
  final String? freelancer;
  final String? jobTitle;
  final String? jobDescription;
  final String? companyName;
  final bool? currentlyWorkingHere;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WorkExperience({
    this.id,
    this.freelancer,
    this.jobTitle,
    this.jobDescription,
    this.companyName,
    this.currentlyWorkingHere,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceFromJson(json);

  Map<String, dynamic> toJson() {
    final j = _$WorkExperienceToJson(this);
    j['start_date'] = startDate?.toIso8601String().split('T').first;
    j['end_date'] = endDate?.toIso8601String().split('T').first;
    return j;
  }
}
