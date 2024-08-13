import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'service.g.dart';

@JsonSerializable()
class Service extends BaseModel {
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

  const Service({
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

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
