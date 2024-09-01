import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';
import 'package:tugela/models/freelancer.dart';
import 'package:tugela/models/job.dart';

part 'job_application.g.dart';

@JsonSerializable()
class JobApplication extends BaseModel {
  final String? id;
  final Freelancer? freelancer;
  final Job? job;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const JobApplication(
      {this.id,
      this.freelancer,
      this.job,
      this.status,
      this.createdAt,
      this.updatedAt});

  factory JobApplication.fromJson(Map<String, dynamic> json) =>
      _$JobApplicationFromJson(json);

  Map<String, dynamic> toJson() => _$JobApplicationToJson(this);

  Map<String, dynamic> toInputJson() {
    final j = _$JobApplicationToJson(this);
    j['job'] = job?.id;
    j['freelancer'] = freelancer?.id;
    return j;
  }
}
