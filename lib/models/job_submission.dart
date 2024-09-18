import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/freelancer.dart';
import 'package:tugela/models/job_application.dart';

part 'job_submission.g.dart';

@JsonSerializable()
class JobSubmission {
  final String? id;
  final JobApplication? application;
  // @JsonKey(includeFromJson: false, includeToJson: true)
  final Freelancer? freelancer;
  final String? link;
  final String? file;

  JobSubmission({
    this.id,
    this.application,
    this.freelancer,
    this.link,
    this.file,
  });

  factory JobSubmission.fromJson(Map<String, dynamic> json) =>
      _$JobSubmissionFromJson(json);

  Map<String, dynamic> toInputJson() {
    final j = _$JobSubmissionToJson(this);
    j['application'] = application?.id;
    j['freelancer'] = freelancer?.id;
    return j;
  }

  Map<String, dynamic> toJson() => _$JobSubmissionToJson(this);
}
