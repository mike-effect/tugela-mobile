import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'job_score.g.dart';

@JsonSerializable()
class JobScore extends BaseModel {
  final double? score;
  final double? confidenceScore;
  final double? technicalSkillsAndCompetency;
  final double? culturalFitAndBehavioralTraits;
  final double? experienceAndPotential;
  final double? probabilityOfJobSuccess;
  final String? explanation;

  const JobScore({
    this.score,
    this.confidenceScore,
    this.technicalSkillsAndCompetency,
    this.culturalFitAndBehavioralTraits,
    this.experienceAndPotential,
    this.probabilityOfJobSuccess,
    this.explanation,
  });

  factory JobScore.fromJson(Map<String, dynamic> json) =>
      _$JobScoreFromJson(json);

  Map<String, dynamic> toJson() => _$JobScoreToJson(this);

  @override
  List<Object?> get props => [];
}
