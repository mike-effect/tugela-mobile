import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';
import 'package:tugela/models/skill.dart';

part 'portfolio_item.g.dart';

@JsonSerializable()
class PortfolioItem extends BaseModel {
  final String? id;
  @JsonKey(includeFromJson: false)
  final String? freelancer;
  final String? title;
  final String? description;
  final String? category;
  final List<Skill>? skills;
  final String? projectUrl;
  final String? videoUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? portfolioFile;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PortfolioItem({
    this.id,
    this.freelancer,
    this.title,
    this.description,
    this.category,
    this.skills,
    this.projectUrl,
    this.videoUrl,
    this.startDate,
    this.endDate,
    this.portfolioFile,
    this.createdAt,
    this.updatedAt,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) =>
      _$PortfolioItemFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioItemToJson(this);

  Map<String, dynamic> toInputJson() {
    final j = _$PortfolioItemToJson(this);
    // j['freelancer'] = freelancer?.id;
    j['start_date'] = startDate?.toIso8601String().split('T').first;
    j['end_date'] = endDate?.toIso8601String().split('T').first;
    j['skills'] = (skills ?? [])
        .map((s) => s.id ?? '')
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
    return j;
  }
}
