import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends BaseModel {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
