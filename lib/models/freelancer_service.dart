import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'freelancer_service.g.dart';

@JsonSerializable()
class FreelancerService extends BaseModel {
  final String? id;
  final String? freelancer;
  final String? title;
  final String? description;
  final String? category;
  final List<String>? skills;
  final String? deliveryTime;
  final String? startingPrice;
  final String? currency;
  final String? priceType;
  final String? serviceImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FreelancerService({
    this.id,
    this.freelancer,
    this.title,
    this.description,
    this.category,
    this.skills,
    this.deliveryTime,
    this.startingPrice,
    this.currency,
    this.priceType,
    this.serviceImage,
    this.createdAt,
    this.updatedAt,
  });

  factory FreelancerService.fromJson(Map<String, dynamic> json) =>
      _$FreelancerServiceFromJson(json);

  Map<String, dynamic> toJson() => _$FreelancerServiceToJson(this);
}
