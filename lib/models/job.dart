import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'job.g.dart';

@JsonSerializable()
class Job extends BaseModel {
  final String? id;
  final String? title;
  final String? company;
  final String? description;
  final DateTime? date;
  final String? location;
  final String? address;
  final List<String> tags;
  final String? priceType;
  final String? price;
  final String? currency;
  final String? applicationType;
  final String? status;
  final String? externalApplyLink;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Job({
    this.id,
    this.title,
    this.company,
    this.description,
    this.date,
    this.location,
    this.address,
    this.tags = const [],
    this.priceType,
    this.price,
    this.currency,
    this.applicationType,
    this.status,
    this.externalApplyLink,
    this.createdAt,
    this.updatedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  Map<String, dynamic> toJson() => _$JobToJson(this);
}
