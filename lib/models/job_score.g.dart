// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobScore _$JobScoreFromJson(Map<String, dynamic> json) => JobScore(
      score: (json['score'] as num?)?.toDouble(),
      confidenceScore: (json['confidence_score'] as num?)?.toDouble(),
      technicalSkillsAndCompetency:
          (json['technical_skills_and_competency'] as num?)?.toDouble(),
      culturalFitAndBehavioralTraits:
          (json['cultural_fit_and_behavioral_traits'] as num?)?.toDouble(),
      experienceAndPotential:
          (json['experience_and_potential'] as num?)?.toDouble(),
      probabilityOfJobSuccess:
          (json['probability_of_job_success'] as num?)?.toDouble(),
      explanation: json['explanation'] as String?,
    );

Map<String, dynamic> _$JobScoreToJson(JobScore instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('score', instance.score);
  writeNotNull('confidence_score', instance.confidenceScore);
  writeNotNull(
      'technical_skills_and_competency', instance.technicalSkillsAndCompetency);
  writeNotNull('cultural_fit_and_behavioral_traits',
      instance.culturalFitAndBehavioralTraits);
  writeNotNull('experience_and_potential', instance.experienceAndPotential);
  writeNotNull('probability_of_job_success', instance.probabilityOfJobSuccess);
  writeNotNull('explanation', instance.explanation);
  return val;
}
