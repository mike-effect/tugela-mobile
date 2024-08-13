import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'portfolio_item.g.dart';

@JsonSerializable()
class PortfolioItem extends BaseModel {
  final String? id;
  final String? freelancer;
  final String? title;
  final String? description;
  final String? category;
  final List<String>? skills;
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
}
